with GAL.Vectors.Definite_Unbounded;
with Support_Vectors;
with Test_Support;
package body Tests_Vectors_Definite_Unbounded is

   package Vecs0 is new GAL.Vectors.Definite_Unbounded
      (Positive,
       Integer,
       Container_Base_Type => GAL.Controlled_Base);
   package Tests0 is new Support_Vectors
      (Category       => "Integer Vector",
       Container_Name => "Def Unbounded",
       Image          => Test_Support.Image,
       Vectors        => Vecs0.Vectors,
       Check_Element  => Test_Support.Check_Element,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth);

   procedure Test0 is
      V : Vecs0.Vector;
   begin
      Tests0.Test (V);
   end Test0;

   procedure Test_Perf0 (Result : in out Report.Output'Class) is
      V1, V2 : Vecs0.Vector;
   begin
      Tests0.Test_Perf (Result, V1, V2, Favorite => True);
   end Test_Perf0;
end Tests_Vectors_Definite_Unbounded;