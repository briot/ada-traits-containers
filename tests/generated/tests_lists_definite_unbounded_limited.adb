with Conts.Lists.Definite_Unbounded_Limited;
with Support_Lists;
with Test_Support;
package body Tests_Lists_Definite_Unbounded_Limited is

   package Lists0 is new Conts.Lists.Definite_Unbounded_Limited
      (Integer);
   package Tests0 is new Support_Lists
      (Category       => "Integer List",
       Container_Name => "Def Unbounded limited",
       Image          => Test_Support.Image,
       Lists          => Lists0.Lists,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth,
       Check_Element  => Test_Support.Check_Element);

   procedure Test0 is
      L1, L2 : Lists0.List;
   begin
      Tests0.Test_Correctness (L1, L2);
   end Test0;

   procedure Test_Perf0 (Result : in out Report.Output'Class) is
      L1, L2 : Lists0.List;
   begin
      Tests0.Test_Perf (Result, L1, L2, Favorite => False);
   end Test_Perf0;
end Tests_Lists_Definite_Unbounded_Limited;