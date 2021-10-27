with GAL.Vectors.Indefinite_Unbounded;
with GNATCOLL.Strings;
with Support_Vectors;
with Test_Support;
package body Tests_Vectors_Indefinite_Unbounded is

   package Vecs0 is new GAL.Vectors.Indefinite_Unbounded
      (Positive,
       Integer,
       Container_Base_Type => GAL.Controlled_Base);
   package Tests0 is new Support_Vectors
      (Category       => "Integer Vector",
       Container_Name => "Indef Unbounded",
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

   package Vecs1 is new GAL.Vectors.Indefinite_Unbounded
      (Positive,
       String,
       Container_Base_Type => GAL.Controlled_Base);
   package Tests1 is new Support_Vectors
      (Category       => "String Vector",
       Container_Name => "Indef Unbounded",
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
      Tests1.Test_Perf (Result, V1, V2, Favorite => True);
   end Test_Perf1;

   package Vecs2 is new GAL.Vectors.Indefinite_Unbounded
      (Positive,
       GNATCOLL.Strings.XString,
       Container_Base_Type => GAL.Controlled_Base);
   package Tests2 is new Support_Vectors
      (Category       => "String Vector",
       Container_Name => "Indef Unbounded (XString)",
       Image          => Test_Support.Image,
       Vectors        => Vecs2.Vectors,
       Check_Element  => Test_Support.Check_Element,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth,
       "="            => GNATCOLL.Strings."=");

   procedure Test2 is
      V : Vecs2.Vector;
   begin
      Tests2.Test (V);
   end Test2;

   procedure Test_Perf2 (Result : in out Report.Output'Class) is
      V1, V2 : Vecs2.Vector;
   begin
      Tests2.Test_Perf (Result, V1, V2, Favorite => True);
   end Test_Perf2;
end Tests_Vectors_Indefinite_Unbounded;