with GAL.Algo.Find;

function GAL.Algo.Contains
  (Self      : Cursors.Container;
   E         : Getters.Element)
  return Boolean
is
   function F is new GAL.Algo.Find (Cursors, Getters, "=");
   use type Cursors.Cursor_Type;
begin
   return F (Self, E) /= Cursors.No_Element;
end GAL.Algo.Contains;
