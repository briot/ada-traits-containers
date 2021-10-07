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
with Conts.Cursors;
with Conts.Elements;
with Conts.Properties;

package Conts.Graphs is

   type Color is (White, Gray, Black);
   --  Used to mark vertices during several algorithms.

   Graph_Has_Cycles : exception;

   -------------------
   -- Edges cursors --
   -------------------
   --  Iterates on edges in or out of a vertex

   generic
      type Container_Type (<>) is limited private;
      with package Vertices is new Conts.Elements.Traits (<>);
      type Edge_Type (<>) is private;
      type Cursor_Type is private;
      with function First
         (G : Container_Type; V : Vertices.Element_Type)
         return Cursor_Type is <>;
      with function Element (G : Container_Type; C : Cursor_Type)
         return Edge_Type is <>;
      with function Has_Element (G : Container_Type; C : Cursor_Type)
         return Boolean is <>;
      with function Next (G : Container_Type; C : Cursor_Type)
         return Cursor_Type is <>;
   package Edge_Cursors is
      subtype Container is Container_Type;
      subtype Edge      is Edge_Type;
      subtype Cursor    is Cursor_Type;
   end Edge_Cursors;

   ------------
   -- Traits --
   ------------
   --  Abstract description of a graph.
   --  All algorithms need to iterate on all vertices of the graph, and at
   --  least on the out edges of a given vertex, so these two cursors are also
   --  part of these requirements.
   --  Such a traits package can be instantiated for your own data structures
   --  that might have an implicit graph somewhere, even if you do not use an
   --  explicit graph type anywhere.

   generic
      type Graph_Type (<>) is limited private;
      with package Vertices is new Conts.Elements.Traits (<>);
      type Edge_Type (<>) is private;
      Null_Vertex : Vertices.Element;

      with function Get_Target
        (G : Graph_Type; E : Edge_Type) return Vertices.Element is <>;
      --  Return the target of the edge.
      --  ??? What does it mean for an undirected graph

      with package Vertex_Cursors is new Conts.Cursors.Forward_Cursors
        (Container_Type => Graph_Type,
         others         => <>);
      with package Vertex_Maps is new Conts.Properties.Read_Only_Maps
        (Key_Type     => Vertex_Cursors.Cursor,
         Element_Type => Vertices.Element,
         Map_Type     => Graph_Type,
         others       => <>);
      --  Iterate on all vertices of the graph

      with package Out_Edges_Cursors is new Edge_Cursors
        (Container_Type => Graph_Type,
         Vertices       => Vertices,
         Edge_Type      => Edge_Type,
         others         => <>);
      --  Iterate on all out-edges of a given vertex.

   package Traits is

      subtype Graph  is Graph_Type;
      subtype Vertex is Vertices.Element;
      subtype Edge   is Edge_Type;
      Cst_Null_Vertex : constant Vertex := Null_Vertex;

      function Get_Edge_Target
        (G : Graph; E : Edge) return Vertices.Element renames Get_Target;

   end Traits;

end Conts.Graphs;
