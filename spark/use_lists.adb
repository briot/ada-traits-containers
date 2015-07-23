pragma Ada_2012;
package body Use_Lists with SPARK_Mode is
   procedure Incr_All (L1 : List; L2 : in out List) is
      Cu : Cursor := First (L1);
   begin
      Clear (L2);
      while Has_Element (L1, Cu) loop
         pragma Loop_Invariant (Capacity (L2) = Capacity (L2)'Loop_Entry);
         pragma Loop_Invariant
           (for all N in 1 .. Length (L2) =>
                Is_Incr (Get (Get_Model (L1), N),
                         Get (Get_Model (L2), N)));
         pragma Loop_Invariant
           (Get (Get_Positions (L1), Cu) = Length (L2) + 1);
         if Element (L1, Cu) < Integer'Last then
            Append (L2, Element (L1, Cu) + 1);
         else
            Append (L2, Element (L1, Cu));
         end if;
         Next (L1, Cu);
      end loop;
   end Incr_All;

   procedure Incr_All_2 (L : in out List) is
      Cu : Cursor := First (L);
   begin
      while Has_Element (L, Cu) loop
         pragma Loop_Invariant (Capacity (L) = Capacity (L)'Loop_Entry);
         pragma Loop_Invariant (Length (L) = Length (L)'Loop_Entry);
         pragma Loop_Invariant
           (for all N in 1 .. Get (Get_Positions (L), Cu) - 1 =>
                Is_Incr (Get (Get_Model (L)'Loop_Entry, N),
                         Get (Get_Model (L), N)));
         pragma Loop_Invariant
           (for all N in Get (Get_Positions (L), Cu) .. Length (L) =>
                Get (Get_Model (L)'Loop_Entry, N) =
                Get (Get_Model (L), N));
         if Element (L, Cu) < Integer'Last then
            Replace_Element (L, Cu, Element (L, Cu) + 1);
         end if;
         Next (L, Cu);
      end loop;
   end Incr_All_2;

   procedure Incr_All_3 (L : in out List) is
      Cu : Cursor := First (L);
   begin
      while Has_Element (L, Cu) loop
         pragma Loop_Invariant (Capacity (L) = Capacity (L)'Loop_Entry);
         pragma Loop_Invariant (Length (L) = Length (L)'Loop_Entry);
         pragma Loop_Invariant
           (for all N in 1 .. Get (Get_Positions (L), Cu) - 1 =>
                Is_Incr (Get (Get_Model (L)'Loop_Entry, N),
                         Get (Get_Model (L), N)));
         pragma Loop_Invariant
           (for all N in Get (Get_Positions (L), Cu) .. Length (L) =>
                Get (Get_Model (L)'Loop_Entry, N) =
                Get (Get_Model (L), N));
         pragma Loop_Invariant
           (Inc (Get_Positions (L)'Loop_Entry, Get_Positions (L))
            and Inc (Get_Positions (L), Get_Positions (L)'Loop_Entry));
         if Element (L, Cu) < Integer'Last then
            Replace_Element (L, Cu, Element (L, Cu) + 1);
         end if;
         Next (L, Cu);
      end loop;
   end Incr_All_3;

   procedure Double_Size (L : in out List) is
      Cu : Cursor := First (L);
   begin
      for I in 1 .. Length (L) loop
         pragma Loop_Invariant (Has_Element (L, Cu));
         pragma Loop_Invariant (Capacity (L) = Capacity (L)'Loop_Entry);
         pragma Loop_Invariant (Length (L) = Length (L)'Loop_Entry + I - 1);
         pragma Loop_Invariant
           (for all I in 1 .. Length (L)'Loop_Entry =>
                Get (Get_Model (L), I) = Get (Get_Model (L)'Loop_Entry, I));
         pragma Loop_Invariant
           (for all J in 1 .. I - 1 =>
              Get (Get_Model (L), J + Length (L)'Loop_Entry) =
                Get (Get_Model (L)'Loop_Entry, J));
         pragma Loop_Invariant
           (Get (Get_Positions (L), Cu) = I);
         Append (L, Element (L, Cu));
         Next (L, Cu);
      end loop;
   end Double_Size;

   procedure Double_Size_2 (L : in out List) is
      Cu : Cursor := First (L);
      N  : Natural := 0 with Ghost;
   begin
      while Has_Element (L, Cu) loop
         pragma Loop_Invariant (Capacity (L) = Capacity (L)'Loop_Entry);
         pragma Loop_Invariant (Length (L) = Length (L)'Loop_Entry + N);
         pragma Loop_Invariant
           (for all I in 1 .. N =>
              Get (Get_Model (L), 2 * I) = Get (Get_Model (L)'Loop_Entry, I)
            and Get (Get_Model (L), 2 * I - 1) =
              Get (Get_Model (L)'Loop_Entry, I));
         pragma Loop_Invariant
           (for all I in N + 1 .. Length (L)'Loop_Entry =>
                Get (Get_Model (L), I + N) =
              Get (Get_Model (L)'Loop_Entry, I));
         pragma Loop_Invariant
           (Get (Get_Positions (L), Cu) = 2 * N + 1);
         Insert (L, Cu, Element (L, Cu));
         Next (L, Cu);
         N := N + 1;
      end loop;
   end Double_Size_2;

   function My_Find (L : List; E : Integer) return Cursor is
      Cu : Cursor := First (L);
   begin
      while Has_Element (L, Cu) loop
         pragma Loop_Invariant
           (for all I in 1 .. Get (Get_Positions (L), Cu) - 1 =>
              Get (Get_Model (L), I) /= E);
         if Element (L, Cu) = E then
            return Cu;
         end if;
         Next (L, Cu);
      end loop;
      return No_Element;
   end My_Find;
end Use_Lists;