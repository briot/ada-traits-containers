with GAL.Adaptors;
with GAL.Algo.Equals;
with GAL.Algo.Is_Sorted;
with GAL.Lists.Definite_Unbounded;
with GAL.Vectors.Definite_Unbounded;
with Support_Lists;
with Support_Vectors;
with Test_Support;   use Test_Support;

package Test_Containers is

   ---------------------
   -- String adaptors --
   ---------------------

   package String_Adaptors is new GAL.Adaptors.Array_Adaptors
      (Positive, Character, String);
   function Image (S : String) return String is (S);
   function Is_Sorted is new GAL.Algo.Is_Sorted
      (Cursors => String_Adaptors.Cursors.Forward,
       Getters => String_Adaptors.Maps.Element);

   ---------------------
   -- Integer vectors --
   ---------------------

   package Int_Vecs is new GAL.Vectors.Definite_Unbounded
      (Positive, Integer, GAL.Controlled_Base);
   package Int_Vecs_Support is new Support_Vectors
      ("Integer Vector", "definite unbounded", Int_Vecs.Vectors);
   function Image (V : Int_Vecs.Vector) return String
      renames Int_Vecs_Support.Image;
   function Equals is new GAL.Algo.Equals
      (Cursors => Int_Vecs.Cursors.Forward,
       Getters => Int_Vecs.Maps.Element_From_Index);
   function Is_Sorted is new GAL.Algo.Is_Sorted
      (Cursors => Int_Vecs.Cursors.Forward,
       Getters => Int_Vecs.Maps.Element_From_Index);

   -------------------
   -- Integer lists --
   -------------------

   package Int_Lists is new GAL.Lists.Definite_Unbounded
      (Integer, GAL.Controlled_Base);
   package Int_Lists_Support is new Support_Lists
      ("Integer List", "definite unbounded", Int_Lists.Lists);
   function Image (V : Int_Lists.List) return String
      renames Int_Lists_Support.Image;
   function Equals is new GAL.Algo.Equals
      (Cursors => Int_Lists.Cursors.Forward,
       Getters => Int_Lists.Maps.Element);
   function Is_Sorted is new GAL.Algo.Is_Sorted
      (Cursors => Int_Lists.Cursors.Forward,
       Getters => Int_Lists.Maps.Element);

end Test_Containers;
