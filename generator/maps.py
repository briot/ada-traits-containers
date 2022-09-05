from .container import Container
from .elements import (
    Elements, Definite_Elements, Indefinite_Elements,
    Indefinite_Elements_SPARK)
from .help import header
from .storage import Storage
from .test import Test
from .types import Base, Pkg, base_to_str
from typing import Tuple, Optional, Set, Sequence


__slots__ = ['predefined']


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
        self.favorite = data[3] is True
        self.container = container
        self.withs: Set[str] = set(["Support_Maps"])
        if '.' in self.key:
            self.withs.add(self.key.rsplit('.', 1)[0])
        if '.' in self.element:
            self.withs.add(self.element.rsplit('.', 1)[0])

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
        return self.container.pkg_name \
            .lower() \
            .replace('gal.', '') \
            .replace('.', '-') \
            + '-' + self.key.lower() + '-' + self.element.lower()

    def code(self, idx: int) -> str:
        actual = [
            self.key,
            f"\n       Element_Type => {self.element}",
            "\n       Hash => Test_Support.Hash",
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

   procedure Test_Perf{idx}
      (Result : in out Report.Output'Class; Favorite : Boolean)
   is
      M1, M2 : Maps{idx}.Map{self.container.storage.bounds_for_test};
   begin
      Tests{idx}.Test_Perf (Result, M1, M2, Favorite => Favorite);
   end Test_Perf{idx};
"""


class Map_Container(Container):
    def __init__(
            self,
            pkg_name: str,
            pkg: Pkg,
            elements: Elements,
            keys: Elements,
            base: Base = 'Container_Base_Type',
            tests: Sequence[Map_Test_Data] = [],
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
        withs: Set[str] = set([
            "GAL.Pools",
            "GAL.Maps.Generics",
        ])
        withs.update(self.elements.withs)
        withs.update(self.keys.withs)

        if self.pkg == "Unbounded_SPARK":
            withs.add("GAL.Properties.SPARK")

        spark = (
            ""
            if self.pkg != 'Unbounded_SPARK'
            else
            """   subtype Model_Map is Impl.Impl.M.Map with Ghost;
   subtype Key_Sequence is Impl.Impl.K.Sequence with Ghost;
   subtype Cursor_Position_Map is Impl.Impl.P_Map with Ghost;
   package Content_Models is new GAL.Properties.SPARK.Content_Models
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

        withs_str = "\n".join(f"with {t};" for t in sorted(withs))

        return f"""{header}
--  {self.pkg_name}
--  {'=' * len(self.pkg_name)}
--
--  This package is a high level version of the maps. It uses a limited
--  number of formal parameters to make instantiation easier and uses
--  default choices for all other parameters. If you need full control over
--  how memory is allocated, whether to use controlled types or not
--  and so on, please consider using the low-level packages instead.
--{self.storage.doc()}
--{self.keys.doc('keys')}
--{self.elements.doc('elements')}
pragma Ada_2012;
{withs_str}

generic
{self.keys.formals}{self.elements.formals}{self.storage.formals}   with function Hash (Key : Key_Type) return Hash_Type;
   with function "=" (Left, Right : Key_Type) return Boolean is <>;
{self.keys.formals_with_default}{self.elements.formals_with_default}package {self.pkg_name}{spark_mode} is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

{self.keys.traits}
{self.elements.traits}
{self.keys.equal()}

   package Impl is new GAL.Maps.Generics
     (Keys                => Keys.Traits,
      Elements            => Elements.Traits,
      Hash                => Hash,
      "="                 => "=",
      Probing             => GAL.Maps.Perturbation_Probing,
      Pool                => GAL.Pools.Global_Pool,
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

    def adb(self) -> str:
        if not self.storage.body:
            return ""

        return f"""{header}
pragma Ada_2012;
package body {self.pkg_name} with SPARK_Mode => Off is
   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);
{self.storage.body}

end {self.pkg_name};
"""


predefined = [
    Map_Container(
        pkg_name="GAL.Maps.Def_Def_Unbounded",
        pkg='Unbounded',
        keys=Definite_Elements(name='Key'),
        elements=Definite_Elements(),
        tests=[
            ("Integer", "Integer", "GAL.Controlled_Base", True),
        ],
    ),
    Map_Container(
        pkg_name="GAL.Maps.Indef_Def_Unbounded",
        pkg='Unbounded',
        keys=Indefinite_Elements(name='Key'),
        elements=Definite_Elements(),
        tests=[
            ("Integer", "Integer", "GAL.Controlled_Base", False),
            ("String", "Integer", "GAL.Controlled_Base", True),
        ],
    ),
    Map_Container(
        pkg_name="GAL.Maps.Indef_Indef_Unbounded",
        pkg='Unbounded',
        keys=Indefinite_Elements(name='Key'),
        elements=Indefinite_Elements(),
        tests=[
            ("Integer", "Integer", "GAL.Controlled_Base", False),
            ("String", "String", "GAL.Controlled_Base", True),
        ],
    ),
    Map_Container(
        pkg_name="GAL.Maps.Indef_Indef_Unbounded_SPARK",
        pkg='Unbounded_SPARK',
        keys=Indefinite_Elements_SPARK(name='Key'),
        elements=Indefinite_Elements_SPARK(),
        base='GAL.Limited_Base',
        tests=[
            ("Integer", "Integer", None, False),
            ("String", "String", None, False),
        ],
    ),
]
