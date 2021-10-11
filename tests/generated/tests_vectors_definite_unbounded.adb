with Support_Vectors;
with Test_Support;
with Conts.Vectors.Definite_Unbounded;
package body Tests_Vectors_Definite_Unbounded is

   package Vecs0 is new Conts.Vectors.Definite_Unbounded
      (Positive, Integer, Container_Base_Type => Conts.Controlled_Base);
   package Tests0 is new Support_Vectors
      (Test_Name    => "vectors-definite_unbounded-integer",
       Image        => Test_Support.Image,
       Elements     => Vecs0.Elements.Traits,
       Storage      => Vecs0.Storage.Traits,
       Vectors      => Vecs0.Vectors,
       Nth          => Test_Support.Nth);

   procedure Test0 is
      V : Vecs0.Vector;
   begin
      Tests0.Test (V);
   end Test0;
end Tests_Vectors_Definite_Unbounded;