with Test_Support;
with Conts.Lists.Definite_Bounded_Limited;
with Support_Lists;
package body Tests_Lists_Definite_Bounded_Limited is

   package Lists0 is new Conts.Lists.Definite_Bounded_Limited
      (Integer);
   package Tests0 is new Support_Lists
      (Category       => "Integer List",
       Container_Name => "Def Bounded limited",
       Image          => Test_Support.Image,
       Lists          => Lists0.Lists,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth,
       Check_Element  => Test_Support.Check_Element);

   procedure Test0 is
      L1, L2 : Lists0.List (20);
   begin
      Tests0.Test_Correctness (L1, L2);
   end Test0;

   procedure Test_Perf0 (Result : in out Report.Output'Class) is
      L1, L2 : Lists0.List (Test_Support.Items_Count);
   begin
      Tests0.Test_Perf (Result, L1, L2, Favorite => False);
   end Test_Perf0;
end Tests_Lists_Definite_Bounded_Limited;