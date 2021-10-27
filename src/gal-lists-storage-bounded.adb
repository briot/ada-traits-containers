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

package body GAL.Lists.Storage.Bounded with SPARK_Mode => Off is

   package body Impl is
      --------------
      -- Allocate --
      --------------

      procedure Allocate
         (Self    : in out Container'Class;
          N       : out Node_Access)
      is
      begin
         if Self.Free > 0 then
            N := Node_Access (Self.Free);
            Self.Free := Integer (Self.Nodes (Count_Type (N)).Next);
         else
            N := Node_Access (abs Self.Free + 1);
            Self.Free := Self.Free - 1;
         end if;

         if Count_Type (N) <= Self.Nodes'Last then
            Self.Nodes (Count_Type (N)) :=
               (Element  => <>,
                Previous => Null_Node_Access,
                Next     => Null_Node_Access);
         else
            N := Null_Node_Access;
         end if;
      end Allocate;

      -------------
      -- Release --
      -------------

      procedure Release (Self : in out Impl.Container'Class) is
      begin
         Self.Free := 0;
      end Release;

      -------------------
      -- Get_RO_Stored --
      -------------------

      function Get_RO_Stored
         (Self : aliased Impl.Container'Class;
          Pos  : Impl.Node_Access)
         return not null access constant Elements.Stored_Type is
      begin
         return Self.Nodes (Count_Type (Pos)).Element'Access;
      end Get_RO_Stored;

      -------------------
      -- Get_RW_Stored --
      -------------------

      function Get_RW_Stored
         (Self : in out Impl.Container'Class;
          Pos  : Impl.Node_Access)
         return not null access Elements.Stored_Type is
      begin
         return Self.Nodes (Count_Type (Pos)).Element'Unchecked_Access;
      end Get_RW_Stored;

      --------------
      -- Get_Next --
      --------------

      function Get_Next
         (Self : Container'Class; N : Node_Access) return Node_Access is
      begin
         return Self.Nodes (Count_Type (N)).Next;
      end Get_Next;

      ------------------
      -- Get_Previous --
      ------------------

      function Get_Previous
         (Self : Container'Class; N : Node_Access) return Node_Access is
      begin
         return Self.Nodes (Count_Type (N)).Previous;
      end Get_Previous;

      ------------------
      -- Set_Previous --
      ------------------

      procedure Set_Previous
         (Self : in out Container'Class; N, Prev : Node_Access) is
      begin
         Self.Nodes (Count_Type (N)).Previous := Prev;
      end Set_Previous;

      --------------
      -- Set_Next --
      --------------

      procedure Set_Next
         (Self : in out Container'Class; N, Next : Node_Access) is
      begin
         Self.Nodes (Count_Type (N)).Next := Next;
      end Set_Next;

      ------------
      -- Assign --
      ------------

      procedure Assign
         (Nodes    : in out Container'Class;
          Source   : Container'Class;
          New_Head : out Node_Access;
          Old_Head : Node_Access;
          New_Tail : out Node_Access;
          Old_Tail : Node_Access)
      is
         N : Node_Access;
      begin
         --  Indices will remain the same
         New_Head := Old_Head;
         New_Tail := Old_Tail;

         Nodes.Free  := Source.Free;

         --  We need to copy each of the elements.

         if not Elements.Copyable then
            N := Old_Head;
            while N /= Null_Node_Access loop
               declare
                  Value : Node renames Source.Nodes (Count_Type (N));
               begin
                  Nodes.Nodes (Count_Type (N)) :=
                     (Element  => Elements.Copy (Value.Element),
                      Next     => Value.Next,
                      Previous => Value.Previous);
                  N := Value.Next;
               end;
            end loop;

         else
            --  ??? Can we copy only a subset
            Nodes.Nodes := Source.Nodes;
         end if;
      end Assign;

      ----------
      -- Swap --
      ----------

      procedure Swap (Nodes : in out Container'Class; L, R : Node_Access) is
         LC : constant Count_Type := Count_Type (L);
         RC : constant Count_Type := Count_Type (R);
      begin
         if Elements.Movable then
            declare
               Tmp : constant Elements.Stored_Type := Nodes.Nodes (LC).Element;
            begin
               Nodes.Nodes (LC).Element := Nodes.Nodes (RC).Element;
               Nodes.Nodes (RC).Element := Tmp;
            end;
         else
            declare
               Tmp : constant Elements.Stored_Type :=
                  Elements.Copy (Nodes.Nodes (RC).Element);
            begin
               Elements.Release (Nodes.Nodes (RC).Element);
               Nodes.Nodes (RC).Element :=
                  Elements.Copy (Nodes.Nodes (LC).Element);
               Elements.Release (Nodes.Nodes (LC).Element);
               Nodes.Nodes (LC).Element := Tmp;
            end;
         end if;
      end Swap;
   end Impl;

end GAL.Lists.Storage.Bounded;
