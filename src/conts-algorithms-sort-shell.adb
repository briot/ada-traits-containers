procedure Conts.Algorithms.Sort.Shell (Self : in out Cursors.Container) is
   --  See https://en.wikipedia.org/wiki/Shellsort

   First : constant Cursors.Index := Cursors.First (Self);
   C     : Cursors.Index;
begin
   for Gap of reverse Gaps loop
      --  Do a gapped insertion sort for this gap size.
      --  The first gap elements are already in gap order.

      C := Cursors.Add (First, Gap);
      while Cursors.Has_Element (Self, C) loop
         declare
            Elem : constant Getters.Element := Getters.Get (Self, C);
            D, E : Cursors.Index;
         begin
            E := C;
            loop
               D := Cursors."+" (E, -Gap);
               exit when "<" (Getters.Get (Self, D), Elem);
               Swap (Self, E, D);
               exit when Cursors.Distance (D, First) < Gap;
               E := D;
            end loop;
         end;

         C := Cursors.Next (Self, C);
      end loop;
   end loop;
end Conts.Algorithms.Sort.Shell;
