with Ada.Containers.Bounded_Doubly_Linked_Lists;
with Ada.Containers.Bounded_Hashed_Maps;
with Ada.Containers.Bounded_Ordered_Maps;
with Ada.Containers.Bounded_Vectors;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Containers.Hashed_Maps;
with Ada.Containers.Indefinite_Doubly_Linked_Lists;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Ordered_Maps;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Hash;
with GAL.Adaptors;
with GAL.Algo.Equals;
with GAL.Algo.Is_Sorted;
with GAL.Lists.Definite_Unbounded;
with GAL.Vectors.Definite_Unbounded;
with Support_Ada;
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

   ---------------
   -- Ada Lists --
   ---------------

   package Integer_Unbounded_Lists is
      new Ada.Containers.Doubly_Linked_Lists (Integer);
   package Integer_Unbounded_List_Tests is
      new Support_Ada.Test_Definite_Unbounded_Lists
        (Category       => "Integer List",
         Container_Name => "Ada Def Unbounded",
         Lists          => Integer_Unbounded_Lists,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package Integer_Bounded_Lists is
      new Ada.Containers.Bounded_Doubly_Linked_Lists (Integer);
   package Integer_Bounded_List_Tests is
      new Support_Ada.Test_Definite_Bounded_Lists
        (Category       => "Integer List",
         Container_Name => "Ada Def Bounded",
         Lists          => Integer_Bounded_Lists,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package Integer_Indef_Unbounded_Lists is
      new Ada.Containers.Indefinite_Doubly_Linked_Lists (Integer);
   package Integer_Indef_Unbounded_List_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Lists
        (Category       => "Integer List",
         Container_Name => "Ada Indef Unbounded",
         Lists          => Integer_Indef_Unbounded_Lists,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package String_Indef_Unbounded_Lists is
      new Ada.Containers.Indefinite_Doubly_Linked_Lists (String);
   package String_Indef_Unbounded_List_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Lists
        (Category       => "String List",
         Container_Name => "Ada Indef Unbounded",
         Lists          => String_Indef_Unbounded_Lists,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   -----------------
   -- Ada Vectors --
   -----------------

   package Integer_Unbounded_Vectors is new Ada.Containers.Vectors
      (Positive, Integer);
   package Integer_Unbounded_Vector_Tests is
      new Support_Ada.Test_Definite_Unbounded_Vectors
        (Category       => "Integer Vector",
         Container_Name => "Ada Def Unbounded",
         Vectors        => Integer_Unbounded_Vectors,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package Integer_Bounded_Vectors is
      new Ada.Containers.Bounded_Vectors (Positive, Integer);
   package Integer_Bounded_Vector_Tests is
      new Support_Ada.Test_Definite_Bounded_Vectors
        (Category       => "Integer Vector",
         Container_Name => "Ada Def Bounded",
         Vectors        => Integer_Bounded_Vectors,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package Integer_Indef_Unbounded_Vectors is
      new Ada.Containers.Indefinite_Vectors (Positive, Integer);
   package Integer_Indef_Unbounded_Vector_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Vectors
        (Category       => "Integer Vector",
         Container_Name => "Ada Indef Unbounded",
         Vectors        => Integer_Indef_Unbounded_Vectors,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package String_Indef_Unbounded_Vectors is
      new Ada.Containers.Indefinite_Vectors (Positive, String);
   package String_Indef_Unbounded_Vector_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Vectors
        (Category       => "String Vector",
         Container_Name => "Ada Indef Unbounded",
         Vectors        => String_Indef_Unbounded_Vectors,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   ----------------------
   -- Ada Ordered_Maps --
   ----------------------

   package IntInt_Unbounded_Ordered_Maps is new Ada.Containers.Ordered_Maps
      (Integer, Integer);
   package IntInt_Unbounded_Ordered_Map_Tests is
      new Support_Ada.Test_Definite_Unbounded_Ordered_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Def Unbounded Ordered",
         Maps           => IntInt_Unbounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package IntInt_Bounded_Ordered_Maps is
      new Ada.Containers.Bounded_Ordered_Maps (Integer, Integer);
   package IntInt_Bounded_Ordered_Map_Tests is
      new Support_Ada.Test_Definite_Bounded_Ordered_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Def Bounded Ordered",
         Maps           => IntInt_Bounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package IntInt_Indef_Unbounded_Ordered_Maps is
      new Ada.Containers.Indefinite_Ordered_Maps (Integer, Integer);
   package IntInt_Indef_Unbounded_Ordered_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Ordered_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Indef Unbounded Ordered",
         Maps           => IntInt_Indef_Unbounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package StrInt_Indef_Unbounded_Ordered_Maps is
      new Ada.Containers.Indefinite_Ordered_Maps (String, Integer);
   package StrInt_Indef_Unbounded_Ordered_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Ordered_Maps
        (Category       => "String-Integer Map",
         Container_Name => "Ada Indef Unbounded Ordered",
         Maps           => StrInt_Indef_Unbounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package StrStr_Indef_Unbounded_Ordered_Maps is
      new Ada.Containers.Indefinite_Ordered_Maps (String, String);
   package StrStr_Indef_Unbounded_Ordered_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Ordered_Maps
        (Category       => "String-String Map",
         Container_Name => "Ada Indef Unbounded Ordered",
         Maps           => StrStr_Indef_Unbounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   ---------------------
   -- Ada Hashed_Maps --
   ---------------------

   package IntInt_Unbounded_Hashed_Maps is new Ada.Containers.Hashed_Maps
      (Integer, Integer, Test_Support.Hash, "=");
   package IntInt_Unbounded_Hashed_Map_Tests is
      new Support_Ada.Test_Definite_Unbounded_Hashed_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Def Unbounded Hashed",
         Maps           => IntInt_Unbounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package IntInt_Bounded_Hashed_Maps is
      new Ada.Containers.Bounded_Hashed_Maps
         (Integer, Integer, Test_Support.Hash, "=");
   package IntInt_Bounded_Hashed_Map_Tests is
      new Support_Ada.Test_Definite_Bounded_Hashed_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Def Bounded Hashed",
         Maps           => IntInt_Bounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package IntInt_Indef_Unbounded_Hashed_Maps is
      new Ada.Containers.Indefinite_Hashed_Maps
         (Integer, Integer, Test_Support.Hash, "=");
   package IntInt_Indef_Unbounded_Hashed_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Hashed_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Indef Unbounded Hashed",
         Maps           => IntInt_Indef_Unbounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package StrInt_Indef_Unbounded_Hashed_Maps is
      new Ada.Containers.Indefinite_Hashed_Maps
         (String, Integer, Ada.Strings.Hash, "=");
   package StrInt_Indef_Unbounded_Hashed_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Hashed_Maps
        (Category       => "String-Integer Map",
         Container_Name => "Ada Indef Unbounded Hashed",
         Maps           => StrInt_Indef_Unbounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package StrStr_Indef_Unbounded_Hashed_Maps is
      new Ada.Containers.Indefinite_Hashed_Maps
         (String, String, Ada.Strings.Hash, "=");
   package StrStr_Indef_Unbounded_Hashed_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Hashed_Maps
        (Category       => "String-String Map",
         Container_Name => "Ada Indef Unbounded Hashed",
         Maps           => StrStr_Indef_Unbounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

end Test_Containers;
