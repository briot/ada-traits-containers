with Conts.Cursors;

generic
   with package Cursors is new Conts.Cursors.Bidirectional_Cursors (<>);
   with procedure Swap
      (Self        : in out Cursors.Container;
       Left, Right : Cursors.Cursor_Type) is <>;
procedure Conts.Algorithms.Reverse_Order
   (Self    : in out Cursors.Container);
--  Reverse the order of elements in Self.
