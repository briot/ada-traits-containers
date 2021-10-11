package body Test_Support is

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

