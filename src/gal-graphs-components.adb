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
with GAL.Vectors.Definite_Unbounded;

package body GAL.Graphs.Components is

   package Roots_Vectors is new GAL.Vectors.Definite_Unbounded
     (Index_Type          => Natural,
      Element_Type        => Integer,
      Container_Base_Type => GAL.Limited_Controlled_Base);
   --  A stack of integers.
   --  For the strongly-connected-components, these are the DFS numbers for
   --  the roots of each SCC.

   ------------------------
   -- Strongly_Connected --
   ------------------------

   package body Strongly_Connected is
      subtype Vertex_Type is Graphs.Vertex;
      subtype Edge_Type is DFS.Incidence.Edge;

      package Vertex_Vectors is new GAL.Vectors.Definite_Unbounded
         (Positive, Vertex_Type, GAL.Limited_Controlled_Base);
      --  A stack of vertices.
      --  Elaborate those when the package is declared (so do not declare them
      --  inside Compute, which would elaborate them when running the
      --  algorithm). Elaboration requires memory allocation (secondary stack).

      --  This algorithm needs multiple pieces of information for each
      --  vertex:
      --     * Whether the node has been visited or not.
      --        unvisited = white color,  visited = gray or black
      --     * whether a node is closed
      --        when it is given a component number, it is closed
      --     * a DFS index (time at which the vertex was discovered)
      --
      --  We combine all of these into a single piece of information, to
      --  make better use of memory cache.
      --  The information is stored in the Components map, with the
      --  following definitions:
      --     * n = 0
      --       The node has not been visited yet.
      --       DFS index unknown, as well as lowlink
      --       Component id unset
      --     * n < 0
      --       Node has been visited. The algorithm does not
      --          need to distinguish gray and black (but then Back_Edge is
      --          the same as Forward_Or_Cross_Edge).
      --       Component id unset
      --       n is the negated DFS index.
      --     * n > 0
      --       Node has been closed
      --       n is the component id
      --
      --  See:
      --    https://people.mpi-inf.mpg.de/~mehlhorn/ftp/EngineeringDFS.pdf

      type SCC_Visitor is record
         Graph      : not null access Graph_Type;
         Components : not null access Component_Maps.Map;

         Roots      : Roots_Vectors.Vector;
         Roots_Top  : Integer;
         --  The roots of the SCC components (their DFS number is enough)

         Open       : Vertex_Vectors.Vector;

         Comp       : Positive := 1; --  current component
         DFS_Index  : Positive := 1; --  current DFS index
      end record;
      procedure Vertices_Initialized
         (Self : in out SCC_Visitor; Count : Count_Type);
      procedure Discover_Vertex
         (Self : in out SCC_Visitor;
          V    : Vertex_Type;
          Stop : in out Boolean);
      procedure Finish_Vertex (Self : in out SCC_Visitor; V : Vertex_Type);
      procedure Back_Edge (Self : in out SCC_Visitor; E : Edge_Type);

      --------------------------
      -- Vertices_Initialized --
      --------------------------

      procedure Vertices_Initialized
        (Self : in out SCC_Visitor; Count : Count_Type) is
      begin
         Self.Roots.Reserve_Capacity (Count_Type'Min (100_000, Count));
         Self.Open.Reserve_Capacity (Count_Type'Min (100_000, Count));
      end Vertices_Initialized;

      ---------------------
      -- Discover_Vertex --
      ---------------------

      procedure Discover_Vertex
         (Self    : in out SCC_Visitor;
          V       : Vertex_Type;
          Stop    : in out Boolean)
      is
         pragma Unreferenced (Stop);
      begin
         Self.Roots_Top := -Self.DFS_Index;
         Component_Maps.Set (Self.Components.all, V, Self.Roots_Top);
         Self.Roots.Append (Self.Roots_Top);
         Self.Open.Append (V);
         Self.DFS_Index := Self.DFS_Index + 1;
      end Discover_Vertex;

      -------------------
      -- Finish_Vertex --
      -------------------

      procedure Finish_Vertex
         (Self : in out SCC_Visitor; V : Vertex_Type)
      is
         V_DFS_Index : constant Integer :=
           Component_Maps.Get (Self.Components.all, V);
      begin
         if V_DFS_Index = Self.Roots_Top then
            Self.Roots.Delete_Last;
            if not Self.Roots.Is_Empty then
               Self.Roots_Top := Self.Roots.Last_Element;
            end if;

            loop
               declare
                  U : constant Vertex_Type := Self.Open.Last_Element;
                  U_Index  : constant Integer :=
                    Component_Maps.Get (Self.Components.all, U);
               begin
                  Self.Open.Delete_Last;
                  Component_Maps.Set (Self.Components.all, U, Self.Comp);
                  exit when U_Index = V_DFS_Index;
               end;
            end loop;

            Self.Comp := Self.Comp + 1;
         end if;
      end Finish_Vertex;

      ---------------
      -- Back_Edge --
      ---------------

      procedure Back_Edge (Self : in out SCC_Visitor; E : Edge_Type) is
         V           : constant Vertex_Type :=
            DFS.Incidence.Edge_Target (DFS.To_Graph (Self.Graph.all).all, E);
         V_DFS_Index : constant Integer :=
            Component_Maps.Get (Self.Components.all, V);
      begin
         --  If V is open
         if V_DFS_Index < 0 then
            while Self.Roots_Top < V_DFS_Index loop
               Self.Roots.Delete_Last;
               Self.Roots_Top := Self.Roots.Last_Element;
            end loop;
         end if;
      end Back_Edge;

      package Visitors is new DFS.DFS_Visitor_Traits
         (Visitor_Type         => SCC_Visitor,
          Vertices_Initialized => Vertices_Initialized,
          Discover_Vertex      => Discover_Vertex,
          Finish_Vertex        => Finish_Vertex,
          Back_Edge            => Back_Edge);
      procedure Search is new DFS.Search (Visitors);

      -------------
      -- Compute --
      -------------

      procedure Compute
        (G                : Graph_Type;
         Components       : out Component_Maps.Map;
         Components_Count : out Natural)
      is
         V : SCC_Visitor :=
            (Graph      => G'Unrestricted_Access,
             Components => Components'Unrestricted_Access,
             others     => <>);
      begin
         Search (G, V);
         Components_Count := V.Comp - 1;
      end Compute;

   end Strongly_Connected;

end GAL.Graphs.Components;
