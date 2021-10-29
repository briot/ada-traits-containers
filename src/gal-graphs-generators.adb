package body GAL.Graphs.Generators is
   use type Graphs.Vertex;

   --------------
   -- Complete --
   --------------

   procedure Complete
      (Self : in out Graphs.Graph;
       N    : Count_Type)
   is
      --  ??? Might result in stack_overflow when adding too many vertices.
      --  But then the graph will likely be too big to manipulate anyway.
      V : array (1 .. N) of Graphs.Vertex;
      E : Graphs.Edge with Unreferenced;
   begin
      --  ??? Would be faster to add multiple vertices at once.
      --  ??? or at least Reserve the space for enough
      for I in 1 .. N loop
         V (I) := Vertex_Mutable.Add_Vertex (Self);
      end loop;

      if N > 1 then
         for V1 of V loop
            for V2 of V loop
               if V1 /= V2 then
                  E := Edge_Mutable.Add_Edge (Self, V1, V2);
               end if;
            end loop;
         end loop;
      end if;
   end Complete;

end GAL.Graphs.Generators;
