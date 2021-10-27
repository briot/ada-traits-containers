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

--  A special kind of elements that store nothing.
--  This is only useful to instantiate some containers, for instance a graph,
--  when no extra information needs to be added to the vertices.

pragma Ada_2012;

package GAL.Elements.Null_Elements is

   type Null_Element is null record;

   No_Element : constant Null_Element := (others => <>);

   procedure Set_Stored (E : Null_Element; S : out Null_Element) is null;
   function Identity (E : Null_Element) return Null_Element is (E) with Inline;
   function To_Constant_Ret
      (E : not null access constant Null_Element) return Null_Element
      is (E.all) with Inline;
   function To_Ret (E : not null access Null_Element) return Null_Element
      is (E.all) with Inline;

   package Traits is new GAL.Elements.Traits
     (Element_Type            => Null_Element,
      Stored_Type             => Null_Element,
      Returned_Type           => Null_Element,
      Constant_Returned_Type  => Null_Element,
      Copyable                => True,
      Movable                 => True,
      Set_Stored              => Set_Stored,
      To_Returned             => To_Ret,
      To_Constant_Returned    => To_Constant_Ret,
      To_Element              => Identity,
      Copy                    => Identity);

end GAL.Elements.Null_Elements;
