package body Test_Support is

   -------------------
   -- Check_Element --
   -------------------

   function Check_Element (Value : Integer) return Boolean is
   begin
      return Value > 0;
   end Check_Element;

   function Check_Element (Value : String) return Boolean is
   begin
      return Value'Length > 0;
   end Check_Element;

   function Check_Element (Value : GNATCOLL.Strings.XString) return Boolean is
   begin
      return Value.Length > 0;
   end Check_Element;

   -----------
   -- Setup --
   -----------

   procedure Setup (Self : in out Test_Filter; Arg : String) is
   begin
      Self.Filter.Set (Arg);
   end Setup;

   ------------
   -- Active --
   ------------

   function Active (Self : Test_Filter; Name : String) return Boolean is
      A : Boolean;
   begin
      A := GNATCOLL.Strings.Starts_With
         (GNATCOLL.Strings.To_XString (Name),
          Self.Filter);
      return A;
   end Active;

end Test_Support;

