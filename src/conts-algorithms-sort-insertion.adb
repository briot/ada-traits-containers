procedure Conts.Algorithms.Sort.Insertion (Self : in out Cursors.Container) is
   C  : Cursors.Index := Cursors.First (Self);
begin
   if Cursors.Has_Element (Self, C) then
      C := Cursors.Next (Self, C);
      while Cursors.Has_Element (Self, C) loop
         declare
            Elem : constant Getters.Element := Getters.Get (Self, C);
            D, E : Cursors.Index;
         begin
            E := C;
            loop
               D := Cursors.Previous (Self, E);
               exit when not Cursors.Has_Element (Self, D)
                 or else "<" (Getters.Get (Self, D), Elem);
               Swap (Self, E, D);
               E := D;
            end loop;
         end;

         C := Cursors.Next (Self, C);
      end loop;
   end if;
end Conts.Algorithms.Sort.Insertion;
