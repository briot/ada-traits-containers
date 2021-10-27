package body GAL.Adaptors is

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
