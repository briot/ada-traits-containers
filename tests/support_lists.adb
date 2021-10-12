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
with Ada.Text_IO;
with Asserts;
with Conts.Algorithms;
with GNAT.Source_Info;
with GNATCOLL.Strings;     use GNATCOLL.Strings;
with Report;
with System.Assertions;    use System.Assertions;
with System.Storage_Elements;
with Test_Support;         use Test_Support;

package body Support_Lists is

   use type System.Storage_Elements.Storage_Count;
   use Lists;
   use Asserts.Booleans;
   use Asserts.Counts;
   use Asserts.Integers;
   use Asserts.Strings;

   function "+" (S : String) return String
      is (Category & '-' & Container_Name & ": " & S);
   --  Create error messages for failed tests

   package Element_Asserts is new Asserts.Asserts.Equals
      (Elements.Element_Type, Image, "=" => "=");
   use Element_Asserts;

   function Image (C : Lists.Cursor) return String
      is (if C = No_Element then "no element" else "a cursor");
   package Cursor_Asserts is new Asserts.Asserts.Equals
      (Lists.Cursor, Image);
   use Cursor_Asserts;

   function Check_Element_Internal
      (E : Lists.Storage.Elements.Constant_Returned_Type)
      return Boolean;
   --  Return Check_Element

   function Count_If is new Conts.Algorithms.Count_If
      (Cursors   => Lists.Cursors.Forward,
       Getters   => Lists.Maps.Constant_Returned);

   ----------------------------
   -- Check_Element_Internal --
   ----------------------------

   function Check_Element_Internal
      (E : Lists.Storage.Elements.Constant_Returned_Type)
      return Boolean is
   begin
      return Check_Element (Lists.Storage.Elements.To_Element (E));
   end Check_Element_Internal;

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

   ----------------------
   -- Test_Correctness --
   ----------------------

   procedure Test_Correctness (L1, L2 : in out Lists.List) is
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
   end Test_Correctness;

   ---------------
   -- Test_Perf --
   ---------------

   procedure Test_Perf
      (Results : in out Report.Output'Class;
       L1, L2  : in out Lists.List)
   is
      Count : Natural;

      procedure Do_Clear;
      procedure Do_Clear2;

      procedure Do_Clear is
      begin
         L1.Clear;
      end Do_Clear;

      procedure Do_Clear2 is
      begin
         Count := 0;
         L2.Clear;
      end Do_Clear2;

      procedure Do_Fill;
      procedure Do_Fill is
      begin
         for C in 1 .. Items_Count loop
            L1.Append (Nth (C));
         end loop;
      end Do_Fill;

      procedure Do_Copy;
      procedure Do_Copy is
      begin
         L2.Assign (L1);
      end Do_Copy;

      procedure Do_Cursor;
      procedure Do_Cursor is
         C     : Lists.Cursor := L1.First;
      begin
         Count := 0;
         while L1.Has_Element (C) loop
            if Check_Element_Internal (L1.Element (C)) then
               Count := Count + 1;
            end if;
            L1.Next (C);
         end loop;
      end Do_Cursor;

      procedure Do_For_Of;
      procedure Do_For_Of is
      begin
         Count := 0;
         for E of L1 loop
            if Check_Element_Internal (E) then
               Count := Count + 1;
            end if;
         end loop;
      end Do_For_Of;

      procedure Do_Count_If;
      procedure Do_Count_If is
      begin
         Count := Count_If (L1, Check_Element_Internal'Access);
      end Do_Count_If;

      procedure Time_Fill is new Report.Timeit (Do_Fill, Cleanup => Do_Clear);
      procedure Time_Copy is new Report.Timeit (Do_Copy, Cleanup => Do_Clear2);
      procedure Time_Cursor is new Report.Timeit (Do_Cursor);
      procedure Time_For_Of is new Report.Timeit (Do_For_Of);
      procedure Time_Count_If is new Report.Timeit (Do_Count_If);

   begin
      Report.Set_Column
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Size        => L1'Size / 8,
          Favorite    => False);

      Time_Fill
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Row         => "fill",
          Start_Group => True);

      Do_Clear;
      Do_Fill;
      Time_Copy
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Row         => "copy");

      Do_Clear;
      Do_Fill;
      Time_Cursor
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Row         => "cursor loop");
      Asserts.Integers.Assert (Count, Items_Count, +"");

      Do_Clear;
      Do_Fill;
      Time_For_Of
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Row         => "for-of loop");
      Asserts.Integers.Assert (Count, Items_Count, +"");

      Do_Clear;
      Do_Fill;
      Time_Count_If
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Row         => "count_if");
      Asserts.Integers.Assert (Count, Items_Count, +"");
   end Test_Perf;
end Support_Lists;
