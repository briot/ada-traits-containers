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
with Asserts;
with GAL.Algo.Random;
with GAL.Algo.Shuffle;
with Test_Containers;  use Test_Containers;

package body Test_Algo_Shuffle is
   use Asserts.Booleans;

   package Rand is new GAL.Algo.Random.Default_Random
      (Int_Vecs.Extended_Index);
   procedure Shuffle is new GAL.Algo.Shuffle
      (Cursors => Int_Vecs.Cursors.Random_Access,
       Swap    => Int_Vecs.Swap,
       Random  => Rand.Traits);

   ----------
   -- Test --
   ----------

   procedure Test is
      V, V2 : Int_Vecs.Vector;
      G : Rand.Generator;
   begin
      for J in 1 .. 40 loop
         V.Append (J);
      end loop;

      Rand.Reset (G);

      V2 := V;
      Shuffle (V, G);
      Assert
         (Equals (V, V2), False,
          "Shuffle should change the order of elements");
   end Test;

end Test_Algo_Shuffle;
