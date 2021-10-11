with Support_Vectors;
with Test_Support;
with Conts.Vectors.Indefinite_Bounded;
package body Tests_Vectors_Indefinite_Bounded is

   package Vecs0 is new Conts.Vectors.Indefinite_Bounded
      (Positive, Integer);
   package Tests0 is new Support_Vectors
      (Test_Name    => "vectors-indefinite_bounded-integer",
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

   package Vecs1 is new Conts.Vectors.Indefinite_Bounded
      (Positive, String);
   package Tests1 is new Support_Vectors
      (Test_Name    => "vectors-indefinite_bounded-string",
       Image        => Test_Support.Image,
       Elements     => Vecs1.Elements.Traits,
       Storage      => Vecs1.Storage.Traits,
       Vectors      => Vecs1.Vectors,
       Nth          => Test_Support.Nth);

   procedure Test1 is
      V : Vecs1.Vector (20);
   begin
      Tests1.Test (V);
   end Test1;
end Tests_Vectors_Indefinite_Bounded;