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
with Ada.Finalization;
with Asserts;
with Conts.Algorithms;
with Conts.Vectors.Definite_Unbounded;

package body Test_Algo_Equals is
   use Asserts.Booleans;

   procedure Test is
      subtype Index_Type is Positive;

      package Int_Vecs is new Conts.Vectors.Definite_Unbounded
         (Index_Type, Integer, Ada.Finalization.Controlled);
      use Int_Vecs;
      function Equals is new Conts.Algorithms.Equals
         (Cursors => Int_Vecs.Cursors.Forward,
          Getters => Int_Vecs.Maps.Element_From_Index);

      V1, V2 : Vector;

   begin
      Assert (Equals (V1, V2), True, "Empty Vectors should be equal");

      for J in 1 .. 40 loop
         V1.Append (J);
      end loop;

      Assert
         (Equals (V1, V2), False,
          "Comparing non-empty and empty Vectors should not be equal");
      Assert
         (Equals (V2, V1), False,
          "Comparing empty and non-empty Vectors should not be equal");
      Assert (Equals (V2, V2), True, "Comparing with self should be equal");

      for J in 1 .. 39 loop
         V2.Append (J);
      end loop;

      Assert
         (Equals (V1, V2), False,
          "Vectors of different lengths should not be equal");

      V2.Append (40);

      Assert (Equals (V1, V2), True, "Vectors should be equal");
   end Test;

end Test_Algo_Equals;
