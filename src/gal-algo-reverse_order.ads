with GAL.Cursors;

generic
   with package Cursors is new GAL.Cursors.Bidirectional_Cursors (<>);
   with procedure Swap
      (Self        : in out Cursors.Container;
       Left, Right : Cursors.Cursor_Type) is <>;
procedure GAL.Algo.Reverse_Order
   (Self    : in out Cursors.Container)
   with Pure, Global => null;
--  Reverse the order of elements in Self.
--
--  See also:
--  * GAL.Algo.Reverse_Order_Ranged
--       to revert the order for a subset of the container
