--  Generate various kinds of graphs

generic
   with package Vertex_Mutable is new GAL.Graphs.Vertex_Mutable_Graphs_Traits
      (<>);
   --  Must be able to add vertices

   with package Edge_Mutable is new GAL.Graphs.Edge_Mutable_Graphs_Traits
      (Graphs => Vertex_Mutable.Graphs, others => <>);
   --  Must be able to add edges

package GAL.Graphs.Generators is
   package Graphs renames Vertex_Mutable.Graphs;
   subtype Graph_Type is Graphs.Graph;

   procedure Complete
      (Self         : in out Graph_Type;
       N            : Count_Type);
   --  Return the complete graph with N nodes.
   --  This assumes the graph is initially empty.
   --
   --  A complete graph on N nodes means that all pairs of distinct nodes have
   --  an edge connecting them.

end GAL.Graphs.Generators;
