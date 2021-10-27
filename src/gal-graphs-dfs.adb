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

   --------------
   -- With_Map --
   --------------

   package body With_Map is
      use Graphs;

      type Vertex_Info is record
         VC : aliased Graphs.Vertices.Stored_Type;
         EC : Graphs.Out_Edges_Cursors.Cursor;  --  next edge to examine
      end record;
      procedure Free (Self : in out Vertex_Info) with Inline;
      package Vertex_Info_Vectors is new GAL.Vectors.Definite_Unbounded
        (Index_Type          => Natural,
         Element_Type        => Vertex_Info,
         Container_Base_Type => GAL.Limited_Base,
         Free                => Free);

      ----------
      -- Free --
      ----------

      procedure Free (Self : in out Vertex_Info) is
      begin
         Graphs.Vertices.Release (Self.VC);
      end Free;

      ------------
      -- Search --
      ------------

      procedure Search
        (G      : Graphs.Graph;
         Visit  : in out Visitors.Visitor_Type;
         Colors : out Color_Maps.Map;
         V      : Graphs.Vertex := Graphs.Null_Vertex)
      is
         use Graphs;

         Stack      : Vertex_Info_Vectors.Vector;
         Terminated : Boolean := False;

         procedure Impl (Start : Vertex);

         procedure Impl (Start : Vertex) is
            EC   : Graphs.Out_Edges_Cursors.Cursor;
            Info : Vertex_Info;
         begin
            Color_Maps.Set (Colors, Start, Gray);
            Visitors.Discover_Vertex (Visit, Start);

            Visitors.Should_Stop (Visit, Start, Stop => Terminated);
            if Terminated then
               return;
            end if;

            declare
               V : Vertex_Info := (
                  VC => <>,
                  EC => Graphs.Out_Edges_Cursors.First (G, Start));
            begin
               Graphs.Vertices.Set_Stored (Start, V.VC);
               Stack.Append (V);
            end;

            while not Stack.Is_Empty loop
               Info := Stack.Last_Element;
               Stack.Delete_Last;

               if not Graphs.Out_Edges_Cursors.Has_Element (G, Info.EC) then
                  --  No more out edges
                  declare
                     V : Vertex renames
                       Graphs.Vertices.To_Element
                         (Graphs.Vertices.To_Constant_Returned
                            (Info.VC'Access));
                  begin
                     Color_Maps.Set (Colors, V, Black);
                     Visitors.Finish_Vertex (Visit, V);
                  end;

               else
                  EC := Info.EC;

                  --  Next time we look at the same vertex, we'll look at
                  --  the next out edge
                  Info.EC := Graphs.Out_Edges_Cursors.Next (G, Info.EC);
                  Stack.Append (Info);

                  --  Append the next vertex to examine (and we need to
                  --  examine it first)

                  declare
                     E  : constant Edge :=
                       Graphs.Out_Edges_Cursors.Element (G, EC);

                     --  ??? Might be using secondary stack
                     Target : constant Vertex := Get_Target (G, E);
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

                        declare
                           V : Vertex_Info :=
                              (VC => <>,
                               EC =>
                                  Graphs.Out_Edges_Cursors.First (G, Target));
                        begin
                           Graphs.Vertices.Set_Stored (Target, V.VC);
                           Stack.Append (V);
                        end;

                     when Gray =>
                        Visitors.Back_Edge (Visit, E);

                     when Black =>
                        Visitors.Forward_Or_Cross_Edge (Visit, E);
                     end case;
                  end;
               end if;
            end loop;
         end Impl;

         use type Vertex;

         VC    : Graphs.Vertex_Cursors.Cursor;
         Count : Count_Type := 0;
      begin
         --  Initialize

         VC := Graphs.Vertex_Cursors.First (G);
         while Graphs.Vertex_Cursors.Has_Element (G, VC) loop
            Color_Maps.Set
              (Colors, Graphs.Vertex_Maps.Get (G, VC), White);
            Visitors.Initialize_Vertex (Visit, Graphs.Vertex_Maps.Get (G, VC));
            Count := Count + 1;
            VC := Graphs.Vertex_Cursors.Next (G, VC);
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

         VC := Vertex_Cursors.First (G);
         while not Terminated
           and then Vertex_Cursors.Has_Element (G, VC)
         loop
            if Color_Maps.Get (Colors, Vertex_Maps.Get (G, VC)) = White then
               Impl (Vertex_Maps.Get (G, VC));
            end if;

            VC := Vertex_Cursors.Next (G, VC);
         end loop;

         Stack.Clear;
      end Search;

      ----------------------
      -- Search_Recursive --
      ----------------------

      procedure Search_Recursive
        (G      : Graphs.Graph;
         Visit  : in out Visitors.Visitor_Type;
         Colors : out Color_Maps.Map;
         V      : Graphs.Vertex := Graphs.Null_Vertex)
      is
         use Graphs;

         Terminated : Boolean := False;

         procedure Impl (Current : Vertex);

         procedure Impl (Current : Vertex) is
            EC   : Out_Edges_Cursors.Cursor;
         begin
            Color_Maps.Set (Colors, Current, Gray);
            Visitors.Discover_Vertex (Visit, Current);
            Visitors.Should_Stop (Visit, Current, Terminated);
            if not Terminated then
               EC := Out_Edges_Cursors.First (G, Current);
               while Out_Edges_Cursors.Has_Element (G, EC) loop
                  declare
                     E      : Edge renames Out_Edges_Cursors.Element (G, EC);
                     Target : constant Vertex := Get_Target (G, E);
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
                  EC := Out_Edges_Cursors.Next (G, EC);
               end loop;
            end if;

            Color_Maps.Set (Colors, Current, Black);
            Visitors.Finish_Vertex (Visit, Current);
         end Impl;

         use type Vertex;

         VC    : Vertex_Cursors.Cursor;
         Count : Count_Type := 0;
      begin
         --  Initialize

         VC := Vertex_Cursors.First (G);
         while Vertex_Cursors.Has_Element (G, VC) loop
            Color_Maps.Set (Colors, Vertex_Maps.Get (G, VC), White);
            Visitors.Initialize_Vertex (Visit, Vertex_Maps.Get (G, VC));
            Count := Count + 1;
            VC := Vertex_Cursors.Next (G, VC);
         end loop;

         Visitors.Vertices_Initialized (Visit, Count);

         --  Search from the start vertex

         if V /= Graphs.Null_Vertex then
            Visitors.Start_Vertex (Visit, V);
            Impl (V);
         end if;

         --  Search from remaining unvisited vertices

         VC := Vertex_Cursors.First (G);
         while not Terminated and then Vertex_Cursors.Has_Element (G, VC) loop
            if Color_Maps.Get (Colors, Vertex_Maps.Get (G, VC)) = White then
               Impl (Vertex_Maps.Get (G, VC));
            end if;

            VC := Vertex_Cursors.Next (G, VC);
         end loop;
      end Search_Recursive;

      ----------------
      -- Is_Acyclic --
      ----------------

      function Is_Acyclic
        (G       : Graphs.Graph;
         Colors  : out Color_Maps.Map) return Boolean
      is
         use Graphs;
         type Visitor_Type is record
            Has_Cycle : Boolean := False;
         end record;

         procedure Back_Edge
           (Self : in out Visitor_Type; Ignored : Edge) with Inline;
         procedure Should_Stop
           (Self : Visitor_Type; Ignored : Graphs.Vertices.Element;
            Stop : in out Boolean) with Inline;

         procedure Should_Stop
           (Self : Visitor_Type; Ignored : Graphs.Vertices.Element;
            Stop : in out Boolean) is
         begin
            Stop := Self.Has_Cycle;
         end Should_Stop;

         procedure Back_Edge
            (Self : in out Visitor_Type; Ignored : Edge) is
         begin
            Self.Has_Cycle := True;
         end Back_Edge;

         package Visitors is new DFS_Visitor_Traits
            (Graphs       => Graphs,
             Visitor_Type => Visitor_Type,
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
        (G      : Graphs.Graph;
         Colors : out Color_Maps.Map)
      is
         type TS_Visitor is null record;
         procedure Back_Edge
           (Ignored  : in out TS_Visitor;
            Ignored2 : Graphs.Edge) with Inline;
         procedure Finish_Vertex
           (Ignored : in out TS_Visitor; V : Graphs.Vertex)
           with Inline;

         procedure Back_Edge
           (Ignored : in out TS_Visitor; Ignored2 : Graphs.Edge) is
         begin
            raise GAL.Graphs.Graph_Has_Cycles with "Graph is not acyclic";
         end Back_Edge;

         procedure Finish_Vertex
           (Ignored : in out TS_Visitor; V : Graphs.Vertex) is
         begin
            Callback (V);
         end Finish_Vertex;

         package Visitors is new DFS_Visitor_Traits
            (Graphs        => Graphs,
             Visitor_Type  => TS_Visitor,
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
      package Internal is new With_Map (Graphs, Color_Maps);

      ----------------
      -- Is_Acyclic --
      ----------------

      function Is_Acyclic (G : Graphs.Graph) return Boolean is
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
        (G     : Graphs.Graph;
         Visit : in out Visitors.Visitor_Type;
         V     : Graphs.Vertex := Graphs.Null_Vertex)
      is
         procedure Internal_Search is new Internal.Search (Visitors);
         Colors : Color_Maps.Map := Create_Map (G);   --  uninitialized map
      begin
         Internal_Search (G, Visit, Colors, V);
         Color_Maps.Clear (Colors);
      end Search;

      ------------------------------
      -- Reverse_Topological_Sort --
      ------------------------------

      procedure Reverse_Topological_Sort (G : Graphs.Graph) is
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

      package Internal is new With_Map (Graphs, Color_Maps);

      ----------------
      -- Is_Acyclic --
      ----------------

      function Is_Acyclic (G : in out Graphs.Graph) return Boolean is
      begin
         return Internal.Is_Acyclic (G, G);
      end Is_Acyclic;

      ------------
      -- Search --
      ------------

      procedure Search
        (G     : in out Graphs.Graph;
         Visit : in out Visitors.Visitor_Type;
         V     : Graphs.Vertex := Graphs.Cst_Null_Vertex)
      is
         procedure Internal_Search is new Internal.Search (Visitors);
      begin
         Internal_Search (G, Visit, G, V);
      end Search;

      ----------------------
      -- Search_Recursive --
      ----------------------

      procedure Search_Recursive
        (G     : in out Graphs.Graph;
         Visit : in out Visitors.Visitor_Type;
         V     : Graphs.Vertex := Graphs.Cst_Null_Vertex)
      is
         procedure Internal_Search is new Internal.Search_Recursive (Visitors);
      begin
         Internal_Search (G, Visit, G, V);
      end Search_Recursive;

      ------------------------------
      -- Reverse_Topological_Sort --
      ------------------------------

      procedure Reverse_Topological_Sort (G : in out Graphs.Graph) is
         procedure Internal_Sort is
           new Internal.Reverse_Topological_Sort (Callback);
      begin
         Internal_Sort (G, G);
      end Reverse_Topological_Sort;

   end Interior;

end GAL.Graphs.DFS;
