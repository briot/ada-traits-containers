pragma Ada_2012;
with Asserts;
with GAL.Algo.Permutations;
with Test_Containers;  use Test_Containers;
with Test_Support;     use Test_Support;

package body Test_Algo_Permutation is
   use type GAL.Count_Type;

   package Vec_Permutations is new GAL.Algo.Permutations
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
         (Vec_Permutations.Next_Permutation (V), False, "empty vector");

      --  Even number of elements
      for J in 1 .. 3 loop
         V.Append (Nth (J));
      end loop;

      Count := 0;
      loop
         Count := Count + 1;
         exit when not Vec_Permutations.Next_Permutation (V);
      end loop;
      Asserts.Integers.Assert (Count, 6);

      Asserts.Booleans.Assert
         (Is_Sorted (V), True, "should be sorted after permutations");

      declare
         use Vec_Permutations;
         Size : constant := 10;
      begin
         V.Clear;
         for J in 1 .. 10 loop
            V.Append (Nth (J));
         end loop;

         ---------------------------
         -- Permutations length 1 --
         ---------------------------

         Count := 0;
         Test_Permut_1 :
         for A in 1 .. Size loop
            Count := Count + 1;
            Asserts.Booleans.Assert
               (V (1) = A, True,
                "Expecting permutation" & A'Image
                & " got " & Int_Vecs_Support.Image (V));
            exit Test_Permut_1 when not Next_Partial_Permutation (V, 1);
         end loop Test_Permut_1;
         Asserts.Integers.Assert (Count, Integer (V.Length));
         Asserts.Booleans.Assert
            (Is_Sorted (V), True, "should be sorted after permutations");

         ---------------------------
         -- Permutations length 2 --
         ---------------------------

         Count := 0;
         Test_Permut_2 :
         for A in 1 .. Size loop
            for B in 1 .. Size loop
               if A /= B then
                  Count := Count + 1;
                  Asserts.Booleans.Assert
                     (V (1) = A and V (2) = B, True,
                      "Expecting permutation" & A'Image & B'Image
                      & " got " & Int_Vecs_Support.Image (V));
                  exit Test_Permut_2 when not Next_Partial_Permutation (V, 2);
               end if;
            end loop;
         end loop Test_Permut_2;
         Asserts.Integers.Assert (Count, Integer (V.Length * (V.Length - 1)));
         Asserts.Booleans.Assert
            (Is_Sorted (V), True, "should be sorted after permutations");

         ---------------------------
         -- Permutations length 3 --
         ---------------------------

         Count := 0;
         Test_Permut_3 :
         for A in 1 .. Size loop
            for B in 1 .. Size loop
               for C in 1 .. Size loop
                  if A /= B and then A /= C and then B /= C then
                     Count := Count + 1;
                     Asserts.Booleans.Assert
                        (V (1) = A and V (2) = B and V (3) = C, True,
                         "Expecting permutation" & A'Image & B'Image & C'Image
                         & " got " & Int_Vecs_Support.Image (V));
                     exit Test_Permut_3
                        when not Next_Partial_Permutation (V, 3);
                  end if;
               end loop;
            end loop;
         end loop Test_Permut_3;
         Asserts.Integers.Assert
            (Count, Integer (V.Length * (V.Length - 1) * (V.Length - 2)));
         Asserts.Booleans.Assert
            (Is_Sorted (V), True, "should be sorted after permutations");

         ---------------------------
         -- Combinations length 1 --
         ---------------------------

         Count := 0;
         Test_Combi_1 :
         for A in 1 .. Size loop
            Count := Count + 1;
            Asserts.Booleans.Assert
               (V (1) = A, True,
                "Expecting" & A'Image & " got " & Int_Vecs_Support.Image (V));
            exit Test_Combi_1 when not Next_Combination (V, 1);
         end loop Test_Combi_1;
         Asserts.Integers.Assert (Count, Integer (V.Length));
         Asserts.Booleans.Assert
            (Is_Sorted (V), True, "should be sorted after combinations");

         ---------------------------
         -- Combinations length 2 --
         ---------------------------

         Count := 0;
         Test_Combi_2 :
         for A in 1 .. Size loop
            for B in A + 1 .. Size loop
               Count := Count + 1;
               Asserts.Booleans.Assert
                  (V (1) = A and V (2) = B, True,
                   "Expecting" & A'Image & B'Image
                   & " got " & Int_Vecs_Support.Image (V));
               exit Test_Combi_2 when not Next_Combination (V, 2);
            end loop;
         end loop Test_Combi_2;
         Asserts.Integers.Assert
            (Count, Integer (V.Length * (V.Length - 1) / 2));
         Asserts.Booleans.Assert
            (Is_Sorted (V), True, "should be sorted after combinations");

         ---------------------------
         -- Combinations length 3 --
         ---------------------------

         Count := 0;
         Test_Combi_3 :
         for A in 1 .. Size loop
            for B in A + 1 .. Size loop
               for C in B + 1 .. Size loop
                  Count := Count + 1;
                  Asserts.Booleans.Assert
                     (V (1) = A and V (2) = B and V (3) = C, True,
                      "Expecting" & A'Image & B'Image & C'Image
                      & " got " & Support.Image (V));
                  exit Test_Combi_3
                     when not Permutations.Next_Combination (V, 3);
               end loop;
            end loop;
         end loop Test_Combi_3;
         Asserts.Integers.Assert
            (Count, Integer (V.Length * (V.Length - 1) * (V.Length - 2) / 6));
      end;

      --  ??? Should check with Ada array and list
   end Test;

end Test_Algo_Permutation;
