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
with GNAT.Strings;     use GNAT.Strings;
with GNATCOLL.Utils;   use GNATCOLL.Utils;
with Perf_Support;     use Perf_Support;
with QGen;             use QGen;
with Report;           use Report;
with System;
with Custom_Graph;

procedure Main is
   procedure Test_Cpp_Graph (Stdout : System.Address)
      with Import, Convention => C, External_Name => "test_cpp_graph";

   Test_Name : String_Access;
   Stdout : aliased Output;

   type CPP_Test is not null access procedure (S : System.Address)
      with Convention => C;

   procedure Run_Test
      (Name : String;
       Proc : not null access procedure (S : not null access Output'Class));
   procedure Run_Test (Name : String; Proc : CPP_Test);
   --  Run a test if the command line arguments allow it

   procedure Run_Test
      (Name : String;
       Proc : not null access procedure (S : not null access Output'Class)) is
   begin
      if Test_Name = null
         or else Starts_With (Name, Test_Name.all)
      then
         --  Put_Line ("Run " & Name);
         Proc (Stdout'Access);
      end if;
   end Run_Test;

   procedure Run_Test (Name : String; Proc : CPP_Test) is
   begin
      if Test_Name = null
         or else Starts_With (Name, Test_Name.all)
      then
         --  Put_Line ("Run " & Name);
         Proc (Stdout'Address);
      end if;
   end Run_Test;

   procedure Run_All;
   procedure Run_All is separate;

begin
   if Ada.Command_Line.Argument_Count >= 1 then
      Test_Name := new String'(Ada.Command_Line.Argument (1));
   end if;

   Run_Test ("int_list_c++", Test_Cpp_Int_List'Access);
   Run_Test ("str_list_c++", Test_Cpp_Str_List'Access);
   Run_Test ("int_vector_c++", Test_Cpp_Int_Vector'Access);
   Run_Test ("int_vector_ada_arrays", Test_Arrays_Int'Access);
   Run_Test ("str_vector_c++", Test_Cpp_Str_Vector'Access);
   Run_Test ("intint_map_c++_unordered",
             Test_Cpp_Int_Int_Unordered_Map'Access);
   Run_Test ("intint_map_c++", Test_Cpp_Int_Int_Map'Access);
   Run_Test ("strstr_map_c++_unordered",
             Test_Cpp_Str_Str_Unordered_Map'Access);
   Run_Test ("strstr_map_c++", Test_Cpp_Str_Str_Map'Access);
   Run_All;

   Run_Test ("graph_c++", Test_Cpp_Graph'Access);
   Run_Test ("graph_ada_custom", Custom_Graph.Test_Custom'Access);
   Run_Test ("graph_ada_adjacency_list",
             Custom_Graph.Test_Adjacency_List'Access);

   Test_QGen;

   Stdout.Display;

   Free (Test_Name);
end Main;
