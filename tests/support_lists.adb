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
with Asserts;
with GNAT.Source_Info;
with GNATCOLL.Strings;     use GNATCOLL.Strings;
with System.Assertions;    use System.Assertions;

package body Support_Lists is

   use Lists;
   use Asserts.Booleans;
   use Asserts.Counts;
   use Asserts.Integers;
   use Asserts.Strings;

   function "+" (S : String) return String is (Test_Name & ": " & S);
   --  Create error messages for failed tests

   package Element_Asserts is new Asserts.Asserts.Equals
      (Elements.Element_Type, Image, "=" => "=");
   use Element_Asserts;

   function Image (C : Lists.Cursor) return String
      is (if C = No_Element then "no element" else "a cursor");
   package Cursor_Asserts is new Asserts.Asserts.Equals
      (Lists.Cursor, Image);
   use Cursor_Asserts;

   -----------------
   -- Assert_List --
   -----------------

   procedure Assert_List
      (L        : Lists.List;
       Expected : String;
       Msg      : String;
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity)
   is
      S : XString;
   begin
      for E of L loop
         S.Append (Image (Elements.To_Element (E)));
         S.Append (',');
      end loop;

      Assert
         (S.To_String, Expected, Msg, Location => Location, Entity => Entity);
   end Assert_List;

   ----------
   -- Test --
   ----------

   procedure Test (L1, L2 : in out Lists.List) is
      Index : Natural;
   begin

      -----------------
      -- Empty lists --
      -----------------

      Assert (L1.Length,      0, +"length of an empty list");
      Assert (L1.Is_Empty, True, +"empty list is empty ?");
      L1.Clear;  --  should be safe

      for E of L1 loop
         Asserts.Should_Not_Get_Here (Msg => +"");
      end loop;
      for C in L1 loop
         Asserts.Should_Not_Get_Here (Msg => +"");
      end loop;

      -----------------
      -- Large lists --
      -----------------

      for E in 1 .. 4 loop
         L1.Append (Nth (E));
      end loop;

      Assert (L1.Length, 4, +"length of list of 10 elements");
      Assert (L1.Is_Empty, False, +"list of 10 elements is empty ?");
      Assert_List (L1, " 1, 2, 3, 4,", Msg => +"element loop");

      Index := 1;
      for C in L1 loop
         Assert_Less_Or_Equal (Index, 4, Msg => +"");
         Assert
            (Elements.To_Element (L1.Element (C)),
             Nth (Index),
             Msg => +"list, cursor loop");
         Index := Index + 1;
      end loop;

      ------------
      -- Assign --
      ------------

      L2.Clear;
      L2.Assign (Source => L1);
      Assert (L2.Length, L1.Length, +"lengths after assign");
      Assert_List (L2, " 1, 2, 3, 4,", Msg => +"assigned list, element loop");

      ------------
      -- Insert --
      ------------

      L2.Clear;
      L2.Insert (No_Element, Nth (1), Count => 3);
      Assert (L2.Length, 3, +"length after inserting 3 elements at tail");
      Assert_List (L2, " 1, 1, 1,", Msg => +"after insert in empty");

      L2.Insert (No_Element, Nth (2), Count => 2);
      Assert (L2.Length, 5, +"length after inserting 2 elements at tail");
      Assert_List (L2, " 1, 1, 1, 2, 2,", Msg => +"after insert");

      L2.Insert (L2.First, Nth (3));
      Assert (L2.Length, 6, +"length after inserting 1 elements at head");
      Assert_List (L2, " 3, 1, 1, 1, 2, 2,", +"after insert at head");

      L2.Insert (L2.Next (L2.First), Nth (4), Count => 2);
      Assert (L2.Length, 8, +"length after inserting 2 elements in middle");
      Assert_List (L2, " 3, 4, 4, 1, 1, 1, 2, 2,", +"after insert in middle");

      --  ??? What happens if we pass a cursor in the wrong list ?
      --  We currently get a contract case error, but we should be getting
      --  a better error message.
      --  L2.Insert (L1.First, 5);

      ---------------------
      -- Replace_Element --
      ---------------------

      L2.Replace_Element (L2.First, Nth (10));
      Assert_List (L2, " 10, 4, 4, 1, 1, 1, 2, 2,", +"after replace element");

      begin
         L2.Replace_Element (No_Element, Nth (11));
         Asserts.Should_Not_Get_Here
            (+"Expected precondition failure when replacing no_element");
      exception
         when Assert_Failure =>
            null;
      end;

      ------------
      -- Delete --
      ------------

      declare
         C : Cursor := L2.First;
         C2 : constant Cursor := L2.Next (C);
      begin
         L2.Delete (C, Count => 1);
         Assert (L2.Length, 7, +"length after delete head");
         Assert (C, C2, +"Cursor should have moved to second element");
         Assert_List (L2, " 4, 4, 1, 1, 1, 2, 2,", +"after delete head");
      end;

      declare
         C : Cursor := L2.First;
         C2 : constant Cursor := L2.Next (L2.Next (C));
      begin
         L2.Delete (C, Count => 2);
         Assert (L2.Length, 5, +"length after delete 2 at head");
         Assert (C, C2, +"Cursor should have moved to third element");
         Assert_List (L2, " 1, 1, 1, 2, 2,", +"after delete 2 at head");
      end;

      declare
         C : Cursor := L2.Last;
      begin
         L2.Delete (C, Count => 20);
         Assert (L2.Length, 4, +"length after delete tail");
         Assert (C, No_Element, +"Cursor should be no_element");
         Assert_List (L2, " 1, 1, 1, 2,", +"after delete at tail");
      end;
   end Test;

end Support_Lists;
