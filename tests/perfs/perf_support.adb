------------------------------------------------------------------------------
--                     Copyright (C) 2015-2016, AdaCore                     --
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
with GAL.Algo.Count_If;
with GAL.Adaptors;     use GAL.Adaptors;
with Report;
with System.Storage_Elements;
with Test_Support;       use Test_Support;

package body Perf_Support is
   use type System.Storage_Elements.Storage_Offset;

   ---------------------
   -- Test_Arrays_Int --
   ---------------------

   procedure Test_Arrays_Int (Stdout : in out Output'Class) is
      Category  : constant String := "Integer Vector";
      Container : constant String := "Ada Array";

      type Int_Array is array (Natural range <>) of Integer;
      package Adaptors is new Array_Adaptors
         (Index_Type   => Natural,
          Element_Type => Integer,
          Array_Type   => Int_Array);
      function Count_If is new GAL.Algo.Count_If
         (Adaptors.Cursors.Forward, Adaptors.Maps.Element);

      V : Int_Array (1 .. Items_Count);
      Count : Natural;

      procedure Do_Fill;
      procedure Do_Fill is
      begin
         for C in 1 .. Items_Count loop
            V (C) := 2;
         end loop;
      end Do_Fill;

      procedure Do_Copy;
      procedure Do_Copy is
         V_Copy : Int_Array := V with Unreferenced;
      begin
         null;
      end Do_Copy;

      procedure Do_Cursor;
      procedure Do_Cursor is
      begin
         Count := 0;
         for It in V'Range loop
            if Test_Support.Check_Element (V (It)) then
               Count := Count + 1;
            end if;
         end loop;
      end Do_Cursor;

      procedure Do_For_Of;
      procedure Do_For_Of is
      begin
         Count := 0;
         for C of V loop
            if Test_Support.Check_Element (C) then
               Count := Count + 1;
            end if;
         end loop;
      end Do_For_Of;

      procedure Do_Count_If;
      procedure Do_Count_If is
      begin
         Count := Count_If (V, Test_Support.Check_Element'Access);
      end Do_Count_If;

      procedure Time_Fill is new Report.Timeit (Do_Fill);
      procedure Time_Copy is new Report.Timeit (Do_Copy);
      procedure Time_Cursor is new Report.Timeit (Do_Cursor);
      procedure Time_For_Of is new Report.Timeit (Do_For_Of);
      procedure Time_Count_If is new Report.Timeit (Do_Count_If);
   begin
      Stdout.Set_Column
         (Category  => Category,
          Column    => Container,
          Size      => V'Size / 8);

      Time_Fill
         (Stdout,
          Category  => Category,
          Column    => Container,
          Row       => "fill");
      Time_Copy
         (Stdout,
          Category  => Category,
          Column    => Container,
          Row       => "copy");

      Time_Cursor
         (Stdout,
          Category  => Category,
          Column    => Container,
          Row       => "cursor loop");
      Asserts.Integers.Assert (Count, Items_Count);

      Time_For_Of
         (Stdout,
          Category  => Category,
          Column    => Container,
          Row       => "for-of loop");
      Asserts.Integers.Assert (Count, Items_Count);

      Time_Count_If
         (Stdout,
          Category  => Category,
          Column    => Container,
          Row       => "count_if");
      Asserts.Integers.Assert (Count, Items_Count);
   end Test_Arrays_Int;

end Perf_Support;
