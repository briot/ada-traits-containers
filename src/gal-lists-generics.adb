package body GAL.Lists.Generics is

   --------------
   -- Previous --
   --------------

   function Previous (Self : List'Class; Position : Cursor) return Cursor is
      P : Cursor := Position;
   begin
      Previous (Self, P);
      return P;
   end Previous;

   ----------
   -- Next --
   ----------

   function Next (Self : List'Class; Position : Cursor) return Cursor is
      P : Cursor := Position;
   begin
      Next (Self, P);
      return P;
   end Next;
end GAL.Lists.Generics;
