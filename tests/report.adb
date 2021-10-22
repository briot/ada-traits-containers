------------------------------------------------------------------------------
--                     Copyright (C) 2015-2016, AdaCore                     --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

pragma Ada_2012;
with Ada.Exceptions;
with Ada.Text_IO;
with Ada.Unchecked_Deallocation;
with GNAT.Calendar;
with Interfaces.C;              use Interfaces.C;
with Interfaces.C.Strings;      use Interfaces.C.Strings;
with Memory;
with System;
with Test_Support;

package body Report is
   use type System.Storage_Elements.Storage_Count;

   type Output_Access is access all Output'Class;
   pragma No_Strict_Aliasing (Output_Access);
   function To_Output is new Ada.Unchecked_Conversion
      (System.Address, Output_Access);

   procedure Unchecked_Free is new Ada.Unchecked_Deallocation
      (Row_Descr_Type, Row_Descr_Access);

   procedure Set_Column
     (Self             : System.Address;
      Category, Column : chars_ptr;
      Size             : System.Storage_Elements.Storage_Count;
      Favorite         : Interfaces.C.int)
     with Export, Convention => C, External_Name => "set_column";
   procedure Start_Test
      (Self                  : System.Address;
       Category, Column, Row : chars_ptr;
       Start_Group           : Interfaces.C.int)
      with Export, Convention => C, External_Name => "start_test";
   procedure Stop_Time (Self : System.Address)
      with Export, Convention => C, External_Name => "stop_time";
   procedure End_Test
     (Self : System.Address;
      Allocated, Allocs_Count, Frees_Count : Natural)
      with Export, Convention => C, External_Name => "end_test";
   procedure End_Test_Not_Run (Self : System.Address)
      with Export, Convention => C, External_Name => "end_test_not_run";

   function Get_Or_Create_Category
     (Self        : in out Output'Class;
      Category    : String) return Category_Lists.Reference_Type;
   function Get_Or_Create_Column
     (Category    : Category_Lists.Reference_Type;
      Column      : String)
     return Column_Lists.Reference_Type;
   function Get_Or_Create_Row
     (Column      : Column_Lists.Reference_Type;
      Row         : String)
     return Row_Lists.Reference_Type;
   --  Create a new category or column entry

   ----------------------------
   -- Get_Or_Create_Category --
   ----------------------------

   function Get_Or_Create_Category
     (Self        : in out Output'Class;
      Category    : String) return Category_Lists.Reference_Type is
   begin
      for Cat in Self.Categories.Iterate loop
         declare
            Ref : Category_Lists.Reference_Type :=
               Self.Categories.Reference (Cat);
         begin
            if Ref.Category = Category then
               return Ref;
            end if;
         end;
      end loop;

      Self.Categories.Append
         ((Category => GNATCOLL.Strings.To_XString (Category),
           others   => <>));
      return Self.Categories.Reference (Self.Categories.Last);
   end Get_Or_Create_Category;

   --------------------------
   -- Get_Or_Create_Column --
   --------------------------

   function Get_Or_Create_Column
     (Category    : Category_Lists.Reference_Type;
      Column      : String)
     return Column_Lists.Reference_Type
   is
   begin
      for C in Category.Columns.Iterate loop
         declare
            Col : constant Column_Lists.Reference_Type :=
               Category.Columns.Reference (C);
         begin
            if Col.Column = Column then
               return Col;
            end if;
         end;
      end loop;

      Category.Columns.Append
         ((Column   => GNATCOLL.Strings.To_XString (Column),
           others   => <>));
      return Category.Columns.Reference (Category.Columns.Last);
   end Get_Or_Create_Column;

   -----------------------
   -- Get_Or_Create_Row --
   -----------------------

   function Get_Or_Create_Row
     (Column      : Column_Lists.Reference_Type;
      Row         : String)
     return Row_Lists.Reference_Type is
   begin
      for C in Column.Rows.Iterate loop
         declare
            R : constant Row_Lists.Reference_Type :=
               Column.Rows.Reference (C);
         begin
            if R.Row = Row then
               return R;
            end if;
         end;
      end loop;

      Column.Rows.Append
         (new Row_Descr_Type'(
            (Row      => GNATCOLL.Strings.To_XString (Row),
             others   => <>)));
      return Column.Rows.Reference (Column.Rows.Last);
   end Get_Or_Create_Row;

   --------------
   -- Finalize --
   --------------

   overriding procedure Finalize (Self : in out Output) is
   begin
      for Cat of Self.Categories loop
         for Col of Cat.Columns loop
            for Row of Col.Rows loop
               Unchecked_Free (Row);
            end loop;
         end loop;
      end loop;
      Self.Categories.Clear;
   end Finalize;

   -----------
   -- Setup --
   -----------

   procedure Setup
      (Self                 : in out Output'Class;
       Minimum_Running_Time : Duration := Default_Minimum_Running_Time;
       Minimum_Runs         : Positive := Default_Minimum_Runs;
       Maximum_Runs         : Positive := Default_Maximum_Runs;
       Warmup_Runs          : Natural := Default_Warmup_Runs) is
   begin
      Self.Minimum_Running_Time := Minimum_Running_Time;
      Self.Minimum_Runs         := Minimum_Runs;
      Self.Maximum_Runs         := Maximum_Runs;
      Self.Warmup_Runs          := Warmup_Runs;
   end Setup;

   ----------------
   -- Set_Column --
   ----------------

   procedure Set_Column
     (Self        : in out Output'Class;
      Category    : String;  --  Each of the groups of tests
      Column      : String;  --  Typically: the container we test
      Size        : System.Storage_Elements.Storage_Count;
      Favorite    : Boolean := False)
   is
      Cat : constant Category_Lists.Reference_Type :=
         Get_Or_Create_Category (Self, Category);
      Col : constant Column_Lists.Reference_Type :=
         Get_Or_Create_Column (Cat, Column);
   begin
      Col.Size := Size;
      Col.Favorite := Favorite;
   end Set_Column;

   ----------------
   -- Start_Test --
   ----------------

   procedure Start_Test
      (Self        : in out Output'Class;
       Category    : Category_Type;
       Column      : String;  --  Typically: the container we test
       Row         : String;  --  Typically: the specific test we ran
       Comment     : String := "";
       Start_Group : Boolean := False)
   is
      Cat : constant Category_Lists.Reference_Type :=
         Get_Or_Create_Category (Self, Category);
      Col : constant Column_Lists.Reference_Type :=
         Get_Or_Create_Column (Cat, Column);
      R   : constant Row_Lists.Reference_Type :=
         Get_Or_Create_Row (Col, Row);
   begin
      R.Comment.Set (Comment);
      R.Start_Group := R.Start_Group or Start_Group;
      Self.Current := R;

      Memory.Reset;
      Self.At_Test_Start := Memory.Current;
      Self.Start_Time := Clock;
   end Start_Test;

   --------------
   -- End_Test --
   --------------

   procedure End_Test (Self : in out Output'Class) is
      E    : constant Time := Clock;
      Info : Mem_Info;
   begin
      Memory.Pause;

      Self.Current.Timing := E - Self.Start_Time;

      Info := Memory.Current - Self.At_Test_Start;
      Self.Current.Allocated := Self.Current.Allocated
         + System.Storage_Elements.Storage_Count (Info.Total_Allocated);
      Self.Current.Allocs   := Self.Current.Allocs + Info.Allocs;
      Self.Current.Frees    := Self.Current.Frees + Info.Frees;
      Self.Current.Reallocs := Self.Current.Reallocs + Info.Reallocs;

      Self.Current := null;

      Memory.Unpause;
   end End_Test;

   ----------------------
   -- End_Test_Not_Run --
   ----------------------

   procedure End_Test_Not_Run (Self : in out Output'Class) is
   begin
      Self.Current := null;
   end End_Test_Not_Run;

   ----------------
   -- Set_Column --
   ----------------

   procedure Set_Column
     (Self             : System.Address;
      Category, Column : chars_ptr;
      Size             : System.Storage_Elements.Storage_Count;
      Favorite         : Interfaces.C.int) is
   begin
      Set_Column
         (To_Output (Self).all,
          Category => Value (Category),
          Column   => Value (Column),
          Size     => Size,
          Favorite => Favorite /= 0);
   end Set_Column;

   ----------------
   -- Start_Test --
   ----------------

   procedure Start_Test
      (Self                  : System.Address;
       Category, Column, Row : chars_ptr;
       Start_Group           : Interfaces.C.int) is
   begin
      Start_Test
         (To_Output (Self).all,
          Category    => Value (Category),
          Column      => Value (Column),
          Row         => Value (Row),
          Start_Group => Start_Group /= 0);
   end Start_Test;

   ---------------
   -- Stop_Time --
   ---------------

   procedure Stop_Time (Self : System.Address) is
      Result : constant Output_Access := To_Output (Self);
      E    : constant Time := Clock;
   begin
      if Result.Start_Time /= GNAT.Calendar.No_Time then
         Result.Current.Timing := E - Result.Start_Time;
         Result.Start_Time := GNAT.Calendar.No_Time;
      end if;
   end Stop_Time;

   --------------
   -- End_Test --
   --------------

   procedure End_Test
     (Self : System.Address;
      Allocated, Allocs_Count, Frees_Count : Natural)
   is
      Result : constant Output_Access := To_Output (Self);
   begin
      Stop_Time (Self);  --  In case it wasn't stopped before

      Result.Current.Allocated := Result.Current.Allocated
         + System.Storage_Elements.Storage_Count (Allocated);
      Result.Current.Allocs   := Result.Current.Allocs + Allocs_Count;
      Result.Current.Frees    := Result.Current.Frees + Frees_Count;

      Result.Current := null;
   end End_Test;

   ----------------------
   -- End_Test_Not_Run --
   ----------------------

   procedure End_Test_Not_Run (Self : System.Address) is
   begin
      End_Test_Not_Run (To_Output (Self).all);
   end End_Test_Not_Run;

   ------------
   -- Timeit --
   ------------

   procedure Timeit
      (Self        : in out Output'Class;
       Category    : Category_Type;
       Column      : String;
       Row         : String;
       Comment     : String := "";
       Factor      : Positive := 1;
       Start_Group : Boolean := False)
   is
      Total       : Long_Float := 0.0;
      Count       : Natural := 0;
      Mean        : Long_Float;
      Min         : Long_Float := Long_Float'Last;
      Max         : Long_Float := Long_Float'First;
      Start, Stop : Ada.Calendar.Time;
      Elapsed     : Long_Float;
      Info        : Mem_Info;

   begin
      Memory.Pause;

      for J in 1 .. Self.Warmup_Runs loop
         begin
            Setup;
            Run;
            Cleanup;
         exception
            when others =>
               null;
         end;
      end loop;

      Start_Test
         (Self,
          Category    => Category,
          Column      => Column,
          Row         => Row,
          Comment     => Comment,
          Start_Group => Start_Group);

      while Count < Self.Maximum_Runs
         and then (Count < Self.Minimum_Runs
                   or else Duration (Total) < Self.Minimum_Running_Time)
      loop
         Memory.Unpause;
         Memory.Reset;
         Setup;

         Start := Ada.Calendar.Clock;
         Run;
         Stop := Ada.Calendar.Clock;
         Cleanup;

         Memory.Pause;

         Elapsed := Long_Float (Stop - Start);
         Count := Count + 1;
         Min := Long_Float'Min (Min, Elapsed);
         Max := Long_Float'Max (Max, Elapsed);
         Total := Total + Elapsed;
      end loop;

      Mean := Total / Long_Float (Count) / Long_Float (Factor);

      Self.Current.Timing := Duration (Mean);

      Info := Memory.Current - Self.At_Test_Start;
      Self.Current.Allocated := Self.Current.Allocated
         + System.Storage_Elements.Storage_Count (Info.Total_Allocated);
      Self.Current.Allocs   := Self.Current.Allocs + Info.Allocs;
      Self.Current.Frees    := Self.Current.Frees + Info.Frees;
      Self.Current.Reallocs := Self.Current.Reallocs + Info.Reallocs;

      Self.Current := null;
   exception
      when E : others =>
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Information (E));
         Self.Current.Timing := 0.0;
         Self.Current := null;
   end Timeit;

   ----------
   -- Save --
   ----------

   procedure Save (Self : in out Output'Class; Filename : String) is
      function Short_Image (D : Duration) return String;
      function Image (D : Duration) return String;

      function Short_Image (D : Duration) return String is
         M : constant String := D'Image & "        ";
      begin
         return M (M'First + 1 .. Integer'Min (M'Last, M'First + 5));
      end Short_Image;

      function Image (D : Duration) return String is
      begin
         if D >= 1.0 then
            return Short_Image (D) & "s";
         elsif D >= 0.001 then
            return Short_Image (D * 1_000) & "ms";
         elsif D >= 0.000_001 then
            return Short_Image (D * 1_000_000) & "us";
         else
            return Short_Image (D * 1_000_000_000) & "ns";
         end if;
      end Image;

   begin
      if Filename = "" then
         for Cat of Self.Categories loop
            Ada.Text_IO.Put_Line ("=== " & Cat.Category.To_String & " ===");
            for Col of Cat.Columns loop
               Ada.Text_IO.Put_Line ("   " & Col.Column.To_String);
               Ada.Text_IO.Put ("     ");
               for Row of Col.Rows loop
                  Ada.Text_IO.Put
                     (' ' & Row.Row.To_String & '=' & Image (Row.Timing));
               end loop;
               Ada.Text_IO.New_Line;
            end loop;
         end loop;

      else
         declare
            use Ada.Text_IO;
            F : File_Type;
            First_Row : Boolean;
            First_Test : Boolean := True;
         begin
            Create (F, Out_File, Filename);
            Put_Line (F, "var data = {");
            Put_Line (F, "   ""repeat_count"": 5,");  --  to be removed
            Put_Line (F, "   ""items_count"":"
               & Test_Support.Items_Count'Image & ",");
            Put_Line (F, "   ""tests"": [");

            for Cat of Self.Categories loop
               for Col of Cat.Columns loop
                  if not First_Test then
                     Put_Line (F, ",");
                  end if;
                  First_Test := False;

                  Put_Line (F, "      {");
                  Put_Line (F, "       ""name"": """
                     & Col.Column.To_String
                     & """,");
                  Put_Line (F, "       ""category"": """
                     & Cat.Category.To_String
                     & """,");
                  Put_Line (F, "       ""favorite"": "
                     & (if Col.Favorite then "true" else "false")
                     & ",");
                  Put_Line (F, "       ""size"":"
                     & Col.Size'Image & ",");
                  Put_Line (F, "       ""tests"": {");

                  First_Row := True;
                  for Row of Col.Rows loop
                     if not First_Row then
                        Put_Line (F, ",");
                     end if;
                     First_Row := False;
                     Put_Line
                        (F, "          """ & Row.Row.To_String & """: {");
                     Put_Line (F, "             ""duration"":"
                        & Row.Timing'Image & ",");
                     Put_Line (F, "             ""group"":"
                        & (if Row.Start_Group then "true" else "false")
                        & ",");
                     Put_Line (F, "             ""allocated"":"
                        & Row.Allocated'Image & ",");
                     Put_Line (F, "             ""allocs"":"
                        & Row.Allocs'Image & ",");
                     Put_Line (F, "             ""reallocs"":"
                        & Row.Reallocs'Image & ",");
                     Put_Line (F, "             ""frees"":"
                        & Row.Frees'Image);
                     Put (F, "        }");
                  end loop;
                  New_Line (F);
                  Put (F, "      }}");
               end loop;
            end loop;

            New_Line (F);
            Put_Line (F, "   ]");
            Put_Line (F, "};");

            Close (F);
            Put_Line ("Open file://" & Filename);
         end;
      end if;
   end Save;
end Report;
