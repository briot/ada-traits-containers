procedure Conts.Algorithms.Shuffle
  (Self : in out Cursors.Container;
   Gen  : in out Random.Generator)
is
   use Cursors;
   First         : constant Cursors.Index := Cursors.First (Self);
   Next_To_First : constant Cursors.Index := First + 1;
   Last  : constant Cursors.Index := Cursors.Last (Self);
   C     : Cursors.Index := Last;
   G     : Cursors.Index;
begin
   --  Fisher and Yates algorithm
   --  http://en.wikipedia.org/wiki/Fisher-Yates_shuffle

   while C /= Next_To_First loop
      declare
         --  The cost of the instance is limited (just a few instructions)
         --  thanks to inlining.
         procedure Rand is new Conts.Ranged_Random (Random, First, C);
      begin
         Rand (Gen, Result => G);
         Swap (Self, G, C);
         C := C - 1;
      end;
   end loop;
end Conts.Algorithms.Shuffle;
