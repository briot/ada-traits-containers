--  Generates permutations and combinations
--
--  Example:
--
--    declare
--       package String_Adaptors is new GAL.Adaptors.Array_Adaptors
--          (Positive, Character, String);
--       package Permutations is new GAL.Algo.Permutations
--          (String_Adaptors.Cursors.Random_Access,
--           String_Adaptors.Maps.Element,
--           String_Adaptors.Swap);
--       S : constant String = "ABCD";
--    begin
--       loop
--          Put_Line (S (S'First .. S'First + 1));
--          exit when not
--             Permutations.Next_Partial_Permutation (S, S'First + 1);
--       end loop;
--    end;

with GAL.Cursors;

generic
   with package Cursors is new GAL.Cursors.Bidirectional_Cursors (<>);
   with package Getters is new GAL.Properties.Read_Only_Maps
      (Map_Type   => Cursors.Container,
       Key_Type   => Cursors.Cursor,
       others     => <>);
   with procedure Swap
      (Self        : in out Cursors.Container;
       Left, Right : Cursors.Cursor_Type) is <>;
   with function "<" (L, R : Getters.Element) return Boolean is <>;

package GAL.Algo.Permutations is

   pragma Pure;

   function Next_Permutation
      (Self    : in out Cursors.Container)
      return Boolean;
   --  Permutes Self into the next permutation, where the set of all
   --  permutations is ordered lexicographically with respect to "<".
   --
   --  Returns true if such a "next permutation" exists; otherwise transforms
   --  Self into the lexicographically first permutation (as if sorting Self),
   --  and returns False.
   --
   --  To get all possible permutations, you should start with a sorted
   --  container and then call Next_Permutation until it returns False.
   --
   --  Complexity:
   --    at most Self.Length comparisons and Self.Length swaps
   --
   --  Example:
   --     "ABC" -> ABC, ACB, BAC, BCA, CAB, CBA

   function Next_Partial_Permutation
      (Self    : in out Cursors.Container;
       K       : Cursors.Cursor_Type)
      return Boolean;
   --  Elements from [Self.First, K] will be set to represent the next k-length
   --  permutation of Self.
   --  The permutations are emitted in lexicographic ordering according. Self
   --  should be sorted initially to get all permutations (this initial sorting
   --  also provides the first partial permutation).
   --
   --  Complexity:
   --    at most Self.Length comparisons and Self.Length swaps
   --
   --  Example:
   --    "ABCD", 2  ->  AB AC AD BA BC BD CA CB CD DA DB DC

   function Next_Combination
      (Self    : in out Cursors.Container;
       K       : Cursors.Cursor_Type)
      return Boolean;
   --  Permutes self to return the next combination, so that elements from
   --  [Self.First, K] are that combination.
   --  A combination of size k of a range of size n is a sorted subsequence of
   --  size k of the total range, i.e., the ordered (possibly multi-)set of the
   --  elements at k positions among the n positions in Self.
   --
   --  Example:
   --    "ABCD", 2  ->  AB AC AD BC BD CD

end GAL.Algo.Permutations;
