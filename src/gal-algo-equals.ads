with GAL.Cursors;
with GAL.Properties;

generic
   with package Cursors is new GAL.Cursors.Forward_Cursors (<>);
   with package Getters is new GAL.Properties.Read_Only_Maps
     (Map_Type => Cursors.Container,
      Key_Type => Cursors.Cursor,
      others   => <>);
   with function "=" (K1, K2 : Getters.Element) return Boolean is <>;
function GAL.Algo.Equals
   (Left, Right  : Cursors.Container) return Boolean
   with Pure, Global => null;
--  True if Left and Right contain the same elements, in the same order.
