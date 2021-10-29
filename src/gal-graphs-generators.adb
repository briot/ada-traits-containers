package body GAL.Graphs.Generators is

   --------------
   -- Complete --
   --------------

   procedure Complete
      (Self : in out Graph.Graph;
       N    : Count_Type) is
   begin
      Clear (Self);
      Add_Vertices (Self, Count => N);

      if N > 1 then
         declare
            use type Graph.Vertex_Cursors.Cursor;
            V1, V2 : Graph.Vertex_Cursors.Cursor;
         begin
            V1 := Graph.Vertex_Cursors.First (Self);
            while Graph.Vertex_Cursors.Has_Element (Self, V1) loop
               V2 := Graph.Vertex_Cursors.First (Self);
               while Graph.Vertex_Cursors.Has_Element (Self, V2) loop
                  if V1 /= V2 then
                     Add_Edge
                        (Self,
                         Graph.Vertex_Maps.Get (Self, V1),
                         Graph.Vertex_Maps.Get (Self, V2));
                  end if;

                  V2 := Graph.Vertex_Cursors.Next (Self, V2);
               end loop;

               V1 := Graph.Vertex_Cursors.Next (Self, V1);
            end loop;
         end;
      end if;
   end Complete;

end GAL.Graphs.Generators;
