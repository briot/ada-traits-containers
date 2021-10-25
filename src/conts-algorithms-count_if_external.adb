function Conts.Algorithms.Count_If_External
   (Self      : Cursors.Container;
    Map       : Getters.Map;
    Predicate : not null access function (E : Getters.Element) return Boolean)
   return Natural
is
   C     : Cursors.Cursor := Cursors.First (Self);
   Count : Natural := 0;
begin
   while Cursors.Has_Element (Self, C) loop
      if Predicate (Getters.Get (Map, C)) then
         Count := Count + 1;
      end if;
      C := Cursors.Next (Self, C);
   end loop;
   return Count;
end Conts.Algorithms.Count_If_External;
