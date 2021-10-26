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
with Asserts;           use Asserts;
with Conts.Algorithms.Is_Sorted;
with Conts.Algorithms.Random;
with Conts.Algorithms.Sort.Insertion;
with Conts.Algorithms.Sort.Shell;
with Conts.Algorithms.Sort.Quicksort;
with Conts.Vectors.Definite_Unbounded;

package body Test_Algo_Sort is

   use Asserts.Booleans;
   use Conts;

   subtype Index_Type is Positive;

   package Int_Vecs is new Conts.Vectors.Definite_Unbounded
      (Index_Type, Integer, Conts.Controlled_Base);
   use Int_Vecs;

   package Rand is new Conts.Algorithms.Random.Default_Random (Extended_Index);

   package Int_Ada_Vecs is new Ada.Containers.Vectors
      (Index_Type, Integer);
   package Ada_Sort is new Int_Ada_Vecs.Generic_Sorting ("<");

   procedure Insert_Sort is new Conts.Algorithms.Sort.Insertion
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Swap    => Int_Vecs.Swap);
   procedure Shell_Ciura_Sort is new Conts.Algorithms.Sort.Shell
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Swap    => Int_Vecs.Swap,
       Gaps    => Conts.Algorithms.Sort.Ciura_Gaps);
   procedure Shell_Sedgewick_Sort is new Conts.Algorithms.Sort.Shell
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Swap    => Int_Vecs.Swap,
       Gaps    => Conts.Algorithms.Sort.Sedgewick_Gaps);
   procedure Quicksort is new Conts.Algorithms.Sort.Quicksort
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Getters => Int_Vecs.Maps.Element,
       "<"     => "<",
       Swap    => Int_Vecs.Swap);
   procedure Quicksort_Only is new Conts.Algorithms.Sort.Quicksort
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

   Sorted_Small         : Vector;
   Ada_Sorted_Small     : Int_Ada_Vecs.Vector;
   Reversed_Small       : Vector;
   Ada_Reversed_Small   : Int_Ada_Vecs.Vector;
   Cst_Small            : Vector;
   Ada_Cst_Small        : Int_Ada_Vecs.Vector;
   Random_Small         : Vector;
   Ada_Random_Small     : Int_Ada_Vecs.Vector;

   Sorted_Large         : Vector;
   Ada_Sorted_Large     : Int_Ada_Vecs.Vector;
   Reversed_Large       : Vector;
   Ada_Reversed_Large   : Int_Ada_Vecs.Vector;
   Cst_Large            : Vector;
   Ada_Cst_Large        : Int_Ada_Vecs.Vector;
   Random_Large         : Vector;
   Ada_Random_Large     : Int_Ada_Vecs.Vector;

   type Kind_Type is (Kind_Random, Kind_Sorted, Kind_Constant, Kind_Reversed);

   function Get_Ref (Kind : Kind_Type; Small : Boolean) return Vector;
   --  Return one of the reference vectors

   procedure Init_Refs (Size_Of_Small : Positive; Init_Large : Boolean);
   --  Initialize the reference vectors

   ---------------
   -- Init_Refs --
   ---------------

   procedure Init_Refs (Size_Of_Small : Positive; Init_Large : Boolean) is
      Val   : Extended_Index;
      G     : Rand.Generator;
   begin
      for J in 1 .. Size_Of_Small loop
         Rand.Random (G, Val);

         Sorted_Small.Append (J);
         Reversed_Small.Append (Size_Of_Small - J);
         Cst_Small.Append (10);
         Random_Small.Append (Val);
         Ada_Sorted_Small.Append (J);
         Ada_Reversed_Small.Append (Size_Of_Small - J);
         Ada_Cst_Small.Append (10);
         Ada_Random_Small.Append (Val);
      end loop;

      if Init_Large then
         for J in 1 .. 1_000_000 loop
            Rand.Random (G, Val);

            Sorted_Large.Append (J);
            Reversed_Large.Append (1_000_000 - J);
            Cst_Large.Append (10);
            Random_Large.Append (Val);
            Ada_Sorted_Large.Append (J);
            Ada_Reversed_Large.Append (1_000_000 - J);
            Ada_Cst_Large.Append (10);
            Ada_Random_Large.Append (Val);
         end loop;
      end if;
   end Init_Refs;

   -------------
   -- Get_Ref --
   -------------

   function Get_Ref
      (Kind : Kind_Type; Small : Boolean) return Vector is
   begin
      if Small then
         case Kind is
         when Kind_Random   => return Random_Small;
         when Kind_Sorted   => return Sorted_Small;
         when Kind_Constant => return Cst_Small;
         when Kind_Reversed => return Reversed_Small;
         end case;
      else
         case Kind is
         when Kind_Random   => return Random_Large;
         when Kind_Sorted   => return Sorted_Large;
         when Kind_Constant => return Cst_Large;
         when Kind_Reversed => return Reversed_Large;
         end case;
      end if;
   end Get_Ref;

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

   procedure Do_Sort_Insert is new Do_Sort (Insert_Sort, "insertion-sort");
   procedure Do_Sort_Shell_Ciura is
      new Do_Sort (Shell_Ciura_Sort,  "shell-sort    ");
   procedure Do_Sort_Shell_Sedgewick is
      new Do_Sort (Shell_Sedgewick_Sort, "shell-sort   ");
   procedure Do_Sort_Quick is
      new Do_Sort (Quicksort,  "quicksort+shell");
   procedure Do_Sort_Quick_Only is
      new Do_Sort (Quicksort_Only, "quicksort_only");

   ---------------
   -- Test_Sort --
   ---------------

   procedure Test_Sort (V : Vector; Msg : String) is
   begin
      Do_Sort_Insert          (V, Msg);
      Do_Sort_Shell_Ciura     (V, Msg);
      Do_Sort_Shell_Sedgewick (V, Msg);
      Do_Sort_Quick           (V, Msg);
      Do_Sort_Quick_Only      (V, Msg);
   end Test_Sort;

   ----------
   -- Test --
   ----------

   procedure Test is
   begin
      Init_Refs (Size_Of_Small => 10, Init_Large => False);
      Test_Sort (Sorted_Small,   "sorted array  ");
      Test_Sort (Reversed_Small, "reversed array");
      Test_Sort (Cst_Small,      "constant array");
      Test_Sort (Random_Small,   "random array  ");
   end Test;

   ---------------
   -- Test_Perf --
   ---------------

   procedure Test_Perf (Result : in out Report.Output'Class) is
      Category : constant String := "Sorting";

      generic
         with procedure Sort
            (Self : in out Int_Vecs.Cursors.Random_Access.Container);
         Algo : String;
      procedure Do_Sort (Omit_Large : Boolean; Favorite : Boolean := False);
      --  Apply multiple sort algorithms

      generic
         Ref : Int_Ada_Vecs.Vector;
      procedure Time_Ada_Sort (Name : String; Start_Group : Boolean := False);

      procedure Time_Ada_Sort
         (Name : String; Start_Group : Boolean := False)
      is
         V : Int_Ada_Vecs.Vector;

         procedure Do_Setup;
         procedure Do_Sort;

         procedure Do_Setup is
         begin
            V := Ref;
         end Do_Setup;

         procedure Do_Sort is
         begin
            Ada_Sort.Sort (V);
         end Do_Sort;
         procedure Time_It is new Report.Timeit (Do_Sort, Setup => Do_Setup);
      begin
         Time_It (Result, Category, "Ada", Name, Start_Group => Start_Group);
      end Time_Ada_Sort;

      procedure Do_Sort (Omit_Large : Boolean; Favorite : Boolean := False) is
         generic
            Kind  : Kind_Type;
            Small : Boolean;
         procedure Time_Sort (Name : String; Start_Group : Boolean := False);

         procedure Time_Sort (Name : String; Start_Group : Boolean := False) is
            V : Vector := Get_Ref (Kind, Small);  --  in case it is bounded

            procedure Do_Setup;
            procedure Do_Sort;
            procedure Do_Clear;

            procedure Do_Setup is
            begin
               V.Assign (Get_Ref (Kind, Small));
            end Do_Setup;

            procedure Do_Clear is
            begin
               V.Clear;  --  free memory within the context of the test
            end Do_Clear;

            procedure Do_Sort is
            begin
               Sort (V);
            end Do_Sort;
            procedure T is new Report.Timeit
               (Do_Sort, Setup => Do_Setup, Cleanup => Do_Clear);
         begin
            T (Result, Category, Algo, Name, Start_Group => Start_Group);
         end Time_Sort;

         procedure Time_Random_Small   is new Time_Sort (Kind_Random, True);
         procedure Time_Sorted_Small   is new Time_Sort (Kind_Sorted, True);
         procedure Time_Reversed_Small is new Time_Sort (Kind_Reversed, True);
         procedure Time_Constant_Small is new Time_Sort (Kind_Constant, True);

         procedure Time_Random_Large   is new Time_Sort (Kind_Random, False);
         procedure Time_Sorted_Large   is new Time_Sort (Kind_Sorted, False);
         procedure Time_Reversed_Large is new Time_Sort (Kind_Reversed, False);
         procedure Time_Constant_Large is new Time_Sort (Kind_Constant, False);

      begin
         Result.Set_Column (Category, Algo, Size => 0, Favorite => Favorite);

         Time_Random_Small   ("random-vec-small", Start_Group => True);
         Time_Sorted_Small   ("sorted-vec-small");
         Time_Reversed_Small ("reversed-vec-small");
         Time_Constant_Small ("constant-vec-small");

         if not Omit_Large then
            Time_Random_Large   ("random-vec-large", Start_Group => True);
            Time_Sorted_Large   ("sorted-vec-large");
            Time_Reversed_Large ("reversed-vec-large");
            Time_Constant_Large ("constant-vec-large");
         end if;
      end Do_Sort;

      procedure Do_Insert  is new Do_Sort (Insert_Sort,      "insertionsort");
      procedure Do_Shell   is new Do_Sort (Shell_Ciura_Sort, "shell-ciura");
      procedure Do_Shell2  is
         new Do_Sort (Shell_Sedgewick_Sort, "shell-sedgewick");
      procedure Do_Quick   is new Do_Sort (Quicksort,      "quicksort+shell");
      procedure Do_Quick_P is new Do_Sort (Quicksort_Only, "quicksort_only");

   begin
      Init_Refs (Size_Of_Small => 10_000, Init_Large => True);

      --  Standard Ada tests

      Result.Set_Column (Category, "Ada", Size => 0, Favorite => True);

      declare
         procedure Time_Ada_Random_S   is new Time_Ada_Sort (Ada_Random_Small);
         procedure Time_Ada_Sorted_S   is new Time_Ada_Sort (Ada_Sorted_Small);
         procedure Time_Ada_Reversed_S is
            new Time_Ada_Sort (Ada_Reversed_Small);
         procedure Time_Ada_Cst_S      is new Time_Ada_Sort (Ada_Cst_Small);
         procedure Time_Ada_Random_L   is new Time_Ada_Sort (Ada_Random_Large);
         procedure Time_Ada_Sorted_L   is new Time_Ada_Sort (Ada_Sorted_Large);
         procedure Time_Ada_Reversed_L is
            new Time_Ada_Sort (Ada_Reversed_Large);
         procedure Time_Ada_Cst_L      is new Time_Ada_Sort (Ada_Cst_Large);
      begin
         Time_Ada_Random_S   ("random-vec-small", Start_Group => True);
         Time_Ada_Sorted_S   ("sorted-vec-small");
         Time_Ada_Reversed_S ("reversed-vec-small");
         Time_Ada_Cst_S      ("constant-vec-small");
         Time_Ada_Random_L   ("random-vec-large", Start_Group => True);
         Time_Ada_Sorted_L   ("sorted-vec-large");
         Time_Ada_Reversed_L ("reversed-vec-large");
         Time_Ada_Cst_L      ("constant-vec-large");
      end;

      --  Traits containers

      Do_Quick   (Omit_Large => False, Favorite => True);
      Do_Quick_P (Omit_Large => False);
      Do_Insert  (Omit_Large => True);
      Do_Shell   (Omit_Large => True);
      Do_Shell2  (Omit_Large => True);
   end Test_Perf;

end Test_Algo_Sort;
