with Conts.Algorithms.Reverse_Order_Ranged;

package body Conts.Algorithms.Permutations is

   procedure Reverse_Order is new Conts.Algorithms.Reverse_Order_Ranged
      (Cursors, Swap);

   ----------------------
   -- Next_Permutation --
   ----------------------

   function Next_Permutation
      (Self    : in out Cursors.Container)
      return Boolean
   is
      use type Cursors.Cursor_Type;
      C : Cursors.Cursor := Cursors.Last_Cursor (Self);
      C2, C3 : Cursors.Cursor;
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

      if not Cursors.Has_Elem (Self, C)
         or else C = Cursors.First_Cursor (Self)
      then
         return False;
      end if;

      loop
         C2 := C;
         C := Cursors.Prev (Self, C);
         if Getters.Get (Self, C) < Getters.Get (Self, C2) then
            C3 := Cursors.Last_Cursor (Self);
            while not (Getters.Get (Self, C) < Getters.Get (Self, C3)) loop
               C3 := Cursors.Prev (Self, C3);
            end loop;
            Swap (Self, C, C3);
            Reverse_Order (Self, C2, Cursors.Last_Cursor (Self));
            return True;
         end if;

         if C = Cursors.First_Cursor (Self) then
            Reverse_Order
               (Self, Cursors.First_Cursor (Self), Cursors.Last_Cursor (Self));
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
   begin
      Reverse_Order (Self, Cursors.Next (Self, K), Cursors.Last_Cursor (Self));
      return Next_Permutation (Self);
   end Next_Partial_Permutation;

end Conts.Algorithms.Permutations;
