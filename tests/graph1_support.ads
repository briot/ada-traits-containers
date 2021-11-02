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

--  An example of wrapping a custom data structure into the various traits
--  packages that are needed to use the graph algorithms

pragma Ada_2012;
with GAL.Cursors;
with GAL.Elements.Definite;
with GAL.Graphs;      use GAL.Graphs;
with GAL.Graphs.DFS;
with GAL.Properties;
with Test_Support;

package Graph1_Support is

   ------------
   -- Graphs --
   ------------

   type Vertex is new Integer;
   package Vertices is new GAL.Elements.Definite (Vertex);

   function Get_Index (V : Vertex) return GAL.Graphs.Vertex_Index
      is (GAL.Graphs.Vertex_Index (V));

   type Edge is record
      Source, Target : Vertex;
   end record;

   type Color_Map is array (Vertex range <>) of Color;

   type Graph is record
      Colors : Color_Map (1 .. Test_Support.Items_Count);
   end record;

   function Get_Source (Ignored : Graph; E : Edge) return Vertex is (E.Source);
   function Get_Target (Ignored : Graph; E : Edge) return Vertex is (E.Target);
   function Length (Self : Graph) return GAL.Count_Type
      is (GAL.Count_Type (Self.Colors'Length));

   --------------------
   -- Vertex_Cursors --
   --------------------

   type Vertex_Cursor is new Integer;
   function First (G : Graph) return Vertex_Cursor with Inline;
   function Element (G : Graph; C : Vertex_Cursor) return Vertex with Inline;
   function Has_Element
     (G : Graph; C : Vertex_Cursor) return Boolean with Inline;
   procedure Next (G : Graph; C : in out Vertex_Cursor) with Inline;

   package Custom_Vertices is new GAL.Cursors.Forward_Cursors
     (Container_Type => Graph,
      Cursor_Type    => Vertex_Cursor,
      No_Element     => Vertex_Cursor'Last);
   package Vertices_Maps is new GAL.Properties.Read_Only_Maps
     (Map_Type       => Graph,
      Key_Type       => Vertex_Cursor,
      Element_Type   => Vertex,
      Get            => Element);

   ------------------
   -- Edge_Cursors --
   ------------------
   --  Not a very interesting graph
   --     1 -> 2 -> 3 -> 4 -> 5 -> ...

   type Edge_Cursor is new Integer;
   function Out_Edges (G : Graph; V : Vertex) return Edge_Cursor with Inline;
   function Element (G : Graph; C : Edge_Cursor) return Edge with Inline;
   function Has_Element
     (G : Graph; C : Edge_Cursor) return Boolean with Inline;
   procedure Next (G : Graph; C : in out Edge_Cursor);

   -----------
   -- Graph --
   -----------

   package Custom_Graphs is new GAL.Graphs.Traits
      (Graph_Type        => Graph,
       Vertex_Type       => Vertex,
       Get_Index         => Get_Index,
       Null_Vertex       => -1);
   package Vertex_Lists is new GAL.Graphs.Vertex_List_Graphs_Traits
      (Graphs            => Custom_Graphs,
       Vertex_Cursors    => Custom_Vertices,
       Vertex_Maps       => Vertices_Maps,
       Length            => Length);
   package Incidence is new GAL.Graphs.Incidence_Graphs_Traits
      (Graphs            => Custom_Graphs,
       Edge_Type         => Edge,
       Cursor_Type       => Edge_Cursor,
       Out_Edges         => Out_Edges,
       Source            => Get_Source,
       Target            => Get_Target);

   ----------------
   -- Color maps --
   ----------------

   procedure Set_Color (G : in out Graph; V : Vertex; C : Color);
   function Get_Color (G : Graph; V : Vertex) return Color;
   package Color_Maps is new GAL.Properties.Maps
      (Graph, Vertex, Color, Set_Color, Get_Color);

   ----------------------
   -- Incidence_Graphs --
   ----------------------

   package All_DFS is new GAL.Graphs.DFS (Vertex_Lists, Incidence);
   package DFS is new All_DFS.Interior (Color_Maps => Color_Maps);

   ----------------
   -- Algo --
   ----------------

   type My_Visitor is null record;  --  no callback
   package My_Visitors is new All_DFS.DFS_Visitor_Traits
      (Visitor_Type => My_Visitor);

   type My_Visitor2 is null record;
   procedure Initialize_Vertex (Ignored : in out My_Visitor2; V : Vertex);
   procedure Start_Vertex      (Ignored : in out My_Visitor2; V : Vertex);
   procedure Finish_Vertex     (Ignored : in out My_Visitor2; V : Vertex);
   procedure Discover_Vertex
      (Ignored : in out My_Visitor2; V : Vertex; Stop : in out Boolean);
   package My_Visitors2 is new All_DFS.DFS_Visitor_Traits
      (Visitor_Type      => My_Visitor2,
       Initialize_Vertex => Initialize_Vertex,
       Start_Vertex      => Start_Vertex,
       Finish_Vertex     => Finish_Vertex,
       Discover_Vertex   => Discover_Vertex);

end Graph1_Support;
