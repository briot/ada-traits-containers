with Conts.Algorithms.Find;

function Conts.Algorithms.Contains
  (Self      : Cursors.Container;
   E         : Getters.Element)
  return Boolean
is
   function F is new Conts.Algorithms.Find (Cursors, Getters, "=");
   use type Cursors.Cursor_Type;
begin
   return F (Self, E) /= Cursors.No_Element;
end Conts.Algorithms.Contains;
