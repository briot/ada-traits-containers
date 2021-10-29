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
with GAL.Vectors.Definite_Unbounded;

package body GAL.Graphs.DFS is
   use type Vertex_Type;

   type Vertex_Info is record
      VC : Vertex_Type;
      EC : Incidence.Cursor_Type;   --  next edge to examine
   end record;
   package Vertex_Info_Vectors is new GAL.Vectors.Definite_Unbounded
     (Index_Type          => Natural,
      Element_Type        => Vertex_Info,
      Container_Base_Type => GAL.Limited_Base);

   --------------
   -- With_Map --
   --------------

   package body With_Map is

      ------------
      -- Search --
      ------------

      procedure Search
        (G      : Graph_Type;
         Visit  : in out Visitors.Visitor_Type;
         Colors : out Color_Maps.Map;
         V      : Vertex_Type := Graphs.Null_Vertex)
      is
         Stack      : Vertex_Info_Vectors.Vector;
         Terminated : Boolean := False;

         procedure Impl (Start_Vertex : Vertex_Type);

         procedure Impl (Start_Vertex : Vertex_Type) is
            EC   : Incidence.Cursor_Type;
            Info : Vertex_Info;
         begin
            Color_Maps.Set (Colors, Start_Vertex, Gray);
            Visitors.Discover_Vertex (Visit, Start_Vertex);

            Visitors.Should_Stop (Visit, Start_Vertex, Stop => Terminated);
            if Terminated then
               return;
            end if;

            Stack.Append
               ((VC => Start_Vertex,
                 EC => Incidence.Out_Edges (G, Start_Vertex)));

            while not Stack.Is_Empty loop
               Info := Stack.Last_Element;
               Stack.Delete_Last;

               if not Incidence.Has_Element (G, Info.EC) then
                  --  No more out edges
                  Color_Maps.Set (Colors, Info.VC, Black);
                  Visitors.Finish_Vertex (Visit, Info.VC);

               else
                  EC := Info.EC;

                  --  Next time we look at the same vertex, we'll look at
                  --  the next out edge
                  Info.EC := Incidence.Next (G, Info.EC);
                  Stack.Append (Info);

                  --  Append the next vertex to examine (and we need to
                  --  examine it first)

                  declare
                     E      : constant Edge_Type := Incidence.Element (G, EC);
                     Target : constant Vertex_Type := Incidence.Target (G, E);
                  begin
                     Visitors.Examine_Edge (Visit, E);
                     case Color_Maps.Get (Colors, Target) is
                     when White =>
                        Visitors.Tree_Edge (Visit, E);
                        Color_Maps.Set (Colors, Target, Gray);
                        Visitors.Discover_Vertex (Visit, Target);
                        Visitors.Should_Stop
                           (Visit, Target, Stop => Terminated);
                        if Terminated then
                           return;
                        end if;

                        Stack.Append
                           ((VC => Target,
                             EC => Incidence.Out_Edges (G, Target)));

                     when Gray =>
                        Visitors.Back_Edge (Visit, E);

                     when Black =>
                        Visitors.Forward_Or_Cross_Edge (Visit, E);
                     end case;
                  end;
               end if;
            end loop;
         end Impl;

         VC    : Vertex_Lists.Vertex_Cursors.Cursor;
         Count : Count_Type := 0;
      begin
         --  Initialize
         --  ??? Fails if the graph is "infinite" (case of custom graphs)

         VC := Vertex_Lists.Vertex_Cursors.First (G);
         while Vertex_Lists.Vertex_Cursors.Has_Element (G, VC) loop
            Color_Maps.Set
              (Colors, Vertex_Lists.Vertex_Maps.Get (G, VC), White);
            Visitors.Initialize_Vertex
               (Visit, Vertex_Lists.Vertex_Maps.Get (G, VC));
            Count := Count + 1;
            VC := Vertex_Lists.Vertex_Cursors.Next (G, VC);
         end loop;

         Visitors.Vertices_Initialized (Visit, Count);

         --  Preallocate some space, to improve performance
         --  Unless the graph is a tree with depth n, we do not need as many
         --  nodes in the stack as they are elements in the graph. So we use
         --  a number somewhere in between, as an attempt to limit the number
         --  of allocations, and yet not allocating too much memory.
         Stack.Reserve_Capacity (Count_Type'Min (300_000, Count));

         --  Search from the start vertex

         if V /= Graphs.Null_Vertex then
            Visitors.Start_Vertex (Visit, V);
            Impl (V);
         end if;

         --  Search for remaining unvisited vertices

         VC := Vertex_Lists.Vertex_Cursors.First (G);
         while not Terminated
           and then Vertex_Lists.Vertex_Cursors.Has_Element (G, VC)
         loop
            declare
               V : constant Vertex_Type :=
                  Vertex_Lists.Vertex_Maps.Get (G, VC);
            begin
               if Color_Maps.Get (Colors, V) = White then
                  Impl (V);
               end if;
            end;

            VC := Vertex_Lists.Vertex_Cursors.Next (G, VC);
         end loop;

         Stack.Clear;
      end Search;

      ----------------------
      -- Search_Recursive --
      ----------------------

      procedure Search_Recursive
        (G      : Graph_Type;
         Visit  : in out Visitors.Visitor_Type;
         Colors : out Color_Maps.Map;
         V      : Vertex_Type := Graphs.Null_Vertex)
      is
         Terminated : Boolean := False;

         procedure Impl (Current : Vertex_Type);

         procedure Impl (Current : Vertex_Type) is
            EC   : Incidence.Cursor;
         begin
            Color_Maps.Set (Colors, Current, Gray);
            Visitors.Discover_Vertex (Visit, Current);
            Visitors.Should_Stop (Visit, Current, Terminated);
            if not Terminated then
               EC := Incidence.Out_Edges (G, Current);
               while Incidence.Has_Element (G, EC) loop
                  declare
                     E      : Edge_Type renames Incidence.Element (G, EC);
                     Target : constant Vertex_Type := Incidence.Target (G, E);
                  begin
                     Visitors.Examine_Edge (Visit, E);
                     case Color_Maps.Get (Colors, Target) is
                     when White =>
                        Visitors.Tree_Edge (Visit, E);
                        Impl (Target);

                     when Gray =>
                        Visitors.Back_Edge (Visit, E);

                     when Black =>
                        Visitors.Forward_Or_Cross_Edge (Visit, E);
                     end case;
                  end;
                  EC := Incidence.Next (G, EC);
               end loop;
            end if;

            Color_Maps.Set (Colors, Current, Black);
            Visitors.Finish_Vertex (Visit, Current);
         end Impl;

         VC    : Vertex_Lists.Vertex_Cursors.Cursor;
         Count : Count_Type := 0;
      begin
         --  Initialize

         VC := Vertex_Lists.Vertex_Cursors.First (G);
         while Vertex_Lists.Vertex_Cursors.Has_Element (G, VC) loop
            Color_Maps.Set
               (Colors, Vertex_Lists.Vertex_Maps.Get (G, VC), White);
            Visitors.Initialize_Vertex
               (Visit, Vertex_Lists.Vertex_Maps.Get (G, VC));
            Count := Count + 1;
            VC := Vertex_Lists.Vertex_Cursors.Next (G, VC);
         end loop;

         Visitors.Vertices_Initialized (Visit, Count);

         --  Search from the start vertex

         if V /= Graphs.Null_Vertex then
            Visitors.Start_Vertex (Visit, V);
            Impl (V);
         end if;

         --  Search from remaining unvisited vertices

         VC := Vertex_Lists.Vertex_Cursors.First (G);
         while not Terminated
            and then Vertex_Lists.Vertex_Cursors.Has_Element (G, VC)
         loop
            declare
               V : constant Vertex_Type :=
                  Vertex_Lists.Vertex_Maps.Get (G, VC);
            begin
               if Color_Maps.Get (Colors, V) = White then
                  Impl (V);
               end if;
            end;

            VC := Vertex_Lists.Vertex_Cursors.Next (G, VC);
         end loop;
      end Search_Recursive;

      ----------------
      -- Is_Acyclic --
      ----------------

      function Is_Acyclic
        (G       : Graph_Type;
         Colors  : out Color_Maps.Map) return Boolean
      is
         type Visitor_Type is record
            Has_Cycle : Boolean := False;
         end record;

         procedure Back_Edge
           (Self : in out Visitor_Type; Ignored : Edge_Type) with Inline;
         procedure Should_Stop
           (Self : Visitor_Type; Ignored : Vertex_Type;
            Stop : in out Boolean) with Inline;

         procedure Should_Stop
           (Self : Visitor_Type; Ignored : Vertex_Type;
            Stop : in out Boolean) is
         begin
            Stop := Self.Has_Cycle;
         end Should_Stop;

         procedure Back_Edge
            (Self : in out Visitor_Type; Ignored : Edge_Type) is
         begin
            Self.Has_Cycle := True;
         end Back_Edge;

         package Visitors is new DFS_Visitor_Traits
            (Visitor_Type => Visitor_Type,
             Back_Edge    => Back_Edge,
             Should_Stop  => Should_Stop);
         procedure DFS is new Search (Visitors);
         V   : Visitor_Type;
      begin
         DFS (G, V, Colors);
         return not V.Has_Cycle;
      end Is_Acyclic;

      ------------------------------
      -- Reverse_Topological_Sort --
      ------------------------------

      procedure Reverse_Topological_Sort
        (G      : Graph_Type;
         Colors : out Color_Maps.Map)
      is
         type TS_Visitor is null record;
         procedure Back_Edge
           (Ignored  : in out TS_Visitor;
            Ignored2 : Edge_Type) with Inline;
         procedure Finish_Vertex (Ignored : in out TS_Visitor; V : Vertex_Type)
           with Inline;

         procedure Back_Edge
           (Ignored : in out TS_Visitor; Ignored2 : Edge_Type) is
         begin
            raise GAL.Graphs.Graph_Has_Cycles with "Graph is not acyclic";
         end Back_Edge;

         procedure Finish_Vertex
           (Ignored : in out TS_Visitor; V : Vertex_Type) is
         begin
            Callback (V);
         end Finish_Vertex;

         package Visitors is new DFS_Visitor_Traits
            (Visitor_Type  => TS_Visitor,
             Back_Edge     => Back_Edge,
             Finish_Vertex => Finish_Vertex);
         procedure DFS is new Search (Visitors);

         V : TS_Visitor;
      begin
         DFS (G, V, Colors);
      end Reverse_Topological_Sort;

   end With_Map;

   --------------
   -- Exterior --
   --------------

   package body Exterior is
      package Internal is new With_Map (Color_Maps);

      ----------------
      -- Is_Acyclic --
      ----------------

      function Is_Acyclic (G : Graph_Type) return Boolean is
         Acyclic : Boolean;
         Colors  : Color_Maps.Map := Create_Map (G);   --  uninitialized map
      begin
         Acyclic := Internal.Is_Acyclic (G, Colors);
         Color_Maps.Clear (Colors);
         return Acyclic;
      end Is_Acyclic;

      ------------
      -- Search --
      ------------

      procedure Search
        (G     : Graph_Type;
         Visit : in out Visitors.Visitor_Type;
         V     : Vertex_Type := Graphs.Null_Vertex)
      is
         procedure Internal_Search is new Internal.Search (Visitors);
         Colors : Color_Maps.Map := Create_Map (G);   --  uninitialized map
      begin
         Internal_Search (G, Visit, Colors, V);
         Color_Maps.Clear (Colors);
      end Search;

      ----------------------
      -- Search_Recursive --
      ----------------------

      procedure Search_Recursive
        (G     : Graph_Type;
         Visit : in out Visitors.Visitor_Type;
         V     : Vertex_Type := Graphs.Cst_Null_Vertex)
      is
         procedure Internal_Search is new Internal.Search_Recursive (Visitors);
         Colors : Color_Maps.Map := Create_Map (G);   --  uninitialized map
      begin
         Internal_Search (G, Visit, Colors, V);
         Color_Maps.Clear (Colors);
      end Search_Recursive;

      ------------------------------
      -- Reverse_Topological_Sort --
      ------------------------------

      procedure Reverse_Topological_Sort (G : Graph_Type) is
         procedure Internal_Sort is
           new Internal.Reverse_Topological_Sort (Callback);
         Colors : Color_Maps.Map := Create_Map (G);
      begin
         Internal_Sort (G, Colors);
         Color_Maps.Clear (Colors);
      end Reverse_Topological_Sort;
   end Exterior;

   --------------
   -- Interior --
   --------------

   package body Interior is

      package Internal is new With_Map (Color_Maps);

      ----------------
      -- Is_Acyclic --
      ----------------

      function Is_Acyclic (G : in out Graph_Type) return Boolean is
      begin
         return Internal.Is_Acyclic (G, G);
      end Is_Acyclic;

      ------------
      -- Search --
      ------------

      procedure Search
        (G     : in out Graph_Type;
         Visit : in out Visitors.Visitor_Type;
         V     : Vertex_Type := Graphs.Cst_Null_Vertex)
      is
         procedure Internal_Search is new Internal.Search (Visitors);
      begin
         Internal_Search (G, Visit, G, V);
      end Search;

      ----------------------
      -- Search_Recursive --
      ----------------------

      procedure Search_Recursive
        (G     : in out Graph_Type;
         Visit : in out Visitors.Visitor_Type;
         V     : Vertex_Type := Graphs.Cst_Null_Vertex)
      is
         procedure Internal_Search is new Internal.Search_Recursive (Visitors);
      begin
         Internal_Search (G, Visit, G, V);
      end Search_Recursive;

      ------------------------------
      -- Reverse_Topological_Sort --
      ------------------------------

      procedure Reverse_Topological_Sort (G : in out Graph_Type) is
         procedure Internal_Sort is
           new Internal.Reverse_Topological_Sort (Callback);
      begin
         Internal_Sort (G, G);
      end Reverse_Topological_Sort;

   end Interior;

end GAL.Graphs.DFS;
