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
with Ada.Unchecked_Deallocation;

package body Conts.Elements.Indefinite_SPARK with SPARK_Mode => Off is

   package body Impl with SPARK_Mode => Off is
      procedure Unchecked_Free is new Ada.Unchecked_Deallocation
         (Element_Type, Element_Access);

      ----------
      -- Free --
      ----------

      procedure Free (X : in out Element_Access) is
      begin
         Unchecked_Free (X);
      end Free;

      ----------------
      -- Set_Stored --
      ----------------

      procedure Set_Stored (E : Element_Type; S : out Element_Access) is
      begin
         S := new Element_Type'(E);
      end Set_Stored;
   end Impl;

end Conts.Elements.Indefinite_SPARK;
