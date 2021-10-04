with Test_Algo_Equals;
with Test_Algo_Random;
with Test_Algo_Shuffle;
with Test_Algo_Sort;
with Test_Graph_Adjlist;
with Test_Lists_Definite_Bounded;
with Test_Lists_Definite_Limited_Bounded;
with Test_Lists_Definite_Limited_Unbounded;
with Test_Lists_Indefinite_Unbounded;
with Test_Lists_Indefinite_Unbounded_Spark;
with Test_Maps_Indef_Def_Unbounded;
with Test_Vectors_Definite_Bounded;
with Test_Vectors_Definite_Unbounded;
with Test_Vectors_Indefinite_Unbounded;
with Test_Vectors_Indefinite_Unbounded_Spark;

procedure Main is
begin
   Test_Graph_Adjlist.Test;
   Test_Lists_Definite_Bounded.Test;
   Test_Lists_Definite_Limited_Bounded.Test;
   Test_Lists_Definite_Limited_Unbounded.Test;
   Test_Lists_Indefinite_Unbounded.Test;
   Test_Lists_Indefinite_Unbounded_Spark.Test;
   Test_Algo_Equals.Test;
   Test_Algo_Random.Test;
   Test_Algo_Shuffle.Test;
   Test_Algo_Sort.Test;
   Test_Maps_Indef_Def_Unbounded.Test;
   Test_Vectors_Definite_Bounded.Test;
   Test_Vectors_Definite_Unbounded.Test;
   Test_Vectors_Indefinite_Unbounded.Test;
   Test_Vectors_Indefinite_Unbounded_Spark.Test;
end Main;
