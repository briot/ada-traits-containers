pragma Ada_2012;
with Conts.Algorithms.Reverse_Order;
with Test_Containers;  use Test_Containers;
with Test_Support;     use Test_Support;

package body Test_Algo_Reverse is

   procedure Reverse_Order is new Conts.Algorithms.Reverse_Order
      (Cursors => Int_Vecs.Cursors.Bidirectional,
       Swap    => Int_Vecs.Swap);

   ----------
   -- Test --
   ----------

   procedure Test is
      V : Int_Vecs.Vector;
   begin
      --  Empty vector
      Reverse_Order (V);
      Support.Assert_Vector (V, "", "empty vector");

      --  Even number of elements
      for J in 1 .. 10 loop
         V.Append (Nth (J));
      end loop;

      Support.Assert_Vector
         (V, " 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,", "before reverse");
      Reverse_Order (V);
      Support.Assert_Vector
         (V, " 10, 9, 8, 7, 6, 5, 4, 3, 2, 1,", "after reverse");

      --  Odd number of elements
      V.Clear;
      for J in 1 .. 9 loop
         V.Append (Nth (J));
      end loop;

      Support.Assert_Vector
         (V, " 1, 2, 3, 4, 5, 6, 7, 8, 9,", "before reverse");
      Reverse_Order (V);
      Support.Assert_Vector
         (V, " 9, 8, 7, 6, 5, 4, 3, 2, 1,", "after reverse");
   end Test;

end Test_Algo_Reverse;
