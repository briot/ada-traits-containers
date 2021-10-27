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
with GAL.Lists.Generics;
with GNAT.Source_Info;
with Report;

generic
   Category       : String;  --  which table we want to show results in
   Container_Name : String;  --  which column
   with package Lists is new GAL.Lists.Generics (<>);
   with function Image
      (Self : Lists.Storage.Elements.Element_Type) return String is <>;

   with function Nth
      (Index : Natural) return Lists.Storage.Elements.Element_Type is <>;
   --  What to insert in the list for correctness tests. Should all be
   --  different.

   with function Perf_Nth
      (Index : Natural) return Lists.Storage.Elements.Element_Type is <>;
   --  What to insert in the list for performance tests.

   with function Check_Element
      (E : Lists.Storage.Elements.Element_Type) return Boolean is <>;
   --  Should be True for all elements returned by Nth (and use E)

   with function "="
      (L, R : Lists.Storage.Elements.Element_Type) return Boolean is <>;
package Support_Lists is

   function Image (L : Lists.List) return String;

   procedure Assert_List
      (L        : Lists.List;
       Expected : String;
       Msg      : String;
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity);
   --  Check the contents of the list

   procedure Test_Correctness (L1, L2 : in out Lists.List);
   --  Perform various tests.
   --  All lists should be empty on input. This is used to handle bounded
   --  lists.

   procedure Test_Perf
      (Results  : in out Report.Output'Class;
       L1, L2   : in out Lists.List;
       Favorite : Boolean);
   --  Run performance tests

end Support_Lists;
