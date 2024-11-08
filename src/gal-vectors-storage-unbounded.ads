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

--  This package describes the underlying storage strategy for a vector.
--  There are mostly two such strategies (bounded and unbounded) depending on
--  whether the vector has a maximal number of elements.

pragma Ada_2012;
with GAL.Elements;

generic
   with package Elements is new GAL.Elements.Traits (<>);
   type Container_Base_Type is abstract tagged limited private;
   with package Resize_Policy is new GAL.Vectors.Resize_Strategy (<>);
package GAL.Vectors.Storage.Unbounded with SPARK_Mode is

   package Impl with SPARK_Mode is
      type Container is abstract new Container_Base_Type with private;

      function Max_Capacity (Self_Ignored : Container'Class) return Count_Type
         is (Count_Type'Last - Min_Index + 1) with Inline;
      function Capacity (Self : Container'Class) return Count_Type
         with Inline;
      procedure Release_Element
        (Self : in out Container'Class; Index : Count_Type) with Inline;
      function Get_RO_Stored
        (Self  : aliased Container'Class;
         Index : Count_Type)
        return not null access constant Elements.Stored_Type
        with Inline;
      function Get_RW_Stored
        (Self  : in out Container'Class;
         Index : Count_Type)
        return not null access Elements.Stored_Type
        with Inline;
      function Get_Returned
        (Self  : in out Container'Class;
         Index : Count_Type) return Elements.Returned_Type with Inline;
      procedure Copy
        (Self                   : in out Container'Class;
         Source                 : Container'Class;
         Source_From, Source_To : Count_Type;
         Self_From              : Count_Type) with Inline;
      procedure Assign
        (Self        : in out Container'Class;
         Last        : Count_Type;
         Source      : Container'Class;
         Source_Last : Count_Type);
      procedure Clone
        (Self        : in out Container'Class;
         Last        : Count_Type);
      procedure Resize
        (Self     : in out Container'Class;
         New_Size : Count_Type;
         Last     : Count_Type;
         Force    : Boolean)
        with Pre => New_Size <= Self.Max_Capacity;
      procedure Release (Self : in out Container'Class);
      procedure Swap_In_Storage
        (Self        : in out Container'Class;
         Left, Right : Count_Type);

   private
      pragma SPARK_Mode (Off);
      type Big_Nodes_Array is
        array (Min_Index .. Count_Type'Last) of aliased Elements.Stored_Type;
      type Nodes_Array_Access is access Big_Nodes_Array;
      for Nodes_Array_Access'Storage_Size use 0;
      --  The nodes is a C-compatible pointer so that we can use realloc

      type Container is abstract new Container_Base_Type with record
         Nodes : Nodes_Array_Access;

         Capacity : Count_Type := 0;
         --  Last element in Nodes (since Nodes does not contain bounds
         --  information).
      end record;

      function Capacity (Self : Container'Class) return Count_Type
        is (Self.Capacity);
      function Get_RO_Stored
        (Self  : aliased Container'Class;
         Index : Count_Type)
        return not null access constant Elements.Stored_Type
        is (Self.Nodes (Index)'Access);
      function Get_RW_Stored
        (Self  : in out Container'Class;
         Index : Count_Type)
        return not null access Elements.Stored_Type
        is (Self.Nodes (Index)'Access);
      function Get_Returned
        (Self  : in out Container'Class;
         Index : Count_Type) return Elements.Returned_Type
        is (Elements.To_Returned (Self.Nodes (Index)'Access));
   end Impl;

   package Traits is new GAL.Vectors.Storage.Traits
     (Elements        => Elements,
      Container       => Impl.Container,
      Max_Capacity    => Impl.Max_Capacity,
      Capacity        => Impl.Capacity,
      Resize          => Impl.Resize,
      Release_Element => Impl.Release_Element,
      Release         => Impl.Release,
      Get_Returned    => Impl.Get_Returned,
      Get_RO_Stored   => Impl.Get_RO_Stored,
      Get_RW_Stored   => Impl.Get_RW_Stored,
      Assign          => Impl.Assign,
      Clone           => Impl.Clone,
      Swap_In_Storage => Impl.Swap_In_Storage,
      Copy            => Impl.Copy);

end GAL.Vectors.Storage.Unbounded;
