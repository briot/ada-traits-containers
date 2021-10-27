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
procedure GAL.Algo.Sort.Insertion (Self : in out Cursors.Container)
  with Pure, Global => null;
--  Sort the container.
--  This is an algorithm only suitable for small containers (up to say 100
--  elements for instance), for which it is fast since it has low overhead.
--
--  Stable: when two elements compare equal, their initial order is
--     preserved. You can thus do a first sort for one criteria, then
--     another sort with another criteria, and elements will be sorted based
--     on the two criteria.
--  In-Place: no additional storage required.
--  Adaptive: it executes faster when Self is already partially sorted.
--
--  Complexity:
--     - if Self is already sorted, this is O(n)
--     - worst-case execution is O(n^2)
