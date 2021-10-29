--  Generate various kinds of graphs

generic
   with package Graph is new GAL.Graphs.Traits (<>);
   with procedure Clear (Self : in out Graph.Graph) is <>;
   with procedure Add_Vertices
      (Self     : in out Graph.Graph;
       Count    : Count_Type := 1) is <>;
   with procedure Add_Edge
      (Self     : in out Graph.Graph;
       From, To : Graph.Vertex) is <>;
package GAL.Graphs.Generators is

   procedure Complete
      (Self         : in out Graph.Graph;
       N            : Count_Type);
   --  Return the complete graph with N nodes.
   --
   --  A complete graph on N nodes means that all pairs of distinct nodes have
   --  an edge connecting them.

end GAL.Graphs.Generators;
