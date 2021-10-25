with Conts.Cursors;
with Conts.Properties;

generic
   with package Cursors is new Conts.Cursors.Forward_Cursors (<>);
   with package Getters is new Conts.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Cursor,
      others   => <>);
function Conts.Algorithms.Count_If
  (Self      : Cursors.Container;
   Predicate : not null access function (E : Getters.Element) return Boolean)
  return Natural
  with Global => null;
--  Count the number of elements in the container that match the predicate
