with Support_Lists;
with Conts.Lists.Indefinite_Unbounded;
with Test_Support;
package body Tests_Lists_Indefinite_Unbounded is

   package Lists0 is new Conts.Lists.Indefinite_Unbounded
      (Integer, Container_Base_Type => Conts.Controlled_Base);
   package Tests0 is new Support_Lists
      (Test_Name    => "lists-indefinite_unbounded-integer",
       Image        => Test_Support.Image,
       Elements     => Lists0.Elements.Traits,
       Storage      => Lists0.Storage.Traits,
       Lists        => Lists0.Lists,
       Nth          => Test_Support.Nth);

   procedure Test0 is
      L1, L2 : Lists0.List;
   begin
      Tests0.Test (L1, L2);
   end Test0;

   package Lists1 is new Conts.Lists.Indefinite_Unbounded
      (String, Container_Base_Type => Conts.Controlled_Base);
   package Tests1 is new Support_Lists
      (Test_Name    => "lists-indefinite_unbounded-string",
       Image        => Test_Support.Image,
       Elements     => Lists1.Elements.Traits,
       Storage      => Lists1.Storage.Traits,
       Lists        => Lists1.Lists,
       Nth          => Test_Support.Nth);

   procedure Test1 is
      L1, L2 : Lists1.List;
   begin
      Tests1.Test (L1, L2);
   end Test1;
end Tests_Lists_Indefinite_Unbounded;