package body GAL.Cursors is

   package body Random_Access_Cursors is

      ----------
      -- Next --
      ----------

      function Next
        (Self : Container_Type; Idx : Index_Type) return Index_Type
      is
         L : constant Index_Type := Idx + 1;
      begin
         if L <= Last (Self) then
            return L;
         else
            return No_Element;
         end if;
      end Next;

      --------------
      -- Previous --
      --------------

      function Previous
        (Self : Container_Type; Idx : Index_Type) return Index_Type
      is
         L : constant Index_Type := Idx - 1;
      begin
         if L >= First (Self) then
            return L;
         else
            return No_Element;
         end if;
      end Previous;
   end Random_Access_Cursors;
end GAL.Cursors;
