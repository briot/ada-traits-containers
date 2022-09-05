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

--  Support for output of the tests

with Ada.Unchecked_Conversion;
with Ada.Calendar;     use Ada.Calendar;
with Ada.Containers.Doubly_Linked_Lists;
with GNATCOLL.Strings; use GNATCOLL.Strings;
with Memory;           use Memory;
with System.Storage_Elements;
private with Ada.Finalization;

package Report is

   type Output is tagged limited private;

   subtype Category_Type is String;
   --  Tests are grouped into categories (the overall part of the code they are
   --  testing). Those categories result in separate tables in the output.

   Default_Minimum_Running_Time : constant Duration := 0.2;
   --  Ensures that a test is repeated often enough that the total time is at
   --  least this many seconds.

   Default_Minimum_Runs : constant Positive := 3;
   --  Minimal number of times that a test is repeated.

   Default_Maximum_Runs : constant Positive := 100_000;
   --  Maximum number of times we run a test

   Default_Warmup_Runs : constant Natural := 0;
   --  Perform a few executions of the test before we start measuring time, to
   --  warm up caches (CPU + disk)

   procedure Setup
      (Self                 : in out Output'Class;
       Minimum_Running_Time : Duration := Default_Minimum_Running_Time;
       Minimum_Runs         : Positive := Default_Minimum_Runs;
       Maximum_Runs         : Positive := Default_Maximum_Runs;
       Warmup_Runs          : Natural := Default_Warmup_Runs);
   --  Setup for the Timeit subprograms.

   generic
      with procedure Run;
      with procedure Setup is null;
      with procedure Cleanup is null;
   procedure Timeit
      (Self        : in out Output'Class;
       Category    : Category_Type;
       Column      : String;
       Row         : String;
       Comment     : String := "";
       Factor      : Positive := 1;
       Start_Group : Boolean := False);
   --  Column: typically the container or the algorithm we test. Each of these
   --     run the same set of tests (within a category), so the intent is to
   --     compare them.
   --  Row: typically the specific test we run.
   --  Run: the actual test.
   --  Setup and Cleanup: run before each call to Run, not counted in elapsed
   --     time.
   --  Factor: divide all timings by this value. Should be used when the test
   --     has its own internal loop for instance, to help focus on a specific
   --     run of the loop. This can be used to reduce the impact of internal
   --     setup of the loop for instance.
   --  Start_Group: whether to start a new group. All following tests
   --     will belong to the same group, until a test that also sets
   --     Start_Group to True.
   --     Tests are grouped, so that the first test run in a group, for the
   --     first container, is displayed as "100%", and other tests in the same
   --     group are displayed relative to this one.

   procedure Set_Column
     (Self        : in out Output'Class;
      Category    : String;  --  Each of the groups of tests
      Column      : String;  --  Typically: the container we test
      Size        : System.Storage_Elements.Storage_Count;
      Favorite    : Boolean := False);
   --  Saves the size of the container in the output (for information only)
   --  Favorite: should be True if this column is what we would expect users
   --     to use by default in their code.

   procedure Start_Test
      (Self        : in out Output'Class;
       Category    : Category_Type;
       Column      : String;  --  Typically: the container we test
       Row         : String;  --  Typically: the specific test we ran
       Comment     : String := "";
       Start_Group : Boolean := False);
   procedure End_Test (Self : in out Output'Class);
   --  A new test is about to start. These procedures measure
   --  the execution time, number of allocation and deallocations and total
   --  allocated.
   --  Those are low-level code below Timeit, for when using the latter is not
   --  possible.
   --  Calling End_Test is optional if you are calling Start_Test immediately.
   --  You can run the same test multiple times after calling
   --  Start_Container_Test. All timings will be recorded.

   procedure End_Test_Not_Run (Self : in out Output'Class);
   --  Same as End_Test, but mark the test as "NOT RUN".

   procedure Save (Self : in out Output'Class; Filename : String);
   --  Outputs the results to a JSON file (if Filename is not empty) or
   --  the terminal (otherwise)

private

   type Row_Descr_Type is record
       Row         : GNATCOLL.Strings.XString;
       Comment     : GNATCOLL.Strings.XString;
       Start_Group : Boolean := False;
       Timing      : Duration := 0.0;
       Allocs      : Natural := 0;
       Frees       : Natural := 0;
       Reallocs    : Natural := 0;
       Allocated   : System.Storage_Elements.Storage_Count := 0;
   end record;
   type Row_Descr_Access is access Row_Descr_Type;
   package Row_Lists is new Ada.Containers.Doubly_Linked_Lists
      (Element_Type => Row_Descr_Access);
   --  Order matters, so we use lists

   type Column_Descr_Type is record
      Column   : GNATCOLL.Strings.XString;
      Size     : System.Storage_Elements.Storage_Count := 0;
      Favorite : Boolean := False;
      Rows     : Row_Lists.List;
   end record;
   package Column_Lists is new Ada.Containers.Doubly_Linked_Lists
      (Element_Type => Column_Descr_Type);

   type Category_Descr_Type is record
      Category : GNATCOLL.Strings.XString;
      Columns  : Column_Lists.List;
   end record;
   package Category_Lists is new Ada.Containers.Doubly_Linked_Lists
      (Element_Type => Category_Descr_Type);

   type Output is new Ada.Finalization.Limited_Controlled with record
      Categories           : Category_Lists.List;
      Current              : Row_Descr_Access;
      At_Test_Start        : Memory.Mem_Info;
      Start_Time           : Ada.Calendar.Time;
      Minimum_Running_Time : Duration := Default_Minimum_Running_Time;
      Minimum_Runs         : Positive := Default_Minimum_Runs;
      Maximum_Runs         : Positive := Default_Maximum_Runs;
      Warmup_Runs          : Natural := Default_Warmup_Runs;
   end record;

   overriding procedure Finalize (Self : in out Output);

end Report;
