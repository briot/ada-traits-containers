function Conts.Algorithms.Is_Sorted
   (Self : Cursors.Container) return Boolean
is
   Prev  : Cursors.Cursor := Cursors.First (Self);
   C     : Cursors.Cursor;
begin
   if not Cursors.Has_Element (Self, Prev) then
      return True;  --  an empty sequence is always sorted
   end if;

   C := Cursors.Next (Self, Prev);

   while Cursors.Has_Element (Self, C) loop
      if Getters.Get (Self, C) < Getters.Get (Self, Prev) then
         return False;
      end if;
      Prev := C;
      C := Cursors.Next (Self, C);
   end loop;
   return True;
end Conts.Algorithms.Is_Sorted;
