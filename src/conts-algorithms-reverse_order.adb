with Conts.Algorithms.Reverse_Order_Ranged;

procedure Conts.Algorithms.Reverse_Order
   (Self    : in out Cursors.Container)
is
   procedure Impl is new Conts.Algorithms.Reverse_Order_Ranged
      (Cursors, Swap);
begin
   Impl (Self, Cursors.First_Cursor (Self), Cursors.Last_Cursor (Self));
end Conts.Algorithms.Reverse_Order;
