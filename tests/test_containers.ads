with Conts.Adaptors;
with Conts.Algorithms.Equals;
with Conts.Vectors.Definite_Unbounded;
with Support_Vectors;
with Test_Support;   use Test_Support;

package Test_Containers is

   ---------------------
   -- String adaptors --
   ---------------------

   package String_Adaptors is new Conts.Adaptors.Array_Adaptors
      (Positive, Character, String);

   ---------------------
   -- Integer vectors --
   ---------------------

   package Int_Vecs is new Conts.Vectors.Definite_Unbounded
      (Positive, Integer, Conts.Controlled_Base);
   package Support is new Support_Vectors
      ("Integer Vector", "definite unbounded", Int_Vecs.Vectors);
   function Image (V : Int_Vecs.Vector) return String renames Support.Image;
   function Equals is new Conts.Algorithms.Equals
      (Cursors => Int_Vecs.Cursors.Forward,
       Getters => Int_Vecs.Maps.Element_From_Index);

end Test_Containers;
