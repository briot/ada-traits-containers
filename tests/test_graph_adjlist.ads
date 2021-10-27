pragma Ada_2012;
with Report;

package Test_Graph_Adjlist is
   procedure Test;
   procedure Test_Perf_Custom
      (Stdout : in out Report.Output'Class; Favorite : Boolean);
   procedure Test_Perf_Adjacency_List
      (Stdout : in out Report.Output'Class; Favorite : Boolean);
end Test_Graph_Adjlist;
