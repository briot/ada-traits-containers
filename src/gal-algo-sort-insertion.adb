procedure GAL.Algo.Sort.Insertion (Self : in out Cursors.Container) is
   C  : Cursors.Index := Cursors.First (Self);
begin
   if Cursors.Has_Element (Self, C) then
      Cursors.Next (Self, C);
      while Cursors.Has_Element (Self, C) loop
         declare
            Elem : constant Getters.Element := Getters.Get (Self, C);
            E : Cursors.Index;
            D : Cursors.Index := C;
         begin
            loop
               E := D;
               Cursors.Previous (Self, D);
               exit when not Cursors.Has_Element (Self, D)
                 or else "<" (Getters.Get (Self, D), Elem);
               Swap (Self, E, D);
            end loop;
         end;

         Cursors.Next (Self, C);
      end loop;
   end if;
end GAL.Algo.Sort.Insertion;
