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

   if Filter.Active ("graph") then
      Test_Graph_Adjlist.Test;
   end if;

   if Filter.Active ("equals") then
      Test_Algo_Equals.Test;
   end if;

   if Filter.Active ("random") then
      Test_Algo_Random.Test;
   end if;

   if Filter.Active ("shuffle") then
      Test_Algo_Shuffle.Test;
   end if;

   if Filter.Active ("sort") then
      Test_Algo_Sort.Test;
   end if;
end Main;
