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
with Conts.Properties.SPARK;
with Conts.Vectors.Generics;
with Conts.Elements.Indefinite;
with Conts.Vectors.Storage.Bounded;
generic
   type Index_Type is (<>);
   type Element_Type (<>) is private;


   with procedure Free (E : in out Element_Type) is null;
package Conts.Vectors.Indefinite_Bounded with SPARK_Mode is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

   package Elements is new Conts.Elements.Indefinite
      (Element_Type, Free => Free, Pool => Conts.Global_Pool);
   package Storage is new Conts.Vectors.Storage.Bounded
      (Elements            => Elements.Traits,
       Container_Base_Type => Conts.Controlled_Base);
   package Vectors is new Conts.Vectors.Generics (Index_Type, Storage.Traits);
   package Cursors renames Vectors.Cursors;  --  Forward, Bidirectional, Random
   package Maps renames Vectors.Maps;

   subtype Vector is Vectors.Vector;
   subtype Cursor is Vectors.Cursor;
   subtype Extended_Index is Vectors.Extended_Index;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;

   No_Element : Cursor renames Vectors.No_Element;
   No_Index   : Index_Type renames Vectors.No_Index;

   procedure Swap
      (Self : in out Cursors.Forward.Container;
       Left, Right : Index_Type)
      renames Vectors.Swap;

   subtype Element_Sequence is Vectors.Impl.M.Sequence with Ghost;
   package Content_Models is new Conts.Properties.SPARK.Content_Models
        (Map_Type     => Vectors.Base_Vector'Class,
         Element_Type => Elements.Traits.Element,
         Model_Type   => Element_Sequence,
         Index_Type   => Vectors.Impl.M.Extended_Index,
         Model        => Vectors.Impl.Model,
         Get          => Vectors.Impl.M.Get,
         First        => Vectors.Impl.M.First,
         Last         => Vectors.Impl.M.Last);
   --  For SPARK proofs
end Conts.Vectors.Indefinite_Bounded;
