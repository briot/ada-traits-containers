function GAL.Algo.Find
  (Self      : Cursors.Container;
   E         : Getters.Element)
  return Cursors.Cursor
is
   C : Cursors.Cursor := Cursors.First (Self);
begin
   while Cursors.Has_Element (Self, C) loop
      if Getters.Get (Self, C) = E then
         return C;
      end if;
      Cursors.Next (Self, C);
   end loop;
   return Cursors.No_Element;
end GAL.Algo.Find;
