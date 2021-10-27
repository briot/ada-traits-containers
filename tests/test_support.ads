with Ada.Strings.Hash;
with GAL;
with GNATCOLL.Strings;

package Test_Support is

   Items_Count : constant := 200_000;  --  untyped, for standard containers
   Integer_Items_Count : constant Integer := Items_Count;
   pragma Export (C, Integer_Items_Count, "items_count");
   --  Number of items we copy into containers, for performance tests

   function Nth (Index : Natural) return Integer is (Index);
   function Nth (Index : Natural) return String is (Index'Image);
   function Nth (Index : Natural) return GNATCOLL.Strings.XString
      is (GNATCOLL.Strings.To_XString (Index'Image));

   function Perf_Nth (Index : Natural) return Integer is (Index);
   function Perf_Nth (Index : Natural) return String
      is (if Index mod 2 = 0
          then "foo"
          else "foofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoo");
   function Perf_Nth (Index : Natural) return GNATCOLL.Strings.XString
      is (GNATCOLL.Strings.To_XString
            ((if Index mod 2 = 0
              then "foo"
              else "foofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoo")));

   function Image (Value : Integer) return String is (Integer'Image (Value));
   function Image (Value : String) return String is (Value);
   function Image (Value : GNATCOLL.Strings.XString) return String
      is (Value.To_String);

   function Hash (Value : Integer) return GAL.Hash_Type
      is (GAL.Hash_Type (Value));
   function Hash (Value : String) return GAL.Hash_Type
      is (Ada.Strings.Hash (Value));
   function Hash (Value : GNATCOLL.Strings.XString) return GAL.Hash_Type
      is (GNATCOLL.Strings.Hash (Value));

   function Check_Element (Value : Integer) return Boolean;
   function Check_Element (Value : String) return Boolean;
   function Check_Element (Value : GNATCOLL.Strings.XString) return Boolean;
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
