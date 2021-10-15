with Conts.Lists.Indefinite_Bounded;
with Support_Lists;
with Test_Support;
package body Tests_Lists_Indefinite_Bounded is

   package Lists0 is new Conts.Lists.Indefinite_Bounded
      (Integer);
   package Tests0 is new Support_Lists
      (Category       => "Integer List",
       Container_Name => "Indef Bounded",
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

   package Lists1 is new Conts.Lists.Indefinite_Bounded
      (String);
   package Tests1 is new Support_Lists
      (Category       => "String List",
       Container_Name => "Indef Bounded",
       Image          => Test_Support.Image,
       Lists          => Lists1.Lists,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth,
       Check_Element  => Test_Support.Check_Element);

   procedure Test1 is
      L1, L2 : Lists1.List (20);
   begin
      Tests1.Test_Correctness (L1, L2);
   end Test1;

   procedure Test_Perf1 (Result : in out Report.Output'Class) is
      L1, L2 : Lists1.List (Test_Support.Items_Count);
   begin
      Tests1.Test_Perf (Result, L1, L2, Favorite => False);
   end Test_Perf1;
end Tests_Lists_Indefinite_Bounded;