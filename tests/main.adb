with Test_Lists_Definite_Bounded;
with Test_Lists_Definite_Limited_Bounded;
with Test_Lists_Definite_Limited_Unbounded;
with Test_Lists_Indefinite_Unbounded;
with Test_Lists_Indefinite_Unbounded_Spark;

procedure Main is
begin
   Test_Lists_Definite_Bounded.Test;
   Test_Lists_Definite_Limited_Bounded.Test;
   Test_Lists_Definite_Limited_Unbounded.Test;
   Test_Lists_Indefinite_Unbounded.Test;
   Test_Lists_Indefinite_Unbounded_Spark.Test;
end Main;
