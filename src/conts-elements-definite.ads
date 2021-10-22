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

--  This unit provides a specialization of the element traits, for use with
--  definite elements, i.e. elements whose size is known at compile time.
--  Such elements do not need an extra level of indirection via pointers to
--  be stored in a container.

pragma Ada_2012;

generic
   type Element_Type is private;
   --  Must be a copyable type (as defined in conts-elements.ads), and
   --  therefore not a pointer type. In such a case, use
   --  conts-elements-indefinite.ads instead, and let it do the allocations
   --  itself.

   with procedure Free (E : in out Element_Type) is null;
   --  Free is called when the element is no longer used (removed from
   --  its container for instance). Most of the time this will do
   --  nothing, but this procedure is useful if the Element_Type is an
   --  access type that you want to deallocate.

   Movable  : Boolean := True;    --  should be False for controlled types
   Copyable : Boolean := True;    --  should be False for controlled types

package Conts.Elements.Definite with SPARK_Mode is
--   pragma Compile_Time_Error
--      (Copyable and Element_Type'Finalization_Size /= 0,
--       "Copyable should be False for controlled types");
--   pragma Compile_Time_Error
--      (Movable and Element_Type'Finalization_Size /= 0,
--       "Movable should be False for controlled types");

   type Reference_Type (Element : not null access Element_Type)
      is null record with Implicit_Dereference => Element;
   type Constant_Reference_Type
      (Element : not null access constant Element_Type)
      is null record with Implicit_Dereference => Element;

   function Identity (E : Element_Type) return Element_Type is (E) with Inline;
   function To_Constant_Ref
      (E : not null access constant Element_Type)
      return Constant_Reference_Type
      is (Constant_Reference_Type'(Element => E)) with Inline;
   function To_Ref (E : not null access Element_Type) return Reference_Type
      is (Reference_Type'(Element => E)) with Inline;
   function To_Element
      (E : Constant_Reference_Type) return Element_Type
      is (E.Element.all);
   procedure Set_Stored (E : Element_Type; S : out Element_Type) with Inline;

   package Traits is new Conts.Elements.Traits
     (Element_Type           => Element_Type,
      Stored_Type            => Element_Type,
      Returned_Type          => Reference_Type,
      Constant_Returned_Type => Constant_Reference_Type,
      Copyable               => Copyable,
      Movable                => Movable,
      Release                => Free,
      Set_Stored             => Set_Stored,
      To_Returned            => To_Ref,
      To_Constant_Returned   => To_Constant_Ref,
      To_Element             => To_Element,
      Copy                   => Identity);

end Conts.Elements.Definite;
