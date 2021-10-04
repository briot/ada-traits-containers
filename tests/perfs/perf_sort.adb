
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
with Ada.Containers.Vectors;
with Ada.Finalization;
with Conts.Algorithms;  use Conts.Algorithms;
with Conts.Vectors.Definite_Unbounded;

package body Perf_Sort is

   use Conts;

   subtype Index_Type is Positive;

   package Int_Ada_Vecs is new Ada.Containers.Vectors
      (Index_Type, Integer);
   package Ada_Sort is new Int_Ada_Vecs.Generic_Sorting ("<");

   package Int_Vecs is new Conts.Vectors.Definite_Unbounded
      (Index_Type, Integer, Ada.Finalization.Controlled);
   use Int_Vecs;

   package Rand is new Conts.Default_Random (Extended_Index);

   procedure Insert_Sort is new Conts.Algorithms.Insertion_Sort
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Swap    => Int_Vecs.Swap);
   procedure Shell_Sort is new Conts.Algorithms.Shell_Sort
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Swap    => Int_Vecs.Swap);
   procedure Shell2_Sort is new Conts.Algorithms.Shell_Sort
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Swap    => Int_Vecs.Swap,
       Gaps    => Sedgewick_Gaps);
   procedure Quicksort is new Conts.Algorithms.Quicksort
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Swap    => Int_Vecs.Swap);
   procedure Quicksort_Pure is new Conts.Algorithms.Quicksort
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Threshold => 0,
       Swap    => Int_Vecs.Swap);

   ----------
   -- Test --
   ----------

   procedure Test (Stdout : not null access Report.Output'Class) is
      generic
         with procedure Sort
            (Self : in out Int_Vecs.Cursors.Random_Access.Container);
         Algo : String;
      procedure Do_Sort (Omit_Large : Boolean; Favorite : Boolean := False);
      --  Apply multiple sort algorithms

      Pre_Sorted_Small     : Vector;
      Ada_Pre_Sorted_Small : Int_Ada_Vecs.Vector;
      Reversed_Small       : Vector;
      Ada_Reversed_Small   : Int_Ada_Vecs.Vector;
      Cst_Small            : Vector;
      Ada_Cst_Small        : Int_Ada_Vecs.Vector;
      Random_Small         : Vector;
      Ada_Random_Small     : Int_Ada_Vecs.Vector;

      Pre_Sorted_Large     : Vector;
      Ada_Pre_Sorted_Large : Int_Ada_Vecs.Vector;
      Reversed_Large       : Vector;
      Ada_Reversed_Large   : Int_Ada_Vecs.Vector;
      Cst_Large            : Vector;
      Ada_Cst_Large        : Int_Ada_Vecs.Vector;
      Random_Large         : Vector;
      Ada_Random_Large     : Int_Ada_Vecs.Vector;

      procedure Do_Sort (Omit_Large : Boolean; Favorite : Boolean := False) is
      begin
         Stdout.Start_Container_Test
            (Algo, Category => "Sorting", Favorite => Favorite);

         Stdout.Start_Test ("random-vec-10000");
         declare
            V : Vector := Random_Small;
         begin
            Sort (V);
         end;
         Stdout.End_Test;

         Stdout.Start_Test ("sorted-vec-10000");
         declare
            V : Vector := Pre_Sorted_Small;
         begin
            Sort (V);
         end;
         Stdout.End_Test;

         Stdout.Start_Test ("reversed-vec-10000");
         declare
            V : Vector := Reversed_Small;
         begin
            Sort (V);
         end;
         Stdout.End_Test;

         Stdout.Start_Test ("constant-vec-10000");
         declare
            V : Vector := Cst_Small;
         begin
            Sort (V);
         end;
         Stdout.End_Test;

         if not Omit_Large then
            Stdout.Start_Test ("random-vec-1million");
            declare
               V : Vector := Random_Large;
            begin
               Sort (V);
            end;
            Stdout.End_Test;

            Stdout.Start_Test ("sorted-vec-1million");
            declare
               V : Vector := Pre_Sorted_Large;
            begin
               Sort (V);
            end;
            Stdout.End_Test;

            Stdout.Start_Test ("reversed-vec-1million");
            declare
               V : Vector := Reversed_Large;
            begin
               Sort (V);
            end;
            Stdout.End_Test;

            Stdout.Start_Test ("constant-vec-1million");
            declare
               V : Vector := Cst_Large;
            begin
               Sort (V);
            end;
            Stdout.End_Test;
         end if;

         Stdout.End_Container_Test;
      end Do_Sort;

      procedure Do_Insert is new Do_Sort (Insert_Sort, "insertion-sort");
      procedure Do_Shell is new Do_Sort (Shell_Sort,  "shell-sort");
      procedure Do_Shell2 is new Do_Sort (Shell2_Sort, "shell2-sort");
      procedure Do_Quick is new Do_Sort (Quicksort,   "quicksort");
      procedure Do_Quick_P is new Do_Sort (Quicksort_Pure, "quicksort_pure");

      Val   : Extended_Index;
      G     : Rand.Generator;
   begin
      Rand.Reset (G);

      for J in 1 .. 10_000 loop
         Rand.Random (G, Val);

         Pre_Sorted_Small.Append (J);
         Reversed_Small.Append (10_000 - J);
         Cst_Small.Append (10);
         Random_Small.Append (Val);
         Ada_Pre_Sorted_Small.Append (J);
         Ada_Reversed_Small.Append (10_000 - J);
         Ada_Cst_Small.Append (10);
         Ada_Random_Small.Append (Val);
      end loop;

      for J in 1 .. 1_000_000 loop
         Rand.Random (G, Val);

         Pre_Sorted_Large.Append (J);
         Reversed_Large.Append (1_000_000 - J);
         Cst_Large.Append (10);
         Random_Large.Append (Val);
         Ada_Pre_Sorted_Large.Append (J);
         Ada_Reversed_Large.Append (1_000_000 - J);
         Ada_Cst_Large.Append (10);
         Ada_Random_Large.Append (Val);
      end loop;

      --  Standard Ada tests

      Stdout.Start_Container_Test
         ("Standard Ada", Category => "Sorting", Favorite => True);

      Stdout.Start_Test ("random-vec-10000", Start_Group => True);
      Ada_Sort.Sort (Ada_Random_Small);
      Stdout.End_Test;

      Stdout.Start_Test ("sorted-vec-10000");
      Ada_Sort.Sort (Ada_Pre_Sorted_Small);
      Stdout.End_Test;

      Stdout.Start_Test ("reversed-vec-10000");
      Ada_Sort.Sort (Ada_Reversed_Small);
      Stdout.End_Test;

      Stdout.Start_Test ("constant-vec-10000");
      Ada_Sort.Sort (Ada_Cst_Small);
      Stdout.End_Test;

      Stdout.Start_Test ("random-vec-1million", Start_Group => True);
      Ada_Sort.Sort (Ada_Random_Large);
      Stdout.End_Test;

      Stdout.Start_Test ("sorted-vec-1million");
      Ada_Sort.Sort (Ada_Pre_Sorted_Large);
      Stdout.End_Test;

      Stdout.Start_Test ("reversed-vec-1million");
      Ada_Sort.Sort (Ada_Reversed_Large);
      Stdout.End_Test;

      Stdout.Start_Test ("constant-vec-1million");
      Ada_Sort.Sort (Ada_Cst_Large);
      Stdout.End_Test;

      Stdout.End_Container_Test;

      --  Traits containers

      Do_Quick (Omit_Large => False, Favorite => True);
      Do_Quick_P (Omit_Large => False);
      Do_Insert (Omit_Large => True);
      Do_Shell (Omit_Large => True);
      Do_Shell2 (Omit_Large => True);
   end Test;

end Perf_Sort;
