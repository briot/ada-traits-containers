------------------------------------------------------------------------------
--                     Copyright (C) 2015-2016, AdaCore                     --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

pragma Ada_2012;
with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;
with System;                   use System;
with System.Memory;            use System.Memory;

package body GAL.Vectors.Storage.Unbounded with SPARK_Mode => Off is

   package body Impl is

      pragma Warnings (Off);  --  no aliasing issue
      function Convert is new Ada.Unchecked_Conversion
        (Nodes_Array_Access, System.Address);
      function Convert is new Ada.Unchecked_Conversion
        (System.Address, Nodes_Array_Access);
      pragma Warnings (On);

      procedure Internal_Copy
        (Self                   : Nodes_Array_Access;
         Source                 : Nodes_Array_Access;
         Source_From, Source_To : Count_Type;
         Self_From              : Count_Type) with Inline;
      --  Internal version of Copy, directly applying on an array

      function Alloc (Size : Count_Type) return Nodes_Array_Access;
      procedure Free (A : in out Nodes_Array_Access; Capacity : Count_Type);
      --  Perform allocation.
      --  For simple elements, we use low-level C routines so that
      --  we can ultimately use realloc for performance. But for
      --  controlled elements, we need to preserve the Ada
      --  semantics (which initializes all elements);

      -----------
      -- Alloc --
      -----------

      function Alloc (Size : Count_Type) return Nodes_Array_Access is
         S   : size_t;
      begin
         if Elements.Movable then
            S := size_t
              (Size * Big_Nodes_Array'Component_Size / System.Storage_Unit);
            return Convert (System.Memory.Alloc (S));
         else
            declare
               type Arr is array (1 .. Size) of aliased Elements.Stored_Type;
               type Arr_Access is access all Arr;
               Tmp : Arr_Access := new Arr;
            begin
               return Convert (Tmp.all'Address);
            end;
         end if;
      end Alloc;

      ----------
      -- Free --
      ----------

      procedure Free (A : in out Nodes_Array_Access; Capacity : Count_Type) is
      begin
         if Elements.Movable then
            System.Memory.Free (Convert (A));
         else
            declare
               type Arr is array (1 .. Capacity)
                  of aliased Elements.Stored_Type;
               type Arr_Access is access all Arr;
               function Convert is new Ada.Unchecked_Conversion
                 (System.Address, Arr_Access);
               procedure Unchecked_Free is new Ada.Unchecked_Deallocation
                  (Arr, Arr_Access);
               Tmp : Arr_Access;
            begin
               Tmp := Convert (A (A'First)'Address);
               Unchecked_Free (Tmp);
            end;
         end if;

         A := null;
      end Free;

      ---------------------
      -- Release_Element --
      ---------------------

      procedure Release_Element
        (Self : in out Container'Class; Index : Count_Type) is
      begin
         Elements.Release (Self.Nodes (Index));
      end Release_Element;

      -------------------
      -- Internal_Copy --
      -------------------

      procedure Internal_Copy
        (Self                   : Nodes_Array_Access;
         Source                 : Nodes_Array_Access;
         Source_From, Source_To : Count_Type;
         Self_From              : Count_Type)
      is
         Self_To : Count_Type;
      begin
         if Elements.Copyable then
            Self (Self_From .. Self_From + Source_To - Source_From) :=
              Source (Source_From .. Source_To);
         else
            Self_To := Self_From + Source_To - Source_From;

            --  If the ranges overlap, the order of the loop is important
            if Self = Source and then Source_To > Self_To then
               for J in Source_From .. Source_To loop
                  Self (Self_From + J - Source_From) :=
                    Elements.Copy (Source (J));
               end loop;

            else
               for J in reverse Source_From .. Source_To loop
                  Self (Self_From + J - Source_From) :=
                    Elements.Copy (Source (J));
               end loop;
            end if;
         end if;
      end Internal_Copy;

      ------------
      -- Assign --
      ------------

      procedure Assign
        (Self        : in out Container'Class;
         Last        : Count_Type;
         Source      : Container'Class;
         Source_Last : Count_Type) is
      begin
         if Self.Nodes = Source.Nodes then
            return;
         end if;

         for J in Min_Index .. Last loop
            Release_Element (Self, J);
         end loop;

         --  We only allocate enough memory to copy everything. This is
         --  slightly faster, avoid fragmentation, and means Copy can be used
         --  to reduce the memory usage in the application.
         Resize
            (Self,
             New_Size => Source_Last,
             Last     => Min_Index - 1,
             Force    => True);
         Internal_Copy
            (Self.Nodes, Source.Nodes, Min_Index, Source_Last, Min_Index);
      end Assign;

      -----------
      -- Clone --
      -----------

      procedure Clone
        (Self : in out Container'Class;
         Last : Count_Type)
      is
         Tmp : Nodes_Array_Access := Alloc (Size => Last);
      begin
         Internal_Copy (Tmp, Self.Nodes, Min_Index, Last, Min_Index);
         Self.Nodes := Tmp;
      end Clone;

      ----------
      -- Copy --
      ----------

      procedure Copy
        (Self                   : in out Container'Class;
         Source                 : Container'Class;
         Source_From, Source_To : Count_Type;
         Self_From              : Count_Type) is
      begin
         Internal_Copy
           (Self.Nodes, Source.Nodes, Source_From, Source_To, Self_From);
      end Copy;

      ------------
      -- Resize --
      ------------

      procedure Resize
        (Self     : in out Container'Class;
         New_Size : Count_Type;
         Last     : Count_Type;
         Force    : Boolean)
      is
         Size : Count_Type;
         S   : size_t;
         Tmp : Nodes_Array_Access;
      begin
         if Force then
            Size := New_Size;
         elsif New_Size < Self.Capacity then
            Size := Resize_Policy.Shrink
              (Current_Size => Self.Capacity, Min_Expected_Size => New_Size);
         else
            Size := Resize_Policy.Grow
              (Current_Size => Self.Capacity, Min_Expected_Size => New_Size);
         end if;

         if Size /= Self.Capacity then
            if Size = 0 then
               Free (Self.Nodes, Self.Capacity);
            else
               if Self.Nodes = null then
                  Self.Nodes := Alloc (Size => Size);

               elsif Elements.Movable then
                  S := size_t
                    (Size * Big_Nodes_Array'Component_Size
                     / System.Storage_Unit);
                  Self.Nodes := Convert (Realloc (Convert (Self.Nodes), S));

               else
                  Tmp := Alloc (Size => Size);

                  for J in Min_Index .. Count_Type'Min (Last, New_Size) loop
                     Tmp (J) := Elements.Copy (Self.Nodes (J));
                     Elements.Release (Self.Nodes (J));
                  end loop;

                  Free (Self.Nodes, Self.Capacity);
                  Self.Nodes := Tmp;
               end if;
            end if;

            Self.Capacity := Size;
         end if;
      end Resize;

      -------------
      -- Release --
      -------------

      procedure Release (Self : in out Container'Class) is
      begin
         if Self.Nodes /= null then
            Free (Self.Nodes, Self.Capacity);
            Self.Capacity := 0;
         end if;
      end Release;

      ---------------------
      -- Swap_In_Storage --
      ---------------------

      procedure Swap_In_Storage
        (Self        : in out Container'Class;
         Left, Right : Count_Type) is
      begin
         --  Since we will only keep one copy of the elements in the end, we
         --  should test Movable here, not Copyable.
         if Elements.Movable then
            declare
               Tmp : constant Elements.Stored_Type := Self.Nodes (Right);
            begin
               Self.Nodes (Right) := Self.Nodes (Left);
               Self.Nodes (Left) := Tmp;
            end;
         else
            declare
               Tmp : constant Elements.Stored_Type :=
                  Elements.Copy (Self.Nodes (Right));
            begin
               Elements.Release (Self.Nodes (Right));
               Self.Nodes (Right) := Elements.Copy (Self.Nodes (Left));
               Elements.Release (Self.Nodes (Left));
               Self.Nodes (Left) := Tmp;
            end;
         end if;
      end Swap_In_Storage;

   end Impl;

end GAL.Vectors.Storage.Unbounded;
