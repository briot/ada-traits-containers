------------------------------------------------------------------------------
--                     Copyright (C) 2016, AdaCore                          --
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

package body Conts.Graphs is

   ----------------------------
   -- Incidence_Graph_Traits --
   ----------------------------

   package body Incidence_Graph_Traits is

      --------------------------
      -- Default_Start_Vertex --
      --------------------------

      function Default_Start_Vertex (G : Graph) return Vertex is
         C : constant Vertices.Cursor := Vertices.First (G);
      begin
         if Vertices.Has_Element (G, C) then
            return Vertices.Element (G, C);
         else
            return Graphs.Null_Vertex;
         end if;
      end Default_Start_Vertex;

   end Incidence_Graph_Traits;

end Conts.Graphs;