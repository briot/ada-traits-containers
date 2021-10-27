with Asserts;
with GAL.Algo.Count_If;
with GNAT.Source_Info;
with System.Storage_Elements; use System.Storage_Elements;
with System.Assertions;       use System.Assertions;
with Test_Support;            use Test_Support;

package body Support_Maps is

   function "+" (S : String) return String
      is (Category & '-' & Container_Name & ": " & S);
   --  Create error messages for failed tests

   package Element_Asserts is new Asserts.Asserts.Equals
      (Maps.Elements.Element_Type, Image_Element, "=" => "=");

   procedure Assert
      (Value    : Maps.Elements.Constant_Returned_Type;
       Expected : Maps.Elements.Element_Type;
       Msg      : String := "";
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity);
   --  Check that the value found in the map is Expected

   procedure Assert_Not_Exist
      (Map      : Maps.Map;
       Key      : Maps.Keys.Element_Type;
       Msg      : String := "";
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity);
   --  Check that the entity is no longer found in the map

   function Check_Element_Internal
      (E : Maps.Elements.Constant_Returned_Type)
      return Boolean
      is (Check_Element (Maps.Elements.To_Element (E)));

   function Count_If is new GAL.Algo.Count_If
      (Cursors   => Maps.Cursors.Forward,
       Getters   => Maps.Maps.Constant_Returned);

   ------------
   -- Assert --
   ------------

   procedure Assert
      (Value    : Maps.Elements.Constant_Returned_Type;
       Expected : Maps.Elements.Element_Type;
       Msg      : String := "";
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity) is
   begin
      Element_Asserts.Assert
         (Maps.Elements.To_Element (Value),
          Expected,
          +Msg,
          Location,
          Entity);
   end Assert;

   ----------------------
   -- Assert_Not_Exist --
   ----------------------

   procedure Assert_Not_Exist
      (Map      : Maps.Map;
       Key      : Maps.Keys.Element_Type;
       Msg      : String := "";
       Location : String := GNAT.Source_Info.Source_Location;
       Entity   : String := GNAT.Source_Info.Enclosing_Entity) is
   begin
      declare
         V : constant Maps.Elements.Constant_Returned_Type := Map.Get (Key)
            with Unreferenced;
      begin
         Asserts.Should_Not_Get_Here
            (Msg => +Msg, Location => Location, Entity => Entity);
      end;
   exception
      when Constraint_Error | Assert_Failure =>
         null;
   end Assert_Not_Exist;

   ----------
   -- Test --
   ----------

   procedure Test (M1, M2 : in out Maps.Map) is
   begin
      --  Check looking for an element in an empty table
      Assert_Not_Exist (M1, Nth_Key (1));

      for J in 1 .. 10 loop
         M1.Set (Nth_Key (J), Nth_Element (J));
      end loop;

      Assert (M1.Get (Nth_Key (1)), Nth_Element (1), +"value for one");
      Assert (M1 (Nth_Key (4)), Nth_Element (4), +"value for four");

      for J in 1 .. 6 loop
         M1.Delete (Nth_Key (J));
      end loop;

      Assert (M1.Get (Nth_Key (7)), Nth_Element (7), +"value for seven");

      Assert_Not_Exist (M1, Nth_Key (3));

      --  Test clear
      M1.Clear;
      Asserts.Integers.Assert
         (Integer (M1.Length), 0, "wrong length after clear");

      --  Test copy
      for J in 1 .. 10 loop
         M1.Set (Nth_Key (J), Nth_Element (J));
      end loop;
      M2.Clear;
      M2.Assign (M1);
      Asserts.Integers.Assert
         (Integer (M2.Length), Integer (M1.Length), "wrong length after copy");
      for J in 1 .. 10 loop
         Element_Asserts.Assert
            (Maps.Elements.To_Element (M2.Get (Nth_Key (J))),
             Maps.Elements.To_Element (M1.Get (Nth_Key (J))),
             "wrong value after copy");
      end loop;
   end Test;

   ---------------
   -- Test_Perf --
   ---------------

   procedure Test_Perf
      (Results  : in out Report.Output'Class;
       M1, M2   : in out Maps.Map;
       Favorite : Boolean)
   is
      Count : Natural;

      procedure Do_Clear;
      procedure Do_Clear2;

      procedure Do_Clear is
      begin
         M1.Clear;
      end Do_Clear;

      procedure Do_Clear2 is
      begin
         M2.Clear;
      end Do_Clear2;

      procedure Do_Fill;
      procedure Do_Fill is
      begin
         for C in 1 .. Items_Count loop
            M1.Set (Nth_Key (C), Nth_Perf_Element (C));
         end loop;
      end Do_Fill;

      procedure Do_Copy;
      procedure Do_Copy is
      begin
         M2.Assign (M1);
      end Do_Copy;

      procedure Do_Cursor;
      procedure Do_Cursor is
         C : Maps.Cursor := M1.First;
      begin
         Count := 0;
         while M1.Has_Element (C) loop
            if Check_Element_Internal (M1.Element (C)) then
               Count := Count + 1;
            end if;
            M1.Next (C);
         end loop;
      end Do_Cursor;

      procedure Do_For_Of;
      procedure Do_For_Of is
      begin
         Count := 0;
         for Key of M1 loop
            if Check_Element_Internal (M1 (Maps.Keys.To_Element (Key))) then
               Count := Count + 1;
            end if;
         end loop;
      end Do_For_Of;

      procedure Do_Count_If;
      procedure Do_Count_If is
      begin
         Count := Count_If (M1, Check_Element_Internal'Access);
      end Do_Count_If;

      procedure Do_Indexed;
      procedure Do_Indexed is
      begin
         Count := 0;
         for J in 1 .. Items_Count loop
            if Check_Element_Internal (M1.Get (Nth_Key (J))) then
               Count := Count + 1;
            end if;
         end loop;
      end Do_Indexed;

      procedure Time_Fill is new Report.Timeit (Do_Fill, Cleanup => Do_Clear);
      procedure Time_Copy is new Report.Timeit (Do_Copy, Cleanup => Do_Clear2);
      procedure Time_Cursor is new Report.Timeit (Do_Cursor);
      procedure Time_For_Of is new Report.Timeit (Do_For_Of);
      procedure Time_Count_If is new Report.Timeit (Do_Count_If);
      procedure Time_Indexed is new Report.Timeit (Do_Indexed);

   begin
      Report.Set_Column
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Size        => M1'Size / 8,
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

      Do_Clear;
      Do_Fill;
      Time_Count_If
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Row         => "count_if");
      Asserts.Integers.Assert (Count, Items_Count, +"");

      Do_Clear;
      Do_Fill;
      Time_Indexed
         (Results,
          Category    => Category,
          Column      => Container_Name,
          Row         => "find");
      Asserts.Integers.Assert (Count, Items_Count, +"");
   end Test_Perf;
end Support_Maps;
