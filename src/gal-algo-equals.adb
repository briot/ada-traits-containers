function GAL.Algo.Equals
   (Left, Right  : Cursors.Container) return Boolean
is
   L_C : Cursors.Cursor := Cursors.First (Left);
   R_C : Cursors.Cursor := Cursors.First (Right);
begin
   while Cursors.Has_Element (Left, L_C) loop
      if not Cursors.Has_Element (Right, R_C)
         or else Getters.Get (Left, L_C) /= Getters.Get (Right, R_C)
      then
         return False;
      end if;

      L_C := Cursors.Next (Left, L_C);
      R_C := Cursors.Next (Right, R_C);
   end loop;

   return not Cursors.Has_Element (Right, R_C);
end GAL.Algo.Equals;
