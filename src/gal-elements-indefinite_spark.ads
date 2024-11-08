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

--  An implementation of the elements traits compatible with SPARK.
--  This package hides the access types.
--  Reference types are not possible with SPARK, so this package always
--  return a copy of the element (as opposed to what's done in
--  gal-elements-indefinite.ads)

pragma Ada_2012;
with GAL.Pools;

generic
   type Element_Type (<>) is private;

   with package Pool is new GAL.Pools.Pools (<>);
   --  The storage pool used for Elements.

package GAL.Elements.Indefinite_SPARK with SPARK_Mode => On is

   package Impl with SPARK_Mode => On is
      type Element_Access is private;

      subtype Constant_Reference_Type is Element_Type;
      --  References are not allowed in SPARK, use the element directly instead

      procedure Set_Stored (E : Element_Type; S : out Element_Access)
      with Inline,
        Global => null,
        Post   => To_Element (S) = E;

      function To_Element (E : Element_Access) return Element_Type
         with Inline, Global => null;

      function To_Constant_Reference_Type
        (E : not null access constant Element_Access)
        return Constant_Reference_Type
      with Inline,
        Global => null;

      function To_Reference_Type
        (E : not null access Element_Access) return Constant_Reference_Type
      with Inline,
        Global => null;

      function To_Element (E : Constant_Reference_Type) return Element_Type is
        (E)
      with Inline,
        Global => null;

      function Copy (E : Element_Access) return Element_Access
      with Inline,
        Global => null;

      procedure Free (X : in out Element_Access) with Global => null;

   private
      pragma SPARK_Mode (Off);

      type Element_Access is access all Element_Type;

      for Element_Access'Storage_Pool use Pool.Pool;

      function To_Element (E : Element_Access) return Element_Type
      is (E.all);

      function Copy (E : Element_Access) return Element_Access
      is (new Element_Type'(E.all));

      function To_Constant_Reference_Type
        (E : not null access constant Element_Access)
        return Constant_Reference_Type
        is (E.all.all);
      function To_Reference_Type
        (E : not null access Element_Access) return Constant_Reference_Type
        is (E.all.all);
   end Impl;

   subtype Stored is Impl.Element_Access;
   function To_Element (E : Stored) return Element_Type
      renames Impl.To_Element;

   package Traits is new GAL.Elements.Traits
     (Element_Type           => Element_Type,
      Stored_Type            => Impl.Element_Access,
      Returned_Type          => Impl.Constant_Reference_Type,
      Constant_Returned_Type => Impl.Constant_Reference_Type,
      Set_Stored             => Impl.Set_Stored,
      To_Returned            => Impl.To_Reference_Type,
      To_Constant_Returned   => Impl.To_Constant_Reference_Type,
      To_Element             => Impl.To_Element,
      Copy                   => Impl.Copy,
      Copyable               => False,
      Movable                => False,
      Release                => Impl.Free);

end GAL.Elements.Indefinite_SPARK;
