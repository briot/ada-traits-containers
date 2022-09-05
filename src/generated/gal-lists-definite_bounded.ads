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

--  GAL.Lists.Definite_Bounded
--  ==========================
--
--  This package is a high level version of the lists. It uses a limited number
--  of formal parameters to make instantiation easier and uses default choices
--  for all other parameters. If you need full control over how memory is
--  allocated, whether to use controlled types or not, and so on, please
--  consider using the low-level packages instead.
--
--  Bounded:
--  ----------
--  This container can store up to a maximum number of elements, as specified
--  by the discriminant. As a result, it doesn't need memory allocations for
--  the container itself.
--
--  Definite elements:
--  ------------------
--  This container can only store elements whose size is known at compile time.
--  In exchange, it doesn't need any memory allocation when adding new
--  elements.

pragma Ada_2012;
with GAL.Elements.Definite;
with GAL.Lists.Generics;
with GAL.Lists.Storage.Bounded;
with GAL.Properties.SPARK;

generic
   type Element_Type is private;
   with procedure Free (E : in out Element_Type) is null;
package GAL.Lists.Definite_Bounded with SPARK_Mode is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

   --------------------
   -- Instantiations --
   --------------------

   package Elements is new GAL.Elements.Definite
      (Element_Type, Free => Free, Movable => True, Copyable => True);
   package Storage is new GAL.Lists.Storage.Bounded
      (Elements            => Elements.Traits,
       Container_Base_Type => GAL.Controlled_Base);
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
end GAL.Lists.Definite_Bounded;
