with GAL.Cursors;
with GAL.Algo.Random;

generic
   with package Cursors is new GAL.Cursors.Random_Access_Cursors (<>);
   with package Random is new GAL.Algo.Random.Uniform_Random_Traits
      (Discrete_Type => Cursors.Index, others => <>);
   with procedure Swap
      (Self        : in out Cursors.Container;
       Left, Right : Cursors.Index) is <>;
procedure GAL.Algo.Shuffle
   (Self : in out Cursors.Container;
    Gen  : in out Random.Generator)
   with Global => null;
--  Generates a random permutation of Self.
--  If you 'use' the package for your container (vector for instance), then
--  Swap will generally be visible by default.
--  Complexity: O(n)
