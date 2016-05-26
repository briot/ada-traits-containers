package body Formal_Hashed_Maps with SPARK_Mode => Off is

   function Capacity (Self : Map'Class) return Count_Type is
      (Element_Maps.Impl.Capacity (Self));

   package body Formal_Model is
      use M;
      use K;
      use P;

      function Model (Self : Map'Class) return M.Map is
         R  : M.Map;
         Cu : Cursor := Element_Maps.Impl.First (Self);
      begin
         while Element_Maps.Impl.Has_Element (Self, Cu) loop
            R := Add (R,
                      Element_Maps.Impl.As_Key (Self, Cu),
                      Element_Maps.Impl.As_Element (Self, Cu));
            Cu := Element_Maps.Impl.Next (Self, Cu);
         end loop;
         return R;
      end Model;

      function Keys (Self : Map'Class) return K.Sequence is
         R  : K.Sequence;
         Cu : Cursor := Element_Maps.Impl.First (Self);
      begin
         while Element_Maps.Impl.Has_Element (Self, Cu) loop
            R := Add (R, Element_Maps.Impl.As_Key (Self, Cu));
            Cu := Element_Maps.Impl.Next (Self, Cu);
         end loop;
         return R;
      end Keys;

      function Positions (Self : Map'Class) return P.Map is
         R  : P.Map;
         Cu : Cursor := Element_Maps.Impl.First (Self);
         I  : Count_Type := 0;
      begin
         while Element_Maps.Impl.Has_Element (Self, Cu) loop
            I := I + 1;
            R := Add (R, Cu, I);
            Cu := Element_Maps.Impl.Next (Self, Cu);
         end loop;
         return R;
      end Positions;

      procedure Lift_Abstraction_Level (Self : Map'Class) is null;
   end Formal_Model;

   function Get (Self : Map'Class; Key : Key_Type) return Element_Type is
      (Element_Maps.Impl.Get (Self, Key));

   procedure Set
     (Self : in out Map'Class; Key : Key_Type; Element : Element_Type)
   is
   begin
      Element_Maps.Impl.Set (Self, Key, Element);
   end Set;

   procedure Resize
     (Self     : in out Map'Class;
      New_Size : Count_Type)
   is
   begin
      Element_Maps.Impl.Resize (Self, New_Size);
   end Resize;

   procedure Delete
     (Self : in out Map'Class;
      Key  : Key_Type)
   is
   begin
      Element_Maps.Impl.Delete (Self, Key);
   end Delete;

   procedure Clear (Self : in out Map'Class) is
   begin
      Element_Maps.Impl.Clear (Self);
   end Clear;

   function Element (Self : Map'Class; Position : Cursor) return Element_Type
   is (Element_Maps.Impl.Element (Self, Position));

   function First (Self : Map'Class) return Cursor is
      (Element_Maps.Impl.First (Self));

   function Next (Self : Map'Class; Position : Cursor) return Cursor is
        (Element_Maps.Impl.Next (Self, Position));

   function Has_Element (Self : Map'Class; Position : Cursor) return Boolean is
        (Element_Maps.Impl.Has_Element (Self, Position));

   function First_Primitive (Self : Map) return Cursor
     is (Element_Maps.Impl.First (Self));
   function Key_Primitive
     (Self : Map; Position : Cursor) return Key_Type
     is (As_Key (Self, Position));
   function Has_Element_Primitive
     (Self : Map; Position : Cursor) return Boolean
     is (Element_Maps.Impl.Has_Element (Self, Position));
   function Next_Primitive
     (Self : Map; Position : Cursor) return Cursor
     is (Element_Maps.Impl.Next (Self, Position));
end Formal_Hashed_Maps;