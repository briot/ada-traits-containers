------------------------------------------------------------------------------
--                     Copyright (C) 2016, AdaCore                          --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

with Conts;              use Conts;
with GNATCOLL.Asserts;
with GNAT.Source_Info;

package Asserts is

   type Testsuite_Reporter is
      new GNATCOLL.Asserts.Error_Reporter with null record;
   overriding procedure On_Assertion_Failed
      (Self     : Testsuite_Reporter;
       Msg      : String;
       Details  : String;
       Location : String;
       Entity   : String);

   Reporter : Testsuite_Reporter;

   Test_Failed : exception;

   function Image (S : String) return String is (S);

   package Asserts is new GNATCOLL.Asserts.Asserts (Reporter, Enabled => True);
   package Integers    is new Asserts.Compare (Integer,    Integer'Image);
   package Booleans    is new Asserts.Compare (Boolean,    Boolean'Image);
   package Floats      is new Asserts.Compare (Float,      Float'Image);
   package Long_Floats is new Asserts.Compare (Long_Float, Long_Float'Image);
   package Counts      is new Asserts.Compare (Count_Type, Count_Type'Image);
   package Strings     is new Asserts.Compare (String,     Image);

   procedure Should_Not_Get_Here
      (Msg      : String := "should not get here";
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity)
      renames Asserts.Assert_Failed;
   --  If some piece of code should never be executed, put this there to get an
   --  assert failures if it ends up being executed.

end Asserts;
