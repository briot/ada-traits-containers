with GAL.Algo.Sort.Shell;

procedure GAL.Algo.Sort.Quicksort (Self : in out Cursors.Container) is
   package Ranges is new Ranged_Random_Access_Cursors
     (Cursors, Getters, Swap);
   procedure Shell is new GAL.Algo.Sort.Shell
     (Ranges.Cursors, Ranges.Getters, "<", Ranges.Swap);

   procedure Recurse (Low, High : Cursors.Index);
   procedure Recurse (Low, High : Cursors.Index) is
      Dist : Integer;
      L    : Cursors.Index := Low;
      H    : Cursors.Index := High;
      Left, Right : Cursors.Index;
   begin
      loop
         Dist := Cursors.Dist (H, L);
         exit when Dist <= 0;

         if Dist < Threshold then
            declare
               S : Ranges.Rg := Ranges.Subset
                 (Self'Unrestricted_Access, L, H);
            begin
               Shell (S);
            end;
            return;
         end if;

         Left := L;
         Right := H;

         declare
            Pivot : constant Getters.Element :=
              Getters.Value (Self, Cursors.Add (L, Dist / 2));
         begin
            --  ??? Should handle cases where the element is equal to the
            --  pivot, to avoid the worst case where the sequences contains
            --  only equal items.

            loop
               while "<" (Getters.Value (Self, Left), Pivot) loop
                  Left := Cursors.Next (Self, Left);
               end loop;

               while "<" (Pivot, Getters.Value (Self, Right)) loop
                  Right := Cursors.Previous (Self, Right);
               end loop;

               exit when Cursors.Dist (Right, Left) <= 0;

               Swap (Self, Right, Left);
               Left := Cursors.Next (Self, Left);
               Right := Cursors.Previous (Self, Right);
            end loop;
         end;

         --  Recurse for smaller sequence, and tail recursion for longer
         --  one. Do not keep pivot on the stack while recursing.
         if Cursors.Dist (Right, L) > Cursors.Dist (H, Right) then
            Recurse (Cursors.Next (Self, Right), H);
            H := Right;  --  loop on L..Right
         else
            Recurse (L, Right);
            L := Cursors.Next (Self, Right);  --  loop on Right+1 .. H
         end if;
      end loop;
   end Recurse;

begin
   Recurse (Cursors.First_Index (Self), Cursors.Last_Index (Self));
end GAL.Algo.Sort.Quicksort;
