with GAL.Vectors.Definite_Bounded;
with Support_Vectors;
with Test_Support;
package body Tests_Vectors_Definite_Bounded is

   package Vecs0 is new GAL.Vectors.Definite_Bounded
      (Positive,
       Integer);
   package Tests0 is new Support_Vectors
      (Category       => "Integer Vector",
       Container_Name => "Def Bounded",
       Image          => Test_Support.Image,
       Vectors        => Vecs0.Vectors,
       Check_Element  => Test_Support.Check_Element,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth);

   procedure Test0 is
      V : Vecs0.Vector (20);
   begin
      Tests0.Test (V);
   end Test0;

   procedure Test_Perf0
      (Result : in out Report.Output'Class; Favorite : Boolean)
   is
      V1, V2 : Vecs0.Vector (Test_Support.Items_Count);
   begin
      Tests0.Test_Perf (Result, V1, V2, Favorite => Favorite);
   end Test_Perf0;
end Tests_Vectors_Definite_Bounded;