with GAL.Algo.Count_If_External;

function GAL.Algo.Count_If
  (Self      : Cursors.Container;
   Predicate : not null access function (E : Getters.Element) return Boolean)
  return Natural
is
   function Internal is new Count_If_External (Cursors, Getters);
begin
   return Internal (Self, Self, Predicate);
end GAL.Algo.Count_If;
