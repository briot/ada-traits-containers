--  Generates permutations and combinations
--
--  Example:
--
--    declare
--       package String_Adaptors is new Conts.Adaptors.Array_Adaptors
--          (Positive, Character, String);
--       package Permutations is new Conts.Algorithms.Permutations
--          (String_Adaptors.Cursors.Random_Access,
--           String_Adaptors.Maps.Element,
--           String_Adaptors.Swap);
--       S : constant String = "ABCD";
--    begin
--       loop
--          Put_Line (S (1 .. 2));
--          exit when not
--             Permutations.Next_Partial_Permutation (S, S'First + 1);
--       end loop;
--    end;

with Conts.Cursors;

generic
   with package Cursors is new Conts.Cursors.Bidirectional_Cursors (<>);
   with package Getters is new Conts.Properties.Read_Only_Maps
      (Map_Type   => Cursors.Container,
       Key_Type   => Cursors.Cursor,
       others     => <>);
   with procedure Swap
      (Self        : in out Cursors.Container;
       Left, Right : Cursors.Cursor_Type) is <>;
   with function "<" (L, R : Getters.Element) return Boolean is <>;

package Conts.Algorithms.Permutations is

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

end Conts.Algorithms.Permutations;
