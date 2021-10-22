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

--  This package describes the underlying storage strategy for a bounded vector

pragma Ada_2012;
with Conts.Elements;

generic
   with package Elements is new Conts.Elements.Traits (<>);

   type Container_Base_Type is abstract tagged limited private;
   --  The base type for the container of nodes.
   --  Since this type is eventually also used as the base type for the list
   --  itself, this is a way to make lists either controlled or limited.

package Conts.Vectors.Storage.Bounded with SPARK_Mode is

   package Impl is
      type Container (Capacity : Count_Type)
         is abstract new Container_Base_Type with private;

      function Max_Capacity (Self : Container'Class) return Count_Type
         is (Self.Capacity) with Inline;
      function Capacity (Self : Container'Class) return Count_Type
         is (Self.Capacity) with Inline;
      procedure Release_Element
        (Self : in out Container'Class; Index : Count_Type) with Inline;
      procedure Set_Element
        (Self    : in out Container'Class;
         Index   : Count_Type;
         Element : Elements.Stored_Type) with Inline;
      function Get_Returned
        (Self  : in out Container'Class;
         Index : Count_Type) return Elements.Returned_Type with Inline;
      function Get_Stored
        (Self  : Container'Class;
         Index : Count_Type) return Elements.Stored_Type with Inline;
      procedure Assign
        (Self        : in out Container'Class;
         Last        : Count_Type;
         Source      : Container'Class;
         Source_Last : Count_Type);
      procedure Copy
        (Self                   : in out Container'Class;
         Source                 : Container'Class;
         Source_From, Source_To : Count_Type;
         Self_From              : Count_Type) with Inline;

   private
      pragma SPARK_Mode (Off);
      type Elem_Array is array (Count_Type range <>)
         of aliased Elements.Stored_Type;

      type Container (Capacity : Count_Type) is
         abstract new Container_Base_Type
      with record
         Nodes : Elem_Array (Min_Index .. Capacity);
      end record;

      function Get_Stored
        (Self  : Container'Class;
         Index : Count_Type) return Elements.Stored_Type
         is (Self.Nodes (Index));
      function Get_Returned
        (Self  : in out Container'Class;
         Index : Count_Type) return Elements.Returned_Type
         is (Elements.To_Returned (Self.Nodes (Index)'Access));
   end Impl;

   package Traits is new Conts.Vectors.Storage.Traits
     (Elements        => Elements,
      Container       => Impl.Container,
      Max_Capacity    => Impl.Max_Capacity,
      Capacity        => Impl.Capacity,
      Release_Element => Impl.Release_Element,
      Set_Element     => Impl.Set_Element,
      Get_Returned    => Impl.Get_Returned,
      Get_Stored      => Impl.Get_Stored,
      Assign          => Impl.Assign,
      Copy            => Impl.Copy);

end Conts.Vectors.Storage.Bounded;
