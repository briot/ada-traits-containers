function GAL.Algo.Is_Sorted
   (Self : Cursors.Container) return Boolean
is
   Prev  : Cursors.Cursor := Cursors.First (Self);
   C     : Cursors.Cursor;
begin
   if not Cursors.Has_Element (Self, Prev) then
      return True;  --  an empty sequence is always sorted
   end if;

   C := Prev;
   Cursors.Next (Self, C);

   while Cursors.Has_Element (Self, C) loop
      if Getters.Get (Self, C) < Getters.Get (Self, Prev) then
         return False;
      end if;
      Prev := C;
      Cursors.Next (Self, C);
   end loop;
   return True;
end GAL.Algo.Is_Sorted;
