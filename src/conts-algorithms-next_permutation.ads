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
function Conts.Algorithms.Next_Permutation
   (Self    : in out Cursors.Container)
   return Boolean;
--  Permutes Self into the next permutation, where the set of all permutations
--  is ordered lexicographically with respect to "<".
--
--  Returns true if such a "next permutation" exists; otherwise transforms Self
--  into the lexicographically first permutation (as if sorting Self), and
--  returns False.
--
--  To get all possible permutations, you should start with a sorted container
--  and then call Next_Permutation until it returns False.
