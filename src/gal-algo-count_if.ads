with GAL.Cursors;
with GAL.Properties;

generic
   with package Cursors is new GAL.Cursors.Forward_Cursors (<>);
   with package Getters is new GAL.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Cursor,
      others   => <>);
function GAL.Algo.Count_If
  (Self      : Cursors.Container;
   Predicate : not null access function (E : Getters.Element) return Boolean)
  return Natural
  with Pure, Global => null;
--  Count the number of elements in the container that match the predicate
