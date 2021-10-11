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
with Conts.Algorithms;  use Conts.Algorithms;
with Conts.Vectors.Definite_Unbounded;

package body Test_Algo_Sort is

   use Asserts.Booleans;
   use Conts;

   subtype Index_Type is Positive;

   package Int_Vecs is new Conts.Vectors.Definite_Unbounded
      (Index_Type, Integer, Conts.Controlled_Base);
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
   function Is_Sorted is new Conts.Algorithms.Is_Sorted
      (Cursors => Int_Vecs.Cursors.Forward,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<");

   generic
      with procedure Sort
         (Self : in out Int_Vecs.Cursors.Random_Access.Container);
      Algo : String;
   procedure Do_Sort (V : Vector; Msg  : String);
   --  Apply one sort algorithm to a copy of V

   procedure Test_Sort (V : Vector; Msg : String);
   --  Apply multiple sort algorithms

   -------------
   -- Do_Sort --
   -------------

   procedure Do_Sort
      (V    : Vector;
       Msg  : String)
   is
      V2  : Vector := V;
   begin
      Sort (V2);
      Assert (Is_Sorted (V2), True, Algo & " failed for " & Msg);
   end Do_Sort;

   procedure Do_Sort_Insert     is new Do_Sort (Insert_Sort, "insertion-sort");
   procedure Do_Sort_Shell      is new Do_Sort (Shell_Sort,  "shell-sort    ");
   procedure Do_Sort_Shell2     is new Do_Sort (Shell2_Sort, "shell2-sort   ");
   procedure Do_Sort_Quick      is new Do_Sort (Quicksort,   "quicksort     ");
   procedure Do_Sort_Quick_Pure is
      new Do_Sort (Quicksort_Pure, "quicksort_pure");

   ---------------
   -- Test_Sort --
   ---------------

   procedure Test_Sort (V : Vector; Msg : String) is
   begin
      Do_Sort_Insert     (V, Msg);
      Do_Sort_Shell      (V, Msg);
      Do_Sort_Shell2     (V, Msg);
      Do_Sort_Quick      (V, Msg);
      Do_Sort_Quick_Pure (V, Msg);
   end Test_Sort;

   ----------
   -- Test --
   ----------

   procedure Test is
      Max   : constant := 1_000;
      V     : Vector;
      Val   : Extended_Index;
      G     : Rand.Generator;
   begin
      Rand.Reset (G);

      for J in 1 .. Max loop
         V.Append (J);
      end loop;
      Test_Sort (V,  "sorted array  ");

      V.Clear;
      for J in reverse 1 .. Max loop
         V.Append (J);
      end loop;
      Test_Sort (V, "reversed array");

      V.Clear;
      for J in reverse 1 .. Max loop
         V.Append (10);
      end loop;
      Test_Sort (V, "constant array");

      V.Clear;
      for J in 1 .. Max loop
         Rand.Random (G, Val);
         V.Append (Val);
      end loop;
      Test_Sort (V,  "random array  ");
   end Test;

end Test_Algo_Sort;
