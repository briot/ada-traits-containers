with Support_Maps;
with Test_Support;
with Conts.Maps.Def_Def_Unbounded;
package body Tests_Maps_Def_Def_Unbounded is

   package Maps0 is new Conts.Maps.Def_Def_Unbounded
      (Integer,
       Element_Type => Integer,
       Hash => Test_Support.Hash,
       Container_Base_Type => Conts.Controlled_Base);
   package Tests0 is new Support_Maps
      (Test_Name     => "maps-def_def_unbounded-integer-integer",
       Image_Element => Test_Support.Image,
       Maps          => Maps0.Impl,
       Nth_Key       => Test_Support.Nth,
       Nth_Element   => Test_Support.Nth);

   procedure Test0 is
      M : Maps0.Map;
   begin
      Tests0.Test (M);
   end Test0;
end Tests_Maps_Def_Def_Unbounded;