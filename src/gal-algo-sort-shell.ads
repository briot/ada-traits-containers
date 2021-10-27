with GAL.Cursors;
with GAL.Properties;

generic
   with package Cursors is new GAL.Cursors.Random_Access_Cursors (<>);
   with package Getters is new GAL.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Index,
      others   => <>);
   with function "<" (Left, Right : Getters.Element) return Boolean is <>;
   with procedure Swap
     (Self        : in out Cursors.Container;
      Left, Right : Cursors.Index) is <>;
   Gaps : GAL.Algo.Sort.Shell_Sort_Gaps := Sedgewick_Gaps;
procedure GAL.Algo.Sort.Shell
  (Self : in out Cursors.Container)
  with Pure, Global => null;
--  Sort the container.
--  This is an improvement over Insertion_Sort. It does several iterations
--  of Insertion_Sort, each looking at elements apart from each other
--  based on the Gaps settings. The Wiki page for this algorithm suggests
--  a number of possible gaps, the default is usually a good choice.
--
--  Unstable: equal elements might change order.
--  Adaptive: it executes faster if Self is already partially sorted.
--  In-place: no additional storage required.
--
--  This algorithm needs to move a cursor by a large number places, so is
--  not suitable for lists (although it will work).
--
--  Complexity:
--     - if Self is already sorted, this is O(n)
--     - worst case execution is roughly O(n^4/3), though it depends on the
--       gap sequence chosen in the instantiation.
