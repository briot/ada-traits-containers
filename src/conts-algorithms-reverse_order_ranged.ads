with Conts.Cursors;

generic
   with package Cursors is new Conts.Cursors.Bidirectional_Cursors (<>);
   with procedure Swap
      (Self        : in out Cursors.Container;
       Left, Right : Cursors.Cursor_Type) is <>;
procedure Conts.Algorithms.Reverse_Order_Ranged
   (Self        : in out Cursors.Container;
    First, Last : Cursors.Cursor_Type)
   with Pure, Global => null;
--  Reverse the order of elements in the [First, Last] range of Self.
--
--  See also:
--  * Conts.Algorithms.Reverse_Order
--       to revert the order for the whole container
