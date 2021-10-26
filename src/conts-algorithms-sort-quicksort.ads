with Conts.Cursors;
with Conts.Properties;

generic
   with package Cursors is new Conts.Cursors.Random_Access_Cursors (<>);
   with package Getters is new Conts.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Index,
      others   => <>);
   with function "<" (Left, Right : Getters.Element) return Boolean is <>;
   with procedure Swap
     (Self        : in out Cursors.Container;
      Left, Right : Cursors.Index) is <>;
   Threshold  : Integer := 20;
procedure Conts.Algorithms.Sort.Quicksort (Self : in out Cursors.Container)
  with Pure, Global => null;
--  Sort the container.
--  When there are fewer than Threshold elements in a sequence, a simpler
--  sort is used instead to avoid a lot of recursions.
--
--  Unstable: equal elements might change order.
--  In-place: no additional storage requirement
--
--  Complexity:
--      - O(n*log(n)) on average
--      - O(n^2) worst case
