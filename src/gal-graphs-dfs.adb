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
      V  : Vertex_Type;
      EC : Incidence.Cursor_Type;   --  next edge to examine
      E  : Edge_Type;               --  edge that led to that vertex
   end record;
   package Vertex_Info_Vectors is new GAL.Vectors.Definite_Unbounded
     (Index_Type          => Natural,
      Element_Type        => Vertex_Info,
      Container_Base_Type => GAL.Limited_Controlled_Base);

   generic
      with package Visitors is new DFS_Visitor_Traits (others => <>);
      with function Impl
         (G       : Vertex_Lists.Graphs.Graph_Type;
          Visit   : in out Visitors.Visitor_Type;
          Colors  : in out Color_Maps.Map;
          Current : Vertex_Type) return Boolean;
      --  Returns True if user asked to stop
   procedure Explore
     (G      : Vertex_Lists.Graphs.Graph_Type;
      Colors : in out Color_Maps.Map;
      Visit  : in out Visitors.Visitor_Type;
      Source : Vertex_Type := Graphs.Null_Vertex);

   -------------
   -- Explore --
   -------------

   procedure Explore
     (G      : Vertex_Lists.Graphs.Graph_Type;
      Colors : in out Color_Maps.Map;
      Visit  : in out Visitors.Visitor_Type;
      Source : Vertex_Type := Graphs.Null_Vertex)
   is
      Count   : constant Count_Type := Vertex_Lists.Length (G);
      VC      : Vertex_Lists.Vertex_Cursors.Cursor;
      Current : Vertex_Type;
   begin
      if Count = 0 then
         return;
      end if;

      VC := Vertex_Lists.Vertex_Cursors.First (G);
      while Vertex_Lists.Vertex_Cursors.Has_Element (G, VC) loop
         Visitors.Initialize_Vertex
            (Visit, Vertex_Lists.Vertex_Maps.Get (G, VC));
         Vertex_Lists.Vertex_Cursors.Next (G, VC);
      end loop;

      Visitors.Vertices_Initialized (Visit, Count);

      --  Search from the start vertex if one was provided
      VC := Vertex_Lists.Vertex_Cursors.First (G);
      if Source = Graphs.Null_Vertex then
         Current := Vertex_Lists.Vertex_Maps.Get (G, VC);
         Vertex_Lists.Vertex_Cursors.Next (G, VC);
      else
         Current := Source;
      end if;

      loop
         if Color_Maps.Get (Colors, Current) = White then
            Visitors.Start_Vertex (Visit, Current);
            if Impl (G, Visit, Colors, Current) then
               return;
            end if;
         end if;

         exit when not Vertex_Lists.Vertex_Cursors.Has_Element (G, VC);
         Current := Vertex_Lists.Vertex_Maps.Get (G, VC);
         Vertex_Lists.Vertex_Cursors.Next (G, VC);
      end loop;
   end Explore;

   ------------------------
   -- Depth_First_Search --
   ------------------------

   procedure Depth_First_Search
     (G      : Graph_Type;
      Visit  : in out Visitors.Visitor_Type;
      Source : Vertex_Type := Graphs.Null_Vertex)
   is
      Stack   : Vertex_Info_Vectors.Vector;

      function Impl
         (G       : Vertex_Lists.Graphs.Graph_Type;
          Visit   : in out Visitors.Visitor_Type;
          Colors  : in out Color_Maps.Map;
          Current : Vertex_Type)
         return Boolean;
      function Impl
         (G       : Vertex_Lists.Graphs.Graph_Type;
          Visit   : in out Visitors.Visitor_Type;
          Colors  : in out Color_Maps.Map;
          Current : Vertex_Type)
         return Boolean
      is
         E    : Edge_Type;
         Stop : Boolean := False;
      begin
         Color_Maps.Set (Colors, Current, Gray);
         Visitors.Discover_Vertex (Visit, Current, Stop => Stop);
         if Stop then
            return True;
         end if;

         Stack.Append
            ((V        => Current,
              E        => <>,
              EC       => Incidence.Out_Edges (G, Current)));

         while not Stack.Is_Empty loop
            declare
               Info : constant Vertex_Info := Stack.Element (Stack.Last);
               U  : Vertex_Type := Info.V;
               V  : Vertex_Type;
               EC : Incidence.Cursor_Type := Info.EC;
            begin
               Stack.Delete_Last;

               --  There is no edge leading to `Current`, which is a source
               if U /= Current then
                  Visitors.Finish_Edge (Visit, Info.E);
               end if;

               --  This loop avoids manipulating the stack for every vertex
               --  and edge. Instead, we optimize by going as deep as we
               --  can while only appending to the stack, not retrieving the
               --  last element.

               while Incidence.Has_Element (G, EC) loop
                  E   := Incidence.Element (G, EC);
                  V   := Incidence.Target (G, E);
                  Visitors.Examine_Edge (Visit, E);

                  case Color_Maps.Get (Colors, V) is
                  when White =>
                     Visitors.Tree_Edge (Visit, E);
                     Incidence.Next (G, EC);
                     Stack.Append
                        ((V        => U,
                          E        => E,
                          EC       => EC));

                     U := V;
                     Color_Maps.Set (Colors, U, Gray);
                     Visitors.Discover_Vertex (Visit, U, Stop => Stop);
                     if Stop then
                        return True;
                     end if;

                     EC := Incidence.Out_Edges (G, U);

                  when Gray =>
                     Visitors.Back_Edge (Visit, E);
                     Visitors.Finish_Edge (Visit, E);
                     Incidence.Next (G, EC);

                  when Black =>
                     Visitors.Forward_Or_Cross_Edge (Visit, E);
                     Visitors.Finish_Edge (Visit, E);
                     Incidence.Next (G, EC);
                  end case;
               end loop;

               Color_Maps.Set (Colors, U, Black);
               Visitors.Finish_Vertex (Visit, U);
            end;
         end loop;
         return False;
      end Impl;

      procedure Expl is new Explore (Visitors, Impl);
      Colors  : Color_Maps.Map := Create_Color_Map (G, Default_Value => White);
   begin
      --  Preallocate some space, to improve performance
      --  Unless the graph is a tree with depth n, we do not need as many
      --  nodes in the stack as they are elements in the graph. So we use
      --  a number somewhere in between, as an attempt to limit the number
      --  of allocations, and yet not allocating too much memory.
      Stack.Reserve_Capacity
         (Count_Type'Min (100_000, Vertex_Lists.Length (To_Graph (G).all)));

      Expl (To_Graph (G).all, Colors, Visit, Source);
   end Depth_First_Search;

   ----------------------------------
   -- Depth_First_Search_Recursive --
   ----------------------------------

   procedure Depth_First_Search_Recursive
     (G      : Graph_Type;
      Visit  : in out Visitors.Visitor_Type;
      Source : Vertex_Type := Graphs.Null_Vertex)
   is
      Stop   : Boolean := False;

      function Impl
         (G       : Vertex_Lists.Graphs.Graph_Type;
          Visit   : in out Visitors.Visitor_Type;
          Colors  : in out Color_Maps.Map;
          Current : Vertex_Type)
         return Boolean;
      function Impl
         (G       : Vertex_Lists.Graphs.Graph_Type;
          Visit   : in out Visitors.Visitor_Type;
          Colors  : in out Color_Maps.Map;
          Current : Vertex_Type)
         return Boolean
      is
         EC   : Incidence.Cursor;
      begin
         Color_Maps.Set (Colors, Current, Gray);
         Visitors.Discover_Vertex (Visit, Current, Stop);
         if Stop then
            return True;
         else
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
                     if Impl (G, Visit, Colors, Target) then
                        return True;
                     end if;

                  when Gray =>
                     Visitors.Back_Edge (Visit, E);

                  when Black =>
                     Visitors.Forward_Or_Cross_Edge (Visit, E);
                  end case;

                  Visitors.Finish_Edge (Visit, E);
               end;
               Incidence.Next (G, EC);
            end loop;

            Color_Maps.Set (Colors, Current, Black);
            Visitors.Finish_Vertex (Visit, Current);
            return False;
         end if;
      end Impl;

      procedure Expl is new Explore (Visitors, Impl);
      Colors  : Color_Maps.Map := Create_Color_Map (G, Default_Value => White);
   begin
      Expl (To_Graph (G).all, Colors, Visit, Source);
   end Depth_First_Search_Recursive;

   ----------------
   -- Is_Acyclic --
   ----------------

   function Is_Acyclic (G : Graph_Type) return Boolean is
      type Visitor_Type is record
         Has_Cycle : Boolean := False;
      end record;

      procedure Back_Edge
        (Self : in out Visitor_Type; Ignored : Edge_Type) with Inline;
      procedure Discover_Vertex
        (Self    : in out Visitor_Type;
         Ignored : Vertex_Type;
         Stop    : in out Boolean) with Inline;

      procedure Discover_Vertex
        (Self    : in out Visitor_Type;
         Ignored : Vertex_Type;
         Stop    : in out Boolean) is
      begin
         Stop := Self.Has_Cycle;
      end Discover_Vertex;

      procedure Back_Edge
         (Self : in out Visitor_Type; Ignored : Edge_Type) is
      begin
         Self.Has_Cycle := True;
      end Back_Edge;

      package Visitors is new DFS_Visitor_Traits
         (Visitor_Type    => Visitor_Type,
          Back_Edge       => Back_Edge,
          Discover_Vertex => Discover_Vertex);
      procedure DFS is new Depth_First_Search (Visitors);
      V   : Visitor_Type;
   begin
      DFS (G, V);
      return not V.Has_Cycle;
   end Is_Acyclic;

   ------------------------------
   -- Reverse_Topological_Sort --
   ------------------------------

   procedure Reverse_Topological_Sort (G : Graph_Type) is
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
      procedure DFS is new Depth_First_Search (Visitors);

      V : TS_Visitor;
   begin
      DFS (G, V);
   end Reverse_Topological_Sort;

end GAL.Graphs.DFS;
