procedure GAL.Algo.Reverse_Order_Ranged
   (Self        : in out Cursors.Container;
    First, Last : Cursors.Cursor_Type)
is
   use type Cursors.Cursor_Type;
   F : Cursors.Cursor_Type := First;
   L : Cursors.Cursor_Type := Last;
begin
   while F /= L loop
      Swap (Self, F, L);
      Cursors.Previous (Self, L);
      exit when F = L;
      Cursors.Next (Self, F);
   end loop;
end GAL.Algo.Reverse_Order_Ranged;
