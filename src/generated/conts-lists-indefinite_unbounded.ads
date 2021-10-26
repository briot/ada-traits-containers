------------------------------------------------------------------------------
--                     Copyright (C) 2015-2021, AdaCore                     --
--                     Copyright (C) 2021-2021, Emmanuel Briot              --
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
with Conts.Elements.Indefinite;
with Conts.Lists.Generics;
with Conts.Lists.Storage.Unbounded;
with Conts.Pools;
with Conts.Properties.SPARK;

generic
   type Element_Type (<>) is private;
   type Container_Base_Type is abstract tagged limited private;
   with procedure Free (E : in out Element_Type) is null;
package Conts.Lists.Indefinite_Unbounded with SPARK_Mode is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

   package Elements is new Conts.Elements.Indefinite
      (Element_Type, Free => Free, Pool => Conts.Pools.Global_Pool);
   package Storage is new Conts.Lists.Storage.Unbounded
      (Elements            => Elements.Traits,
       Pool                => Conts.Pools.Global_Pool,
       Container_Base_Type => Container_Base_Type);
   package Lists is new Conts.Lists.Generics (Storage.Traits);
   package Cursors renames Lists.Cursors;  --  Forward, Bidirectional
   package Maps renames Lists.Maps;

   subtype List is Lists.List;
   subtype Cursor is Lists.Cursor;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;

   No_Element : Cursor renames Lists.No_Element;

   subtype Element_Sequence is Lists.Impl.M.Sequence with Ghost;
   subtype Cursor_Position_Map is Lists.Impl.P_Map with Ghost;
   package Content_Models is new Conts.Properties.SPARK.Content_Models
        (Map_Type     => Lists.Base_List'Class,
         Element_Type => Elements.Traits.Element,
         Model_Type   => Element_Sequence,
         Index_Type   => Lists.Impl.M.Extended_Index,
         Model        => Lists.Impl.Model,
         Get          => Lists.Impl.M.Get,
         First        => Lists.Impl.M.First,
         Last         => Lists.Impl.M.Last);
   --  For SPARK proofs
end Conts.Lists.Indefinite_Unbounded;
