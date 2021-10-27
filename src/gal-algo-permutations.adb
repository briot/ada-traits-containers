with GAL.Algo.Reverse_Order_Ranged;

package body GAL.Algo.Permutations is

   procedure Reverse_Order is new GAL.Algo.Reverse_Order_Ranged
      (Cursors, Swap);

   ----------------------
   -- Next_Permutation --
   ----------------------

   function Next_Permutation
      (Self    : in out Cursors.Container)
      return Boolean
   is
      use type Cursors.Cursor_Type;
      First : constant Cursors.Cursor := Cursors.First_Cursor (Self);
      Last  : constant Cursors.Cursor := Cursors.Last_Cursor (Self);
      C, C2, C3 : Cursors.Cursor;
   begin
      --  This algorithm works by changing the value at a position when the
      --  elements to the right of the position are in descending order.
      --  For instance, we want to generate:
      --     1 2 3 4
      --     1 2 4 3
      --     1 3 2 4
      --     1 3 4 2
      --     1 4 2 3
      --     1 4 3 2
      --     2 1 3 4
      --     ...
      --     2 4 3 1
      --     3 1 2 4
      --     ...
      --  When we change the element at a position, we find the next largest
      --  digit, and reverse the order of all elements to the right.

      --  zero or one element => nothing to do
      if not Cursors.Has_Elem (Self, Last) or else Last = First then
         return False;
      end if;

      C := Last;
      loop
         C2 := C;
         C := Cursors.Prev (Self, C);
         if Getters.Get (Self, C) < Getters.Get (Self, C2) then
            C3 := Cursors.Last_Cursor (Self);
            while not (Getters.Get (Self, C) < Getters.Get (Self, C3)) loop
               C3 := Cursors.Prev (Self, C3);
            end loop;
            Swap (Self, C, C3);
            Reverse_Order (Self, C2, Last);
            return True;
         end if;

         if C = First then
            Reverse_Order (Self, First, Last);
            return False;
         end if;
      end loop;
   end Next_Permutation;

   ------------------------------
   -- Next_Partial_Permutation --
   ------------------------------

   function Next_Partial_Permutation
      (Self    : in out Cursors.Container;
       K       : Cursors.Cursor_Type)
      return Boolean
   is
      --  See  "combinations, with and without repetitions", Hervé Brönnimann
      --  https://citeseerx.ist.psu.edu/viewdoc/
      --     download?doi=10.1.1.353.930&rep=rep1&type=pdf
      N : constant Cursors.Cursor_Type := Cursors.Next (Self, K);
   begin
      if Cursors.Has_Element (Self, N) then
         Reverse_Order (Self, N, Cursors.Last_Cursor (Self));
      end if;
      return Next_Permutation (Self);
   end Next_Partial_Permutation;

   ----------------------
   -- Next_Combination --
   ----------------------

   function Next_Combination
      (Self    : in out Cursors.Container;
       K       : Cursors.Cursor_Type)
      return Boolean
   is
      --  See  "combinations, with and without repetitions", Hervé Brönnimann
      --  https://citeseerx.ist.psu.edu/viewdoc/
      --     download?doi=10.1.1.353.930&rep=rep1&type=pdf

      use type Cursors.Cursor_Type;
      First1 : Cursors.Cursor := Cursors.First_Cursor (Self);
      Last2  : constant Cursors.Cursor := Cursors.Last_Cursor (Self);
      K_Next : constant Cursors.Cursor := Cursors.Next (Self, K);
      M1, M2, First2 : Cursors.Cursor;
      Result : Boolean;

   begin
      --  zero or one element => nothing to do
      if not Cursors.Has_Elem (Self, Last2) or else Last2 = First1 then
         return False;
      end if;

      M1 := K;
      First2 := K_Next;
      M2 := Last2;

      while M1 /= First1
         and then not (Getters.Get (Self, M1) < Getters.Get (Self, M2))
      loop
         M1 := Cursors.Previous (Self, M1);
      end loop;

      Result := M1 = First1
         and then not (Getters.Get (Self, First1) < Getters.Get (Self, M2));

      if not Result then
         while First2 /= M2
            and then not (Getters.Get (Self, M1) < Getters.Get (Self, First2))
         loop
            First2 := Cursors.Next (Self, First2);
         end loop;

         First1 := M1;
         Swap (Self, First1, First2);
         First1 := Cursors.Next (Self, First1);
         First2 := Cursors.Next (Self, First2);
      end if;

      if First1 /= K_Next and First2 /= Cursors.No_Element then
         M1 := K_Next;
         M2 := First2;
         while M1 /= First1 and then M2 /= Cursors.No_Element loop
            M1 := Cursors.Previous (Self, M1);
            Swap (Self, M1, M2);
            M2 := Cursors.Next (Self, M2);
         end loop;

         if M1 /= First1 then
            Reverse_Order (Self, First1, Cursors.Previous (Self, M1));
         end if;
         Reverse_Order (Self, First1, K);
         if M2 /= Cursors.No_Element then
            Reverse_Order (Self, M2, Last2);
         end if;
         Reverse_Order (Self, First2, Last2);
      end if;

      return not Result;
   end Next_Combination;

end GAL.Algo.Permutations;
