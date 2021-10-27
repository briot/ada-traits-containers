with GNAT.Command_Line;
with GNATCOLL.Strings;
with Perf_Support;             use Perf_Support;
with Report;                   use Report;
with Test_Algo_Equals;
with Test_Algo_Permutation;
with Test_Algo_Random;
with Test_Algo_Reverse;
with Test_Algo_Shuffle;
with Test_Algo_Sort;
with Test_Containers;         use Test_Containers;
with Test_Graph_Adjlist;
with QGen;
with System;
with Test_Support;

procedure Main is
   Filter      : Test_Support.Test_Filter;
   Output_File : GNATCOLL.Strings.XString;
   Stdout      : aliased Output;
   Is_Perf     : Boolean := False;

   procedure Test_Cpp_Graph (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_graph";

   type CPP_Test is not null access procedure (S : System.Address)
      with Convention => C;
   type Perf_Test is access procedure
      (S : in out Output'Class; Favorite : Boolean);
   type Correctness_Test is access procedure;

   procedure Run_Test
      (Name     : String;
       Correct  : Correctness_Test := null;
       Perf     : Perf_Test := null;
       Favorite : Boolean := False);
   procedure Run_Perf_Test (Name : String; Proc : CPP_Test);
   --  Run a test if the command line arguments allow it

   procedure Run_Test
      (Name     : String;
       Correct  : Correctness_Test := null;
       Perf     : Perf_Test := null;
       Favorite : Boolean := False) is
   begin
      if Filter.Active (Name) then
         if Is_Perf then
            if Perf /= null then
               Perf (Stdout, Favorite => Favorite);
            end if;
         else
            if Correct /= null then
               Correct.all;
            end if;
         end if;
      end if;
   end Run_Test;

   procedure Run_Perf_Test (Name : String; Proc : CPP_Test) is
   begin
      if Is_Perf and then Filter.Active (Name) then
         Proc (Stdout'Address);
      end if;
   end Run_Perf_Test;

   procedure Run_All;   --  auto-generated
   procedure Run_All is separate;

begin
   loop
      case GNAT.Command_Line.Getopt ("o: perf") is
         when 'o' =>
            Output_File.Set (GNAT.Command_Line.Parameter);
         when 'p' =>
            Is_Perf := True;
         when others =>
            exit;
      end case;
   end loop;
   loop
      declare
         S : constant String := GNAT.Command_Line.Get_Argument;
      begin
         exit when S'Length = 0;
         Filter.Setup (S);
      end;
   end loop;

   Run_Perf_Test ("int_list_c++", Test_Cpp_Int_List'Access);
   Run_Perf_Test ("str_list_c++", Test_Cpp_Str_List'Access);
   Run_Perf_Test ("int_vector_c++", Test_Cpp_Int_Vector'Access);
   Run_Perf_Test ("str_vector_c++", Test_Cpp_Str_Vector'Access);
   Run_Perf_Test
      ("intint_map_c++_unordered", Test_Cpp_Int_Int_Unordered_Map'Access);
   Run_Perf_Test ("intint_map_c++", Test_Cpp_Int_Int_Map'Access);
   Run_Perf_Test ("strint_map_c++", Test_Cpp_Str_Int_Map'Access);
   Run_Perf_Test
      ("strstr_map_c++_unordered", Test_Cpp_Str_Str_Unordered_Map'Access);
   Run_Perf_Test ("strstr_map_c++", Test_Cpp_Str_Str_Map'Access);
   Run_Test
      ("ada-array-integer",
       null,
       Perf_Support.Test_Arrays_Int'Access);
   Run_Test
      ("ada-lists-definite-unbounded-integer",
       null,
       Integer_Unbounded_List_Tests.Test_Perf'Access,
       Favorite => True);
   Run_Test
      ("ada-lists-definite-bounded-integer",
       null,
       Integer_Bounded_List_Tests.Test_Perf'Access);
   Run_Test
      ("ada-lists-indefinite-unbounded-integer",
       null,
       Integer_Indef_Unbounded_List_Tests.Test_Perf'Access);
   Run_Test
      ("ada-lists-indefinite-unbounded-string",
       null,
       String_Indef_Unbounded_List_Tests.Test_Perf'Access,
       Favorite => True);
   Run_Test
      ("ada-vectors-definite-unbounded-integer",
       null,
       Integer_Unbounded_Vector_Tests.Test_Perf'Access,
       Favorite => True);
   Run_Test
      ("ada-vectors-definite-bounded-integer",
       null,
       Integer_Bounded_Vector_Tests.Test_Perf'Access);
   Run_Test
      ("ada-vectors-indefinite-unbounded-integer",
       null,
       Integer_Indef_Unbounded_Vector_Tests.Test_Perf'Access);
   Run_Test
      ("ada-vectors-indefinite-unbounded-string",
       null,
       String_Indef_Unbounded_Vector_Tests.Test_Perf'Access,
       Favorite => True);
   Run_Test
      ("ada-omap-definite-unbounded-intint",
       null,
       IntInt_Unbounded_Ordered_Map_Tests.Test_Perf'Access);
   Run_Test
      ("ada-omap-definite-bounded-intint",
       null,
       IntInt_Bounded_Ordered_Map_Tests.Test_Perf'Access);
   Run_Test
      ("ada-omap-indefinite-unbounded-intint",
       null,
       IntInt_Indef_Unbounded_Ordered_Map_Tests.Test_Perf'Access);
   Run_Test
      ("ada-omap-indefinite-unbounded-strint",
       null,
       StrInt_Indef_Unbounded_Ordered_Map_Tests.Test_Perf'Access);
   Run_Test
      ("ada-omap-indefinite-unbounded-strstr",
       null,
       StrStr_Indef_Unbounded_Ordered_Map_Tests.Test_Perf'Access);
   Run_Test
      ("ada-hmap-definite-unbounded-intint",
       null,
       IntInt_Unbounded_Hashed_Map_Tests.Test_Perf'Access,
       Favorite => True);
   Run_Test
      ("ada-hmap-definite-bounded-intint",
       null,
       IntInt_Bounded_Hashed_Map_Tests.Test_Perf'Access);
   Run_Test
      ("ada-hmap-indefinite-unbounded-intint",
       null,
       IntInt_Indef_Unbounded_Hashed_Map_Tests.Test_Perf'Access);
   Run_Test
      ("ada-hmap-indefinite-unbounded-strint",
       null,
       StrInt_Indef_Unbounded_Hashed_Map_Tests.Test_Perf'Access,
       Favorite => True);
   Run_Test
      ("ada-hmap-indefinite-unbounded-strstr",
       null,
       StrStr_Indef_Unbounded_Hashed_Map_Tests.Test_Perf'Access,
       Favorite => True);
   Run_Perf_Test ("graph_c++", Test_Cpp_Graph'Access);

   Run_Test
      ("graph_adj_list",
       Test_Graph_Adjlist.Test'Access,
       Test_Graph_Adjlist.Test_Perf_Adjacency_List'Access,
       Favorite => True);
   Run_Test
      ("graph_custom",
       null,
       Test_Graph_Adjlist.Test_Perf_Custom'Access);
   Run_Test
      ("equals",
       Test_Algo_Equals.Test'Access);
   Run_Test
      ("random",
       Test_Algo_Random.Test'Access);
   Run_Test
      ("reverse",
       Test_Algo_Reverse.Test'Access);
   Run_Test
      ("permutation",
       Test_Algo_Permutation.Test'Access);
   Run_Test
      ("shuffle",
       Test_Algo_Shuffle.Test'Access);
   Run_Test
      ("sort",
       Test_Algo_Sort.Test'Access,
       Test_Algo_Sort.Test_Perf'Access);
   Run_Test
      ("qgen",
       QGen.Test_QGen'Access);

   Run_All;

   Stdout.Save (Output_File.To_String);
end Main;
