with Ada.Strings.Hash;
with Conts;
with GNATCOLL.Strings;

package Test_Support is

   Items_Count : constant := 200_000;  --  untyped, for standard containers
   Integer_Items_Count : constant Integer := Items_Count;
   pragma Export (C, Integer_Items_Count, "items_count");
   --  Number of items we copy into containers, for performance tests

   function Nth (Index : Natural) return Integer is (Index);
   function Nth (Index : Natural) return String is (Index'Image);

   function Image (Value : Integer) return String is (Integer'Image (Value));
   function Image (Value : String) return String is (Value);

   function Hash (Value : Integer) return Conts.Hash_Type
      is (Conts.Hash_Type (Value));
   function Hash (Value : String) return Conts.Hash_Type
      is (Ada.Strings.Hash (Value));

   function Check_Element (Value : Integer) return Boolean;
   function Check_Element (Value : String) return Boolean;
   --  Perform trivial check on Value

   -----------------
   -- Test_Filter --
   -----------------

   type Test_Filter is tagged private;

   procedure Setup (Self : in out Test_Filter; Arg : String);
   --  Initialize from command line

   function Active (Self : Test_Filter; Name : String) return Boolean;
   --  Whether the test Name should run

private
   type Test_Filter is tagged record
      Filter : GNATCOLL.Strings.XString;
   end record;
end Test_Support;
