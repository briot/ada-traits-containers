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

--  GAL.Lists.Indefinite_Unbounded_SPARK
--  ====================================
--
--  This package is a high level version of the lists. It uses a limited number
--  of formal parameters to make instantiation easier and uses default choices
--  for all other parameters. If you need full control over how memory is
--  allocated, whether to use controlled types or not, and so on, please
--  consider using the low-level packages instead.
--
--  Unbounded SPARK:
--  ----------
--  This container can store any number of elements, and will grow as needed.
--  It requires memory allocations for the container itself.
--  Internally, memory is managed as a single big array so that we can have
--  SPARK pre and post conditions.

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
with GAL.Lists.Generics;
with GAL.Lists.Storage.Unbounded_SPARK;
with GAL.Pools;
with GAL.Properties.SPARK;

generic
   type Element_Type (<>) is private;
package GAL.Lists.Indefinite_Unbounded_SPARK with SPARK_Mode is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

   --------------------
   -- Instantiations --
   --------------------

   package Elements is new GAL.Elements.Indefinite_SPARK
      (Element_Type, Pool => GAL.Pools.Global_Pool);
   package Storage is new GAL.Lists.Storage.Unbounded_SPARK
      (Elements            => Elements.Traits,
       Container_Base_Type => GAL.Limited_Base);
   package Lists is new GAL.Lists.Generics (Storage.Traits);
   package Cursors renames Lists.Cursors;  --  Forward, Bidirectional
   package Maps renames Lists.Maps;        --  From cursors to elements

   --------------------------
   -- Types and Operations --
   --------------------------

   subtype List is Lists.List;
   subtype Cursor is Lists.Cursor;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;
   subtype Returned is Elements.Traits.Returned;

   No_Element : Cursor renames Lists.No_Element;

   procedure Swap
      (Self        : in out Cursors.Forward.Container;  --  List
       Left, Right : Cursor)
      renames Lists.Swap;

   function Copy (Self : List'Class) return List'Class;
   --  Return a deep copy of Self

   -------------------
   -- SPARK support --
   -------------------

   subtype Element_Sequence is Lists.Impl.M.Sequence with Ghost;
   subtype Cursor_Position_Map is Lists.Impl.P_Map with Ghost;
   package Content_Models is new GAL.Properties.SPARK.Content_Models
        (Map_Type     => Lists.Base_List'Class,
         Element_Type => Element_Type,
         Model_Type   => Element_Sequence,
         Index_Type   => Lists.Impl.M.Extended_Index,
         Model        => Lists.Impl.Model,
         Get          => Lists.Impl.M.Get,
         First        => Lists.Impl.M.First,
         Last         => Lists.Impl.M.Last);
end GAL.Lists.Indefinite_Unbounded_SPARK;
