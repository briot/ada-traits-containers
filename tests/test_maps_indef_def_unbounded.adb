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

pragma Ada_2012;
with Ada.Strings.Hash;
with Asserts;
with Conts.Maps.Indef_Def_Unbounded;
with System.Assertions;    use System.Assertions;

package body Test_Maps_Indef_Def_Unbounded is
   use Asserts.Integers;

   package Maps is new Conts.Maps.Indef_Def_Unbounded
     (Key_Type            => String,
      Element_Type        => Integer,
      Container_Base_Type => Conts.Controlled_Base,
      Hash                => Ada.Strings.Hash);

   ----------
   -- Test --
   ----------

   procedure Test is
      M : Maps.Map;
      V : Integer;
   begin
      --  Check looking for an element in an empty table
      begin
         V := M.Get ("one");
         Asserts.Should_Not_Get_Here ("element from empty table");
      exception
         when Constraint_Error | Assert_Failure =>
            null;
      end;

      M.Set ("one", 1);
      M.Set ("two", 2);
      M.Set ("three", 3);
      M.Set ("four", 4);
      M.Set ("five", 5);
      M.Set ("six", 6);
      M.Set ("seven", 7);
      M.Set ("height", 8);
      M.Set ("nine", 9);
      M.Set ("ten", 10);

      Assert (M.Get ("one"), 1, "value for one");
      Assert (M ("four"), 4, "value for four");

      M.Delete ("one");
      M.Delete ("two");
      M.Delete ("three");
      M.Delete ("four");
      M.Delete ("five");
      M.Delete ("six");

      Assert (M.Get ("seven"), 7, "value for seven");

      begin
         V := M ("three");
         Asserts.Should_Not_Get_Here ("three should have been removed");
      exception
         when Constraint_Error | Assert_Failure =>
            null;   --  expected
      end;
   end Test;
end Test_Maps_Indef_Def_Unbounded;
