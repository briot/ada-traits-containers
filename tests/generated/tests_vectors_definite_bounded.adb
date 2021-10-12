with Support_Vectors;
with Test_Support;
with Conts.Vectors.Definite_Bounded;
package body Tests_Vectors_Definite_Bounded is

   package Vecs0 is new Conts.Vectors.Definite_Bounded
      (Positive, Integer);
   package Tests0 is new Support_Vectors
      (Test_Name    => "vectors-definite_bounded-integer",
       Image        => Test_Support.Image,
       Elements     => Vecs0.Elements.Traits,
       Storage      => Vecs0.Storage.Traits,
       Vectors      => Vecs0.Vectors,
       Nth          => Test_Support.Nth);

   procedure Test0 is
      V : Vecs0.Vector (20);
   begin
      Tests0.Test (V);
   end Test0;

   procedure Test_Perf0 (Result : in out Report.Output'Class) is
   begin
      null;
   end Test_Perf0;
end Tests_Vectors_Definite_Bounded;