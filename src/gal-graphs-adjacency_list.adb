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

--  A graph data structure implemented as an adjacency list.
--  It stores a sequence of out-edges for each vertex.
--  This package lets users decide whether to use lists, vectors, or other
--  types of sequences for vertices and their edges.

pragma Ada_2012;

package body GAL.Graphs.Adjacency_List is

   ----------
   -- Impl --
   ----------

   package body Impl is

      -----------
      -- Clear --
      -----------

      procedure Clear (Self : in out Graph) is
      begin
         Self.Edges.Clear;
         Self.Vertices.Clear;
      end Clear;

      --------------
      -- Finalize --
      --------------

      procedure Finalize (Self : in out Graph) is
      begin
         Self.Clear;
      end Finalize;

      ------------
      -- Adjust --
      ------------

      procedure Adjust (Self : in out Graph) is
      begin
         raise Program_Error with "Adjust not implemented for graphs";
      end Adjust;

      ----------------
      -- Add_Vertex --
      ----------------

      function Add_Vertex (Self : in out Graph) return Vertex is
      begin
         Self.Vertices.Append
            (Vertex_Details_Type'(Props => <>, Out_Edges => <>));
         return Vertex (Self.Vertices.Last);
      end Add_Vertex;

      ------------------
      -- Add_Vertices --
      ------------------

      procedure Add_Vertices (Self : in out Graph; Count : Count_Type) is
         V : Vertex_Details_Type;
      begin
         Self.Vertices.Append (V, Count => Count);
      end Add_Vertices;

      ----------------
      -- Add_Vertex --
      ----------------

      function Add_Vertex
         (Self  : in out Graph;
          Props : Vertex_Properties.Element) return Vertex
      is
         V : Vertex_Details_Type;
      begin
         Vertex_Properties.Set_Stored (Props, V.Props);
         Self.Vertices.Append (V);
         return Vertex (Self.Vertices.Last);
      end Add_Vertex;

      ---------
      -- Set --
      ---------

      procedure Set
         (Self  : in out Graph;
          V     : Vertex;
          Props : Vertex_Properties.Element) is
      begin
         --  ??? What happens if it was never initialized by Add_Vertex
         Vertex_Properties.Release
            (Self.Vertices.Reference (Vertex_Index (V)).Props);
         Vertex_Properties.Set_Stored
            (Props, Self.Vertices.Reference (Vertex_Index (V)).Props);
      end Set;

      --------------
      -- Add_Edge --
      --------------

      function Add_Edge (Self : in out Graph; From, To : Vertex) return Edge is
         D : Edge_Details_Type :=
            (From  => Vertex_Index (From),
             To    => Vertex_Index (To),
             Props => <>);  --  Uninitialized
      begin
         Self.Edges.Append (D);

         return E : constant Edge := (Current => Self.Edges.Last) do
            Self.Vertices.Reference (Vertex_Index (From)).Out_Edges.Append (E);
         end return;
      end Add_Edge;

      function Add_Edge
         (Self     : in out Graph;
          From, To : Vertex;
          Props    : Edge_Properties.Element) return Edge
      is
         D : Edge_Details_Type :=
            (From  => Vertex_Index (From),
             To    => Vertex_Index (To),
             Props => <>);
      begin
         Edge_Properties.Set_Stored (Props, D.Props);
         Self.Edges.Append (D);

         return E : constant Edge := (Current => Self.Edges.Last) do
            Self.Vertices.Reference (Vertex_Index (From)).Out_Edges.Append (E);
         end return;
      end Add_Edge;

      --------------
      -- Add_Edge --
      --------------

      procedure Add_Edge (Self : in out Graph; From, To : Vertex) is
         Ignored : Edge;
      begin
         Ignored := Add_Edge (Self, From, To);
      end Add_Edge;

      ---------
      -- Set --
      ---------

      procedure Set
         (Self  : in out Graph;
          E     : Edge;
          Props : Edge_Properties.Element) is
      begin
         --  ??? What happens if it was never initialized by Add_Edge
         Edge_Properties.Release (Self.Edges.Reference (E.Current).Props);
         Edge_Properties.Set_Stored
            (Props, Self.Edges.Reference (E.Current).Props);
      end Set;

      ------------
      -- Length --
      ------------

      function Length (Self : Graph) return Count_Type is
      begin
         return Self.Vertices.Length;
      end Length;

      ----------------
      -- Get_Source --
      ----------------

      function Get_Source (G : Graph; E : Edge) return Vertex is
      begin
         return Vertex (G.Edges.Constant_Reference (E.Current).From);
      end Get_Source;

      ----------------
      -- Get_Target --
      ----------------

      function Get_Target (G : Graph; E : Edge) return Vertex is
      begin
         return Vertex (G.Edges.Constant_Reference (E.Current).To);
      end Get_Target;

      -----------
      -- First --
      -----------

      function First (G : Graph) return Vertex_Cursor is
      begin
         return (Current => G.Vertices.First);
      end First;

      -------------
      -- Element --
      -------------

      function Element (G : Graph; C : Vertex_Cursor) return Vertex is
         pragma Unreferenced (G);
      begin
         return Vertex (C.Current);
      end Element;

      -----------------
      -- Has_Element --
      -----------------

      function Has_Element (G : Graph; C : Vertex_Cursor) return Boolean is
      begin
         return G.Vertices.Has_Element (C.Current);
      end Has_Element;

      ----------
      -- Next --
      ----------

      function Next (G : Graph; C : Vertex_Cursor) return Vertex_Cursor is
      begin
         return (Current => G.Vertices.Next (C.Current));
      end Next;

      ---------------
      -- Out_Edges --
      ---------------

      function Out_Edges (G : Graph; V : Vertex) return Vertex_Edges_Cursor is
      begin
         return
            (Current => G.Vertices.Element (Vertex_Index (V)).Out_Edges.First,
             From    => Vertex_Index (V));
      end Out_Edges;

      -------------
      -- Element --
      -------------

      function Element (G : Graph; C : Vertex_Edges_Cursor) return Edge is
      begin
         return G.Vertices.Constant_Reference (C.From).Out_Edges.Element
            (C.Current);
      end Element;

      -----------------
      -- Has_Element --
      -----------------

      function Has_Element
         (G : Graph; C : Vertex_Edges_Cursor) return Boolean is
      begin
         return G.Vertices.Constant_Reference
            (C.From).Out_Edges.Has_Element (C.Current);
      end Has_Element;

      ----------
      -- Next --
      ----------

      function Next
         (G : Graph; C : Vertex_Edges_Cursor) return Vertex_Edges_Cursor is
      begin
         return
            (Current => G.Vertices.Constant_Reference (C.From).Out_Edges.Next
               (C.Current),
             From    => C.From);
      end Next;

      -------------
      -- Release --
      -------------

      procedure Release (E : in out Edge_Details_Type) is
      begin
         Edge_Properties.Release (E.Props);
      end Release;

      -------------
      -- Release --
      -------------

      procedure Release (V : in out Vertex_Details_Type) is
      begin
         Vertex_Properties.Release (V.Props);
         V.Out_Edges.Clear;
      end Release;

      ----------------
      -- From_Index --
      ----------------

      function From_Index (Self : Graph; Index : Vertex_Index) return Vertex is
      begin
         if Index > Vertex_Index (Self.Length) then
            return Null_Vertex;
         end if;
         return Vertex (Index);
      end From_Index;

   end Impl;

end GAL.Graphs.Adjacency_List;
