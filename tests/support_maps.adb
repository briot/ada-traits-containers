with Asserts;
with GNAT.Source_Info;
with System.Assertions;    use System.Assertions;

package body Support_Maps is

   function "+" (S : String) return String is (Test_Name & ": " & S);
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

   procedure Test (M : in out Maps.Map) is
   begin
      --  Check looking for an element in an empty table
      Assert_Not_Exist (M, Nth_Key (1));

      for J in 1 .. 10 loop
         M.Set (Nth_Key (J), Nth_Element (J));
      end loop;

      Assert (M.Get (Nth_Key (1)), Nth_Element (1), +"value for one");
      Assert (M (Nth_Key (4)), Nth_Element (4), +"value for four");

      for J in 1 .. 6 loop
         M.Delete (Nth_Key (J));
      end loop;

      Assert (M.Get (Nth_Key (7)), Nth_Element (7), +"value for seven");

      Assert_Not_Exist (M, Nth_Key (3));
   end Test;
end Support_Maps;
