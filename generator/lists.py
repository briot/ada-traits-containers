from .container import Container
from .elements import (
    Elements, Definite_Elements, Indefinite_Elements,
    Indefinite_Elements_SPARK)
from .help import header
from .storage import Storage
from .test import Test
from .types import Base, Pkg, base_to_str
from typing import Tuple, Optional, Sequence, Set


__slots__ = ['predefined']


class Storage_List(Storage):
    def __init__(self, pkg: Pkg, base: Base = 'Container_Base_Type'):
        super().__init__(
            container="List",
            pkg=pkg,
            base=base,
            extra_actual=(
                ""
                if pkg != "Unbounded"
                else "       Pool                => GAL.Pools.Global_Pool,\n"
            )
        )

        if pkg == "Unbounded":
            self.withs.add("GAL.Pools")


List_Test_Data = Tuple[
    str,             # list of element types to test
    Optional[Base],  # container_base (if applicable)
    bool,            # favorite: is this a container users would likely use
    str,             # category of the test
]


class List_Test(Test):
    def __init__(self, container: "List_Container", data: List_Test_Data):
        self.container = container
        self.element = data[0]
        self.base = data[1]
        self.favorite = data[2] is True
        self.category_name = data[3] or self.element
        self.withs: Set[str] = set(["Support_Lists"])
        if '.' in self.element:
            self.withs.add(self.element.rsplit('.', 1)[0])

    def category(self) -> str:
        return f"{self.category_name} List"

    def container_name(self) -> str:
        base = base_to_str(self.base or self.container.storage.base)
        n = (
            f"{self.container.elements.descr}"
            f" {self.container.storage.pkg}{base}"
        )
        if self.element != self.category_name:
            e = self.element.rsplit('.', 1)[-1]
            n += f" ({e})"
        return n

    def test_name(self) -> str:
        return self.container.pkg_name \
            .lower() \
            .replace('gal.', '') \
            .replace('.', '-') \
            + '-' + self.element.lower()

    def code(self, idx: int) -> str:
        actual = [self.element]
        if self.base:
            actual.append(f"Container_Base_Type => {self.base}")
        actual_str = "(%s)" % ", ".join(actual)

        actual_support = []
        if '.' in self.element:
            p = self.element.rsplit('.', 1)[0]
            actual_support.append(f'"="            => {p}."="')
        actual_support_str = "".join(
            ",\n       {}".format(s)
            for s in actual_support)

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
       Check_Element  => Test_Support.Check_Element{actual_support_str});

   procedure Test{idx} is
      L1, L2 : Lists{idx}.List{self.container.storage.bounds_for_test};
   begin
      Tests{idx}.Test_Correctness (L1, L2);
   end Test{idx};

   procedure Test_Perf{idx}
      (Result : in out Report.Output'Class; Favorite : Boolean)
   is
      L1, L2 : Lists{idx}.List{self.container.storage.bounds_for_perf_test};
   begin
      Tests{idx}.Test_Perf (Result, L1, L2, Favorite => Favorite);
   end Test_Perf{idx};
"""


class List_Container(Container):
    def __init__(
            self,
            pkg_name: str,
            storage: Storage,
            elements: Elements,
            tests: Sequence[List_Test_Data] = [],
            ):
        super().__init__(
            pkg_name=pkg_name,
            tests=[List_Test(container=self, data=t) for t in tests]
        )
        self.elements = elements
        self.storage = storage

    def ads(self) -> str:
        spark_mode = " with SPARK_Mode"

        withs: Set[str] = set([
            "GAL.Properties.SPARK",
            "GAL.Lists.Generics",
        ])
        withs.update(self.elements.withs)
        withs.update(self.storage.withs)
        withs_str = "\n".join(f"with {t};" for t in sorted(withs))

        return (
            f"""{header}
--  {self.pkg_name}
--  {'=' * len(self.pkg_name)}
--
--  This package is a high level version of the lists. It uses a limited number
--  of formal parameters to make instantiation easier and uses default choices
--  for all other parameters. If you need full control over how memory is
--  allocated, whether to use controlled types or not, and so on, please
--  consider using the low-level packages instead.
--{self.storage.doc()}
--{self.elements.doc('elements')}

pragma Ada_2012;
{withs_str}

generic
{self.elements.formals}{self.storage.formals}{self.elements.formals_with_default}package {self.pkg_name}{spark_mode} is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

   --------------------
   -- Instantiations --
   --------------------

{self.elements.traits}
{self.storage.traits}
   package Lists is new GAL.Lists.Generics (Storage.Traits);
   package Cursors renames Lists.Cursors;  --  Forward, Bidirectional
   package Maps renames Lists.Maps;        --  From cursors to elements

   --------------------------
   -- Types and Operations --
   --------------------------

   subtype List is Lists.List;
   subtype Cursor is Lists.Cursor;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;
   subtype Returned is Elements.Traits.Returned;

   No_Element : Cursor renames Lists.No_Element;

   procedure Swap
      (Self        : in out Cursors.Forward.Container;  --  List
       Left, Right : Cursor)
      renames Lists.Swap;
{self.storage.subprograms}
   -------------------
   -- SPARK support --
   -------------------

   subtype Element_Sequence is Lists.Impl.M.Sequence with Ghost;
   subtype Cursor_Position_Map is Lists.Impl.P_Map with Ghost;
   package Content_Models is new GAL.Properties.SPARK.Content_Models
        (Map_Type     => Lists.Base_List'Class,
         Element_Type => Element_Type,
         Model_Type   => Element_Sequence,
         Index_Type   => Lists.Impl.M.Extended_Index,
         Model        => Lists.Impl.Model,
         Get          => Lists.Impl.M.Get,
         First        => Lists.Impl.M.First,
         Last         => Lists.Impl.M.Last);
end {self.pkg_name};
"""
        )

    def adb(self) -> str:
        if not self.storage.body:
            return ""

        return (
            f"""{header}
pragma Ada_2012;
package body {self.pkg_name} with SPARK_Mode => Off is
   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);
{self.storage.body}

end {self.pkg_name};
"""
        )


predefined = [
    List_Container(
        pkg_name="GAL.Lists.Definite_Bounded",
        elements=Definite_Elements(),
        storage=Storage_List(pkg='Bounded', base='GAL.Controlled_Base'),
        tests=[("Integer", None, False, "Integer")],
    ),
    List_Container(
        pkg_name="GAL.Lists.Definite_Bounded_Limited",
        elements=Definite_Elements(),
        storage=Storage_List(
            pkg='Bounded', base='GAL.Limited_Controlled_Base'),
        tests=[("Integer", None, False, "Integer")],
    ),
    List_Container(
        pkg_name="GAL.Lists.Definite_Unbounded",
        elements=Definite_Elements(),
        storage=Storage_List(pkg='Unbounded'),
        tests=[("Integer", "GAL.Controlled_Base", True, "Integer")],
    ),
    List_Container(
        pkg_name="GAL.Lists.Definite_Unbounded_Limited",
        elements=Definite_Elements(),
        storage=Storage_List(
            pkg='Unbounded', base='GAL.Limited_Controlled_Base'),
        tests=[("Integer", None, False, "Integer")],
    ),
    List_Container(
        pkg_name="GAL.Lists.Indefinite_Bounded",
        elements=Indefinite_Elements(),
        storage=Storage_List(pkg='Bounded', base='GAL.Controlled_Base'),
        tests=[
            ("Integer", None, False, "Integer"),
            ("String", None, False, "String"),
        ],
    ),
    List_Container(
        pkg_name="GAL.Lists.Indefinite_Unbounded",
        elements=Indefinite_Elements(),
        storage=Storage_List(pkg='Unbounded'),
        tests=[
            ("Integer", "GAL.Controlled_Base", False, "Integer"),
            ("String", "GAL.Controlled_Base", True, "String"),
        ],
    ),
    List_Container(
        pkg_name="GAL.Lists.Indefinite_Unbounded_SPARK",
        elements=Indefinite_Elements_SPARK(),
        storage=Storage_List(base="GAL.Limited_Base", pkg="Unbounded_SPARK"),
        tests=[
            ("Integer", None, False, "Integer"),
            ("String", None, False, "String"),
        ],
    ),
    List_Container(
        pkg_name="GAL.Lists.Unmovable_Definite_Unbounded",
        elements=Definite_Elements(movable=False, copyable=False),
        storage=Storage_List(pkg='Unbounded'),
        tests=[
            ("GNATCOLL.Strings.XString",
             "GAL.Controlled_Base",
             True, "String"),
        ],
    ),
    #    List_Container(
    #        pkg_name='GAL.Lists.Strings',
    #        elements=Array_Elements('Positive', 'Character', 'String'),
    #        storage=Storage_List(pkg='Unbounded', base='GAL.Controlled_Base'),
    #        tests=["String"],
    #    ),
]
