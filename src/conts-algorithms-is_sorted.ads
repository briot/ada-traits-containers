with Conts.Cursors;
with Conts.Properties;

generic
   with package Cursors is new Conts.Cursors.Forward_Cursors (<>);
   with package Getters is new Conts.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Cursor,
      others   => <>);
   with function "<" (Left, Right : Getters.Element) return Boolean is <>;
function Conts.Algorithms.Is_Sorted (Self : Cursors.Container) return Boolean
  with Pure, Global => null;
--  Whether Self is sorted for the given criteria.
--  On exit, an element is always "<" or equal to the following element.
