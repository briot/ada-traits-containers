pragma Ada_2012;
with Asserts;
with Conts.Algorithms.Next_Permutation;
with Test_Containers;  use Test_Containers;
with Test_Support;     use Test_Support;

package body Test_Algo_Permutation is
   function Next_Permutation is new Conts.Algorithms.Next_Permutation
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
      Asserts.Booleans.Assert (Next_Permutation (V), False, "empty vector");

      --  Even number of elements
      for J in 1 .. 3 loop
         V.Append (Nth (J));
      end loop;

      Count := 0;
      loop
         Count := Count + 1;
         exit when not Next_Permutation (V);
      end loop;
      Asserts.Integers.Assert (Count, 6);

   end Test;

end Test_Algo_Permutation;
