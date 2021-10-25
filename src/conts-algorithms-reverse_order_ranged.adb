procedure Conts.Algorithms.Reverse_Order_Ranged
   (Self        : in out Cursors.Container;
    First, Last : Cursors.Cursor_Type)
is
   use type Cursors.Cursor_Type;
   F : Cursors.Cursor_Type := First;
   L : Cursors.Cursor_Type := Last;
begin
   loop
      exit when F = L;
      Swap (Self, F, L);
      L := Cursors.Previous (Self, L);
      exit when F = L;
      F := Cursors.Next (Self, F);
   end loop;
end Conts.Algorithms.Reverse_Order_Ranged;
