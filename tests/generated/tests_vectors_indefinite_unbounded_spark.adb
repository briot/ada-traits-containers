with Support_Vectors;
with Conts.Vectors.Indefinite_Unbounded_SPARK;
with Test_Support;
package body Tests_Vectors_Indefinite_Unbounded_SPARK is

   package Vecs0 is new Conts.Vectors.Indefinite_Unbounded_SPARK
      (Positive, Integer);
   package Tests0 is new Support_Vectors
      (Category       => "Integer Vector",
       Container_Name => "Indef_SPARK Unbounded limited",
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
      Tests0.Test_Perf (Result, V1, V2, Favorite => False);
   end Test_Perf0;

   package Vecs1 is new Conts.Vectors.Indefinite_Unbounded_SPARK
      (Positive, String);
   package Tests1 is new Support_Vectors
      (Category       => "String Vector",
       Container_Name => "Indef_SPARK Unbounded limited",
       Image          => Test_Support.Image,
       Vectors        => Vecs1.Vectors,
       Check_Element  => Test_Support.Check_Element,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth);

   procedure Test1 is
      V : Vecs1.Vector;
   begin
      Tests1.Test (V);
   end Test1;

   procedure Test_Perf1 (Result : in out Report.Output'Class) is
      V1, V2 : Vecs1.Vector;
   begin
      Tests1.Test_Perf (Result, V1, V2, Favorite => False);
   end Test_Perf1;
end Tests_Vectors_Indefinite_Unbounded_SPARK;