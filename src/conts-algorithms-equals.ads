with Conts.Cursors;
with Conts.Properties;

generic
   with package Cursors is new Conts.Cursors.Forward_Cursors (<>);
   with package Getters is new Conts.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Cursor,
      others   => <>);
   with function "=" (K1, K2 : Getters.Element) return Boolean is <>;
function Conts.Algorithms.Equals
   (Left, Right  : Cursors.Container) return Boolean
   with Global => null;
--  True if Left and Right contain the same elements, in the same order.
