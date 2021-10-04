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
with Conts.Elements;
with Conts.Vectors.Generics;
with Conts.Vectors.Storage;
with GNAT.Source_Info;

generic
   Test_Name : String;

   with package Elements is new Conts.Elements.Traits (<>);
   with package Storage is new Conts.Vectors.Storage.Traits
      (Elements => Elements, others => <>);
   with package Vectors is new Conts.Vectors.Generics
      (Storage => Storage, Index_Type => Positive);
   with function Image (Self : Elements.Element_Type) return String;

   with function Nth (Index : Natural) return Elements.Element_Type;
   with function "=" (L, R : Elements.Element_Type) return Boolean is <>;

package Support_Vectors is

   procedure Assert_Vector
      (V        : Vectors.Vector;
       Expected : String;
       Msg      : String;
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity);
   --  Check the contents of the vector

   procedure Test (V1 : in out Vectors.Vector);
   --  Perform various tests.
   --  All vectors should be empty on input. This is used to handle bounded
   --  vectors.

end Support_Vectors;