------------------------------------------------------------------------------
--                     Copyright (C) 2016-2016, AdaCore                     --
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
with GAL.Graphs.DFS;
with GAL.Properties;

package GAL.Graphs.Components is

   generic
      with package DFS is new GAL.Graphs.DFS (<>);
      with package Component_Maps is new GAL.Properties.Maps
        (Key_Type     => DFS.Graphs.Vertex,
         Element_Type => Integer,
         others       => <>);
      --  The result is a map from vertex to the component it belongs to

   package Strongly_Connected is
      package Graphs renames DFS.Graphs;
      subtype Graph_Type is DFS.Graph_Type;

      procedure Compute
        (G                : Graph_Type;
         Components       : out Component_Maps.Map;
         Components_Count : out Natural);
      --  Compute the strongly components of the graph:
      --  These are maximal sets of vertices such that for every pair of
      --  vertices u and v in the set, there exists a path from u to v and
      --  a path from v to u.
      --  Each vertex belongs to one, and only one, such component. This
      --  algorithm sets the index of that component in the Components map,
      --  and returns the number of components that were found. In the
      --  Components, the indexes are in the range 1 .. Components_Count.
      --
      --  Components must have been initialized first (so that it has enough
      --  entries for all vertices).
      --
      --  Each vertex that is not part of a vertex forms its own component.
      --
      --  The implementation uses the Cheriyan-Mehlhorn-Gabow algorithm.
      --  Complexity is O( |edges| + |vertices| )

   end Strongly_Connected;

end GAL.Graphs.Components;
