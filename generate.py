#!/usr/bin/env python3

import os
from typing import Literal, Sequence, Tuple, List, Optional

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


def base_to_str(base: Base) -> str:
    if base == 'Conts.Controlled_Base':
        return ''
    elif base == 'Conts.Limited_Base':
        return ' limited'
    raise Exception("unknown base %s" % base)


class Test:
    withs: str
    def code(self, idx: int) -> str: ...
    def test_name(self) -> str: ...


class Elements:
    descr: str
    withs: str
    formals: str
    formals_with_default: str
    traits: str
    def equal(self) -> str: ...


class Definite_Elements(Elements):
    def __init__(self, name="Element"):
        self.descr = "Def"
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
        self.descr = "Indef"
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
        self.descr = "Indef_SPARK"
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
        self.descr = "Array"
        self.withs = "with Conts.Elements.Arrays;"
        self.array = array
        self.formals = ""
        self.formals_with_default = ""
        self.traits = (
            f"   package Elements is new Conts.Elements.Arrays\n"
            f"     ({index}, {element}, {array}, Conts.Global_Pool);"
        )


class Storage:
    def __init__(self, container: str, pkg: Pkg, base: Base, extra_actual=""):
        self.pkg = pkg
        self.base = base
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

        bounds = (
            ""
            if pkg != 'Bounded'
            else " (Self.Capacity)"
        )
        self.body = (
            ""
            if base != 'Conts.Limited_Base'
            else
            f"""
   function Copy (Self : {container}'Class) return {container}'Class is
   begin
      return Result : {container}{bounds} do
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
        self.bounds_for_test = (
            " (20)"
            if pkg == 'Bounded'
            else ""
        )
        self.bounds_for_perf_test = (
            " (Test_Support.Items_Count)"
            if pkg == 'Bounded'
            else ""
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
    all_tests: List["Container"] = []

    def __init__(
        self,
        pkg_name: str,
        tests: Sequence[Test],
    ):
        Container.all_tests.append(self)

        self.pkg_name = pkg_name
        self.test_pkg = pkg_name.replace("Conts.", "Tests_").replace(".", "_")
        self.tests = tests

    def write_files(self) -> None:
        filename = self.pkg_name.lower().replace('.', '-')
        testname = self.test_pkg.lower().replace('.', '-')

        generated = 'src/generated'
        test_generated = 'tests/generated'

        try:
            os.mkdir(generated)
        except OSError:
            pass

        try:
            os.mkdir(test_generated)
        except OSError:
            pass

        with open('%s/%s.ads' % (generated, filename), "w") as f:
            f.write(self.ads())

        b = self.adb()
        if b:
            with open("%s/%s.adb" % (generated, filename), "w") as f:
                f.write(b)

        if self.tests:
            with open("%s/%s.ads" % (test_generated, testname), "w") as f:
                f.write(
                    f"with Report;\n"
                    f"package {self.test_pkg} is\n"
                )
                for idx, t in enumerate(self.tests):
                    f.write(f"   procedure Test{idx};\n")
                    f.write(
                        f"   procedure Test_Perf{idx}"
                        f"      (Result : in out Report.Output'Class);\n"
                    )
                f.write(f"end {self.test_pkg};")

            adb_withs = set([
                f"with {self.pkg_name};",
                f"with Test_Support;",
            ])
            for t in self.tests:
                adb_withs.add(t.withs)

            with open("%s/%s.adb" % (test_generated, testname), "w") as f:
                f.write("\n".join(adb_withs))
                f.write(f"\npackage body {self.test_pkg} is\n")
                for idx, t in enumerate(self.tests):
                    f.write(t.code(idx))
                f.write(f"end {self.test_pkg};")

    @classmethod
    def write_main_driver(cls) -> None:
        with open("tests/generated/main_driver.adb", "w") as f:
            for cont in cls.all_tests:
                if cont.tests:
                    f.write(f"with {cont.test_pkg};\n")
            f.write("with Test_Support;\n")
            f.write("procedure Main_Driver (F : Test_Support.Test_Filter) is\nbegin\n")
            for cont in cls.all_tests:
                for idx, t in enumerate(cont.tests):
                    f.write(
                        f'   if F.Active ("{t.test_name()}") then\n'
                        f"      {cont.test_pkg}.Test{idx};\n"
                        f"   end if;\n"
                    )
            f.write("""end Main_Driver;""")

        try:
            os.mkdir("tests/perfs/generated")
        except OSError:
            pass

        with open("tests/perfs/generated/run_all.adb", "w") as f:
            for cont in cls.all_tests:
                if cont.tests:
                    f.write(f"with {cont.test_pkg};\n")
            f.write("with Test_Support;\n")
            f.write("with Report;\n")
            f.write("procedure Run_All\n"
                    "   (Result : in out Report.Output'Class;\n"
                    "    Filter : Test_Support.Test_Filter)\n"
                    "is\n"
                    "begin\n")
            for cont in cls.all_tests:
                for idx, t in enumerate(cont.tests):
                    f.write(
                        f'   if Filter.Active ("{t.test_name()}") then\n'
                        f"      {cont.test_pkg}.Test_Perf{idx} (Result);\n"
                        f"   end if;\n"
                    )
            f.write("""end Run_All;""")

    def ads(self) -> str:
        return ""

    def adb(self) -> str:
        return ""


Vector_Test_Data = Tuple[
    str,             # index type
    str,             # list of element types to test
    Optional[Base],  # container_base (if applicable)
    bool,            # favorite: is this a container users would likely use
]


class Vector_Test(Test):
    def __init__(
        self,
        container: "Vector_Container",
        data: Vector_Test_Data,
    ):
        self.index: str = data[0]
        self.element: str = data[1]
        self.base: Optional[Base] = data[2]
        self.favorite = ("True" if data[3] else "False")
        self.container = container
        self.withs = "with Support_Vectors;"

    def category(self) -> str:
        return f"{self.element} Vector"

    def container_name(self) -> str:
        base = base_to_str(self.base or self.container.storage.base)
        return (
            f"{self.container.elements.descr}"
            f" {self.container.storage.pkg}{base}"
        )

    def test_name(self) -> str:
        return self.container.pkg_name.lower(
            ).replace('conts.', ''
            ).replace('.', '-'
            ) + '-' + self.element.lower()

    def code(self, idx: int) -> str:
        actual = [self.index, self.element]
        if self.base:
            actual.append(f"Container_Base_Type => {self.base}")
        actual_str = "(%s)" % ", ".join(actual)

        return f"""
   package Vecs{idx} is new {self.container.pkg_name}
      {actual_str};
   package Tests{idx} is new Support_Vectors
      (Category       => "{self.category()}",
       Container_Name => "{self.container_name()}",
       Image          => Test_Support.Image,
       Vectors        => Vecs{idx}.Vectors,
       Check_Element  => Test_Support.Check_Element,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth);

   procedure Test{idx} is
      V : Vecs{idx}.Vector{self.container.storage.bounds_for_test};
   begin
      Tests{idx}.Test (V);
   end Test{idx};

   procedure Test_Perf{idx} (Result : in out Report.Output'Class) is
      V1, V2 : Vecs{idx}.Vector{self.container.storage.bounds_for_perf_test};
   begin
      Tests{idx}.Test_Perf (Result, V1, V2, Favorite => {self.favorite});
   end Test_Perf{idx};
"""


class Vector_Container(Container):
    def __init__(
        self,
        pkg_name: str,
        storage: Storage,
        elements: Elements,
        tests: Sequence[Vector_Test_Data]=[]
    ):
        super().__init__(
            pkg_name=pkg_name,
            tests=[Vector_Test(container=self, data=t) for t in tests],
        )
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

List_Test_Data = Tuple[
    str,             # list of element types to test
    Optional[Base],  # container_base (if applicable)
    bool,            # favorite: is this a container users would likely use
]


class List_Test(Test):
    def __init__(self, container: "List_Container", data: List_Test_Data):
        self.container = container
        self.element = data[0]
        self.base = data[1]
        self.withs = "with Support_Lists;"
        self.favorite = ("True" if data[2] else "False")

    def category(self) -> str:
        return f"{self.element} List"

    def container_name(self) -> str:
        base = base_to_str(self.base or self.container.storage.base)
        return (
            f"{self.container.elements.descr}"
            f" {self.container.storage.pkg}{base}"
        )

    def test_name(self) -> str:
        return self.container.pkg_name.lower(
            ).replace('conts.', ''
            ).replace('.', '-'
            ) + '-' + self.element.lower()

    def code(self, idx: int) -> str:
        actual = [self.element]
        if self.base:
            actual.append(f"Container_Base_Type => {self.base}")
        actual_str = "(%s)" % ", ".join(actual)

        return f"""
   package Lists{idx} is new {self.container.pkg_name}
      {actual_str};
   package Tests{idx} is new Support_Lists
      (Category       => "{self.category()}",
       Container_Name => "{self.container_name()}",
       Image          => Test_Support.Image,
       Lists          => Lists{idx}.Lists,
       Nth            => Test_Support.Nth,
       Perf_Nth       => Test_Support.Perf_Nth,
       Check_Element  => Test_Support.Check_Element);

   procedure Test{idx} is
      L1, L2 : Lists{idx}.List{self.container.storage.bounds_for_test};
   begin
      Tests{idx}.Test_Correctness (L1, L2);
   end Test{idx};

   procedure Test_Perf{idx} (Result : in out Report.Output'Class) is
      L1, L2 : Lists{idx}.List{self.container.storage.bounds_for_perf_test};
   begin
      Tests{idx}.Test_Perf (Result, L1, L2, Favorite => {self.favorite});
   end Test_Perf{idx};
"""


class List_Container(Container):
    def __init__(
        self,
        pkg_name: str,
        storage: Storage,
        elements: Elements,
        tests: Sequence[List_Test_Data]=[],
    ):
        super().__init__(
            pkg_name=pkg_name,
            tests=[List_Test(container=self, data=t) for t in tests]
        )
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


Map_Test_Data = Tuple[
    str,             # key type
    str,             # element type
    Optional[Base],  # container_base (if applicable)
    bool,            # favorite: is this a container users would likely use
]


class Map_Test(Test):
    def __init__(
        self,
        container: "Map_Container",
        data: Map_Test_Data,
    ):
        self.key: str = data[0]
        self.element: str = data[1]
        self.base: Optional[Base] = data[2]
        self.favorite = ("True" if data[3] else "False")
        self.container = container
        self.withs = "with Support_Maps;"

    def category(self) -> str:
        return f"{self.key}-{self.element} Map"

    def container_name(self) -> str:
        base = base_to_str(self.base or self.container.storage.base)
        return (
            f"{self.container.keys.descr}-"
            f"{self.container.elements.descr}"
            f" {self.container.storage.pkg}{base}"
        )

    def test_name(self) -> str:
        return self.container.pkg_name.lower(
            ).replace('conts.', ''
            ).replace('.', '-'
            ) + '-' + self.key.lower() + '-' + self.element.lower()

    def code(self, idx: int) -> str:
        actual = [
            self.key,
            f"\n       Element_Type => {self.element}",
            f"\n       Hash => Test_Support.Hash",
        ]
        if self.base:
            actual.append(f"\n       Container_Base_Type => {self.base}")
        actual_str = "(%s)" % ",".join(actual)

        return f"""
   package Maps{idx} is new {self.container.pkg_name}
      {actual_str};
   package Tests{idx} is new Support_Maps
      (Category         => "{self.category()}",
       Container_Name   => "{self.container_name()}",
       Image_Element    => Test_Support.Image,
       Maps             => Maps{idx}.Impl,
       Check_Element    => Test_Support.Check_Element,
       Nth_Key          => Test_Support.Nth,
       Nth_Element      => Test_Support.Nth,
       Nth_Perf_Element => Test_Support.Perf_Nth);

   procedure Test{idx} is
      M1, M2 : Maps{idx}.Map{self.container.storage.bounds_for_test};
   begin
      Tests{idx}.Test (M1, M2);
   end Test{idx};

   procedure Test_Perf{idx} (Result : in out Report.Output'Class) is
      M1, M2 : Maps{idx}.Map{self.container.storage.bounds_for_test};
   begin
      Tests{idx}.Test_Perf (Result, M1, M2, Favorite => {self.favorite});
   end Test_Perf{idx};
"""


class Map_Container(Container):
    def __init__(
        self,
        pkg_name: str,
        pkg: Pkg,
        elements: Elements,
        keys: Elements,
        base: Base='Container_Base_Type',
        tests: List[Map_Test_Data] = [],
    ):
        super().__init__(
            pkg_name=pkg_name,
            tests=[Map_Test(container=self, data=t) for t in tests],
        )
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
    Vector_Container(
        pkg_name="Conts.Vectors.Definite_Bounded",
        elements=Definite_Elements(),
        storage=Storage_Vector(pkg='Bounded', base='Conts.Controlled_Base'),
        tests=[("Positive", "Integer", None, False)],
    ),
    Vector_Container(
        pkg_name="Conts.Vectors.Definite_Unbounded",
        elements=Definite_Elements(),
        storage=Storage_Vector(pkg='Unbounded'),
        tests=[("Positive", "Integer", "Conts.Controlled_Base", True)],
    ),
    Vector_Container(
        pkg_name="Conts.Vectors.Indefinite_Bounded",
        elements=Indefinite_Elements(),
        storage=Storage_Vector(pkg='Bounded', base='Conts.Controlled_Base'),
        tests=[
            ("Positive", "Integer", None, False),
            ("Positive", "String", None, False),
        ],
    ),
    Vector_Container(
        pkg_name="Conts.Vectors.Indefinite_Unbounded",
        elements=Indefinite_Elements(),
        storage=Storage_Vector(pkg='Unbounded'),
        tests=[
            ("Positive", "Integer", "Conts.Controlled_Base", False),
            ("Positive", "String", "Conts.Controlled_Base", True),
        ],
    ),
    Vector_Container(
        pkg_name="Conts.Vectors.Indefinite_Unbounded_SPARK",
        elements=Indefinite_Elements_SPARK(),
        storage=Storage_Vector(pkg='Unbounded', base="Conts.Limited_Base"),
        tests=[
            ("Positive", "Integer", None, False),
            ("Positive", "String", None, False),
        ],
    ),
#    Vector_Container(
#        pkg_name='Conts.Vectors.Strings',
#        elements=Array_Elements('Positive', 'Character', 'String'),
#        storage=Storage_Vector(pkg='Unbounded', base='Conts.Controlled_Base'),
#    ),
    List_Container(
        pkg_name="Conts.Lists.Definite_Bounded",
        elements=Definite_Elements(),
        storage=Storage_List(pkg='Bounded', base='Conts.Controlled_Base'),
        tests=[("Integer", None, False)],
    ),
    List_Container(
        pkg_name="Conts.Lists.Definite_Bounded_Limited",
        elements=Definite_Elements(),
        storage=Storage_List(pkg='Bounded', base='Conts.Limited_Base'),
        tests=[("Integer", None, False)],
    ),
    List_Container(
        pkg_name="Conts.Lists.Definite_Unbounded",
        elements=Definite_Elements(),
        storage=Storage_List(pkg='Unbounded'),
        tests=[("Integer", "Conts.Controlled_Base", True)],
    ),
    List_Container(
        pkg_name="Conts.Lists.Definite_Unbounded_Limited",
        elements=Definite_Elements(),
        storage=Storage_List(pkg='Unbounded', base='Conts.Limited_Base'),
        tests=[("Integer", None, False)],
    ),
    List_Container(
        pkg_name="Conts.Lists.Indefinite_Bounded",
        elements=Indefinite_Elements(),
        storage=Storage_List(pkg='Bounded', base='Conts.Controlled_Base'),
        tests=[
            ("Integer", None, False),
            ("String", None, False),
        ],
    ),
    List_Container(
        pkg_name="Conts.Lists.Indefinite_Unbounded",
        elements=Indefinite_Elements(),
        storage=Storage_List(pkg='Unbounded'),
        tests=[
            ("Integer", "Conts.Controlled_Base", False),
            ("String", "Conts.Controlled_Base", True),
        ],
    ),
    List_Container(
        pkg_name="Conts.Lists.Indefinite_Unbounded_SPARK",
        elements=Indefinite_Elements_SPARK(),
        storage=Storage_List(base="Conts.Limited_Base", pkg="Unbounded_SPARK"),
        tests=[
            ("Integer", None, False),
            ("String", None, False),
        ],
    ),
#    List_Container(
#        pkg_name='Conts.Lists.Strings',
#        elements=Array_Elements('Positive', 'Character', 'String'),
#        storage=Storage_List(pkg='Unbounded', base='Conts.Controlled_Base'),
#        tests=["String"],
#    ),
    Map_Container(
        pkg_name="Conts.Maps.Def_Def_Unbounded",
        pkg='Unbounded',
        keys=Definite_Elements(name='Key'),
        elements=Definite_Elements(),
        tests=[
            ("Integer", "Integer", "Conts.Controlled_Base", True),
        ],
    ),
    Map_Container(
        pkg_name="Conts.Maps.Indef_Def_Unbounded",
        pkg='Unbounded',
        keys=Indefinite_Elements(name='Key'),
        elements=Definite_Elements(),
        tests=[
            ("Integer", "Integer", "Conts.Controlled_Base", False),
            ("String", "Integer", "Conts.Controlled_Base", True),
        ],
    ),
    Map_Container(
        pkg_name="Conts.Maps.Indef_Indef_Unbounded",
        pkg='Unbounded',
        keys=Indefinite_Elements(name='Key'),
        elements=Indefinite_Elements(),
        tests=[
            ("Integer", "Integer", "Conts.Controlled_Base", False),
            ("String", "String", "Conts.Controlled_Base", True),
        ],
    ),
    Map_Container(
        pkg_name="Conts.Maps.Indef_Indef_Unbounded_SPARK",
        pkg='Unbounded_SPARK',
        keys=Indefinite_Elements_SPARK(name='Key'),
        elements=Indefinite_Elements_SPARK(),
        base='Conts.Limited_Base',
        tests=[
            ("Integer", "Integer", None, False),
            ("String", "String", None, False),
        ],
    ),
]
for v in containers:
    v.write_files()
Container.write_main_driver()

