------------------------------------------------------------------------------
--                     Copyright (C) 2016, AdaCore                          --
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
with GNAT.IO;   use GNAT.IO;

package body Asserts is

   -------------------------
   -- On_Assertion_Failed --
   -------------------------

   overriding procedure On_Assertion_Failed
      (Self     : Testsuite_Reporter;
       Msg      : String;
       Details  : String;
       Location : String;
       Entity   : String)
   is
      pragma Unreferenced (Self);
      Full : constant String :=
         ((if Msg = "" then "" else Msg & " ")
          & "(at " & Location & ", in " & Entity & ")"
          & ASCII.LF & "   " & Details);
   begin
      --  Print the full error message, because exception messages could get
      --  truncated.
      Put_Line (Full);
      raise Test_Failed;
   end On_Assertion_Failed;

end Asserts;
