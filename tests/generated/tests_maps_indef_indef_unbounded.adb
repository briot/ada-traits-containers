with Support_Maps;
with Test_Support;
with Conts.Maps.Indef_Indef_Unbounded;
package body Tests_Maps_Indef_Indef_Unbounded is

   package Maps0 is new Conts.Maps.Indef_Indef_Unbounded
      (Integer,
       Element_Type => Integer,
       Hash => Test_Support.Hash,
       Container_Base_Type => Conts.Controlled_Base);
   package Tests0 is new Support_Maps
      (Test_Name     => "maps-indef_indef_unbounded-integer-integer",
       Image_Element => Test_Support.Image,
       Maps          => Maps0.Impl,
       Nth_Key       => Test_Support.Nth,
       Nth_Element   => Test_Support.Nth);

   procedure Test0 is
      M : Maps0.Map;
   begin
      Tests0.Test (M);
   end Test0;

   procedure Test_Perf0 (Result : in out Report.Output'Class) is
   begin
      null;
   end Test_Perf0;

   package Maps1 is new Conts.Maps.Indef_Indef_Unbounded
      (String,
       Element_Type => String,
       Hash => Test_Support.Hash,
       Container_Base_Type => Conts.Controlled_Base);
   package Tests1 is new Support_Maps
      (Test_Name     => "maps-indef_indef_unbounded-string-string",
       Image_Element => Test_Support.Image,
       Maps          => Maps1.Impl,
       Nth_Key       => Test_Support.Nth,
       Nth_Element   => Test_Support.Nth);

   procedure Test1 is
      M : Maps1.Map;
   begin
      Tests1.Test (M);
   end Test1;

   procedure Test_Perf1 (Result : in out Report.Output'Class) is
   begin
      null;
   end Test_Perf1;
end Tests_Maps_Indef_Indef_Unbounded;