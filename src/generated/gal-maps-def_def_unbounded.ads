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

--  GAL.Maps.Def_Def_Unbounded
--  ==========================
--
--  This package is a high level version of the maps. It uses a limited
--  number of formal parameters to make instantiation easier and uses
--  default choices for all other parameters. If you need full control over
--  how memory is allocated, whether to use controlled types or not
--  and so on, please consider using the low-level packages instead.
--
--  Unbounded:
--  ----------
--  This container can store any number of elements, and will grow as needed.
--  It requires memory allocations for the container itself.
--
--  Definite keys:
--  --------------
--  This container can only store keys whose size is known at compile time.
--  In exchange, it doesn't need any memory allocation when adding new
--  keys.
--
--  Definite elements:
--  ------------------
--  This container can only store elements whose size is known at compile time.
--  In exchange, it doesn't need any memory allocation when adding new
--  elements.
pragma Ada_2012;
with GAL.Elements.Definite;
with GAL.Maps.Generics;
with GAL.Pools;

generic
   type Key_Type is private;
   type Element_Type is private;
   type Container_Base_Type is abstract tagged limited private;
   with function Hash (Key : Key_Type) return Hash_Type;
   with function "=" (Left, Right : Key_Type) return Boolean is <>;
   with procedure Free (E : in out Key_Type) is null;
   with procedure Free (E : in out Element_Type) is null;
package GAL.Maps.Def_Def_Unbounded with SPARK_Mode is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

   package Keys is new GAL.Elements.Definite
      (Key_Type, Free => Free, Movable => True, Copyable => True);
   package Elements is new GAL.Elements.Definite
      (Element_Type, Free => Free, Movable => True, Copyable => True);


   package Impl is new GAL.Maps.Generics
     (Keys                => Keys.Traits,
      Elements            => Elements.Traits,
      Hash                => Hash,
      "="                 => "=",
      Probing             => GAL.Maps.Perturbation_Probing,
      Pool                => GAL.Pools.Global_Pool,
      Container_Base_Type => Container_Base_Type);

   subtype Map is Impl.Map;
   subtype Cursor is Impl.Cursor;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;
   subtype Returned is Impl.Returned_Type;
   No_Element : Cursor renames Impl.No_Element;

   package Cursors renames Impl.Cursors;
   package Maps renames Impl.Maps;


end GAL.Maps.Def_Def_Unbounded;
