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
with Asserts;           use Asserts;
with GNATCOLL.Strings;
with System.Assertions; use System.Assertions;

package body Support_Vectors is

   use Asserts.Booleans;
   use Asserts.Counts;
   use Asserts.Strings;
   use Vectors;

   function "+" (S : String) return String is (Test_Name & ": " & S);
   --  Create error messages for failed tests

   package Element_Asserts is new Asserts.Asserts.Equals
      (Elements.Element_Type, Image, "=" => "=");
   use Element_Asserts;

   package Index_Asserts is new Asserts.Asserts.Equals
      (Vectors.Extended_Index, Vectors.Extended_Index'Image, "=" => "=");

   subtype Index_Type is Positive;

   -------------------
   -- Assert_Vector --
   -------------------

   procedure Assert_Vector
      (V        : Vectors.Vector;
       Expected : String;
       Msg      : String;
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity)
   is
      S : GNATCOLL.Strings.XString;
   begin
      for E of V loop
         S.Append (Image (Elements.To_Element (E)));
         S.Append (',');
      end loop;
      Assert (S.To_String, Expected, Msg, Location, Entity);
   end Assert_Vector;

   ----------
   -- Test --
   ----------

   procedure Test (V1 : in out Vectors.Vector) is
   begin
      --------------------
      --  Empty vectors --
      --------------------

      Assert (V1.Length, 0, "length of empty vector");
      Assert (V1.Is_Empty, True, "empty vector is empty ?");
      Index_Asserts.Assert
         (Vectors.Extended_Index (V1.Last), Index_Type'First - 1,
          "last of empty vector");

      V1.Clear;   --  Should be safe

      begin
         declare
            E : constant Elements.Element_Type :=
               Elements.To_Element (V1.Last_Element)
               with Unreferenced;
         begin
            Asserts.Should_Not_Get_Here ("last_element of empty vector");
         end;
      exception
         when Assert_Failure | Vectors.Invalid_Index =>
            null;  --  expected
      end;

      Assert_Vector (V1, "", Msg => +"element loop");

      for C in V1 loop
         Asserts.Should_Not_Get_Here (+"empty vector");
      end loop;

      ------------------------------
      -- Vectors with one element --
      ------------------------------

      V1.Append (Nth (1));
      Assert (V1.Length, 1, +"Length of vector with one element");
      Assert (V1.Is_Empty, False, +"vector of one element is empty ?");
      Index_Asserts.Assert
         (V1.Last, Index_Type'First, +"last of one-element-vector");
      Assert (Elements.To_Element (V1.Last_Element), Nth (1),
              +"last element of one-element-vector");
      Assert_Vector (V1, " 1,", +"one-element vector");

      for C in V1 loop
         Assert (Elements.To_Element (V1.Element (C)), Nth (1), +"");
      end loop;

      Assert (V1.Has_Element (1), True,     +"has element on valid index");
      Assert (V1.Has_Element (1000), False, +"has element on invalid index");
      Assert (V1.Has_Element (0), False,    +"has element on invalid index");

      -----------------------------------------
      -- Removing one element, back to empty --
      -----------------------------------------

      V1.Delete_Last;
      Assert (V1.Length, 0, +"Length after removing single element");
      Assert (V1.Is_Empty, True, +"After removing single element, is empty ?");

      ------------------
      -- Large vector --
      ------------------

      for E2 in 1 .. 10 loop
         V1.Append (Nth (E2));
      end loop;

      Assert (V1.Length, 10, +"");
      Assert (V1.Is_Empty, False, +"");
      Index_Asserts.Assert
         (V1.Last, Index_Type'First + 9, +"last of large vector");
      Assert (Elements.To_Elem (V1.Last_Element), Nth (10),
              +"last element of large vector");
      Assert_Vector (V1, " 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,", +"after append");

      -----------------------------
      -- Deleting a few elements --
      -----------------------------

      V1.Delete (1);   --  removes "1", first element
      V1.Delete (3);   --  removes "4"
      V1.Delete (4);   --  removes "6"
      V1.Delete (7);   --  removes "10", last element
      Assert (V1.Length, 6, +"length after delete");
      Assert (V1.Is_Empty, False, +"is_empty after delete");
      Assert (Elements.To_Elem (V1.Last_Element), Nth (9),
              +"last element after delete");
      Assert_Vector (V1, " 2, 3, 5, 7, 8, 9,", "after delete");

      begin
         V1.Delete (10);  --  invalid
         Asserts.Should_Not_Get_Here
            (+"should not delete element at invalid index");
      exception
         when Assert_Failure | Invalid_Index =>
            null;   --  expected
      end;

      V1.Delete (5, Count => 10);
      Assert (V1.Length, 4, +"after delete 10 elements at end");
      Assert_Vector (V1, " 2, 3, 5, 7,", +"delete 10 elements at end");

      V1.Append (Nth (8));
      V1.Append (Nth (9));

      -----------------------
      -- Swapping elements --
      -----------------------

      V1.Swap (1, 6);
      Assert (V1.Length, 6, +"length after swap");
      Assert (V1.Is_Empty, False, +"is_empty after swap");
      Assert (Elements.To_Element (V1.Last_Element), Nth (2),
              +"last_element after swap");
      Assert_Vector (V1, " 9, 3, 5, 7, 8, 2,", +"after swap");

      V1.Swap (1, 1);    --  swapping same element
      Assert (V1.Length, 6, +"length after swap same element");
      Assert (V1.Is_Empty, False, +"is_empty after swap same element");
      Assert (Elements.To_Element (V1.Last_Element), Nth (2),
              +"last_element after swap same element");
      Assert_Vector (V1, " 9, 3, 5, 7, 8, 2,", +"after swap same element");

      begin
         V1.Swap (10000, 1);     --  invalid first index
         Asserts.Should_Not_Get_Here (+"Swap with invalid first index");
      exception
         when Assert_Failure | Vectors.Invalid_Index =>
            null;   --  expected
      end;

      begin
         V1.Swap (1, 10000);     --  invalid second index
         Asserts.Should_Not_Get_Here (+"Swap with invalid second index");
      exception
         when Assert_Failure | Vectors.Invalid_Index =>
            null;   --  expected
      end;

      ------------------------
      -- Replacing elements --
      ------------------------

      V1.Replace_Element (1, Nth (100));
      V1.Replace_Element (6, Nth (600));
      Assert (V1.Length, 6, +"length after replace");
      Assert (V1.Is_Empty, False, +"is_empty after replace");
      Assert (Elements.To_Element (V1.Last_Element), Nth (600),
              +"last_element after replace");
      Assert_Vector (V1, " 100, 3, 5, 7, 8, 600,", +"after replace");

      begin
         V1.Replace_Element (10000, Nth (20));
         Asserts.Should_Not_Get_Here (+"Replace at invalid index");
      exception
         when Assert_Failure | Vectors.Invalid_Index =>
            null;   --  expected
      end;

      ------------------------------------------
      -- Clearing large vector, back to empty --
      ------------------------------------------

      V1.Clear;
      Assert (V1.Length, 0, +"length after clear");
      Assert (V1.Is_Empty, True, +"is_empty, after clear");

      -----------------------
      -- Resizing a vector --
      -----------------------

      --  resize from empty
      V1.Resize (Length => 4, Element => Nth (1));
      Assert (V1.Length, 4, +"length after resize");
      Assert (V1.Is_Empty, False, +"is_empty after resize");
      Assert (Elements.To_Elem (V1.Last_Element), Nth (1),
              +"last_element after resize");
      Assert_Vector (V1, " 1, 1, 1, 1,", +"after resize from empty");

      --  resize to bigger size
      V1.Resize (Length => 6, Element => Nth (2));
      Assert (V1.Length, 6, +"length after resize2");
      Assert (Elements.To_Element (V1.Last_Element), Nth (2),
              +"last_element after resize2");
      Assert_Vector (V1, " 1, 1, 1, 1, 2, 2,", +"after resize (2)");

      --  resize to smaller size
      V1.Resize (Length => 3, Element => Nth (3));
      Assert (V1.Length, 3, +"length after resize3");
      Assert (Elements.To_Element (V1.Last_Element), Nth (1),
              +"last_element after resize3");
      Assert_Vector (V1, " 1, 1, 1,", +"after resize (3)");

      --  resize to 0
      V1.Resize (Length => 0, Element => Nth (3));
      Assert (V1.Length, 0, +"length after resize4");
      Assert_Vector (V1, "", +"after resize (4)");

      ---------------
      -- Shrinking --
      ---------------

      V1.Clear;
      for E in 1 .. 20 loop
         V1.Append (Nth (E));
      end loop;

      V1.Shrink_To_Fit;
      Assert (V1.Length, 20, +"length after shrink");
      Assert (Elements.To_Element (V1.Last_Element), Nth (20),
              +"last_element after shrink");

      ------------
      -- Insert --
      ------------

      V1.Clear;

      V1.Insert (Before => No_Element, Element => Nth (1), Count => 3);
      Assert (V1.Length, 3, +"length after insert in empty");
      Assert_Vector (V1, " 1, 1, 1,", +"after insert in empty");

      V1.Insert (Before => No_Element, Element => Nth (4), Count => 2);
      Assert (V1.Length, 5, +"length after insert at end");
      Assert_Vector (V1, " 1, 1, 1, 4, 4,", +"after insert at end");

      V1.Insert (Before => 1, Element => Nth (2), Count => 2);
      Assert (V1.Length, 7, +"length after insert at head");
      Assert_Vector (V1, " 2, 2, 1, 1, 1, 4, 4,", +"after insert at head");

      begin
         V1.Insert (Before => 60, Element => Nth (3));
         Asserts.Should_Not_Get_Here (+"Can't insert at invalid location");
      exception
         when Assert_Failure | Vectors.Invalid_Index =>
            null;
      end;
   end Test;

end Support_Vectors;