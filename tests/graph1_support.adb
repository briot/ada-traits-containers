------------------------------------------------------------------------------
--                     Copyright (C) 2016-2016, AdaCore                     --
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
with Ada.Text_IO; use Ada.Text_IO;

package body Graph1_Support is

   Output : constant Boolean := False;

   function Create_Color_Map
      (G : Graph_Access; Default_Value : Color) return Graph_Access
   is
   begin
      G.Colors := (others => Default_Value);
      return G;
   end Create_Color_Map;

   procedure Set_Color (G : in out Graph_Access; V : Vertex; C : Color) is
   begin
      G.Colors (V) := C;
   end Set_Color;

   function Get_Color (G : Graph_Access; V : Vertex) return Color is
   begin
      return G.Colors (V);
   end Get_Color;

   procedure Initialize_Vertex (Ignored : in out My_Visitor2; V : Vertex) is
   begin
      if Output then
         Put_Line ("Initialize" & V'Img);
      end if;
   end Initialize_Vertex;

   procedure Start_Vertex (Ignored : in out My_Visitor2; V : Vertex) is
   begin
      if Output then
         Put_Line ("Start" & V'Img);
      end if;
   end Start_Vertex;

   procedure Finish_Vertex (Ignored : in out My_Visitor2; V : Vertex) is
   begin
      if Output then
         Put_Line ("Finish" & V'Img);
      end if;
   end Finish_Vertex;

   procedure Discover_Vertex
      (Ignored : in out My_Visitor2; V : Vertex; Stop : in out Boolean)
   is
      pragma Unreferenced (Stop);
   begin
      if Output then
         Put_Line ("Discover" & V'Img);
      end if;
   end Discover_Vertex;

   function First (G : Graph) return Vertex_Cursor is
   begin
      return Vertex_Cursor (G.Colors'First);
   end First;

   function Element (G : Graph; C : Vertex_Cursor) return Vertex is
      pragma Unreferenced (G);
   begin
      return Vertex (C);
   end Element;

   function Has_Element
      (G : Graph; C : Vertex_Cursor) return Boolean is
   begin
      return C <= Vertex_Cursor (G.Colors'Last);
   end Has_Element;

   procedure Next (G : Graph; C : in out Vertex_Cursor) is
      pragma Unreferenced (G);
   begin
      C := C + 1;
   end Next;

   function Out_Edges (G : Graph; V : Vertex) return Edge_Cursor is
      pragma Unreferenced (G);
   begin
      return Edge_Cursor (V);
   end Out_Edges;

   function Element (G : Graph; C : Edge_Cursor) return Edge is
      pragma Unreferenced (G);
   begin
      return (Source => Vertex (C), Target => Vertex (C + 1));
   end Element;

   function Has_Element
      (G : Graph; C : Edge_Cursor) return Boolean is
   begin
      return Integer (C) >= Integer (G.Colors'First)
         and then Integer (C) < Integer (G.Colors'Last);
   end Has_Element;

   procedure Next (G : Graph; C : in out Edge_Cursor) is
   begin
      --  Only one edge from each vertex
      C := Edge_Cursor (G.Colors'Last + 1);
   end Next;

end Graph1_Support;
