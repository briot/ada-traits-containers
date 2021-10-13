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

with Ada.Command_Line;
with Ada.Containers.Bounded_Doubly_Linked_Lists;
with Ada.Containers.Bounded_Hashed_Maps;
with Ada.Containers.Bounded_Ordered_Maps;
with Ada.Containers.Bounded_Vectors;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Containers.Hashed_Maps;
with Ada.Containers.Indefinite_Doubly_Linked_Lists;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Ordered_Maps;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Hash;
with Perf_Support;     use Perf_Support;
with QGen;             use QGen;
with Report;           use Report;
with Run_All;
with Support_Ada;
with System;
with Test_Algo_Sort;
with Test_Graph_Adjlist;
with Test_Support;

procedure Main_Perf is
   procedure Test_Cpp_Graph (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_graph";

   -----------
   -- Lists --
   -----------

   package Integer_Unbounded_Lists is
      new Ada.Containers.Doubly_Linked_Lists (Integer);
   package Integer_Unbounded_List_Tests is
      new Support_Ada.Test_Definite_Unbounded_Lists
        (Category       => "Integer List",
         Container_Name => "Ada Def Unbounded",
         Lists          => Integer_Unbounded_Lists,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package Integer_Bounded_Lists is
      new Ada.Containers.Bounded_Doubly_Linked_Lists (Integer);
   package Integer_Bounded_List_Tests is
      new Support_Ada.Test_Definite_Bounded_Lists
        (Category       => "Integer List",
         Container_Name => "Ada Def Bounded",
         Lists          => Integer_Bounded_Lists,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package Integer_Indef_Unbounded_Lists is
      new Ada.Containers.Indefinite_Doubly_Linked_Lists (Integer);
   package Integer_Indef_Unbounded_List_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Lists
        (Category       => "Integer List",
         Container_Name => "Ada Indef Unbounded",
         Lists          => Integer_Indef_Unbounded_Lists,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package String_Indef_Unbounded_Lists is
      new Ada.Containers.Indefinite_Doubly_Linked_Lists (String);
   package String_Indef_Unbounded_List_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Lists
        (Category       => "String List",
         Container_Name => "Ada Indef Unbounded",
         Lists          => String_Indef_Unbounded_Lists,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   -------------
   -- Vectors --
   -------------

   package Integer_Unbounded_Vectors is new Ada.Containers.Vectors
      (Positive, Integer);
   package Integer_Unbounded_Vector_Tests is
      new Support_Ada.Test_Definite_Unbounded_Vectors
        (Category       => "Integer Vector",
         Container_Name => "Ada Def Unbounded",
         Vectors        => Integer_Unbounded_Vectors,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package Integer_Bounded_Vectors is
      new Ada.Containers.Bounded_Vectors (Positive, Integer);
   package Integer_Bounded_Vector_Tests is
      new Support_Ada.Test_Definite_Bounded_Vectors
        (Category       => "Integer Vector",
         Container_Name => "Ada Def Bounded",
         Vectors        => Integer_Bounded_Vectors,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package Integer_Indef_Unbounded_Vectors is
      new Ada.Containers.Indefinite_Vectors (Positive, Integer);
   package Integer_Indef_Unbounded_Vector_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Vectors
        (Category       => "Integer Vector",
         Container_Name => "Ada Indef Unbounded",
         Vectors        => Integer_Indef_Unbounded_Vectors,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package String_Indef_Unbounded_Vectors is
      new Ada.Containers.Indefinite_Vectors (Positive, String);
   package String_Indef_Unbounded_Vector_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Vectors
        (Category       => "String Vector",
         Container_Name => "Ada Indef Unbounded",
         Vectors        => String_Indef_Unbounded_Vectors,
         Nth            => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   ------------------
   -- Ordered_Maps --
   ------------------

   package IntInt_Unbounded_Ordered_Maps is new Ada.Containers.Ordered_Maps
      (Integer, Integer);
   package IntInt_Unbounded_Ordered_Map_Tests is
      new Support_Ada.Test_Definite_Unbounded_Ordered_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Def Unbounded Ordered",
         Maps           => IntInt_Unbounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package IntInt_Bounded_Ordered_Maps is
      new Ada.Containers.Bounded_Ordered_Maps (Integer, Integer);
   package IntInt_Bounded_Ordered_Map_Tests is
      new Support_Ada.Test_Definite_Bounded_Ordered_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Def Bounded Ordered",
         Maps           => IntInt_Bounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package IntInt_Indef_Unbounded_Ordered_Maps is
      new Ada.Containers.Indefinite_Ordered_Maps (Integer, Integer);
   package IntInt_Indef_Unbounded_Ordered_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Ordered_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Indef Unbounded Ordered",
         Maps           => IntInt_Indef_Unbounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package StrInt_Indef_Unbounded_Ordered_Maps is
      new Ada.Containers.Indefinite_Ordered_Maps (String, Integer);
   package StrInt_Indef_Unbounded_Ordered_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Ordered_Maps
        (Category       => "String-Integer Map",
         Container_Name => "Ada Indef Unbounded Ordered",
         Maps           => StrInt_Indef_Unbounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package StrStr_Indef_Unbounded_Ordered_Maps is
      new Ada.Containers.Indefinite_Ordered_Maps (String, String);
   package StrStr_Indef_Unbounded_Ordered_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Ordered_Maps
        (Category       => "String-String Map",
         Container_Name => "Ada Indef Unbounded Ordered",
         Maps           => StrStr_Indef_Unbounded_Ordered_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   ------------------
   -- Hashed_Maps --
   ------------------

   package IntInt_Unbounded_Hashed_Maps is new Ada.Containers.Hashed_Maps
      (Integer, Integer, Test_Support.Hash, "=");
   package IntInt_Unbounded_Hashed_Map_Tests is
      new Support_Ada.Test_Definite_Unbounded_Hashed_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Def Unbounded Hashed",
         Maps           => IntInt_Unbounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package IntInt_Bounded_Hashed_Maps is
      new Ada.Containers.Bounded_Hashed_Maps
         (Integer, Integer, Test_Support.Hash, "=");
   package IntInt_Bounded_Hashed_Map_Tests is
      new Support_Ada.Test_Definite_Bounded_Hashed_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Def Bounded Hashed",
         Maps           => IntInt_Bounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package IntInt_Indef_Unbounded_Hashed_Maps is
      new Ada.Containers.Indefinite_Hashed_Maps
         (Integer, Integer, Test_Support.Hash, "=");
   package IntInt_Indef_Unbounded_Hashed_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Hashed_Maps
        (Category       => "Integer-Integer Map",
         Container_Name => "Ada Indef Unbounded Hashed",
         Maps           => IntInt_Indef_Unbounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package StrInt_Indef_Unbounded_Hashed_Maps is
      new Ada.Containers.Indefinite_Hashed_Maps
         (String, Integer, Ada.Strings.Hash, "=");
   package StrInt_Indef_Unbounded_Hashed_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Hashed_Maps
        (Category       => "String-Integer Map",
         Container_Name => "Ada Indef Unbounded Hashed",
         Maps           => StrInt_Indef_Unbounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   package StrStr_Indef_Unbounded_Hashed_Maps is
      new Ada.Containers.Indefinite_Hashed_Maps
         (String, String, Ada.Strings.Hash, "=");
   package StrStr_Indef_Unbounded_Hashed_Map_Tests is
      new Support_Ada.Test_Indefinite_Unbounded_Hashed_Maps
        (Category       => "String-String Map",
         Container_Name => "Ada Indef Unbounded Hashed",
         Maps           => StrStr_Indef_Unbounded_Hashed_Maps,
         Nth_Key        => Test_Support.Nth,
         Nth_Element    => Test_Support.Nth,
         Check_Element  => Test_Support.Check_Element);

   Filter : Test_Support.Test_Filter;
   Stdout : aliased Output;

   type CPP_Test is not null access procedure (S : System.Address)
      with Convention => C;

   procedure Run_Test
      (Name : String;
       Proc : not null access procedure (S : in out Output'Class));
   procedure Run_Test (Name : String; Proc : CPP_Test);
   --  Run a test if the command line arguments allow it

   procedure Run_Test
      (Name : String;
       Proc : not null access procedure (S : in out Output'Class)) is
   begin
      if Filter.Active (Name) then
         Proc (Stdout);
      end if;
   end Run_Test;

   procedure Run_Test (Name : String; Proc : CPP_Test) is
   begin
      if Filter.Active (Name) then
         Proc (Stdout'Address);
      end if;
   end Run_Test;

begin
   for A in 1 .. Ada.Command_Line.Argument_Count loop
      Filter.Setup (Ada.Command_Line.Argument (1));
   end loop;

   Run_Test ("int_list_c++", Test_Cpp_Int_List'Access);
   Run_Test ("str_list_c++", Test_Cpp_Str_List'Access);
   Run_Test ("int_vector_c++", Test_Cpp_Int_Vector'Access);
   Run_Test ("int_vector_ada_arrays", Test_Arrays_Int'Access);
   Run_Test ("str_vector_c++", Test_Cpp_Str_Vector'Access);
   Run_Test ("intint_map_c++_unordered",
             Test_Cpp_Int_Int_Unordered_Map'Access);
   Run_Test ("intint_map_c++", Test_Cpp_Int_Int_Map'Access);
   Run_Test ("strint_map_c++", Test_Cpp_Str_Int_Map'Access);
   Run_Test ("strstr_map_c++_unordered",
             Test_Cpp_Str_Str_Unordered_Map'Access);
   Run_Test ("strstr_map_c++", Test_Cpp_Str_Str_Map'Access);

   if Filter.Active ("ada-array-integer") then
      Perf_Support.Test_Arrays_Int (Stdout);
   end if;

   if Filter.Active ("ada-lists-definite-unbounded-integer") then
      Integer_Unbounded_List_Tests.Test_Perf (Stdout, Favorite => True);
   end if;

   if Filter.Active ("ada-lists-definite-bounded-integer") then
      Integer_Bounded_List_Tests.Test_Perf (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-lists-indefinite-unbounded-integer") then
      Integer_Indef_Unbounded_List_Tests.Test_Perf (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-lists-indefinite-unbounded-string") then
      String_Indef_Unbounded_List_Tests.Test_Perf (Stdout, Favorite => True);
   end if;

   if Filter.Active ("ada-vectors-definite-unbounded-integer") then
      Integer_Unbounded_Vector_Tests.Test_Perf (Stdout, Favorite => True);
   end if;

   if Filter.Active ("ada-vectors-definite-bounded-integer") then
      Integer_Bounded_Vector_Tests.Test_Perf (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-vectors-indefinite-unbounded-integer") then
      Integer_Indef_Unbounded_Vector_Tests.Test_Perf
         (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-vectors-indefinite-unbounded-string") then
      String_Indef_Unbounded_Vector_Tests.Test_Perf (Stdout, Favorite => True);
   end if;

   --  ordered_maps

   if Filter.Active ("ada-omap-definite-unbounded-intint") then
      IntInt_Unbounded_Ordered_Map_Tests.Test_Perf (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-omap-definite-bounded-intint") then
      IntInt_Bounded_Ordered_Map_Tests.Test_Perf (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-omap-indefinite-unbounded-intint") then
      IntInt_Indef_Unbounded_Ordered_Map_Tests.Test_Perf
         (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-omap-indefinite-unbounded-strint") then
      StrInt_Indef_Unbounded_Ordered_Map_Tests.Test_Perf
         (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-omap-indefinite-unbounded-strstr") then
      StrStr_Indef_Unbounded_Ordered_Map_Tests.Test_Perf
         (Stdout, Favorite => False);
   end if;

   --  hashed_maps

   if Filter.Active ("ada-hmap-definite-unbounded-intint") then
      IntInt_Unbounded_Hashed_Map_Tests.Test_Perf (Stdout, Favorite => True);
   end if;

   if Filter.Active ("ada-hmap-definite-bounded-intint") then
      IntInt_Bounded_Hashed_Map_Tests.Test_Perf (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-hmap-indefinite-unbounded-intint") then
      IntInt_Indef_Unbounded_Hashed_Map_Tests.Test_Perf
         (Stdout, Favorite => False);
   end if;

   if Filter.Active ("ada-hmap-indefinite-unbounded-strint") then
      StrInt_Indef_Unbounded_Hashed_Map_Tests.Test_Perf
         (Stdout, Favorite => True);
   end if;

   if Filter.Active ("ada-hmap-indefinite-unbounded-strstr") then
      StrStr_Indef_Unbounded_Hashed_Map_Tests.Test_Perf
         (Stdout, Favorite => True);
   end if;

   Run_Test ("graph_c++", Test_Cpp_Graph'Access);
   Run_Test ("graph_ada_adjacency_list",
             Test_Graph_Adjlist.Test_Perf_Adjacency_List'Access);
   Run_Test ("graph_ada_custom", Test_Graph_Adjlist.Test_Perf_Custom'Access);

   Run_Test ("sort", Test_Algo_Sort.Test_Perf'Access);

   Test_QGen;

   Run_All (Stdout, Filter);
   Stdout.Save;
end Main_Perf;
