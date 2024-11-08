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
with GAL.Graphs.Generators;
with GAL;                           use GAL;
with GNATCOLL.Strings;              use GNATCOLL.Strings;
with Graph1_Support;                use Graph1_Support;
with Report;                        use Report;
with System.Storage_Elements;       use System.Storage_Elements;
with Test_Support;                  use Test_Support;

package body Test_Graph_Adjlist is
   use Asserts.Integers;
   use type GAL.Graphs.Vertex_Index;

   package Graphs is new GAL.Graphs.Adjacency_List
     (Vertex_Properties   => GAL.Elements.Null_Elements.Traits,
      Edge_Properties     => GAL.Elements.Null_Elements.Traits,
      Container_Base_Type => GAL.Limited_Controlled_Base);
   package Generators is new GAL.Graphs.Generators
     (Vertex_Mutable      => Graphs.Vertex_Mutable,
      Edge_Mutable        => Graphs.Edge_Mutable);

   generic
      Category  : String;
      Container : String;
      with package Graphs is new GAL.Graphs.Adjacency_List (<>);
      with procedure Fill (G : in out Graphs.Graph);
   procedure Generic_Test_Perf
      (Stdout            : in out Output'Class;
       Favorite          : Boolean;
       Expected_Acyclic  : Boolean);

   ----------
   -- Test --
   ----------

   procedure Test is
      G   : Graphs.Graph;
      Count : Positive;
      Events : GNATCOLL.Strings.XString;
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

      declare
         Map : Graphs.Integer_Maps.Map := Graphs.Create_Integer_Map
            (G, Default_Value => -1);
      begin
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
      end;

      G.Clear;
      Generators.Complete (G, N => 3);

      declare
         subtype Vertex_Type is Graphs.Vertex;
         subtype Edge_Type is Graphs.Edge;

         function Image (V : Vertex_Type) return String
            is (Graphs.Impl.Get_Index (V)'Image);
         function Image (E : Edge_Type) return String
            is (Image (G.Get_Source (E)) & "->" & Image (G.Get_Target (E)));

         type Visit is null record;

         procedure Vertices_Initialized
            (Ignored : in out Visit; Count : Count_Type);
         procedure Discover_Vertex
            (Ignored : in out Visit; V : Vertex_Type; Stop : in out Boolean);

         generic
             Name : String;
         procedure Vertex_Cb (Ignored : in out Visit; V : Vertex_Type);
         procedure Vertex_Cb (Ignored : in out Visit; V : Vertex_Type) is
         begin
            Events.Append (Name & Image (V) & ASCII.LF);
         end Vertex_Cb;

         generic
             Name : String;
         procedure Edge_Cb (Ignored : in out Visit; E : Edge_Type);
         procedure Edge_Cb (Ignored : in out Visit; E : Edge_Type) is
         begin
            Events.Append (Name & Image (E) & ASCII.LF);
         end Edge_Cb;

         procedure Vertices_Initialized
            (Ignored : in out Visit; Count : Count_Type) is
         begin
            Events.Append ("Vertices_Initialized" & Count'Image & ASCII.LF);
         end Vertices_Initialized;

         procedure Discover_Vertex
            (Ignored : in out Visit; V : Vertex_Type; Stop : in out Boolean) is
         begin
            Events.Append ("Discover_Vertex" & Image (V) & ASCII.LF);
            Stop := False;
         end Discover_Vertex;

         procedure Initialize_Vertex is new Vertex_Cb ("Initialize_Vertex");
         procedure Start_Vertex is new Vertex_Cb ("Start_Vertex");
         procedure Finish_Vertex is new Vertex_Cb ("Finish_Vertex");
         procedure Examine_Edge is new Edge_Cb ("Examine_Edge");
         procedure Finish_Edge is new Edge_Cb ("Finish_Edge");
         procedure Tree_Edge is new Edge_Cb ("Tree_Edge");
         procedure Back_Edge is new Edge_Cb ("Back_Edge");
         procedure Forward_Or_Cross_Edge is new Edge_Cb
            ("Forward_Or_Cross_Edge");

         package Visitor is new Graphs.DFS.DFS_Visitor_Traits
            (Visitor_Type          => Visit,
             Vertices_Initialized  => Vertices_Initialized,
             Initialize_Vertex     => Initialize_Vertex,
             Start_Vertex          => Start_Vertex,
             Finish_Vertex         => Finish_Vertex,
             Discover_Vertex       => Discover_Vertex,
             Examine_Edge          => Examine_Edge,
             Tree_Edge             => Tree_Edge,
             Back_Edge             => Back_Edge,
             Forward_Or_Cross_Edge => Forward_Or_Cross_Edge,
             Finish_Edge           => Finish_Edge);
         procedure DFS_Search is new Graphs.Depth_First_Search (Visitor);

         V : Visit;
      begin
         DFS_Search (G, V);
         Asserts.Strings.Assert
            (Events.To_String,
             "Initialize_Vertex 1" & ASCII.LF &
             "Initialize_Vertex 2" & ASCII.LF &
             "Initialize_Vertex 3" & ASCII.LF &
             "Vertices_Initialized 3" & ASCII.LF &
             "Start_Vertex 1" & ASCII.LF &
             "Discover_Vertex 1" & ASCII.LF &
             "Examine_Edge 1-> 2" & ASCII.LF &
             "Tree_Edge 1-> 2" & ASCII.LF &
             "Discover_Vertex 2" & ASCII.LF &
             "Examine_Edge 2-> 1" & ASCII.LF &
             "Back_Edge 2-> 1" & ASCII.LF &
             "Finish_Edge 2-> 1" & ASCII.LF &
             "Examine_Edge 2-> 3" & ASCII.LF &
             "Tree_Edge 2-> 3" & ASCII.LF &
             "Discover_Vertex 3" & ASCII.LF &
             "Examine_Edge 3-> 1" & ASCII.LF &
             "Back_Edge 3-> 1" & ASCII.LF &
             "Finish_Edge 3-> 1" & ASCII.LF &
             "Examine_Edge 3-> 2" & ASCII.LF &
             "Back_Edge 3-> 2" & ASCII.LF &
             "Finish_Edge 3-> 2" & ASCII.LF &
             "Finish_Vertex 3" & ASCII.LF &
             "Finish_Edge 2-> 3" & ASCII.LF &
             "Finish_Vertex 2" & ASCII.LF &
             "Examine_Edge 1-> 3" & ASCII.LF &
             "Forward_Or_Cross_Edge 1-> 3" & ASCII.LF &
             "Finish_Edge 1-> 3" & ASCII.LF &
             "Finish_Vertex 1" & ASCII.LF);
      end;

      Asserts.Booleans.Assert (Graphs.DFS.Is_Acyclic (G), False);
   end Test;

   -----------------------
   -- Generic_Test_Perf --
   -----------------------

   procedure Generic_Test_Perf
      (Stdout            : in out Output'Class;
       Favorite          : Boolean;
       Expected_Acyclic  : Boolean)
   is
      type My_Visit is null record;
      procedure Finish_Vertex (Ignored : in out My_Visit; V : Graphs.Vertex);
      procedure Finish_Vertex (Ignored : in out My_Visit; V : Graphs.Vertex) is
      begin
         null;
      end Finish_Vertex;

      package Visitors is new Graphs.DFS.DFS_Visitor_Traits
         (Visitor_Type  => My_Visit,
          Finish_Vertex => Finish_Vertex);
      procedure DFS is new Graphs.DFS.Depth_First_Search (Visitors);
      procedure DFS_Recursive is
         new Graphs.DFS.Depth_First_Search_Recursive (Visitors);

      G : Graphs.Graph;
      Acyclic : Boolean;

      procedure Do_Fill;
      procedure Do_Fill is
      begin
         Fill (G);
      end Do_Fill;

      procedure Do_Clear;
      procedure Do_Clear is
      begin
         G.Clear;
      end Do_Clear;

      procedure Do_DFS;
      procedure Do_DFS is
         Vis : My_Visit;
      begin
         DFS (G, Vis);
      end Do_DFS;

      procedure Do_DFS_Recursive;
      procedure Do_DFS_Recursive is
         Vis : My_Visit;
      begin
         DFS_Recursive (G, Vis);
      end Do_DFS_Recursive;

      procedure Do_Is_Acyclic;
      procedure Do_Is_Acyclic is
      begin
         Acyclic := Graphs.DFS.Is_Acyclic (G);
      end Do_Is_Acyclic;

      procedure Do_SCC;
      procedure Do_SCC is
         M : Graphs.Integer_Maps.Map := Graphs.Create_Integer_Map
            (G, Default_Value => -1);
         Count : Integer;
      begin
         Graphs.Strongly_Connected_Components.Compute
            (G, M, Components_Count => Count);
      end Do_SCC;

      procedure Time_Fill is new Report.Timeit
         (Run => Do_Fill, Cleanup => Do_Clear);
      procedure Time_DFS is new Report.Timeit (Do_DFS);
      procedure Time_DFS_Recursive is new Report.Timeit (Do_DFS_Recursive);
      procedure Time_Acyclic is new Report.Timeit (Do_Is_Acyclic);
      procedure Time_SCC is new Report.Timeit (Do_SCC);

   begin
      Stdout.Set_Column
         (Category, Container, G'Size / 8, Favorite => Favorite);

      Time_Fill (Stdout, Category, Container, "fill", Start_Group => True);

      G.Clear;  --  after Time_Fill, the graph is empty
      Fill (G);

      Time_DFS (Stdout, Category, Container, "dfs", Start_Group => True);
      Time_DFS_Recursive (Stdout, Category, Container, "dfs-recursive");
      Time_Acyclic (Stdout, Category, Container, "is_acyclic");
      Asserts.Booleans.Assert (Acyclic, Expected_Acyclic);

      Time_SCC (Stdout, Category, Container, "scc", Start_Group => True);
   end Generic_Test_Perf;

   ------------------------------------
   -- Test_Perf_Adjacency_List_Chain --
   ------------------------------------

   procedure Test_Perf_Adjacency_List_Chain
      (Stdout : in out Output'Class; Favorite : Boolean)
   is
      procedure Fill_Chain (G : in out Graphs.Graph);
      procedure Fill_Chain (G : in out Graphs.Graph) is
         V, V2 : Graphs.Vertex_Cursor;
      begin
         G.Add_Vertices (Count => Items_Count);

         V := G.Vertices;
         V2 := V;
         loop
            G.Next (V2);
            exit when not G.Has_Element (V2);
            G.Add_Edge (G.Element (V), G.Element (V2));
            V := V2;
         end loop;

         G.Add_Edge (G.From_Index (Items_Count / 10 + 1), G.From_Index (4));
         G.Add_Edge
            (G.From_Index (2 * Items_Count / 10 + 1),
             G.From_Index (Items_Count));
      end Fill_Chain;

      procedure Gen_Test_Chain is new Generic_Test_Perf
         ("Integer Graph (chain)", "adjacency list", Graphs, Fill_Chain);
   begin
      Gen_Test_Chain    (Stdout, Favorite, Expected_Acyclic => False);
   end Test_Perf_Adjacency_List_Chain;

   ---------------------------------------
   -- Test_Perf_Adjacency_List_Complete --
   ---------------------------------------

   procedure Test_Perf_Adjacency_List_Complete
      (Stdout : in out Output'Class; Favorite : Boolean)
   is
      procedure Fill_Complete (G : in out Graphs.Graph);
      procedure Fill_Complete (G : in out Graphs.Graph) is
      begin
         Generators.Complete (G, N => 10_000);
      end Fill_Complete;

      procedure Gen_Test_Complete is new Generic_Test_Perf
         ("Integer Graph (complete, small)",
          "adjacency list", Graphs, Fill_Complete);
   begin
      Gen_Test_Complete (Stdout, Favorite, Expected_Acyclic => False);
   end Test_Perf_Adjacency_List_Complete;

   ----------------------
   -- Test_Perf_Custom --
   ----------------------

   procedure Test_Perf_Custom
      (Stdout : in out Output'Class; Favorite : Boolean)
   is
      Container : constant String := "custom graph";
      Category  : constant String := "Integer Graph (chain)";

      procedure Search is
         new Graph1_Support.DFS.Depth_First_Search (My_Visitors);
      procedure Recursive is
         new Graph1_Support.DFS.Depth_First_Search_Recursive (My_Visitors2);

      G     : aliased Graph;

      procedure Do_Search1;
      procedure Do_Search1 is
         V     : My_Visitor;
      begin
         Search (G'Unchecked_Access, V);
      end Do_Search1;

      procedure Do_Recursive;
      procedure Do_Recursive is
         V     : My_Visitor2;
      begin
         Recursive (G'Unchecked_Access, V);
      end Do_Recursive;

      procedure Time_Search1 is new Report.Timeit (Do_Search1);
      procedure Time_Recursive is new Report.Timeit (Do_Recursive);

   begin
      Stdout.Set_Column
         (Category, Container, G'Size / 8, Favorite => Favorite);
      Time_Search1 (Stdout, Category, Container, "dfs");
      Time_Recursive (Stdout, Category, Container, "dfs-recursive");
   end Test_Perf_Custom;

end Test_Graph_Adjlist;
