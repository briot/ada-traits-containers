with Asserts;
with Test_Support;             use Test_Support;
with System.Storage_Elements;  use System.Storage_Elements;

package body Support_Ada is

   -----------------------------------
   -- Test_Definite_Unbounded_Lists --
   -----------------------------------

   package body Test_Definite_Unbounded_Lists is

      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Lists.List;
         L2    : Lists.List;

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Append (Nth (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Lists.Cursor := L1.First;
         begin
            Count := 0;
            while Lists.Has_Element (C) loop
               if Check_Element (Lists.Element (C)) then
                  Count := Count + 1;
               end if;
               Lists.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Definite_Unbounded_Lists;

   -------------------------------------
   -- Test_Indefinite_Unbounded_Lists --
   -------------------------------------

   package body Test_Indefinite_Unbounded_Lists is

      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Lists.List;
         L2    : Lists.List;

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Append (Nth (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Lists.Cursor := L1.First;
         begin
            Count := 0;
            while Lists.Has_Element (C) loop
               if Check_Element (Lists.Element (C)) then
                  Count := Count + 1;
               end if;
               Lists.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Indefinite_Unbounded_Lists;

   ---------------------------------
   -- Test_Definite_Bounded_Lists --
   ---------------------------------

   package body Test_Definite_Bounded_Lists is

      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Lists.List (Items_Count);
         L2    : Lists.List (Items_Count);

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Append (Nth (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Lists.Cursor := L1.First;
         begin
            Count := 0;
            while Lists.Has_Element (C) loop
               if Check_Element (Lists.Element (C)) then
                  Count := Count + 1;
               end if;
               Lists.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Definite_Bounded_Lists;

   -------------------------------------
   -- Test_Definite_Unbounded_Vectors --
   -------------------------------------

   package body Test_Definite_Unbounded_Vectors is
      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Vectors.Vector;
         L2    : Vectors.Vector;

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Append (Nth (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Vectors.Cursor := L1.First;
         begin
            Count := 0;
            while Vectors.Has_Element (C) loop
               if Check_Element (Vectors.Element (C)) then
                  Count := Count + 1;
               end if;
               Vectors.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Definite_Unbounded_Vectors;

   -----------------------------------
   -- Test_Definite_Bounded_Vectors --
   -----------------------------------

   package body Test_Definite_Bounded_Vectors is
      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Vectors.Vector (Items_Count);
         L2    : Vectors.Vector (Items_Count);

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Append (Nth (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Vectors.Cursor := L1.First;
         begin
            Count := 0;
            while Vectors.Has_Element (C) loop
               if Check_Element (Vectors.Element (C)) then
                  Count := Count + 1;
               end if;
               Vectors.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Definite_Bounded_Vectors;

   ---------------------------------------
   -- Test_Indefinite_Unbounded_Vectors --
   ---------------------------------------

   package body Test_Indefinite_Unbounded_Vectors is
      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Vectors.Vector;
         L2    : Vectors.Vector;

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Append (Nth (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Vectors.Cursor := L1.First;
         begin
            Count := 0;
            while Vectors.Has_Element (C) loop
               if Check_Element (Vectors.Element (C)) then
                  Count := Count + 1;
               end if;
               Vectors.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Indefinite_Unbounded_Vectors;

   ----------------------------------------
   -- Test_Definite_Bounded_Ordered_Maps --
   ----------------------------------------

   package body Test_Definite_Bounded_Ordered_Maps is
      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Maps.Map (Items_Count);
         L2    : Maps.Map (Items_Count);

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Include (Nth_Key (C), Nth_Element (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Maps.Cursor := L1.First;
         begin
            Count := 0;
            while Maps.Has_Element (C) loop
               if Check_Element (Maps.Element (C)) then
                  Count := Count + 1;
               end if;
               Maps.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Definite_Bounded_Ordered_Maps;

   ------------------------------------------
   -- Test_Definite_Unbounded_Ordered_Maps --
   ------------------------------------------

   package body Test_Definite_Unbounded_Ordered_Maps is
      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Maps.Map;
         L2    : Maps.Map;

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Include (Nth_Key (C), Nth_Element (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Maps.Cursor := L1.First;
         begin
            Count := 0;
            while Maps.Has_Element (C) loop
               if Check_Element (Maps.Element (C)) then
                  Count := Count + 1;
               end if;
               Maps.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Definite_Unbounded_Ordered_Maps;

   --------------------------------------------
   -- Test_Indefinite_Unbounded_Ordered_Maps --
   --------------------------------------------

   package body Test_Indefinite_Unbounded_Ordered_Maps is
      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Maps.Map;
         L2    : Maps.Map;

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Include (Nth_Key (C), Nth_Element (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Maps.Cursor := L1.First;
         begin
            Count := 0;
            while Maps.Has_Element (C) loop
               if Check_Element (Maps.Element (C)) then
                  Count := Count + 1;
               end if;
               Maps.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Indefinite_Unbounded_Ordered_Maps;

   ----------------------------------------
   -- Test_Definite_Bounded_Hashed_Maps --
   ----------------------------------------

   package body Test_Definite_Bounded_Hashed_Maps is
      use Ada.Containers;

      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Maps.Map (Items_Count, Modulus => 2 ** 20);
         L2    : Maps.Map (Items_Count, Modulus => 2 ** 20);

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            Maps.Clear (L1);
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Include (Nth_Key (C), Nth_Element (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Maps.Cursor := L1.First;
         begin
            Count := 0;
            while Maps.Has_Element (C) loop
               if Check_Element (Maps.Element (C)) then
                  Count := Count + 1;
               end if;
               Maps.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Definite_Bounded_Hashed_Maps;

   ------------------------------------------
   -- Test_Definite_Unbounded_Hashed_Maps --
   ------------------------------------------

   package body Test_Definite_Unbounded_Hashed_Maps is
      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Maps.Map;
         L2    : Maps.Map;

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Include (Nth_Key (C), Nth_Element (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Maps.Cursor := L1.First;
         begin
            Count := 0;
            while Maps.Has_Element (C) loop
               if Check_Element (Maps.Element (C)) then
                  Count := Count + 1;
               end if;
               Maps.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Definite_Unbounded_Hashed_Maps;

   --------------------------------------------
   -- Test_Indefinite_Unbounded_Hashed_Maps --
   --------------------------------------------

   package body Test_Indefinite_Unbounded_Hashed_Maps is
      function "+" (S : String) return String
         is (Category & '-' & Container_Name & ": " & S);

      procedure Test_Perf
         (Results  : in out Report.Output'Class;
          Favorite : Boolean)
      is
         Count : Natural;
         L1    : Maps.Map;
         L2    : Maps.Map;

         procedure Do_Clear;
         procedure Do_Clear2;

         procedure Do_Clear is
         begin
            L1.Clear;
         end Do_Clear;

         procedure Do_Clear2 is
         begin
            L2.Clear;
         end Do_Clear2;

         procedure Do_Fill;
         procedure Do_Fill is
         begin
            for C in 1 .. Items_Count loop
               L1.Include (Nth_Key (C), Nth_Element (C));
            end loop;
         end Do_Fill;

         procedure Do_Copy;
         procedure Do_Copy is
         begin
            L2 := L1;
         end Do_Copy;

         procedure Do_Cursor;
         procedure Do_Cursor is
            C     : Maps.Cursor := L1.First;
         begin
            Count := 0;
            while Maps.Has_Element (C) loop
               if Check_Element (Maps.Element (C)) then
                  Count := Count + 1;
               end if;
               Maps.Next (C);
            end loop;
         end Do_Cursor;

         procedure Do_For_Of;
         procedure Do_For_Of is
         begin
            Count := 0;
            for E of L1 loop
               if Check_Element (E) then
                  Count := Count + 1;
               end if;
            end loop;
         end Do_For_Of;

         procedure Time_Fill is new Report.Timeit
            (Do_Fill, Cleanup => Do_Clear);
         procedure Time_Copy is new Report.Timeit
            (Do_Copy, Cleanup => Do_Clear2);
         procedure Time_Cursor is new Report.Timeit (Do_Cursor);
         procedure Time_For_Of is new Report.Timeit (Do_For_Of);

      begin
         Report.Set_Column
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Size        => L1'Size / 8,
             Favorite    => Favorite);

         Time_Fill
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "fill",
             Start_Group => True);

         Do_Clear;
         Do_Fill;
         Time_Copy
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "copy");

         Do_Clear;
         Do_Fill;
         Time_Cursor
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "cursor loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");

         Do_Clear;
         Do_Fill;
         Time_For_Of
            (Results,
             Category    => Category,
             Column      => Container_Name,
             Row         => "for-of loop");
         Asserts.Integers.Assert (Count, Items_Count, +"");
      end Test_Perf;
   end Test_Indefinite_Unbounded_Hashed_Maps;

end Support_Ada;
