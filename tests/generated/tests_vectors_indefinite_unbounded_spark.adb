with Support_Vectors;
with Test_Support;
with Conts.Vectors.Indefinite_Unbounded_SPARK;
package body Tests_Vectors_Indefinite_Unbounded_SPARK is

   package Vecs0 is new Conts.Vectors.Indefinite_Unbounded_SPARK
      (Positive, Integer);
   package Tests0 is new Support_Vectors
      (Test_Name    => "vectors-indefinite_unbounded_spark-integer",
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

   package Vecs1 is new Conts.Vectors.Indefinite_Unbounded_SPARK
      (Positive, String);
   package Tests1 is new Support_Vectors
      (Test_Name    => "vectors-indefinite_unbounded_spark-string",
       Image        => Test_Support.Image,
       Elements     => Vecs1.Elements.Traits,
       Storage      => Vecs1.Storage.Traits,
       Vectors      => Vecs1.Vectors,
       Nth          => Test_Support.Nth);

   procedure Test1 is
      V : Vecs1.Vector;
   begin
      Tests1.Test (V);
   end Test1;
end Tests_Vectors_Indefinite_Unbounded_SPARK;