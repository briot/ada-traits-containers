with Support_Lists;
with Test_Support;
with Conts.Lists.Definite_Bounded;
package body Tests_Lists_Definite_Bounded is

   package Lists0 is new Conts.Lists.Definite_Bounded
      (Integer);
   package Tests0 is new Support_Lists
      (Test_Name    => "lists-definite_bounded-integer",
       Image        => Test_Support.Image,
       Elements     => Lists0.Elements.Traits,
       Storage      => Lists0.Storage.Traits,
       Lists        => Lists0.Lists,
       Nth          => Test_Support.Nth);

   procedure Test0 is
      L1, L2 : Lists0.List (20);
   begin
      Tests0.Test (L1, L2);
   end Test0;
end Tests_Lists_Definite_Bounded;