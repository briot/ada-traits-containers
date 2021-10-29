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

--  A graph data structure implemented as an adjacency list.
--  It stores a sequence of out-edges for each vertex.
--
--  ??? Should Vertex_Index be a formal parameter. It could be an enumeration
--      type, which would simplify user code in some places.
--  ??? Would be nice to write "for V of G.Vertices loop"

pragma Ada_2012;

with GAL.Cursors;
with GAL.Properties.Indexed;
with GAL.Elements;
with GAL.Graphs.Components;
with GAL.Graphs.DFS;
private with GAL.Lists.Definite_Unbounded;
private with GAL.Vectors.Definite_Unbounded;

generic
   with package Vertex_Properties is new GAL.Elements.Traits (<>);
   with package Edge_Properties is new GAL.Elements.Traits (<>);
   --  The data associated with edges and properties

   type Container_Base_Type is abstract tagged limited private;
   --  The base type for the graph.
   --  This is a way to make graphs either controlled or limited.

package GAL.Graphs.Adjacency_List is

   package Impl is
      type Graph is new Container_Base_Type with private;

      type Vertex is private;
      Null_Vertex : constant Vertex;
      --  A vertex is the graph.
      --  Depending on how the graph is implemented internally (using vectors
      --  or lists, for instance), a given vertex might change identifier when
      --  the structure of the graph is modified.
      --  For instance, when the list of vertices is stored as a vector, and
      --  you remove a vertex from the graph, then all existing Vertex
      --  descriptors are invalidated.

      type Edge is private;
      --  A descriptor for an edge. Just like for Vertex, existing descriptors
      --  might be invalidated when the structure of the graph is modified.

      function Length (Self : Graph) return Count_Type;
      --  Return the number of vertices in the graph

      function Get_Source (G : Graph; E : Edge) return Vertex with Inline;
      function Get_Target (G : Graph; E : Edge) return Vertex with Inline;
      --  Both ends of an edge

      type Vertex_Cursor is private;
      No_Vertex : constant Vertex_Cursor;
      function First (G : Graph) return Vertex_Cursor;
      function Element (G : Graph; C : Vertex_Cursor) return Vertex;
      function Has_Element (G : Graph; C : Vertex_Cursor) return Boolean;
      function Next (G : Graph; C : Vertex_Cursor) return Vertex_Cursor;

      type Vertex_Edges_Cursor is private;
      function Out_Edges (G : Graph; V : Vertex) return Vertex_Edges_Cursor;
      function Element (G : Graph; C : Vertex_Edges_Cursor) return Edge;
      function Has_Element (G : Graph; C : Vertex_Edges_Cursor) return Boolean;
      function Next
         (G : Graph; C : Vertex_Edges_Cursor) return Vertex_Edges_Cursor;

      function Add_Vertex (Self : in out Graph) return Vertex;
      procedure Add_Vertices (Self : in out Graph; Count : Count_Type);
      function Add_Vertex
         (Self  : in out Graph;
          Props : Vertex_Properties.Element) return Vertex;
      --  Add a new vertex to the graph.
      --  Its associated properties are left uninitialized when the subprogram
      --  has no Props parameter. Your code should immediately set them.

      procedure Set
         (Self  : in out Graph;
          V     : Vertex;
          Props : Vertex_Properties.Element);
      --  Modify the properties associated with a vertex

      function Add_Edge (Self : in out Graph; From, To : Vertex) return Edge;
      procedure Add_Edge (Self : in out Graph; From, To : Vertex);
      function Add_Edge
         (Self     : in out Graph;
          From, To : Vertex;
          Props    : Edge_Properties.Element) return Edge;
      --  Add a new edge to the graph.
      --  Its associated element is left uninitialized, your code should
      --  immediately set it.

      procedure Set
         (Self  : in out Graph;
          E     : Edge;
          Props : Edge_Properties.Element);
      --  Set the properties for the edge

      procedure Clear (Self : in out Graph);
      --  Remove all vertices and edges from the graph

      function Get_Index (V : Vertex) return Vertex_Index
         with Inline;
      --  Return the index of a vertex.
      --  Those indexes are always in the range [1 .. Self.Length].
      --  When you change the structure of the graph, the graph might need to
      --  re-adjust those indexes. Therefore any property map that depends on
      --  them should also be changed.
      --
      --  ??? This should be implemented as its own property map

      function From_Index (Self : Graph; Index : Vertex_Index) return Vertex;
      --   Return the vertex with the given index.
      --
      --   Complexity:
      --      Up to O(n) where n is the number of vertices in graph.
      --      This depends on how the graph is implemented. When using a vector
      --      this is a O(1) operation.

   private
      type Dummy_Record is tagged null record;
      --  This class is doing its own memory management, to all nested
      --  containers are not controlled types. This is slightly more efficient.

      type Vertex is new Vertex_Index'Base;

      type Edge_Details_Type is record
         From, To : Vertex_Index;  --  not Vertex, must be valid index
         Props    : Edge_Properties.Stored;
      end record;
      procedure Release (E : in out Edge_Details_Type);

      package Edge_Details_Lists is new GAL.Lists.Definite_Unbounded
         (Element_Type        => Edge_Details_Type,
          Container_Base_Type => Dummy_Record,
          Free                => Release);
      --  A graph stores all edges in a single list.
      --  That way, undirected graphs can share edges between the two end
      --  vertices.

      type Edge is record
         Current : Edge_Details_Lists.Cursor;
      end record;

      type Edge_Index is new Positive;
      --  The index is only valid for a given vertex

      package Edge_Vectors is new GAL.Vectors.Definite_Unbounded
        (Index_Type          => Edge_Index,
         Element_Type        => Edge, --  pointer into the global list of edges
         Container_Base_Type => Dummy_Record);
      --  Each vertex also stores a list of all its incoming/outgoing edges

      type Vertex_Details_Type is record
         Props     : Vertex_Properties.Stored;
         Out_Edges : Edge_Vectors.Vector;
      end record;
      procedure Release (V : in out Vertex_Details_Type);

      package Vertex_Vectors is new GAL.Vectors.Definite_Unbounded
         (Index_Type          => Vertex_Index,
          Element_Type        => Vertex_Details_Type,
          Container_Base_Type => Dummy_Record,
          Free                => Release);

      Null_Vertex : constant Vertex := Vertex (Vertex_Vectors.No_Index);

      type Graph is new Container_Base_Type with record
         Vertices : Vertex_Vectors.Vector;
         Edges    : Edge_Details_Lists.List;
      end record;

      procedure Adjust (Self : in out Graph);
      procedure Finalize (Self : in out Graph);
      --  Might be overriding

      type Vertex_Cursor is record
         Current : Vertex_Vectors.Cursor;
      end record;
      No_Vertex : constant Vertex_Cursor :=
         (Current => Vertex_Vectors.No_Element);

      type Vertex_Edges_Cursor is record
         From    : Vertex_Index;   --  must be a valid vertex
         Current : Edge_Vectors.Cursor;
      end record;

      function Get_Index (V : Vertex) return Vertex_Index
         is (Vertex_Index (V));
   end Impl;

   subtype Graph is Impl.Graph;
   subtype Vertex is Impl.Vertex;
   subtype Edge is Impl.Edge;
   subtype Vertex_Cursor is Impl.Vertex_Cursor;
   subtype Vertex_Edges_Cursor is Impl.Vertex_Cursor;

   package Vertices_Cursors is new GAL.Cursors.Forward_Cursors
     (Container_Type => Graph,
      Cursor_Type    => Impl.Vertex_Cursor,
      No_Element     => Impl.No_Vertex,
      First          => Impl.First,
      Has_Element    => Impl.Has_Element,
      Next           => Impl.Next,
      "="            => Impl."=");
   --  Iterate over all vertices in a graph

   package Vertices_Maps is new GAL.Properties.Read_Only_Maps
     (Map_Type       => Graph,
      Key_Type       => Impl.Vertex_Cursor,
      Element_Type   => Vertex,
      Get            => Impl.Element);
   --  Retrieve the actual vertex from a vertex cursor

   package Traits is new GAL.Graphs.Traits
     (Graph_Type        => Impl.Graph,
      Vertex_Type       => Vertex,
      Null_Vertex       => Impl.Null_Vertex,
      Get_Index         => Impl.Get_Index);
   package Vertex_Lists is new GAL.Graphs.Vertex_List_Graphs_Traits
     (Graphs            => Traits,
      Vertex_Cursors    => Vertices_Cursors,
      Vertex_Maps       => Vertices_Maps,
      Length            => Impl.Length);
   package Incidence is new GAL.Graphs.Incidence_Graphs_Traits
     (Graphs            => Traits,
      Edge_Type         => Edge,
      Cursor_Type       => Impl.Vertex_Edges_Cursor,
      Out_Edges         => Impl.Out_Edges,
      Element           => Impl.Element,
      Has_Element       => Impl.Has_Element,
      Next              => Impl.Next,
      Source            => Impl.Get_Source,
      Target            => Impl.Get_Target);
   package Adjacency is new GAL.Graphs.Adjacency_Graphs_Traits
     (Graphs            => Traits);
   package Vertex_Mutable is new GAL.Graphs.Vertex_Mutable_Graphs_Traits
     (Graphs            => Traits,
      Add_Vertex        => Impl.Add_Vertex);
   package Edge_Mutable is new GAL.Graphs.Edge_Mutable_Graphs_Traits
     (Graphs            => Traits,
      Edge_Type         => Edge,
      Add_Edge          => Impl.Add_Edge);
   --  Make the various capabilities of adjacency lists available to
   --  algorithms.

   package Color_Maps is new GAL.Properties.Indexed
     (Container_Type      => Graph,
      Key_Type            => Vertex,
      Element_Type        => Color,
      Default_Value       => White,
      Index_Type          => Vertex_Index,
      Container_Base_Type => GAL.Limited_Base,
      Get_Index           => Impl.Get_Index,
      Length              => Impl.Length);
   --  Associates a "color" to a vertex.
   --  This is used for the duration of a number of algorithms to somehow
   --  mark the temporary state of vertices. This should in general be
   --  implemented as an external property map (i.e. the color is not stored
   --  directly in the vertices themselves), so that we can have multiple
   --  algorithms running in parallel and using their own color map.
   --
   --  Such a map is invalidated as soon as the structure of the graph
   --  changes (since vertex indices might change at that time).

   package Integer_Maps is new GAL.Properties.Indexed
     (Container_Type      => Graph,
      Key_Type            => Vertex,
      Element_Type        => Integer,
      Default_Value       => -1,
      Index_Type          => Vertex_Index,
      Container_Base_Type => Container_Base_Type,
      Get_Index           => Impl.Get_Index,
      Length              => Impl.Length);
   --  An integer map is mostly created by the application, since it holds the
   --  results of strongly connected components for instance. So we make it
   --  a controlled type (implicit Clear) if the graph itself is controlled,
   --  so that it is compatible with SPARK when people want to, but on the
   --  other hand it is in general cleared automatically when possible.
   --
   --  Such a map is invalidated as soon as the structure of the graph
   --  changes (since vertex indices might change at that time).

   package All_DFS is new GAL.Graphs.DFS (Vertex_Lists, Incidence);
   package DFS is new All_DFS.Exterior
     (Color_Maps.As_Map, Create_Map => Color_Maps.Create_Map);
   package Strongly_Connected_Components is
      new GAL.Graphs.Components.Strongly_Connected_Components
         (Vertex_Lists   => Vertex_Lists,
          Incidence      => Incidence,
          Component_Maps => Integer_Maps.As_Map);
end GAL.Graphs.Adjacency_List;
