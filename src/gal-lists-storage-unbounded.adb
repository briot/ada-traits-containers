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
with Ada.Unchecked_Deallocation;

package body GAL.Lists.Storage.Unbounded with SPARK_Mode => Off is

   procedure Unchecked_Free is new Ada.Unchecked_Deallocation
      (Node, Node_Access);

   --------------
   -- Allocate --
   --------------

   procedure Allocate
      (Self    : in out Nodes_Container'Class;
       N       : out Node_Access)
   is
      pragma Unreferenced (Self);
   begin
      N := new Node;
   end Allocate;

   ------------------
   -- Release_Node --
   ------------------

   procedure Release_Node
      (Self : in out Nodes_Container'Class; N : in out Node_Access)
   is
      pragma Unreferenced (Self);
   begin
      Unchecked_Free (N);
   end Release_Node;

   -------------------
   -- Get_RO_Stored --
   -------------------

   function Get_RO_Stored
      (Self : aliased Nodes_Container'Class;
       Pos  : Node_Access)
      return not null access constant Elements.Stored_Type
   is
      pragma Unreferenced (Self);
   begin
      return Pos.Element'Access;
   end Get_RO_Stored;

   -------------------
   -- Get_RW_Stored --
   -------------------

   function Get_RW_Stored
      (Self : in out Nodes_Container'Class;
       Pos  : Node_Access)
      return not null access Elements.Stored_Type
   is
      pragma Unreferenced (Self);
   begin
      return Pos.Element'Access;
   end Get_RW_Stored;

   --------------
   -- Get_Next --
   --------------

   function Get_Next
      (Self : Nodes_Container'Class; N : Node_Access) return Node_Access
   is
      pragma Unreferenced (Self);
   begin
      return N.Next;
   end Get_Next;

   ------------------
   -- Get_Previous --
   ------------------

   function Get_Previous
      (Self : Nodes_Container'Class; N : Node_Access) return Node_Access
   is
      pragma Unreferenced (Self);
   begin
      return N.Previous;
   end Get_Previous;

   ------------------
   -- Set_Previous --
   ------------------

   procedure Set_Previous
      (Self : in out Nodes_Container'Class; N, Previous : Node_Access)
   is
      pragma Unreferenced (Self);
   begin
      N.Previous := Previous;
   end Set_Previous;

   --------------
   -- Set_Next --
   --------------

   procedure Set_Next
      (Self : in out Nodes_Container'Class; N, Next : Node_Access)
   is
      pragma Unreferenced (Self);
   begin
      N.Next := Next;
   end Set_Next;

   ------------
   -- Assign --
   ------------

   procedure Assign
      (Nodes    : in out Nodes_Container'Class;
       Source   : Nodes_Container'Class;
       New_Head : out Node_Access;
       Old_Head : Node_Access;
       New_Tail : out Node_Access;
       Old_Tail : Node_Access)
   is
      pragma Unreferenced (Source, Old_Tail);
      N, Tmp, Tmp2 : Node_Access;
   begin
      if Old_Head = null then
         New_Head := null;
         New_Tail := null;
         return;
      end if;

      Tmp2 := Old_Head;
      Allocate (Nodes, Tmp);
      if Elements.Copyable then
         Tmp.Element := Tmp2.Element;
      else
         Tmp.Element := Elements.Copy (Tmp2.Element);
      end if;
      New_Head := Tmp;

      loop
         Tmp2 := Tmp2.Next;
         exit when Tmp2 = null;

         Allocate (Nodes, N);
         if Elements.Copyable then
            N.Element := Tmp2.Element;
         else
            N.Element := Elements.Copy (Tmp2.Element);
         end if;

         Tmp.Next := N;
         N.Previous := Tmp;
         Tmp := N;
      end loop;

      New_Tail := N;
   end Assign;

   ----------
   -- Swap --
   ----------

   procedure Swap (Nodes : in out Nodes_Container'Class; L, R : Node_Access) is
      pragma Unreferenced (Nodes);
   begin
      --  We cannot just change the node's previous and next. Although this
      --  would be way more efficient, it also changes the position of the node
      --  in the list, and algorithms do not expect that in general.

      if Elements.Movable then
         declare
            Tmp : constant Elements.Stored_Type := L.Element;
         begin
            L.Element := R.Element;
            R.Element := Tmp;
         end;
      else
         declare
            Tmp : constant Elements.Stored_Type := Elements.Copy (L.Element);
         begin
            Elements.Release (L.Element);
            L.Element := R.Element;
            Elements.Release (R.Element);
            R.Element := Tmp;
         end;
      end if;
   end Swap;

end GAL.Lists.Storage.Unbounded;
