with GAL.Vectors.Unmovable_Definite_Unbounded;
with GNATCOLL.Strings;
with Support_Vectors;
with Test_Support;
package body Tests_Vectors_Unmovable_Definite_Unbounded is

   package Vecs0 is new GAL.Vectors.Unmovable_Definite_Unbounded
      (Positive,
       GNATCOLL.Strings.XString,
       Container_Base_Type => GAL.Controlled_Base);
   package Tests0 is new Support_Vectors
      (Category       => "String Vector",
       Container_Name => "Def Unbounded (XString)",
       Image          => Test_Support.Image,
       Vectors        => Vecs0.Vectors,
       Check_Element  => Test_Support.Check_Element,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth,
       "="            => GNATCOLL.Strings."=");

   procedure Test0 is
      V : Vecs0.Vector;
   begin
      Tests0.Test (V);
   end Test0;

   procedure Test_Perf0
      (Result : in out Report.Output'Class; Favorite : Boolean)
   is
      V1, V2 : Vecs0.Vector;
   begin
      Tests0.Test_Perf (Result, V1, V2, Favorite => Favorite);
   end Test_Perf0;
end Tests_Vectors_Unmovable_Definite_Unbounded;