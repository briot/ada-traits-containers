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
with Conts.Vectors.Definite_Bounded;
with Support_Vectors;

package body Test_Vectors_Definite_Bounded is

   function Nth (Index : Natural) return Integer is (Index);
   package Int_Vecs is new Conts.Vectors.Definite_Bounded
      (Positive, Integer);
   package Tests is new Support_Vectors
      (Test_Name       => "vectors-def-bounded",
       Nth             => Nth,
       Image           => Integer'Image,
       Elements        => Int_Vecs.Elements.Traits,
       Storage         => Int_Vecs.Storage.Traits,
       Vectors         => Int_Vecs.Vectors);

   procedure Test is
      V1 : Int_Vecs.Vector (20);
   begin
      Tests.Test (V1);
   end Test;
end Test_Vectors_Definite_Bounded;