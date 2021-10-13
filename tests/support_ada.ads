--  Tests for Ada containers

with Ada.Containers.Bounded_Doubly_Linked_Lists;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Containers.Indefinite_Doubly_Linked_Lists;

with Ada.Containers.Bounded_Vectors;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Vectors;

with Ada.Containers.Ordered_Maps;
with Ada.Containers.Hashed_Maps;
with Ada.Containers.Bounded_Hashed_Maps;
with Ada.Containers.Bounded_Ordered_Maps;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Ordered_Maps;

with Report;

package Support_Ada is

   function Hash (Val : Integer) return Ada.Containers.Hash_Type
      is (Ada.Containers.Hash_Type (Val));

   -----------
   -- Lists --
   -----------

   generic
      Category       : String;
      Container_Name : String;
      with package Lists is new Ada.Containers.Doubly_Linked_Lists (<>);
      with function Nth (Index : Natural) return Lists.Element_Type;
      with function Check_Element (E : Lists.Element_Type) return Boolean;
   package Test_Definite_Unbounded_Lists is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Definite_Unbounded_Lists;

   generic
      Category       : String;
      Container_Name : String;
      with package Lists is
         new Ada.Containers.Bounded_Doubly_Linked_Lists (<>);
      with function Nth (Index : Natural) return Lists.Element_Type;
      with function Check_Element (E : Lists.Element_Type) return Boolean;
   package Test_Definite_Bounded_Lists is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Definite_Bounded_Lists;

   generic
      Category       : String;
      Container_Name : String;
      with package Lists is
         new Ada.Containers.Indefinite_Doubly_Linked_Lists (<>);
      with function Nth (Index : Natural) return Lists.Element_Type;
      with function Check_Element (E : Lists.Element_Type) return Boolean;
   package Test_Indefinite_Unbounded_Lists is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Indefinite_Unbounded_Lists;

   -------------
   -- Vectors --
   -------------

   generic
      Category       : String;
      Container_Name : String;
      with package Vectors is new Ada.Containers.Vectors (<>);
      with function Nth (Index : Natural) return Vectors.Element_Type;
      with function Check_Element (E : Vectors.Element_Type) return Boolean;
   package Test_Definite_Unbounded_Vectors is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Definite_Unbounded_Vectors;

   generic
      Category       : String;
      Container_Name : String;
      with package Vectors is new Ada.Containers.Bounded_Vectors (<>);
      with function Nth (Index : Natural) return Vectors.Element_Type;
      with function Check_Element (E : Vectors.Element_Type) return Boolean;
   package Test_Definite_Bounded_Vectors is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Definite_Bounded_Vectors;

   generic
      Category       : String;
      Container_Name : String;
      with package Vectors is new Ada.Containers.Indefinite_Vectors (<>);
      with function Nth (Index : Natural) return Vectors.Element_Type;
      with function Check_Element (E : Vectors.Element_Type) return Boolean;
   package Test_Indefinite_Unbounded_Vectors is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Indefinite_Unbounded_Vectors;

   ------------------
   -- Hashed Maps --
   ------------------

   generic
      Category       : String;
      Container_Name : String;
      with package Maps is new Ada.Containers.Hashed_Maps (<>);
      with function Nth_Key (Index : Natural) return Maps.Key_Type;
      with function Nth_Element (Index : Natural) return Maps.Element_Type;
      with function Check_Element (E : Maps.Element_Type) return Boolean;
   package Test_Definite_Unbounded_Hashed_Maps is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Definite_Unbounded_Hashed_Maps;

   generic
      Category       : String;
      Container_Name : String;
      with package Maps is new Ada.Containers.Bounded_Hashed_Maps (<>);
      with function Nth_Key (Index : Natural) return Maps.Key_Type;
      with function Nth_Element (Index : Natural) return Maps.Element_Type;
      with function Check_Element (E : Maps.Element_Type) return Boolean;
   package Test_Definite_Bounded_Hashed_Maps is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Definite_Bounded_Hashed_Maps;

   generic
      Category       : String;
      Container_Name : String;
      with package Maps is new Ada.Containers.Indefinite_Hashed_Maps (<>);
      with function Nth_Key (Index : Natural) return Maps.Key_Type;
      with function Nth_Element (Index : Natural) return Maps.Element_Type;
      with function Check_Element (E : Maps.Element_Type) return Boolean;
   package Test_Indefinite_Unbounded_Hashed_Maps is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Indefinite_Unbounded_Hashed_Maps;

   ------------------
   -- Ordered Maps --
   ------------------

   generic
      Category       : String;
      Container_Name : String;
      with package Maps is new Ada.Containers.Ordered_Maps (<>);
      with function Nth_Key (Index : Natural) return Maps.Key_Type;
      with function Nth_Element (Index : Natural) return Maps.Element_Type;
      with function Check_Element (E : Maps.Element_Type) return Boolean;
   package Test_Definite_Unbounded_Ordered_Maps is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Definite_Unbounded_Ordered_Maps;

   generic
      Category       : String;
      Container_Name : String;
      with package Maps is new Ada.Containers.Bounded_Ordered_Maps (<>);
      with function Nth_Key (Index : Natural) return Maps.Key_Type;
      with function Nth_Element (Index : Natural) return Maps.Element_Type;
      with function Check_Element (E : Maps.Element_Type) return Boolean;
   package Test_Definite_Bounded_Ordered_Maps is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Definite_Bounded_Ordered_Maps;

   generic
      Category       : String;
      Container_Name : String;
      with package Maps is new Ada.Containers.Indefinite_Ordered_Maps (<>);
      with function Nth_Key (Index : Natural) return Maps.Key_Type;
      with function Nth_Element (Index : Natural) return Maps.Element_Type;
      with function Check_Element (E : Maps.Element_Type) return Boolean;
   package Test_Indefinite_Unbounded_Ordered_Maps is
      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean);
   end Test_Indefinite_Unbounded_Ordered_Maps;

end Support_Ada;
