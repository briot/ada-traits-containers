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
with Report;                use Report;
with System;

package Perf_Support is

   --------------------
   -- Unary functors --
   --------------------
   --  These packages provide objects that act like functions, except it is
   --  possible to store data in them. They can thus be used to write
   --  accumulators, or to curry binary functions into unary functions.

   generic
      type Param is private;
      type Ret is private;
   package Unary_Functors is
      --  Define the types so that we can access the generic formals from an
      --  instance of this package.
      subtype Param_Type is Param;
      subtype Returned_Type is Ret;

      type Obj is interface;
      function Call (Self : Obj; P : Param) return Ret is abstract;
   end Unary_Functors;

   generic
      with package F is new Unary_Functors (others => <>);
      with function Call (P : F.Param_Type) return F.Returned_Type;
   package Unary_Functions is
      package Functors renames F;

      type Obj is new F.Obj with null record;
      overriding function Call
         (Self : Obj; P : F.Param_Type) return F.Returned_Type
         is (Call (P));

      Make : constant Obj := (null record);
   end Unary_Functions;

   --------------------
   -- Using generics --
   --------------------

   generic
      type Param1 is private;
      type Param2 is private;
      type Ret is private;
      with function Call (P : Param1; Q : Param2) return Ret;
   package Binary_Functions is
      --  Define the types so that we can access the generic formals from an
      --  instance of this package.
      subtype Param1_Type is Param1;
      subtype Param2_Type is Param2;
      subtype Returned_Type is Ret;
   end Binary_Functions;

   generic
      type Param1 is private;
      type Param2 is private;
      B : Param2;
      type Ret is private;
      with function Call (P : Param1; Q : Param2) return Ret;
   package Binder2nd is
      --  Define the types so that we can access the generic formals from an
      --  instance of this package.
      subtype Param1_Type is Param1;
      subtype Param2_Type is Param2;
      subtype Returned_Type is Ret;

      function Binder_Call (P : Param1_Type) return Returned_Type
         is (Call (P, B));
      --  package Funcs is new Unary_Functors
      --     (Param => Param1_Type,
      --      Ret   => Returned_Type,
      --      Call  => Binder_Call);
   end Binder2nd;
   --  ??? Not the same as in C++ STL: since we do not have a class, there is
   --  no constructor to pass the value of the constant, which is therefore
   --  part of the generic formals, so we need a different instantiation for
   --  every possible value we might want for B.

   -----------
   -- Tests --
   -----------

   procedure Test_Cpp_Int_List (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_int_list";
   procedure Test_Cpp_Str_List (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_str_list";
   procedure Test_Cpp_Int_Vector (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_int_vector";
   procedure Test_Cpp_Str_Vector (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_str_vector";
   procedure Test_Cpp_Str_Int_Map (Stdout : System.Address)
     with Import, Convention => C, External_Name => "test_cpp_str_int_map";
   procedure Test_Cpp_Str_Str_Map (Stdout : System.Address)
     with Import, Convention => C, External_Name => "test_cpp_str_str_map";
   procedure Test_Cpp_Str_Str_Unordered_Map (Stdout : System.Address)
     with Import, Convention => C,
          External_Name => "test_cpp_str_str_unordered_map";
   procedure Test_Cpp_Int_Int_Map (Stdout : System.Address)
     with Import, Convention => C, External_Name => "test_cpp_int_int_map";
   procedure Test_Cpp_Int_Int_Unordered_Map (Stdout : System.Address)
     with Import, Convention => C,
          External_Name => "test_cpp_int_int_unordered_map";
   --  Perform C++ testing

   procedure Test_Arrays_Int
      (Stdout : in out Output'Class; Favorite : Boolean);
   --  Test standard Ada arrays

end Perf_Support;
