with GAL.Cursors;
with GAL.Properties;

generic
   with package Cursors is new GAL.Cursors.Forward_Cursors (<>);
   with package Getters is new GAL.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Cursor,
      others   => <>);
   with function "=" (K1, K2 : Getters.Element) return Boolean is <>;
function GAL.Algo.Contains
  (Self      : Cursors.Container;
   E         : Getters.Element)
  return Boolean
  with Pure, Global => null;
--  True if E is found in Self
