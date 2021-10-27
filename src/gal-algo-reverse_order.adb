with GAL.Algo.Reverse_Order_Ranged;

procedure GAL.Algo.Reverse_Order
   (Self    : in out Cursors.Container)
is
   procedure Impl is new GAL.Algo.Reverse_Order_Ranged
      (Cursors, Swap);
begin
   Impl (Self, Cursors.First_Cursor (Self), Cursors.Last_Cursor (Self));
end GAL.Algo.Reverse_Order;
