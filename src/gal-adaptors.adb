package body GAL.Adaptors is

   package body Bounded_List_Adaptors is
      procedure Next (Self_Ignored : List; Position : in out Cursor) is
      begin
         Lists.Next (Position);
      end Next;

      procedure Previous (Self_Ignored : List; Position : in out Cursor) is
      begin
         Lists.Previous (Position);
      end Previous;
   end Bounded_List_Adaptors;

   package body List_Adaptors is
      procedure Next (Self_Ignored : List; Position : in out Cursor) is
      begin
         Lists.Next (Position);
      end Next;

      procedure Previous (Self_Ignored : List; Position : in out Cursor) is
      begin
         Lists.Previous (Position);
      end Previous;
   end List_Adaptors;

   package body Indefinite_List_Adaptors is
      procedure Next (Self_Ignored : List; Position : in out Cursor) is
      begin
         Lists.Next (Position);
      end Next;

      procedure Previous (Self_Ignored : List; Position : in out Cursor) is
      begin
         Lists.Previous (Position);
      end Previous;
   end Indefinite_List_Adaptors;

   package body Bounded_Vector_Adaptors is
      procedure Next (Self_Ignored : Vector; Position : in out Cursor) is
      begin
         Vectors.Next (Position);
      end Next;

      procedure Previous (Self_Ignored : Vector; Position : in out Cursor) is
      begin
         Vectors.Previous (Position);
      end Previous;
   end Bounded_Vector_Adaptors;

   package body Vector_Adaptors is
      procedure Next (Self_Ignored : Vector; Position : in out Cursor) is
      begin
         Vectors.Next (Position);
      end Next;

      procedure Previous (Self_Ignored : Vector; Position : in out Cursor) is
      begin
         Vectors.Previous (Position);
      end Previous;
   end Vector_Adaptors;

   package body Indefinite_Vector_Adaptors is
      procedure Next (Self_Ignored : Vector; Position : in out Cursor) is
      begin
         Vectors.Next (Position);
      end Next;

      procedure Previous (Self_Ignored : Vector; Position : in out Cursor) is
      begin
         Vectors.Previous (Position);
      end Previous;
   end Indefinite_Vector_Adaptors;

   package body Hashed_Maps_Adaptors is
      procedure Next (Self_Ignored : Map; Position : in out Cursor) is
      begin
         Hashed_Maps.Next (Position);
      end Next;
   end Hashed_Maps_Adaptors;

   package body Bounded_Hashed_Maps_Adaptors is
      procedure Next (Self_Ignored : Map; Position : in out Cursor) is
      begin
         Hashed_Maps.Next (Position);
      end Next;
   end Bounded_Hashed_Maps_Adaptors;

   package body Ordered_Maps_Adaptors is
      procedure Next (Self_Ignored : Map; Position : in out Cursor) is
      begin
         Ordered_Maps.Next (Position);
      end Next;

      procedure Previous (Self_Ignored : Map; Position : in out Cursor) is
      begin
         Ordered_Maps.Previous (Position);
      end Previous;
   end Ordered_Maps_Adaptors;

   package body Indefinite_Hashed_Maps_Adaptors is
      procedure Next (Self_Ignored : Map; Position : in out Cursor) is
      begin
         Hashed_Maps.Next (Position);
      end Next;
   end Indefinite_Hashed_Maps_Adaptors;

   package body Indefinite_Ordered_Maps_Adaptors is
      procedure Next (Self_Ignored : Map; Position : in out Cursor) is
      begin
         Ordered_Maps.Next (Position);
      end Next;

      procedure Previous (Self_Ignored : Map; Position : in out Cursor) is
      begin
         Ordered_Maps.Previous (Position);
      end Previous;
   end Indefinite_Ordered_Maps_Adaptors;

   package body Array_Adaptors is

      ----------
      -- Swap --
      ----------

      procedure Swap (Self : in out Array_Type; Left, Right : Index_Type) is
         Tmp : constant Element_Type := Self (Right);
      begin
         Self (Right) := Self (Left);
         Self (Left) := Tmp;
      end Swap;

   end Array_Adaptors;
end GAL.Adaptors;
