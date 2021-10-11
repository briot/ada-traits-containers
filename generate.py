#!/usr/bin/env python3

import os
from typing import Literal

# Generate high-level packages by combining various traits packages

header = """
------------------------------------------------------------------------------
--                     Copyright (C) 2015-2021, AdaCore                     --
--                     Copyright (C) 2021-2021, Emmanuel Briot              --
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
""".lstrip()


Base = Literal[
    'Conts.Controlled_Base', 'Conts.Limited_Base', 'Container_Base_Type']
Pkg = Literal['Unbounded', 'Bounded', 'Unbounded_SPARK']


class Elements:
    pass


class Definite_Elements(Elements):
    def __init__(self, name="Element"):
        self.withs = "with Conts.Elements.Definite;"
        self.formals = f"   type {name}_Type is private;\n"
        self.formals_with_default = (
            f"   with procedure Free (E : in out {name}_Type) is null;\n"
        )
        self.traits = (
            f"   package {name}s is new Conts.Elements.Definite\n"
            f"      ({name}_Type, Free => Free);"
        )

    def equal(self) -> str:
        return ""


class Indefinite_Elements(Elements):
    def __init__(self, name="Element"):
        self.name = name
        self.withs = "with Conts.Elements.Indefinite;"
        self.formals = f"   type {name}_Type (<>) is private;\n"
        self.formals_with_default = (
            f"   with procedure Free (E : in out {name}_Type) is null;\n"
        )
        self.traits = (
            f"   package {name}s is new Conts.Elements.Indefinite\n"
            f"      ({name}_Type, Free => Free, Pool => Conts.Global_Pool);"
        )

    def equal(self) -> str:
        return (
            f"""
   function "=" (Left : {self.name}_Type; Right : {self.name}s.Traits.Stored) return Boolean
        is (Left = Right.all) with Inline;"""
        )

class Indefinite_Elements_SPARK(Elements):
    def __init__(self, name="Element"):
        self.name = name
        self.withs = "with Conts.Elements.Indefinite_SPARK;"
        self.formals = f"   type {name}_Type (<>) is private;\n"
        self.formals_with_default = ""
        self.traits = (
            f"   package {name}s is new Conts.Elements.Indefinite_SPARK\n"
            f"      ({name}_Type, Pool => Conts.Global_Pool);"
        )

    def equal(self) -> str:
        return (
            f"""
   function "=" (Left : {self.name}_Type; Right : {self.name}s.Traits.Stored) return Boolean
        is (Left = {self.name}s.Impl.To_Element
           ({self.name}s.Impl.To_Constant_Reference_Type (Right))) with Inline;"""
        )


class Array_Elements(Elements):
    def __init__(self, index: str, element: str, array: str):
        self.withs = "with Conts.Elements.Arrays;"
        self.formals = ""
        self.formals_with_default = ""
        self.traits = (
            f"   package Elements is new Conts.Elements.Arrays\n"
            f"     ({index}, {element}, {array}, Conts.Global_Pool);"
        )


class Storage:
    def __init__(self, container: str, pkg: Pkg, base: Base, extra_actual=""):
        self.withs = f"with Conts.{container}s.Storage.{pkg};"
        self.formals = (
            "   type Container_Base_Type is abstract tagged limited private;\n"
            if base == 'Container_Base_Type'
            else ""
        )
        self.subprograms = (
            ""
            if base != 'Conts.Limited_Base'
            else
            "\n"
            f"   function Copy (Self : {container}'Class) return {container}'Class;\n"
            "   --  Return a deep copy of Self\n"
        )
        self.body = (
            ""
            if base != 'Conts.Limited_Base'
            else
            f"""
   function Copy (Self : {container}'Class) return {container}'Class is
   begin
      return Result : {container} do
         Result.Assign (Self);
      end return;
   end Copy;"""
        )
        self.traits = (
            f"   package Storage is new Conts.{container}s.Storage.{pkg}\n"
            f"      (Elements            => Elements.Traits,\n"
            f"{extra_actual}"
            f"       Container_Base_Type => {base});"
        )


class Storage_Vector(Storage):
    def __init__(self, pkg: Pkg, base: Base='Container_Base_Type'):
        super().__init__(
            container="Vector",
            pkg=pkg,
            base=base,
            extra_actual=(
                ""
                if pkg == 'Bounded'
                else "       Resize_Policy       => Conts.Vectors.Resize_1_5,\n"
            )
        )


class Storage_List(Storage):
    def __init__(self, pkg: Pkg, base: Base='Container_Base_Type'):
        super().__init__(
            container="List",
            pkg=pkg,
            base=base,
            extra_actual=(
                ""
                if pkg != "Unbounded"
                else "       Pool                => Conts.Global_Pool,\n"
            )
        )


class Container:
    def __init__(
        self,
        pkg_name: str,
    ):
        self.pkg_name = pkg_name

    def write_files(self) -> None:
        filename = self.pkg_name.lower().replace('.', '-')

        generated = 'src/generated'

        try:
            os.mkdir(generated)
        except OSError:
            pass

        with open('%s/%s.ads' % (generated, filename), "w") as ads:
            ads.write(self.ads())

        b = self.adb()
        if b:
            with open("%s/%s.adb" % (generated, filename), "w") as adb:
                adb.write(b)

    def ads(self) -> str:
        return ""

    def adb(self) -> str:
        return ""


class Vector(Container):
    def __init__(
        self,
        pkg_name: str,
        storage: Storage,
        elements: Elements,
    ):
        self.pkg_name = pkg_name
        self.elements = elements
        self.storage = storage

    def ads(self) -> str:
        spark_mode = " with SPARK_Mode"
        return (f"""{header}
pragma Ada_2012;
with Conts.Properties.SPARK;
with Conts.Vectors.Generics;
{self.elements.withs}
{self.storage.withs}
generic
   type Index_Type is (<>);
{self.elements.formals}
{self.storage.formals}
{self.elements.formals_with_default}package {self.pkg_name}{spark_mode} is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

{self.elements.traits}
{self.storage.traits}
   package Vectors is new Conts.Vectors.Generics (Index_Type, Storage.Traits);
   package Cursors renames Vectors.Cursors;  --  Forward, Bidirectional, Random
   package Maps renames Vectors.Maps;

   subtype Vector is Vectors.Vector;
   subtype Cursor is Vectors.Cursor;
   subtype Extended_Index is Vectors.Extended_Index;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;

   No_Element : Cursor renames Vectors.No_Element;
   No_Index   : Index_Type renames Vectors.No_Index;

   procedure Swap
      (Self : in out Cursors.Forward.Container;
       Left, Right : Index_Type)
      renames Vectors.Swap;
{self.storage.subprograms}
   subtype Element_Sequence is Vectors.Impl.M.Sequence with Ghost;
   package Content_Models is new Conts.Properties.SPARK.Content_Models
        (Map_Type     => Vectors.Base_Vector'Class,
         Element_Type => Elements.Traits.Element,
         Model_Type   => Element_Sequence,
         Index_Type   => Vectors.Impl.M.Extended_Index,
         Model        => Vectors.Impl.Model,
         Get          => Vectors.Impl.M.Get,
         First        => Vectors.Impl.M.First,
         Last         => Vectors.Impl.M.Last);
   --  For SPARK proofs
end {self.pkg_name};
"""
    )

    def adb(self) -> str:
        if not self.storage.body:
            return ""

        return (f"""{header}
pragma Ada_2012;
package body {self.pkg_name} with SPARK_Mode => Off is
   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);
{self.storage.body}

end {self.pkg_name};
"""
        )


class List(Container):
    def __init__(
        self,
        pkg_name: str,
        storage: Storage,
        elements: Elements,
    ):
        self.pkg_name = pkg_name
        self.elements = elements
        self.storage = storage

    def ads(self) -> str:
        spark_mode = " with SPARK_Mode"
        return (f"""{header}
pragma Ada_2012;
with Conts.Properties.SPARK;
with Conts.Lists.Generics;
{self.elements.withs}
{self.storage.withs}

generic
{self.elements.formals}{self.storage.formals}{self.elements.formals_with_default}package {self.pkg_name}{spark_mode} is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

{self.elements.traits}
{self.storage.traits}
   package Lists is new Conts.Lists.Generics (Storage.Traits);
   package Cursors renames Lists.Cursors;  --  Forward, Bidirectional
   package Maps renames Lists.Maps;

   subtype List is Lists.List;
   subtype Cursor is Lists.Cursor;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;

   No_Element : Cursor renames Lists.No_Element;
{self.storage.subprograms}
   subtype Element_Sequence is Lists.Impl.M.Sequence with Ghost;
   subtype Cursor_Position_Map is Lists.Impl.P_Map with Ghost;
   package Content_Models is new Conts.Properties.SPARK.Content_Models
        (Map_Type     => Lists.Base_List'Class,
         Element_Type => Elements.Traits.Element,
         Model_Type   => Element_Sequence,
         Index_Type   => Lists.Impl.M.Extended_Index,
         Model        => Lists.Impl.Model,
         Get          => Lists.Impl.M.Get,
         First        => Lists.Impl.M.First,
         Last         => Lists.Impl.M.Last);
   --  For SPARK proofs
end {self.pkg_name};
"""
    )

    def adb(self) -> str:
        if not self.storage.body:
            return ""

        return (f"""{header}
pragma Ada_2012;
package body {self.pkg_name} with SPARK_Mode => Off is
   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);
{self.storage.body}

end {self.pkg_name};
"""
        )


class Map(Container):
    def __init__(
        self,
        pkg_name: str,
        pkg: Pkg,
        elements: Elements,
        keys: Elements,
        base: Base='Container_Base_Type',
    ):
        self.pkg_name = pkg_name
        self.pkg = pkg
        self.keys = keys
        self.elements = elements
        self.base = base
        self.storage = Storage(container='Map', pkg=pkg, base=base)

    def ads(self) -> str:
        spark_mode = " with SPARK_Mode"
        withs = "\n".join(set([self.elements.withs, self.keys.withs,]))

        spark_withs = (
            ""
            if self.pkg != 'Unbounded_SPARK'
            else
            "with Conts.Properties.SPARK;\n"
        )

        spark = (
            ""
            if self.pkg != 'Unbounded_SPARK'
            else
            """   subtype Model_Map is Impl.Impl.M.Map with Ghost;
   subtype Key_Sequence is Impl.Impl.K.Sequence with Ghost;
   subtype Cursor_Position_Map is Impl.Impl.P_Map with Ghost;
   package Content_Models is new Conts.Properties.SPARK.Content_Models
        (Map_Type     => Impl.Base_Map'Class,
         Element_Type => Key_Type,
         Model_Type   => Key_Sequence,
         Index_Type   => Impl.Impl.K.Extended_Index,
         Model        => Impl.S_Keys,
         Get          => Impl.Impl.K.Get,
         First        => Impl.Impl.K.First,
         Last         => Impl.Impl.K.Last);
   --  for SPARK proofs
"""
        )

        return (f"""{header}
pragma Ada_2012;
with Conts.Maps.Generics;
{spark_withs}{withs}

generic
{self.keys.formals}{self.elements.formals}{self.storage.formals}   with function Hash (Key : Key_Type) return Hash_Type;
   with function "=" (Left, Right : Key_Type) return Boolean is <>;
{self.keys.formals_with_default}{self.elements.formals_with_default}package {self.pkg_name}{spark_mode} is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

{self.keys.traits}
{self.elements.traits}
{self.keys.equal()}

   package Impl is new Conts.Maps.Generics
     (Keys                => Keys.Traits,
      Elements            => Elements.Traits,
      Hash                => Hash,
      "="                 => "=",
      Probing             => Conts.Maps.Perturbation_Probing,
      Pool                => Conts.Global_Pool,
      Container_Base_Type => {self.base});

   subtype Map is Impl.Map;
   subtype Cursor is Impl.Cursor;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;
   subtype Returned is Impl.Returned_Type;
   No_Element : Cursor renames Impl.No_Element;

   package Cursors renames Impl.Cursors;
   package Maps renames Impl.Maps;
{self.storage.subprograms}
{spark}
end {self.pkg_name};
"""
    )

    def adb(self) -> str:
        if not self.storage.body:
            return ""

        return (f"""{header}
pragma Ada_2012;
package body {self.pkg_name} with SPARK_Mode => Off is
   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);
{self.storage.body}

end {self.pkg_name};
"""
        )


containers = [
    Vector(
        pkg_name="Conts.Vectors.Definite_Bounded",
        elements=Definite_Elements(),
        storage=Storage_Vector(pkg='Bounded', base='Conts.Controlled_Base'),
    ),
    Vector(
        pkg_name="Conts.Vectors.Definite_Unbounded",
        elements=Definite_Elements(),
        storage=Storage_Vector(pkg='Unbounded'),
    ),
    Vector(
        pkg_name="Conts.Vectors.Indefinite_Bounded",
        elements=Indefinite_Elements(),
        storage=Storage_Vector(pkg='Bounded', base='Conts.Controlled_Base'),
    ),
    Vector(
        pkg_name="Conts.Vectors.Indefinite_Unbounded",
        elements=Indefinite_Elements(),
        storage=Storage_Vector(pkg='Unbounded'),
    ),
    Vector(
        pkg_name="Conts.Vectors.Indefinite_Unbounded_SPARK",
        elements=Indefinite_Elements_SPARK(),
        storage=Storage_Vector(pkg='Unbounded', base="Conts.Limited_Base"),
    ),
    Vector(
        pkg_name='Conts.Vectors.Strings',
        elements=Array_Elements('Positive', 'Character', 'String'),
        storage=Storage_Vector(pkg='Unbounded', base='Conts.Controlled_Base'),
    ),
    List(
        pkg_name="Conts.Lists.Definite_Bounded",
        elements=Definite_Elements(),
        storage=Storage_List(pkg='Bounded', base='Conts.Controlled_Base'),
    ),
    List(
        pkg_name="Conts.Lists.Definite_Unbounded",
        elements=Definite_Elements(),
        storage=Storage_List(pkg='Unbounded'),
    ),
    List(
        pkg_name="Conts.Lists.Indefinite_Bounded",
        elements=Indefinite_Elements(),
        storage=Storage_List(pkg='Bounded', base='Conts.Controlled_Base'),
    ),
    List(
        pkg_name="Conts.Lists.Indefinite_Unbounded",
        elements=Indefinite_Elements(),
        storage=Storage_List(pkg='Unbounded'),
    ),
    List(
        pkg_name="Conts.Lists.Indefinite_Unbounded_SPARK",
        elements=Indefinite_Elements_SPARK(),
        storage=Storage_List(base="Conts.Limited_Base", pkg="Unbounded_SPARK"),
    ),
    List(
        pkg_name='Conts.Lists.Strings',
        elements=Array_Elements('Positive', 'Character', 'String'),
        storage=Storage_List(pkg='Unbounded', base='Conts.Controlled_Base'),
    ),
    Map(
        pkg_name="Conts.Maps.Def_Def_Unbounded",
        pkg='Unbounded',
        keys=Definite_Elements(name='Key'),
        elements=Definite_Elements(),
    ),
    Map(
        pkg_name="Conts.Maps.Indef_Def_Unbounded",
        pkg='Unbounded',
        keys=Indefinite_Elements(name='Key'),
        elements=Definite_Elements(),
    ),
    Map(
        pkg_name="Conts.Maps.Indef_Indef_Unbounded",
        pkg='Unbounded',
        keys=Indefinite_Elements(name='Key'),
        elements=Indefinite_Elements(),
    ),
    Map(
        pkg_name="Conts.Maps.Indef_Indef_Unbounded_SPARK",
        pkg='Unbounded_SPARK',
        keys=Indefinite_Elements_SPARK(name='Key'),
        elements=Indefinite_Elements_SPARK(),
        base='Conts.Limited_Base',
    ),
]
for v in containers:
    v.write_files()

