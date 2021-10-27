with GAL.Cursors;
with GAL.Properties;

generic
   with package Cursors is new GAL.Cursors.Forward_Cursors (<>);
   with package Getters is new GAL.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Cursor,
      others   => <>);
   with function "=" (K1, K2 : Getters.Element) return Boolean is <>;
function GAL.Algo.Find
  (Self      : Cursors.Container;
   E         : Getters.Element)
  return Cursors.Cursor
  with Pure, Global => null;
--  Return the location of E within Self, or No_Element if it could not be
--  found.
