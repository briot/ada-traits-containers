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
with Conts.Cursors;
with Conts.Properties;

package Conts.Algorithms is

   pragma Pure;

   -------------
   -- Subsets --
   -------------
   --  This package can be used to manipulate subsets of containers in the
   --  algorithms.
   --  It has the same formal parameters as a sort algorithm, so that you can
   --  more easily sort only a range.

   generic
      with package Base_Cursors is
        new Conts.Cursors.Random_Access_Cursors (<>);
      with package Base_Getters is new Conts.Properties.Read_Only_Maps
        (Map_Type => Base_Cursors.Container,
         Key_Type => Base_Cursors.Index,
         others   => <>);
      with procedure Base_Swap
        (Self        : in out Base_Cursors.Container;
         Left, Right : Base_Cursors.Index) is <>;
   package Ranged_Random_Access_Cursors is
      type Rg is record
         Base     : not null access Base_Cursors.Container;
         From, To : Base_Cursors.Index;
      end record;

      function Subset
        (Self     : not null access Base_Cursors.Container;
         From, To : Base_Cursors.Index)
         return Rg
      is (Base => Self, From => From, To => To);
      --  Maps a subset of a container, [From..To].
      --  The result is only valid while Self itself is valid, since no copy
      --  is made. The subset works on Self's data directly.

      function First (Self : Rg) return Base_Cursors.Index is (Self.From);
      function Last (Self : Rg) return Base_Cursors.Index is (Self.To);

      package Cursors is new Conts.Cursors.Random_Access_Cursors
        (Container_Type     => Rg,
         Index_Type         => Base_Cursors.Index,
         No_Element         => Base_Cursors.No_Element,
         First              => First,
         Last               => Last,
         Distance           => Base_Cursors.Distance,
         "+"                => Base_Cursors."+");

      function Get (M : Rg; K : Cursors.Index) return Base_Getters.Element
      is (Base_Getters.Get (M.Base.all, K));

      package Getters is new Conts.Properties.Read_Only_Maps
        (Map_Type           => Rg,
         Key_Type           => Cursors.Index,
         Element_Type       => Base_Getters.Element,
         Get                => Get);

      procedure Swap (Self : in out Rg; Left, Right :  Cursors.Index)
        with Inline, Global => null;
   end Ranged_Random_Access_Cursors;

end Conts.Algorithms;
