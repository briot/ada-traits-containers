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

pragma Ada_2012;
with Ada.Containers;
with Ada.Finalization;

package Conts with SPARK_Mode is

   pragma Pure;

   type Count_Type is range 0 .. 2 ** 31 - 1;
   subtype Positive_Count_Type is Count_Type range 1 .. Count_Type'Last;
   subtype Hash_Type is Ada.Containers.Hash_Type;    --  0 .. 2**32 - 1
   --  Base types for the size of containers, and the hash values used
   --  for some containers. We reuse the same values as for Ada.Containers,
   --  but redefine the type here so that it is possible to change to
   --  other values on specific architectures, for instance, without
   --  breaking code that would assume this Count_Type to always be the
   --  same as Ada.Containers.Count_Type.
   --  For now, various places in the code assume that
   --     Count_Type'Last * 2 <= Hash_Type'Last
   --  since we often cast from the latter to the former to get a greater
   --  range.

   type Controlled_Base is abstract
      new Ada.Finalization.Controlled with null record;
   type Limited_Base is abstract tagged limited null record;
   --  A type that can be used as the root of a container hierarchy when a
   --  container should be limited (and thus prevent its copying).
   --  Other containers will in general derive from
   --  Ada.Finalization.Controlled.

end Conts;
