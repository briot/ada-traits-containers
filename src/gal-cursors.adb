package body GAL.Cursors is

   package body Random_Access_Cursors is

      ----------
      -- Next --
      ----------

      procedure Next (Self : Container_Type; Idx : in out Index_Type) is
         L : constant Index_Type := Idx + 1;
      begin
         if L <= Last (Self) then
            Idx := L;
         else
            Idx := No_Element;
         end if;
      end Next;

      --------------
      -- Previous --
      --------------

      procedure Previous (Self : Container_Type; Idx : in out Index_Type) is
         L : constant Index_Type := Idx - 1;
      begin
         if L >= First (Self) then
            Idx := L;
         else
            Idx := No_Element;
         end if;
      end Previous;
   end Random_Access_Cursors;
end GAL.Cursors;
