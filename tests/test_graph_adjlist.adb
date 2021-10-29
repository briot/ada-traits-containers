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
with Asserts;
with GAL.Elements.Null_Elements;
with GAL.Graphs.Adjacency_List;
with GAL.Graphs.DFS;
with GAL;                           use GAL;
with Graph1_Support;                use Graph1_Support;
with Report;                        use Report;
with System.Storage_Elements;       use System.Storage_Elements;
with Test_Support;                  use Test_Support;

package body Test_Graph_Adjlist is
   use Asserts.Integers;
   use type GAL.Graphs.Vertex_Index;

   Category  : constant String := "Integer Graph";

   package Graphs is new GAL.Graphs.Adjacency_List
     (Vertex_Properties   => GAL.Elements.Null_Elements.Traits,
      Edge_Properties     => GAL.Elements.Null_Elements.Traits,
      Container_Base_Type => GAL.Controlled_Base);

   ----------
   -- Test --
   ----------

   procedure Test is
      G   : Graphs.Graph;
      Map : Graphs.Integer_Maps.Map;
      Count : Positive;
   begin
      G.Add_Vertices (Count => 8);

      --  In Boost Graph Library, the fact that adjacency_list uses a vector
      --  for vertices (one of the possible configs) shows through, in fact
      --  user code knows that a vertex is in an index into a vector. As such,
      --  add_edge() can be directly passed integers. This leads to somewhat
      --  easier code, though doesn't hide the implementation details.

      G.Add_Edge (G.From_Index (1), G.From_Index (2));
      G.Add_Edge (G.From_Index (2), G.From_Index (3));
      G.Add_Edge (G.From_Index (3), G.From_Index (1));
      G.Add_Edge (G.From_Index (4), G.From_Index (2));
      G.Add_Edge (G.From_Index (4), G.From_Index (3));
      G.Add_Edge (G.From_Index (4), G.From_Index (5));
      G.Add_Edge (G.From_Index (5), G.From_Index (4));
      G.Add_Edge (G.From_Index (5), G.From_Index (6));
      G.Add_Edge (G.From_Index (6), G.From_Index (3));
      G.Add_Edge (G.From_Index (6), G.From_Index (7));
      G.Add_Edge (G.From_Index (7), G.From_Index (6));
      G.Add_Edge (G.From_Index (8), G.From_Index (7));
      G.Add_Edge (G.From_Index (8), G.From_Index (6));
      G.Add_Edge (G.From_Index (8), G.From_Index (8));

      Graphs.Strongly_Connected_Components.Compute
         (G, Map, Components_Count => Count);
      Assert (Count, 4, "number of strongly connected components");
      Assert (Graphs.Integer_Maps.Get (Map, G.From_Index (1)), 1);
      Assert (Graphs.Integer_Maps.Get (Map, G.From_Index (2)), 1);
      Assert (Graphs.Integer_Maps.Get (Map, G.From_Index (3)), 1);
      Assert (Graphs.Integer_Maps.Get (Map, G.From_Index (4)), 3);
      Assert (Graphs.Integer_Maps.Get (Map, G.From_Index (5)), 3);
      Assert (Graphs.Integer_Maps.Get (Map, G.From_Index (6)), 2);
      Assert (Graphs.Integer_Maps.Get (Map, G.From_Index (7)), 2);
      Assert (Graphs.Integer_Maps.Get (Map, G.From_Index (8)), 4);
   end Test;

   ------------------------------
   -- Test_Perf_Adjacency_List --
   ------------------------------

   procedure Test_Perf_Adjacency_List
      (Stdout : in out Output'Class; Favorite : Boolean)
   is
      Container : constant String := "adjacency list";

      type My_Visit is null record;
      procedure Finish_Vertex (Ignored : in out My_Visit; V : Graphs.Vertex);
      procedure Finish_Vertex (Ignored : in out My_Visit; V : Graphs.Vertex) is
      begin
         null;
      end Finish_Vertex;

      package Visitors is new GAL.Graphs.DFS.DFS_Visitor_Traits
         (Graphs        => Graphs.Traits,
          Visitor_Type  => My_Visit,
          Finish_Vertex => Finish_Vertex);
      procedure DFS is new Graphs.DFS.Search (Visitors);

      G : Graphs.Graph;
      Acyclic : Boolean;

      procedure Do_Clear;
      procedure Do_Clear is
      begin
         G.Clear;
      end Do_Clear;

      procedure Do_Fill;
      procedure Do_Fill is
         V, V2 : Graphs.Vertex_Cursor;
      begin
         G.Add_Vertices (Count => Items_Count);

         V := G.First;
         loop
            V2 := G.Next (V);
            exit when not G.Has_Element (V2);
            G.Add_Edge (G.Element (V), G.Element (V2));
            V := V2;
         end loop;
      end Do_Fill;

      procedure Do_DFS_No_Visit;
      procedure Do_DFS_No_Visit is
         Vis : My_Visit;
      begin
         DFS (G, Vis);
      end Do_DFS_No_Visit;

      procedure Do_Is_Acyclic;
      procedure Do_Is_Acyclic is
      begin
         Acyclic := Graphs.DFS.Is_Acyclic (G);
      end Do_Is_Acyclic;

      procedure Do_SCC;
      procedure Do_SCC is
         M : Graphs.Integer_Maps.Map; -- := Graphs.Integer_Maps.Create_Map (G);
         Count : Integer;
      begin
         Graphs.Strongly_Connected_Components.Compute
            (G, M, Components_Count => Count);
      end Do_SCC;

      procedure Time_Fill is new Report.Timeit
         (Run => Do_Fill, Cleanup => Do_Clear);
      procedure Time_DFS_No_Visit is new Report.Timeit (Do_DFS_No_Visit);
      procedure Time_Acyclic is new Report.Timeit (Do_Is_Acyclic);
      procedure Time_SCC is new Report.Timeit (Do_SCC);

   begin
      Stdout.Set_Column
         (Category, Container, G'Size / 8, Favorite => Favorite);

      Time_Fill (Stdout, Category, Container, "fill", Start_Group => True);

      Do_Clear;
      Do_Fill;
      Time_DFS_No_Visit
         (Stdout, Category, Container, "dfs, no visitor", Start_Group => True);

      Do_Clear;
      Do_Fill;
      Time_Acyclic (Stdout, Category, Container, "is_acyclic");
      Asserts.Booleans.Assert (Acyclic, True);

      Do_Clear;
      Do_Fill;
      G.Add_Edge (G.From_Index (Items_Count / 10 + 1), G.From_Index (4));
      G.Add_Edge
         (G.From_Index (2 * Items_Count / 10 + 1), G.From_Index (Items_Count));
      Time_SCC (Stdout, Category, Container, "scc", Start_Group => True);
   end Test_Perf_Adjacency_List;

   ----------------------
   -- Test_Perf_Custom --
   ----------------------

   procedure Test_Perf_Custom
      (Stdout : in out Output'Class; Favorite : Boolean)
   is
      Container : constant String := "custom graph";

      procedure Search is new Graph1_Support.DFS.Search (My_Visitors);
      procedure Search is new Graph1_Support.DFS.Search (My_Visitors2);
      procedure Recursive is
        new Graph1_Support.DFS.Search_Recursive (My_Visitors2);

      G     : Graph;

      procedure Do_Search1;
      procedure Do_Search1 is
         V     : My_Visitor;
      begin
         Search (G, V);
      end Do_Search1;

      procedure Do_Search2;
      procedure Do_Search2 is
         V     : My_Visitor2;
      begin
         Search (G, V);
      end Do_Search2;

      procedure Do_Recursive;
      procedure Do_Recursive is
         V     : My_Visitor2;
      begin
         Recursive (G, V);
      end Do_Recursive;

      procedure Time_Search1 is new Report.Timeit (Do_Search1);
      procedure Time_Search2 is new Report.Timeit (Do_Search2);
      procedure Time_Recursive is new Report.Timeit (Do_Recursive);

   begin
      Stdout.Set_Column
         (Category, Container, G'Size / 8, Favorite => Favorite);
      Time_Search1 (Stdout, Category, Container, "dfs, no visitor");
      Time_Search2 (Stdout, Category, Container, "dfs, visitor");
      Time_Recursive (Stdout, Category, Container, "dfs-recursive, visitor");
   end Test_Perf_Custom;

end Test_Graph_Adjlist;
