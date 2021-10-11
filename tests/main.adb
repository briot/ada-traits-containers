with Ada.Command_Line;
with Test_Algo_Equals;
with Test_Algo_Random;
with Test_Algo_Shuffle;
with Test_Algo_Sort;
with Test_Graph_Adjlist;
with Main_Driver;
with Test_Support;

procedure Main is
   Filter : Test_Support.Test_Filter;
begin
   for A in 1 .. Ada.Command_Line.Argument_Count loop
      Filter.Setup (Ada.Command_Line.Argument (A));
   end loop;

   Main_Driver (Filter);
   Test_Graph_Adjlist.Test;
   Test_Algo_Equals.Test;
   Test_Algo_Random.Test;
   Test_Algo_Shuffle.Test;
   Test_Algo_Sort.Test;
end Main;
