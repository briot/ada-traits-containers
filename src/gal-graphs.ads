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
with GAL.Cursors;
with GAL.Properties;

package GAL.Graphs is

   type Color is (White, Gray, Black);
   --  Used to mark vertices during several algorithms.

   type Vertex_Index is new Positive;
   --  All vertices can always be mapped to a range of [1..N] integers, where
   --  N is the number of vertices in the graph.

   Graph_Has_Cycles : exception;

   ------------
   -- Traits --
   ------------
   --  Abstract description of a graph.
   --  Those are only very general concepts. There are more specialized
   --  packages below, which algorithms should chose depending on their needs.
   --  The reason was splitting things up is that algorithms can request the
   --  minimal set of features they need, which in turn makes them easier to
   --  reuse with custom graph types (no need to instantiate all features of
   --  graphs for instance).
   --  Such a traits package can be instantiated for your own data structures
   --  that might have an implicit graph somewhere, even if you do not use an
   --  explicit graph type anywhere.

   generic
      type Graph_Type (<>) is limited private;
      type Vertex_Type is private;
      type Edge_Type is private;
      Null_Vertex : Vertex_Type;

      with function Get_Index (V : Vertex_Type) return Vertex_Index is <>;
      --  Return the index of a vertex.
      --  This is always in the range [1..N] where N is the total number of
      --  vertices in the graph. The index for a given Vertex might change as
      --  the graph structure is modified (by adding or removing vertices)
      --
      --  ??? should be a property map instead

   package Traits is

      subtype Graph  is Graph_Type;
      subtype Vertex is Vertex_Type;
      subtype Edge   is Edge_Type;
      Cst_Null_Vertex : constant Vertex := Null_Vertex;

   end Traits;

   ------------------------
   -- Vertex List Graphs --
   ------------------------
   --  These graphs provide efficient traversal of all vertices in the graph

   generic
      with package Graphs is new Traits (<>);
      with package Vertex_Cursors is new GAL.Cursors.Forward_Cursors
        (Container_Type => Graphs.Graph,
         others         => <>);
      with package Vertex_Maps is new GAL.Properties.Read_Only_Maps
        (Key_Type     => Vertex_Cursors.Cursor,
         Element_Type => Graphs.Vertex_Type,
         Map_Type     => Graphs.Graph_Type,
         others       => <>);
      --  Iterate on all vertices of the graph

      with function Length (G : Graphs.Graph_Type) return Count_Type;
      --  Return the number of vertices in the graph.
      --  Complexity: must be O(n) though in general it will be O(1)

   package Vertex_List_Graphs_Traits is
   end Vertex_List_Graphs_Traits;

   ----------------------
   -- Incidence Graphs --
   ----------------------
   --  These graphs provide a way to efficiently access out edges of a given
   --  vertex.

   generic
      with package Graphs is new Traits (<>);

      type Cursor_Type is private;
      with function Out_Edges (G : Graphs.Graph; V : Graphs.Vertex)
         return Cursor_Type is <>;
      with function Element (G : Graphs.Graph; C : Cursor_Type)
         return Graphs.Edge is <>;
      with function Has_Element (G : Graphs.Graph; C : Cursor_Type)
         return Boolean is <>;
      with function Next (G : Graphs.Graph; C : Cursor_Type)
         return Cursor_Type is <>;
      --  Iterate on all out-edges of a given vertex.

      with function Source (G : Graphs.Graph; E : Graphs.Edge)
        return Graphs.Vertex is <>;
      with function Target (G : Graphs.Graph; E : Graphs.Edge)
        return Graphs.Vertex is <>;
      --  Return the source and target of the edge.
      --  Complexity: constant time
      --
      --  ??? What does it mean for an undirected graph

      --  ??? Out_Degree
   package Incidence_Graphs_Traits is
      subtype Cursor is Cursor_Type;

      function Edge_Source
        (G : Graphs.Graph; E : Graphs.Edge) return Graphs.Vertex
        renames Source;
      function Edge_Target
        (G : Graphs.Graph; E : Graphs.Edge) return Graphs.Vertex
        renames Target;

   end Incidence_Graphs_Traits;

   -----------------------
   --  Adjacency Graphs --
   -----------------------
   --  These graphs provide access to the adjacent vertices of a given vertex.
   --  Those could be computed by looking at the out-edges and getting their
   --  targets, but some algorithms only need the vertices, not the edges, so
   --  this might make it simpler to use those algorithms with custom graphs.

   generic
      with package Graphs is new Traits (<>);
      --  ??? Adjacent_Vertices
   package Adjacency_Graphs_Traits is
   end Adjacency_Graphs_Traits;

   ---------------------------
   -- Vertex Mutable Graphs --
   ---------------------------
   --  A vertex mutable graph can be changed by adding or removing vertices.

   generic
      with package Graphs is new Traits (<>);

      with function Add_Vertex
         (Self : in out Graphs.Graph) return Graphs.Vertex is <>;
      --  Add a new vertex to the graph.
      --  Its properties are uninitialized.
      --  This operation may invalidate existing Vertex of the graph depending
      --  on the graph implementation.
      --  Complexity:
      --     must be amortized constant time

      --  ??? Remove_Vertex
   package Vertex_Mutable_Graphs_Traits is
   end Vertex_Mutable_Graphs_Traits;

   -------------------------
   -- Edge Mutable Graphs --
   -------------------------
   --  An edge mutable graph can be changed by adding or removing edges

   generic
      with package Graphs is new Traits (<>);

      with function Add_Edge
         (Self : in out Graphs.Graph; From, To : Graphs.Vertex)
         return Graphs.Edge is <>;
      --  Attempt to insert a new edge in the graph. This might fail when the
      --  graph doesn't allow parallel edges and you try to add a second edge
      --  between From and To. Or in other cases, for instance when From=To
      --  and the graph doesn't allow such self edges.
      --  This operation must not invalidate Vertex or vertex iterators of the
      --  graph.
      --  It may invalidate Edge or edge iterators.
      --  Complexity:
      --     must be either amortized constant time, or O(log(E/V)) if the
      --     insertion also checks to prevent the addition of parallel edges.

      --  ??? Remove_Edges
      --  ??? Clear_Vertex
   package Edge_Mutable_Graphs_Traits is
   end Edge_Mutable_Graphs_Traits;

end GAL.Graphs;
