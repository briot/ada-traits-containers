------------------------------------------------------------------------------
--                     Copyright (C) 2016, AdaCore                          --
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
with System;

package body GAL.Vectors.Storage.Bounded with SPARK_Mode => Off is
   use type System.Address;

   ----------
   -- Impl --
   ----------

   package body Impl is

      ---------------------
      -- Release_Element --
      ---------------------

      procedure Release_Element
        (Self : in out Container'Class; Index : Count_Type) is
      begin
         Elements.Release (Self.Nodes (Index));
      end Release_Element;

      ------------
      -- Assign --
      ------------

      procedure Assign
        (Self        : in out Container'Class;
         Last        : Count_Type;
         Source      : Container'Class;
         Source_Last : Count_Type)
      is
      begin
         if Self.Nodes'Address = Source.Nodes'Address then
            return;
         end if;

         for J in Min_Index .. Last loop
            Release_Element (Self, J);
         end loop;

         Copy (Self, Source, Min_Index, Source_Last, Min_Index);
      end Assign;

      ----------
      -- Copy --
      ----------

      procedure Copy
        (Self                   : in out Container'Class;
         Source                 : Container'Class;
         Source_From, Source_To : Count_Type;
         Self_From              : Count_Type) is
      begin
         if Elements.Copyable then
            Self.Nodes (Self_From .. Self_From + Source_To - Source_From) :=
              Source.Nodes (Source_From .. Source_To);
         elsif Source_From >= Self_From then
            for J in Source_From .. Source_To loop
               Self.Nodes (Self_From + J - Source_From) :=
                 Elements.Copy (Source.Nodes (J));
            end loop;
         else
            for J in reverse Source_From .. Source_To loop
               Self.Nodes (Self_From + J - Source_From) :=
                 Elements.Copy (Source.Nodes (J));
            end loop;
         end if;
      end Copy;

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
               --   ??? should we systematically copy
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

end GAL.Vectors.Storage.Bounded;
