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

--  GAL.Maps.Indef_Indef_Unbounded_SPARK
--  ====================================
--
--  This package is a high level version of the maps. It uses a limited
--  number of formal parameters to make instantiation easier and uses
--  default choices for all other parameters. If you need full control over
--  how memory is allocated, whether to use controlled types or not
--  and so on, please consider using the low-level packages instead.
--
--  Unbounded SPARK:
--  ----------
--  This container can store any number of elements, and will grow as needed.
--  It requires memory allocations for the container itself.
--  Internally, memory is managed as a single big array so that we can have
--  SPARK pre and post conditions.

--
--  Indefinite SPARK keys:
--  ---------------------
--  These lists can store indefinite keys, for which the size is not known
--  at runtime. This includes strings, arrays, class wide types and so on. In
--  exchange for this generality, each keys will require extra memory
--  allocations.
--  For compatibility with SPARK, we hide the internal access types, and always
--  return a copy of the keys rather than an access to it.
--
--  Indefinite SPARK elements:
--  -------------------------
--  These lists can store indefinite elements, for which the size is not known
--  at runtime. This includes strings, arrays, class wide types and so on. In
--  exchange for this generality, each elements will require extra memory
--  allocations.
--  For compatibility with SPARK, we hide the internal access types, and always
--  return a copy of the elements rather than an access to it.
pragma Ada_2012;
with GAL.Elements.Indefinite_SPARK;
with GAL.Maps.Generics;
with GAL.Pools;
with GAL.Properties.SPARK;

generic
   type Key_Type (<>) is private;
   type Element_Type (<>) is private;
   with function Hash (Key : Key_Type) return Hash_Type;
   with function "=" (Left, Right : Key_Type) return Boolean is <>;
package GAL.Maps.Indef_Indef_Unbounded_SPARK with SPARK_Mode is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

   package Keys is new GAL.Elements.Indefinite_SPARK
      (Key_Type, Pool => GAL.Pools.Global_Pool);
   package Elements is new GAL.Elements.Indefinite_SPARK
      (Element_Type, Pool => GAL.Pools.Global_Pool);

   function "=" (Left : Key_Type; Right : Keys.Stored) return Boolean
        is (Left = Keys.Impl.To_Element (Right))
        with Inline;

   package Impl is new GAL.Maps.Generics
     (Keys                => Keys.Traits,
      Elements            => Elements.Traits,
      Hash                => Hash,
      "="                 => "=",
      Probing             => GAL.Maps.Perturbation_Probing,
      Pool                => GAL.Pools.Global_Pool,
      Container_Base_Type => GAL.Limited_Base);

   subtype Map is Impl.Map;
   subtype Cursor is Impl.Cursor;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;
   subtype Returned is Impl.Returned_Type;
   No_Element : Cursor renames Impl.No_Element;

   package Cursors renames Impl.Cursors;
   package Maps renames Impl.Maps;

   function Copy (Self : Map'Class) return Map'Class;
   --  Return a deep copy of Self

   subtype Model_Map is Impl.Impl.M.Map with Ghost;
   subtype Key_Sequence is Impl.Impl.K.Sequence with Ghost;
   subtype Cursor_Position_Map is Impl.Impl.P_Map with Ghost;
   package Content_Models is new GAL.Properties.SPARK.Content_Models
        (Map_Type     => Impl.Base_Map'Class,
         Element_Type => Key_Type,
         Model_Type   => Key_Sequence,
         Index_Type   => Impl.Impl.K.Extended_Index,
         Model        => Impl.S_Keys,
         Get          => Impl.Impl.K.Get,
         First        => Impl.Impl.K.First,
         Last         => Impl.Impl.K.Last);
   --  for SPARK proofs

end GAL.Maps.Indef_Indef_Unbounded_SPARK;
