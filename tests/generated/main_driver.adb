pragma Style_Checks (Off);
with Tests_Vectors_Definite_Bounded;
with Tests_Vectors_Definite_Unbounded;
with Tests_Vectors_Unmovable_Definite_Unbounded;
with Tests_Vectors_Indefinite_Bounded;
with Tests_Vectors_Indefinite_Unbounded;
with Tests_Vectors_Indefinite_Unbounded_SPARK;
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
with Test_Support;
procedure Main_Driver (F : Test_Support.Test_Filter) is
begin
   if F.Active ("vectors-definite_bounded-integer") then
      Tests_Vectors_Definite_Bounded.Test0;
   end if;
   if F.Active ("vectors-definite_unbounded-integer") then
      Tests_Vectors_Definite_Unbounded.Test0;
   end if;
   if F.Active ("vectors-unmovable_definite_unbounded-gnatcoll.strings.xstring") then
      Tests_Vectors_Unmovable_Definite_Unbounded.Test0;
   end if;
   if F.Active ("vectors-indefinite_bounded-integer") then
      Tests_Vectors_Indefinite_Bounded.Test0;
   end if;
   if F.Active ("vectors-indefinite_bounded-string") then
      Tests_Vectors_Indefinite_Bounded.Test1;
   end if;
   if F.Active ("vectors-indefinite_unbounded-integer") then
      Tests_Vectors_Indefinite_Unbounded.Test0;
   end if;
   if F.Active ("vectors-indefinite_unbounded-string") then
      Tests_Vectors_Indefinite_Unbounded.Test1;
   end if;
   if F.Active ("vectors-indefinite_unbounded-gnatcoll.strings.xstring") then
      Tests_Vectors_Indefinite_Unbounded.Test2;
   end if;
   if F.Active ("vectors-indefinite_unbounded_spark-integer") then
      Tests_Vectors_Indefinite_Unbounded_SPARK.Test0;
   end if;
   if F.Active ("vectors-indefinite_unbounded_spark-string") then
      Tests_Vectors_Indefinite_Unbounded_SPARK.Test1;
   end if;
   if F.Active ("lists-definite_bounded-integer") then
      Tests_Lists_Definite_Bounded.Test0;
   end if;
   if F.Active ("lists-definite_bounded_limited-integer") then
      Tests_Lists_Definite_Bounded_Limited.Test0;
   end if;
   if F.Active ("lists-definite_unbounded-integer") then
      Tests_Lists_Definite_Unbounded.Test0;
   end if;
   if F.Active ("lists-definite_unbounded_limited-integer") then
      Tests_Lists_Definite_Unbounded_Limited.Test0;
   end if;
   if F.Active ("lists-indefinite_bounded-integer") then
      Tests_Lists_Indefinite_Bounded.Test0;
   end if;
   if F.Active ("lists-indefinite_bounded-string") then
      Tests_Lists_Indefinite_Bounded.Test1;
   end if;
   if F.Active ("lists-indefinite_unbounded-integer") then
      Tests_Lists_Indefinite_Unbounded.Test0;
   end if;
   if F.Active ("lists-indefinite_unbounded-string") then
      Tests_Lists_Indefinite_Unbounded.Test1;
   end if;
   if F.Active ("lists-indefinite_unbounded_spark-integer") then
      Tests_Lists_Indefinite_Unbounded_SPARK.Test0;
   end if;
   if F.Active ("lists-indefinite_unbounded_spark-string") then
      Tests_Lists_Indefinite_Unbounded_SPARK.Test1;
   end if;
   if F.Active ("lists-unmovable_definite_unbounded-gnatcoll.strings.xstring") then
      Tests_Lists_Unmovable_Definite_Unbounded.Test0;
   end if;
   if F.Active ("maps-def_def_unbounded-integer-integer") then
      Tests_Maps_Def_Def_Unbounded.Test0;
   end if;
   if F.Active ("maps-indef_def_unbounded-integer-integer") then
      Tests_Maps_Indef_Def_Unbounded.Test0;
   end if;
   if F.Active ("maps-indef_def_unbounded-string-integer") then
      Tests_Maps_Indef_Def_Unbounded.Test1;
   end if;
   if F.Active ("maps-indef_indef_unbounded-integer-integer") then
      Tests_Maps_Indef_Indef_Unbounded.Test0;
   end if;
   if F.Active ("maps-indef_indef_unbounded-string-string") then
      Tests_Maps_Indef_Indef_Unbounded.Test1;
   end if;
   if F.Active ("maps-indef_indef_unbounded_spark-integer-integer") then
      Tests_Maps_Indef_Indef_Unbounded_SPARK.Test0;
   end if;
   if F.Active ("maps-indef_indef_unbounded_spark-string-string") then
      Tests_Maps_Indef_Indef_Unbounded_SPARK.Test1;
   end if;
end Main_Driver;