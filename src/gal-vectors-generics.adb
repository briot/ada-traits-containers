package body GAL.Vectors.Generics is

   --------------------
   -- Next_Primitive --
   --------------------

   function Next_Primitive (Self : Vector; Position : Cursor) return Cursor is
      P : Cursor := Position;
   begin
      Next (Self, P);
      return P;
   end Next_Primitive;

end GAL.Vectors.Generics;
