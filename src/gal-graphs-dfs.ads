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

--  This package provides various algorithms that do a single depth first
--  search traversal, and return various results.
--
--  The three packages below behave the same (and in fact share implementation)
--  but they apply to different kinds of property maps. So only the first
--  package is fully documented.

pragma Ada_2012;
with GAL.Properties;

generic
   with package Vertex_Lists is new GAL.Graphs.Vertex_List_Graphs_Traits
      (<>);
   --  These algorithms need to iterate on all vertices of the graph

   with package Incidence is new GAL.Graphs.Incidence_Graphs_Traits
      (Graphs => Vertex_Lists.Graphs, others => <>);
   --  They also need to find all out-edges for a given vertex

package GAL.Graphs.DFS is

   package Graphs renames Vertex_Lists.Graphs;

   ------------------------
   -- DFS_Visitor_Traits --
   ------------------------
   --  When we run a depth-first-search, we might want to retrieve various
   --  details on the running of the algorithm. This is used to implement
   --  multiple other algorithms on top of this one.
   --  As always, we use a traits package to specify the various callbacks, so
   --  that no performance penalty occurs when a subprogram does nothing.

   pragma Warnings (Off, "is not referenced");
   generic
      type Visitor_Type (<>) is limited private;

      with procedure Should_Stop
        (Self   : Visitor_Type;
         Vertex : Graphs.Vertex;
         Stop   : in out Boolean) is null;
      --  Whether to stop iterating after discovering Vertex.
      --  If iteration should stop, this procedure should set Stop to True (its
      --  initial value is always False).
      --  This can be used for instance when you are only interested in finding
      --  whether there exists a path between two specific vertices.
      --  It should also be used for infinite graphs (those an infinite number
      --  of vertices that are created on the fly for instance).

      with procedure Vertices_Initialized
        (Self  : in out Visitor_Type;
         Count : Count_Type) is null;
      --  Provide the number of vertices in the graph. This might be used to
      --  reserve_capacity for some internal data for instance.
      --  This is called after all vertices have been initialized via
      --  Initialize_Vertex.

      with procedure Initialize_Vertex
         (Self   : in out Visitor_Type;
          Vertex : Graphs.Vertex) is null;
      --  Called on every vertex before the start of the search
      --  ??? Not compatible with infinite graphs.

      with procedure Start_Vertex
         (Self   : in out Visitor_Type;
          Vertex : Graphs.Vertex) is null;
      --  Called on a source vertex once before the start of the search.
      --  All vertices reachable from the source will not be source vertices
      --  themselves, so will not be called for Start_Vertex.

      with procedure Finish_Vertex
         (Self   : in out Visitor_Type;
          Vertex : Graphs.Vertex) is null;
      --  Called on every vertex after all its out edges have been added to the
      --  search tree and its adjacent vertices have been visited.

      with procedure Discover_Vertex
         (Self   : in out Visitor_Type;
          Vertex : Graphs.Vertex) is null;
      --  Called when a vertex is encountered the first time.

      with procedure Examine_Edge
         (Self : in out Visitor_Type;
          Edge : Graphs.Edge) is null;
      --  Called for every out edge of every vertex, after it is discovered.

      with procedure Tree_Edge
         (Self : in out Visitor_Type;
          Edge : Graphs.Edge) is null;
      --  Called on each edge when it becomes a member of the edges that form
      --  a spanning tree (i.e. for out edges that do not lead to an already
      --  visited vertex).
      --  Those are edges that lead to unvisited vertices.

      with procedure Back_Edge
         (Self : in out Visitor_Type;
          Edge : Graphs.Edge) is null;
      --  Called on the back edges of the graph.
      --  Those are edges that lead back to a visited ancestors vertex in the
      --  tree.
      --  For an undirected graph, there is an ambiguity between Back_Edge and
      --  Tree_Edge, so both are called.

      with procedure Forward_Or_Cross_Edge
         (Self : in out Visitor_Type;
          Edge : Graphs.Edge) is null;
      --  Called on forward or cross edges, unused for undirected
      --  Forward edges lead to a visited descendant vertex in the tree.
      --  Cross edges lead to a visited vertex which is neither ancestor nor
      --  descendant in the tree.

      with procedure Finish_Edge
         (Self : in out Visitor_Type;
          Edge : Graphs.Edge) is null;
      --  Called when the algorithm finishes processing an edge

   package DFS_Visitor_Traits is
   end DFS_Visitor_Traits;

   pragma Warnings (On, "is not referenced");

   --------------
   -- With_Map --
   --------------
   --  The map is given explicitly as a parameter, so that we do not need the
   --  Create_Map function and can use this for both interior and exterior
   --  maps, or with types of maps that cannot easily be returned from a
   --  function.
   --  This is the most general implementation of the algorithm.

   generic
      with package Color_Maps is new GAL.Properties.Maps
        (Key_Type     => Vertex_Lists.Graphs.Vertex,
         Element_Type => Color,
         others       => <>);
   package With_Map is

      generic
         with package Visitors is new DFS_Visitor_Traits (<>);
      procedure Search
        (G      : Graphs.Graph;
         Visit  : in out Visitors.Visitor_Type;
         Colors : out Color_Maps.Map;
         V      : Graphs.Vertex := Graphs.Null_Vertex);
      --  A depth first search is a traversal of the graph that always chooses
      --  to go deeper in the graph when possible, by looking at the next
      --  adjacent undiscovered vertex until reaching a vertex that has no
      --  undiscovered adjacent vertex. It then backtracks to the previous
      --  vertex.
      --
      --  All vertices and edges are visited exactly once.
      --
      --  Searching starts at V, if specified, but all vertices are eventually
      --  visited, unless Visit.Should_Stop returns True before then. In the
      --  case of an infinite graph, the caller must make sure that Should_Stop
      --  eventually returns True.
      --
      --  Depth First Search is a basic block for a lot of other algorithms.
      --  However, it is also useful on its own:
      --    * compute whether a vertex is reachable from another vertex
      --    * detect cycles in a graph
      --
      --  This algorithm needs to mark visited vertices with colors, using the
      --  provided map.
      --
      --  Complexity:  O( |edges| + |vertices| )
      --
      --  This algorithm returns nothing. All actions happen through a visitor.
      --  Calls to the visitor's operations are not dispatching, so that they
      --  can be inlined by the compiler and provide maximum performance.

      generic
         with package Visitors is new DFS_Visitor_Traits (<>);
      procedure Search_Recursive
        (G      : Graphs.Graph;
         Visit  : in out Visitors.Visitor_Type;
         Colors : out Color_Maps.Map;
         V      : Graphs.Vertex := Graphs.Null_Vertex);
      --  A recursive version of the DFS algorithm.
      --  It is fractionally faster on small graph, and is not compatible with
      --  large graphs (since the depth of recursion with blow the stack).

      function Is_Acyclic
        (G      : Graphs.Graph;
         Colors : out Color_Maps.Map) return Boolean;
      --  Whether the graph has no cycles

      generic
         with procedure Callback (V : Graphs.Vertex);
      procedure Reverse_Topological_Sort
        (G      : Graphs.Graph;
         Colors : out Color_Maps.Map);
      --  Return the vertices in reverse topological order.
      --
      --  Raises Graph_Has_Cycles if the graph has cycles and cannot be used
      --  with this algorithm.
      --
      --  Topological order:
      --  If the graph contains an edge (u-->v), then v will always be finished
      --  first, i.e. the visitor's Finish_Vertex operation will be called on v
      --  before it is called on u. And the Callback will also be called on v
      --  before it is called on u.

   end With_Map;

   -------------------
   -- Exterior maps --
   -------------------
   --  Depth-First-Search with exterior color maps.
   --  The map is automatically created and cleared by the algorithm.

   generic
      with package Color_Maps is new GAL.Properties.Maps
        (Key_Type     => Vertex_Lists.Graphs.Vertex,
         Element_Type => Color,
         others       => <>);
      with function Create_Map
         (G : Vertex_Lists.Graphs.Graph) return Color_Maps.Map;
   package Exterior is

      generic
         with package Visitors is new DFS_Visitor_Traits (<>);
      procedure Search
        (G     : Graphs.Graph;
         Visit : in out Visitors.Visitor_Type;
         V     : Graphs.Vertex := Graphs.Null_Vertex);

      generic
         with package Visitors is new DFS_Visitor_Traits (<>);
      procedure Search_Recursive
        (G     : Graphs.Graph;
         Visit : in out Visitors.Visitor_Type;
         V     : Graphs.Vertex := Graphs.Cst_Null_Vertex);

      function Is_Acyclic (G : Graphs.Graph) return Boolean;

      generic
         with procedure Callback (V : Graphs.Vertex);
      procedure Reverse_Topological_Sort (G : Graphs.Graph);

   end Exterior;

   -------------------
   -- Interior maps --
   -------------------
   --  Depth-First-Search
   --  This version stores the vertices colors in the graph itself.
   --  This version will not, in general, support simultaneous runs of the
   --  algorithms, since they would interfere in the color map.

   generic
      with package Color_Maps is new GAL.Properties.Maps
        (Map_Type     => Vertex_Lists.Graphs.Graph,
         Key_Type     => Vertex_Lists.Graphs.Vertex,
         Element_Type => Color,
         others       => <>);
   package Interior is

      generic
         with package Visitors is new DFS_Visitor_Traits (<>);
      procedure Search
        (G     : in out Graphs.Graph;
         Visit : in out Visitors.Visitor_Type;
         V     : Graphs.Vertex := Graphs.Cst_Null_Vertex);

      generic
         with package Visitors is new DFS_Visitor_Traits (<>);
      procedure Search_Recursive
        (G     : in out Graphs.Graph;
         Visit : in out Visitors.Visitor_Type;
         V     : Graphs.Vertex := Graphs.Cst_Null_Vertex);

      function Is_Acyclic (G : in out Graphs.Graph) return Boolean;

      generic
         with procedure Callback (V : Graphs.Vertex);
      procedure Reverse_Topological_Sort (G : in out Graphs.Graph);

   end Interior;

end GAL.Graphs.DFS;
