with GAL.Lists.Unmovable_Definite_Unbounded;
with GNATCOLL.Strings;
with Support_Lists;
with Test_Support;
package body Tests_Lists_Unmovable_Definite_Unbounded is

   package Lists0 is new GAL.Lists.Unmovable_Definite_Unbounded
      (GNATCOLL.Strings.XString, Container_Base_Type => GAL.Controlled_Base);
   package Tests0 is new Support_Lists
      (Category       => "String List",
       Container_Name => "Def Unbounded (XString)",
       Image          => Test_Support.Image,
       Lists          => Lists0.Lists,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth,
       Check_Element  => Test_Support.Check_Element,
       "="            => GNATCOLL.Strings."=");

   procedure Test0 is
      L1, L2 : Lists0.List;
   begin
      Tests0.Test_Correctness (L1, L2);
   end Test0;

   procedure Test_Perf0 (Result : in out Report.Output'Class) is
      L1, L2 : Lists0.List;
   begin
      Tests0.Test_Perf (Result, L1, L2, Favorite => True);
   end Test_Perf0;
end Tests_Lists_Unmovable_Definite_Unbounded;