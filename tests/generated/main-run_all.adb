pragma Style_Checks (Off);
with Tests_Lists_Definite_Bounded;
with Tests_Lists_Definite_Bounded_Limited;
with Tests_Lists_Definite_Unbounded;
with Tests_Lists_Definite_Unbounded_Limited;
with Tests_Lists_Indefinite_Bounded;
with Tests_Lists_Indefinite_Unbounded;
with Tests_Lists_Indefinite_Unbounded_SPARK;
with Tests_Lists_Unmovable_Definite_Unbounded;
with Tests_Maps_Def_Def_Unbounded;
with Tests_Maps_Indef_Def_Unbounded;
with Tests_Maps_Indef_Indef_Unbounded;
with Tests_Maps_Indef_Indef_Unbounded_SPARK;
with Tests_Vectors_Definite_Bounded;
with Tests_Vectors_Definite_Unbounded;
with Tests_Vectors_Unmovable_Definite_Unbounded;
with Tests_Vectors_Indefinite_Bounded;
with Tests_Vectors_Indefinite_Unbounded;
with Tests_Vectors_Indefinite_Unbounded_SPARK;
with Test_Support;
separate (Main)
procedure Run_All is
begin
   Run_Test
     ("lists-definite_bounded-integer",
      Tests_Lists_Definite_Bounded.Test0'Access,
      Tests_Lists_Definite_Bounded.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("lists-definite_bounded_limited-integer",
      Tests_Lists_Definite_Bounded_Limited.Test0'Access,
      Tests_Lists_Definite_Bounded_Limited.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("lists-definite_unbounded-integer",
      Tests_Lists_Definite_Unbounded.Test0'Access,
      Tests_Lists_Definite_Unbounded.Test_Perf0'Access,
      Favorite => True);
   Run_Test
     ("lists-definite_unbounded_limited-integer",
      Tests_Lists_Definite_Unbounded_Limited.Test0'Access,
      Tests_Lists_Definite_Unbounded_Limited.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("lists-indefinite_bounded-integer",
      Tests_Lists_Indefinite_Bounded.Test0'Access,
      Tests_Lists_Indefinite_Bounded.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("lists-indefinite_bounded-string",
      Tests_Lists_Indefinite_Bounded.Test1'Access,
      Tests_Lists_Indefinite_Bounded.Test_Perf1'Access,
      Favorite => False);
   Run_Test
     ("lists-indefinite_unbounded-integer",
      Tests_Lists_Indefinite_Unbounded.Test0'Access,
      Tests_Lists_Indefinite_Unbounded.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("lists-indefinite_unbounded-string",
      Tests_Lists_Indefinite_Unbounded.Test1'Access,
      Tests_Lists_Indefinite_Unbounded.Test_Perf1'Access,
      Favorite => True);
   Run_Test
     ("lists-indefinite_unbounded_spark-integer",
      Tests_Lists_Indefinite_Unbounded_SPARK.Test0'Access,
      Tests_Lists_Indefinite_Unbounded_SPARK.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("lists-indefinite_unbounded_spark-string",
      Tests_Lists_Indefinite_Unbounded_SPARK.Test1'Access,
      Tests_Lists_Indefinite_Unbounded_SPARK.Test_Perf1'Access,
      Favorite => False);
   Run_Test
     ("lists-unmovable_definite_unbounded-gnatcoll.strings.xstring",
      Tests_Lists_Unmovable_Definite_Unbounded.Test0'Access,
      Tests_Lists_Unmovable_Definite_Unbounded.Test_Perf0'Access,
      Favorite => True);
   Run_Test
     ("maps-def_def_unbounded-integer-integer",
      Tests_Maps_Def_Def_Unbounded.Test0'Access,
      Tests_Maps_Def_Def_Unbounded.Test_Perf0'Access,
      Favorite => True);
   Run_Test
     ("maps-indef_def_unbounded-integer-integer",
      Tests_Maps_Indef_Def_Unbounded.Test0'Access,
      Tests_Maps_Indef_Def_Unbounded.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("maps-indef_def_unbounded-string-integer",
      Tests_Maps_Indef_Def_Unbounded.Test1'Access,
      Tests_Maps_Indef_Def_Unbounded.Test_Perf1'Access,
      Favorite => True);
   Run_Test
     ("maps-indef_indef_unbounded-integer-integer",
      Tests_Maps_Indef_Indef_Unbounded.Test0'Access,
      Tests_Maps_Indef_Indef_Unbounded.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("maps-indef_indef_unbounded-string-string",
      Tests_Maps_Indef_Indef_Unbounded.Test1'Access,
      Tests_Maps_Indef_Indef_Unbounded.Test_Perf1'Access,
      Favorite => True);
   Run_Test
     ("maps-indef_indef_unbounded_spark-integer-integer",
      Tests_Maps_Indef_Indef_Unbounded_SPARK.Test0'Access,
      Tests_Maps_Indef_Indef_Unbounded_SPARK.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("maps-indef_indef_unbounded_spark-string-string",
      Tests_Maps_Indef_Indef_Unbounded_SPARK.Test1'Access,
      Tests_Maps_Indef_Indef_Unbounded_SPARK.Test_Perf1'Access,
      Favorite => False);
   Run_Test
     ("vectors-definite_bounded-integer",
      Tests_Vectors_Definite_Bounded.Test0'Access,
      Tests_Vectors_Definite_Bounded.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("vectors-definite_unbounded-integer",
      Tests_Vectors_Definite_Unbounded.Test0'Access,
      Tests_Vectors_Definite_Unbounded.Test_Perf0'Access,
      Favorite => True);
   Run_Test
     ("vectors-unmovable_definite_unbounded-gnatcoll.strings.xstring",
      Tests_Vectors_Unmovable_Definite_Unbounded.Test0'Access,
      Tests_Vectors_Unmovable_Definite_Unbounded.Test_Perf0'Access,
      Favorite => True);
   Run_Test
     ("vectors-indefinite_bounded-integer",
      Tests_Vectors_Indefinite_Bounded.Test0'Access,
      Tests_Vectors_Indefinite_Bounded.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("vectors-indefinite_bounded-string",
      Tests_Vectors_Indefinite_Bounded.Test1'Access,
      Tests_Vectors_Indefinite_Bounded.Test_Perf1'Access,
      Favorite => False);
   Run_Test
     ("vectors-indefinite_unbounded-integer",
      Tests_Vectors_Indefinite_Unbounded.Test0'Access,
      Tests_Vectors_Indefinite_Unbounded.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("vectors-indefinite_unbounded-string",
      Tests_Vectors_Indefinite_Unbounded.Test1'Access,
      Tests_Vectors_Indefinite_Unbounded.Test_Perf1'Access,
      Favorite => True);
   Run_Test
     ("vectors-indefinite_unbounded-gnatcoll.strings.xstring",
      Tests_Vectors_Indefinite_Unbounded.Test2'Access,
      Tests_Vectors_Indefinite_Unbounded.Test_Perf2'Access,
      Favorite => True);
   Run_Test
     ("vectors-indefinite_unbounded_spark-integer",
      Tests_Vectors_Indefinite_Unbounded_SPARK.Test0'Access,
      Tests_Vectors_Indefinite_Unbounded_SPARK.Test_Perf0'Access,
      Favorite => False);
   Run_Test
     ("vectors-indefinite_unbounded_spark-string",
      Tests_Vectors_Indefinite_Unbounded_SPARK.Test1'Access,
      Tests_Vectors_Indefinite_Unbounded_SPARK.Test_Perf1'Access,
      Favorite => False);
end Run_All;