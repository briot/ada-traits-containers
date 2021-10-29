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
      Self.Filter.Append (Arg);
   end Setup;

   ------------
   -- Active --
   ------------

   function Active (Self : Test_Filter; Name : String) return Boolean is
   begin
      if Self.Filter.Is_Empty then
         return True;
      end if;

      for V of Self.Filter loop
         if V = Name then
            return True;
         end if;
      end loop;
      return False;
   end Active;

end Test_Support;

