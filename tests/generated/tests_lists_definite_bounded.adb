with GAL.Lists.Definite_Bounded;
with Support_Lists;
with Test_Support;
package body Tests_Lists_Definite_Bounded is

   package Lists0 is new GAL.Lists.Definite_Bounded
      (Integer);
   package Tests0 is new Support_Lists
      (Category       => "Integer List",
       Container_Name => "Def Bounded",
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

   procedure Test_Perf0
      (Result : in out Report.Output'Class; Favorite : Boolean)
   is
      L1, L2 : Lists0.List (Test_Support.Items_Count);
   begin
      Tests0.Test_Perf (Result, L1, L2, Favorite => Favorite);
   end Test_Perf0;
end Tests_Lists_Definite_Bounded;