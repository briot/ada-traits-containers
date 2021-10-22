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
with Conts.Cursors;
with Conts.Elements.Definite;
with Conts.Graphs;      use Conts.Graphs;
with Conts.Graphs.DFS;
with Conts.Properties;
with Test_Support;

package Graph1_Support is

   ------------
   -- Graphs --
   ------------

   type Vertex is new Integer;
   package Vertices is new Conts.Elements.Definite (Vertex);

   type Edge is record
      Source, Target : Vertex;
   end record;

   type Color_Map is array (Vertex range <>) of Color;

   type Graph is record
      Colors : Color_Map (1 .. Test_Support.Items_Count);
   end record;

   --------------------
   -- Vertex_Cursors --
   --------------------

   type Vertex_Cursor is new Integer;
   function First (G : Graph) return Vertex_Cursor with Inline;
   function Element (G : Graph; C : Vertex_Cursor) return Vertex with Inline;
   function Has_Element
     (G : Graph; C : Vertex_Cursor) return Boolean with Inline;
   function Next
     (G : Graph; C : Vertex_Cursor) return Vertex_Cursor with Inline;

   package Custom_Vertices is new Conts.Cursors.Forward_Cursors
     (Container_Type => Graph,
      Cursor_Type    => Vertex_Cursor,
      No_Element     => Vertex_Cursor'Last);
   package Vertices_Maps is new Conts.Properties.Read_Only_Maps
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
   function First (G : Graph; V : Vertex) return Edge_Cursor with Inline;
   function Element (G : Graph; C : Edge_Cursor) return Edge with Inline;
   function Has_Element
     (G : Graph; C : Edge_Cursor) return Boolean with Inline;
   function Next
     (G : Graph; C : Edge_Cursor) return Edge_Cursor with Inline;

   package Custom_Edges is new Edge_Cursors
     (Container_Type => Graph,
      Vertices       => Vertices.Traits,
      Edge_Type      => Edge,
      Cursor_Type    => Edge_Cursor);

   -----------
   -- Graph --
   -----------

   function Get_Target (G : Graph; E : Edge) return Vertex;
   package Custom_Graphs is new Conts.Graphs.Traits
      (Graph_Type        => Graph,
       Vertices          => Vertices.Traits,
       Null_Vertex       => -1,
       Vertex_Cursors    => Custom_Vertices,
       Vertex_Maps       => Vertices_Maps,
       Out_Edges_Cursors => Custom_Edges);

   ----------------
   -- Color maps --
   ----------------

   procedure Set_Color (G : in out Graph; V : Vertex; C : Color);
   function Get_Color (G : Graph; V : Vertex) return Color;
   package Color_Maps is new Conts.Properties.Maps
      (Graph, Vertex, Color, Set_Color, Get_Color);

   ----------------------
   -- Incidence_Graphs --
   ----------------------

   package DFS is new Conts.Graphs.DFS.Interior
     (Graphs     => Custom_Graphs,
      Color_Maps => Color_Maps);

   ----------------
   -- Algorithms --
   ----------------

   type My_Visitor is null record;  --  no callback
   package My_Visitors is new Conts.Graphs.DFS.DFS_Visitor_Traits
      (Graphs       => Custom_Graphs,
       Visitor_Type => My_Visitor);

   type My_Visitor2 is null record;
   procedure Initialize_Vertex (Ignored : in out My_Visitor2; V : Vertex);
   procedure Start_Vertex      (Ignored : in out My_Visitor2; V : Vertex);
   procedure Finish_Vertex     (Ignored : in out My_Visitor2; V : Vertex);
   procedure Discover_Vertex   (Ignored : in out My_Visitor2; V : Vertex);
   package My_Visitors2 is new Conts.Graphs.DFS.DFS_Visitor_Traits
      (Graphs            => Custom_Graphs,
       Visitor_Type      => My_Visitor2,
       Initialize_Vertex => Initialize_Vertex,
       Start_Vertex      => Start_Vertex,
       Finish_Vertex     => Finish_Vertex,
       Discover_Vertex   => Discover_Vertex);

end Graph1_Support;