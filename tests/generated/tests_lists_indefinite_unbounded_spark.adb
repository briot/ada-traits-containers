with Test_Support;
with Conts.Lists.Indefinite_Unbounded_SPARK;
with Support_Lists;
package body Tests_Lists_Indefinite_Unbounded_SPARK is

   package Lists0 is new Conts.Lists.Indefinite_Unbounded_SPARK
      (Integer);
   package Tests0 is new Support_Lists
      (Category       => "Integer List",
       Container_Name => "Indef_SPARK Unbounded_SPARK limited",
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

   package Lists1 is new Conts.Lists.Indefinite_Unbounded_SPARK
      (String);
   package Tests1 is new Support_Lists
      (Category       => "String List",
       Container_Name => "Indef_SPARK Unbounded_SPARK limited",
       Image          => Test_Support.Image,
       Lists          => Lists1.Lists,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth,
       Check_Element  => Test_Support.Check_Element);

   procedure Test1 is
      L1, L2 : Lists1.List;
   begin
      Tests1.Test_Correctness (L1, L2);
   end Test1;

   procedure Test_Perf1 (Result : in out Report.Output'Class) is
      L1, L2 : Lists1.List;
   begin
      Tests1.Test_Perf (Result, L1, L2, Favorite => False);
   end Test_Perf1;
end Tests_Lists_Indefinite_Unbounded_SPARK;