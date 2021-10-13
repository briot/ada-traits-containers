with Conts.Maps.Indef_Indef_Unbounded;
with Support_Maps;
with Test_Support;
package body Tests_Maps_Indef_Indef_Unbounded is

   package Maps0 is new Conts.Maps.Indef_Indef_Unbounded
      (Integer,
       Element_Type => Integer,
       Hash => Test_Support.Hash,
       Container_Base_Type => Conts.Controlled_Base);
   package Tests0 is new Support_Maps
      (Category         => "Integer-Integer Map",
       Container_Name   => "Indef-Indef Unbounded",
       Image_Element    => Test_Support.Image,
       Maps             => Maps0.Impl,
       Check_Element    => Test_Support.Check_Element,
       Nth_Key          => Test_Support.Nth,
       Nth_Element      => Test_Support.Nth,
       Nth_Perf_Element => Test_Support.Perf_Nth);

   procedure Test0 is
      M1, M2 : Maps0.Map;
   begin
      Tests0.Test (M1, M2);
   end Test0;

   procedure Test_Perf0 (Result : in out Report.Output'Class) is
      M1, M2 : Maps0.Map;
   begin
      Tests0.Test_Perf (Result, M1, M2, Favorite => False);
   end Test_Perf0;

   package Maps1 is new Conts.Maps.Indef_Indef_Unbounded
      (String,
       Element_Type => String,
       Hash => Test_Support.Hash,
       Container_Base_Type => Conts.Controlled_Base);
   package Tests1 is new Support_Maps
      (Category         => "String-String Map",
       Container_Name   => "Indef-Indef Unbounded",
       Image_Element    => Test_Support.Image,
       Maps             => Maps1.Impl,
       Check_Element    => Test_Support.Check_Element,
       Nth_Key          => Test_Support.Nth,
       Nth_Element      => Test_Support.Nth,
       Nth_Perf_Element => Test_Support.Perf_Nth);

   procedure Test1 is
      M1, M2 : Maps1.Map;
   begin
      Tests1.Test (M1, M2);
   end Test1;

   procedure Test_Perf1 (Result : in out Report.Output'Class) is
      M1, M2 : Maps1.Map;
   begin
      Tests1.Test_Perf (Result, M1, M2, Favorite => True);
   end Test_Perf1;
end Tests_Maps_Indef_Indef_Unbounded;