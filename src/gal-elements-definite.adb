package body GAL.Elements.Definite with SPARK_Mode is
   procedure Set_Stored (E : Element_Type; S : out Element_Type) is
   begin
      S := E;
   end Set_Stored;
end GAL.Elements.Definite;