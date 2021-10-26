pragma Ada_2012;
with Asserts;
with Conts.Algorithms.Permutations;
with Test_Containers;  use Test_Containers;
with Test_Support;     use Test_Support;

package body Test_Algo_Permutation is
   use type Conts.Count_Type;

   package Permutations is new Conts.Algorithms.Permutations
      (Cursors => Int_Vecs.Cursors.Bidirectional,
       Getters => Int_Vecs.Maps.Element_From_Index,
       Swap    => Int_Vecs.Swap);

   ----------
   -- Test --
   ----------

   procedure Test is
      V     : Int_Vecs.Vector;
      Count : Natural;
   begin
      --  Empty vector
      Asserts.Booleans.Assert
         (Permutations.Next_Permutation (V), False, "empty vector");

      --  Even number of elements
      for J in 1 .. 3 loop
         V.Append (Nth (J));
      end loop;

      Count := 0;
      loop
         Count := Count + 1;
         exit when not Permutations.Next_Permutation (V);
      end loop;
      Asserts.Integers.Assert (Count, 6);

      --  ??? Should check that V is now sorted

      Count := 0;
      V.Clear;
      for J in 1 .. 5 loop
         V.Append (Nth (J));
      end loop;
      loop
         Count := Count + 1;
         exit when not Permutations.Next_Partial_Permutation (V, 2);

         --  ??? Could check that range 3 .. 5 is sorted
      end loop;
      Asserts.Integers.Assert (Count, Integer (V.Length * (V.Length - 1)));

      --  ??? Should check with Ada array and list
   end Test;

end Test_Algo_Permutation;
