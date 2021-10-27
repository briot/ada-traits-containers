with GAL.Cursors;
with GAL.Properties;

generic
   with package Cursors is new GAL.Cursors.Forward_Cursors (<>);
   with package Getters is new GAL.Properties.Read_Only_Maps
     (Key_Type => Cursors.Cursor, others => <>);
function GAL.Algo.Count_If_External
  (Self      : Cursors.Container;
   Map       : Getters.Map;
   Predicate : not null access function (E : Getters.Element) return Boolean)
  return Natural
  with Pure, Global => null;
--  Count the number of elements in Self that match Predicate.
--  This version of the algorithm extracts the value from an external property
--  map (so from Self we get a cursor, and from that cursor and the external
--  map we get the value to check).
--  See also GAL.Algo.Count_If.
