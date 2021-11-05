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

--  A vector abstract data type

pragma Ada_2012;
with GAL.Cursors;
with GAL.Properties;
with GAL.Vectors.Storage;
with GAL.Vectors.Impl;

generic
   type Index_Type is (<>);
   --  Because Last needs to return a meaningful value for empty vectors,
   --  (Index_Type'First - 1) must be a valid value in Index_Type'Base.
   --  This means that the index type cannot be Integer.
   --  Nor can it be an enumeration type. However, this would not be a good
   --  use case for vectors anyway, since the number of elements is known at
   --  compile time and a standard Ada array would be more efficient.

   with package Storage is new GAL.Vectors.Storage.Traits (<>);

package GAL.Vectors.Generics with SPARK_Mode is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

   subtype Element_Type is Storage.Elements.Element_Type;
   subtype Returned_Type is Storage.Elements.Returned_Type;
   subtype Constant_Returned_Type is Storage.Elements.Constant_Returned_Type;
   subtype Stored_Type is Storage.Elements.Stored_Type;

   package Impl is new GAL.Vectors.Impl (Index_Type, Storage);

   subtype Extended_Index is Impl.Extended_Index;
   subtype Base_Vector is Impl.Base_Vector;
   subtype Cursor is Impl.Cursor;
   No_Element : constant Cursor := Impl.No_Element;
   No_Index   : constant Extended_Index := Impl.No_Index;

   Invalid_Index : exception renames Impl.Invalid_Index;

   function To_Count (Idx : Index_Type) return Count_Type
     renames Impl.To_Count;
   --  Converts to or from an index type to an index into the actual underlying
   --  array.

   function "<=" (Idx : Index_Type; Count : Count_Type) return Boolean
     is (To_Count (Idx) <= Count)
     with Inline,
       Pre => Idx in Index_Type'First .. Impl.To_Index (Impl.Last_Count);

   procedure Reserve_Capacity
     (Self : in out Base_Vector'Class; Capacity : Count_Type)
     renames Impl.Reserve_Capacity;
   --  Make sure the vector is at least big enough to contain Capacity items
   --  (the vector must also be big enough to contain all its current
   --  elements)
   --  If you insert more items, the vector might be resized to a bigger
   --  capacity (when using unbounded nodes, for instance).
   --  If you remove items, a vector is never resized.
   --  If you clear the vector, it's capacity is reset to 0 and memory is
   --  freed if possible.

   procedure Shrink_To_Fit (Self : in out Base_Vector'Class)
     renames Impl.Shrink_To_Fit;
   --  Resize the vector to fit its number of elements. This might free
   --  memory. This changes the capacity, but not the length of the vector.

   procedure Resize
     (Self    : in out Base_Vector'Class;
      Length  : Count_Type;
      Element : Storage.Elements.Element_Type)
     renames Impl.Resize;
   --  Resize the container so that it contains Length elements.
   --  If Length is smaller than the current container length, Self is
   --     reduced to its first Length elements, destroying the other elements.
   --     This does not change the capacity of the vector.
   --  If Length is greater than the current container length, new elements
   --     are added as needed, as copied of Element. This might also extend
   --     the capacity of the vector if needed.

   function Length (Self : Base_Vector'Class) return Count_Type
     renames Impl.Length;
   --  Return the number of elements in Self.

   function Is_Empty (Self : Base_Vector'Class) return Boolean
     renames Impl.Is_Empty;
   --  Whether the vector is empty

   function Last (Self : Base_Vector'Class) return Extended_Index
     renames Impl.Last;
   --  Return the index of the last element in the vector.
   --  For a null vector, this returns (Index_Type'First - 1), so that it is
   --  always possible to write:
   --      for Idx in Index_Type'First .. Self.Last loop
   --      end loop;

   procedure Append
     (Self    : in out Base_Vector'Class;
      Element : Element_Type;
      Count   : Count_Type := 1)
     renames Impl.Append;
   --  Append Count copies of Element to the vector, increasing the capacity
   --  as needed.

   procedure Insert
     (Self    : in out Base_Vector'Class;
      Before  : Index_Type;
      Element : Element_Type;
      Count   : Count_Type := 1)
      renames Impl.Insert;
   --  Insert Count copies of Element starting at position before.
   --  Complexity: O(n)

   procedure Replace_Element
     (Self     : in out Base_Vector'Class;
      Index    : Index_Type;
      New_Item : Element_Type)
     renames Impl.Replace_Element;
   --  Replace the element at the given position.

   procedure Swap
     (Self        : in out Base_Vector'Class;
      Left, Right : Index_Type)
     renames Impl.Swap;
   --  Efficiently swap the elements at the two positions.
   --  For large elements, this will be more efficient than retrieving them
   --  and storing them again (which might involve the secondary stack, or
   --  allocating and freeing elements).

   procedure Clear (Self : in out Base_Vector'Class)
     renames Impl.Clear;
   --  Remove all contents from the vector.

   procedure Delete
     (Self  : in out Base_Vector'Class;
      Index : Index_Type;
      Count : Count_Type := 1)
     renames Impl.Delete;
   --  Remove Count elements, starting at Index.
   --  Unless you are removing the last element (see Delete_Last), this is an
   --  inefficient operation since it needs to copy all the elements after
   --  the one being removed.

   procedure Delete_Last (Self : in out Base_Vector'Class)
     renames Impl.Delete_Last;
   --  Remove the last element from the vector.
   --  The vector is not resized, so it will keep its current capacity, for
   --  efficient insertion of future elements. You can call Shrink_To_Fit.
   --  Existing cursors are still valid after this call (except one that
   --  was pointing to the last element, of course).

   function Last_Element
     (Self : Base_Vector'Class) return Constant_Returned_Type
     renames Impl.Last_Element;
   --  Return the last element in the vector.

   procedure Assign
     (Self : in out Base_Vector'Class; Source : Base_Vector'Class)
     renames Impl.Assign;
   --  Replace all elements of Self with a copy of the elements of Source.
   --  When the list is controlled, this has the same behavior as calling
   --  Self := Source.

   function First (Self : Base_Vector'Class) return Cursor
     renames Impl.First;
   function Element
     (Self : Base_Vector'Class; Position : Cursor)
      return Constant_Returned_Type
     renames Impl.Element;
   function Has_Element
     (Self : Base_Vector'Class; Position : Cursor) return Boolean
     renames Impl.Has_Element;
   procedure Next
     (Self : Base_Vector'Class; Position : in out Cursor)
     renames Impl.Next;
   procedure Previous
     (Self : Base_Vector'Class; Position : in out Cursor)
     renames Impl.Previous;
   --  Complexity: constant for all cursor operations.

   function Has_Element_For_Loops
     (Ignored : Base_Vector'Class; Position : Cursor) return Boolean
     is (Position /= No_Element)
     with Inline, Global => null;
   --  A faster version of Has_Element, suitable for use in loops when the
   --  position is only manipulated via First, Next or Previous. Since those
   --  functions always set invalid position to No_Element, we do not need
   --  to check this again here.

   function Reference
     (Self : in out Base_Vector'Class; Position : Index_Type)
     return Returned_Type
     renames Impl.Reference;
   --  Return a reference to the element at the given position.

   use type Element_Type;

   function As_Element
     (Self : Base_Vector'Class; Position : Cursor) return Element_Type
   --  Return a copy of the element at the given position.
     is (Storage.Elements.To_Element (Element (Self, Position)))
     with
       Pre => Has_Element (Self, Position),
       Post => As_Element'Result = Element (Impl.Model (Self), Position);
   pragma Annotate (GNATprove, Inline_For_Proof, As_Element);

   ------------------
   -- for-of loops --
   ------------------

   type Vector is new Base_Vector with null record
     with Constant_Indexing => Constant_Reference,
          Iterable          => (First       => First_Primitive,
                                Next        => Next_Primitive,
                                Has_Element => Has_Element_For_Loops_Primitive,
                                Element     => Element_Primitive);

   function Constant_Reference
     (Self : Vector; Position : Index_Type) return Constant_Returned_Type
     is (Element (Self, Position))
     with Inline, Pre'Class => Position <= Last (Self);

   function First_Primitive (Self : Vector) return Cursor is (First (Self));
   function Element_Primitive
     (Self : Vector; Position : Cursor) return Constant_Returned_Type
     is (Element (Self, Position))
     with
       Inline,
       Pre'Class => Has_Element (Self, Position),
       Post      => Storage.Elements.To_Element (Element_Primitive'Result) =
          Element (Model (Self), Position);
   function Has_Element_For_Loops_Primitive
     (Self : Vector; Position : Cursor) return Boolean
     is (Has_Element_For_Loops (Self, Position))
     with
       Inline,
       Post => Has_Element_For_Loops_Primitive'Result =
          (Position in Index_Type'First .. Self.Last);
   pragma Annotate
      (GNATprove, Inline_For_Proof, Has_Element_For_Loops_Primitive);

   function Next_Primitive
     (Self : Vector; Position : Cursor) return Cursor
     with Inline, Pre'Class => Has_Element (Self, Position);
   --  These are only needed because the Iterable aspect expects a parameter
   --  of type List instead of List'Class. But then it means that the loop
   --  is doing a lot of dynamic dispatching, and is twice as slow as a loop
   --  using an explicit cursor.

   -----------
   -- Model --
   -----------
   --  The following subprograms are used to write loop invariants for SPARK

   function Model (Self : Vector'Class) return Impl.M.Sequence
     is (Impl.Model (Self))
     with Ghost;
   pragma Annotate (GNATprove, Iterable_For_Proof, "Model", Model);

   function Element (S : Impl.M.Sequence; I : Index_Type) return Element_Type
     renames Impl.Element;

   -------------
   -- Cursors --
   -------------

   package Cursors is
      function Index_First (Self_Ignored : Base_Vector'Class) return Index_Type
        is (Index_Type'First) with Inline;
      function Distance (Left, Right : Index_Type) return Integer
        is (Integer (To_Count (Left)) - Integer (To_Count (Right)))
        with Pre =>
          Left in Index_Type'First .. Impl.To_Index (Impl.Last_Count)
          and then
          Right in Index_Type'First .. Impl.To_Index (Impl.Last_Count);

      function "+" (Left : Index_Type; N : Integer) return Extended_Index
        is (Impl.To_Index (Count_Type (Integer (To_Count (Left)) + N)))
      with Pre =>
          --  N could be negative to move backward, and we must return
          --  Extended_Index'First if Left is already on first element
          Left in Index_Type'First .. Impl.To_Index (Impl.Last_Count)
        and then N in Integer
            (Extended_Index'Pos (Extended_Index'First) - To_Count (Left)) ..
            Integer (Impl.Last_Count - To_Count (Left));

      package Random_Access is new GAL.Cursors.Random_Access_Cursors
        (Container_Type => Base_Vector'Class,
         Index_Type     => Extended_Index,
         No_Element     => Impl.No_Index,
         First          => Index_First,
         Last           => Last,
         Distance       => Distance,
         "+"            => "+");
      package Bidirectional is new GAL.Cursors.Bidirectional_Cursors
        (Container_Type => Base_Vector'Class,
         Cursor_Type    => Cursor,
         No_Element     => No_Element,
         First          => First,
         Last           => Last,
         Has_Element    => Has_Element_For_Loops,
         Next           => Next,
         Previous       => Previous);
      package Forward renames Bidirectional.Forward;
   end Cursors;

   -------------------------
   -- Getters and setters --
   -------------------------

   package Maps is
      package Element is new GAL.Properties.Read_Only_Maps
        (Cursors.Forward.Container, Cursors.Forward.Cursor,
         Element_Type, As_Element);
      package Constant_Returned is new GAL.Properties.Read_Only_Maps
        (Cursors.Forward.Container, Cursors.Forward.Cursor,
         Storage.Elements.Constant_Returned, GAL.Vectors.Generics.Element);
      package Element_From_Index is new GAL.Properties.Read_Only_Maps
        (Cursors.Random_Access.Container, Cursors.Random_Access.Index,
         Element_Type, As_Element);
   end Maps;

end GAL.Vectors.Generics;
