with Conts.Cursors;
with Conts.Properties;

generic
   with package Cursors is new Conts.Cursors.Forward_Cursors (<>);
   with package Getters is new Conts.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Cursor,
      others   => <>);
   with function "=" (K1, K2 : Getters.Element) return Boolean is <>;
function Conts.Algorithms.Contains
  (Self      : Cursors.Container;
   E         : Getters.Element)
  return Boolean
  with Global => null;
--  True if E is found in Self
