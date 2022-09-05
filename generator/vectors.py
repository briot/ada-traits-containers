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


class Storage_Vector(Storage):
    def __init__(self, pkg: Pkg, base: Base = 'Container_Base_Type'):
        super().__init__(
            container="Vector",
            pkg=pkg,
            base=base,
            extra_actual=(
                ""
                if pkg == 'Bounded'
                else "       Resize_Policy       => GAL.Vectors.Resize_1_5,\n"
            )
        )


Vector_Test_Data = Tuple[
    str,             # index type
    str,             # list of element types to test
    Optional[Base],  # container_base (if applicable)
    bool,            # favorite: is this a container users would likely use
    str,             # category of the test
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
        self.favorite = data[3] is True
        self.category_name = data[4] or self.element
        self.container = container
        self.withs = set([
            "Support_Vectors",
        ])
        if '.' in self.element:
            self.withs.add(self.element.rsplit('.', 1)[0])

    def category(self) -> str:
        return f"{self.category_name} Vector"

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
        actual = [self.index, self.element]
        if self.base:
            actual.append(f"Container_Base_Type => {self.base}")
        actual_str = "(%s)" % ",\n       ".join(actual)

        actual_support = []
        if '.' in self.element:
            p = self.element.rsplit('.', 1)[0]
            actual_support.append(f'"="            => {p}."="')
        actual_support_str = "".join(
            ",\n       {}".format(s)
            for s in actual_support)

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
       Perf_Nth       => Test_Support.Perf_Nth{actual_support_str});

   procedure Test{idx} is
      V : Vecs{idx}.Vector{self.container.storage.bounds_for_test};
   begin
      Tests{idx}.Test (V);
   end Test{idx};

   procedure Test_Perf{idx}
      (Result : in out Report.Output'Class; Favorite : Boolean)
   is
      V1, V2 : Vecs{idx}.Vector{self.container.storage.bounds_for_perf_test};
   begin
      Tests{idx}.Test_Perf (Result, V1, V2, Favorite => Favorite);
   end Test_Perf{idx};
"""


class Vector_Container(Container):
    def __init__(
            self,
            pkg_name: str,
            storage: Storage,
            elements: Elements,
            tests: Sequence[Vector_Test_Data] = []
            ):
        super().__init__(
            pkg_name=pkg_name,
            tests=[Vector_Test(container=self, data=t) for t in tests],
        )
        self.elements = elements
        self.storage = storage

    def ads(self) -> str:
        spark_mode = " with SPARK_Mode"
        withs: Set[str] = set([
            "GAL.Properties.SPARK",
            "GAL.Vectors.Generics",
        ])
        withs.update(self.elements.withs)
        withs.update(self.storage.withs)

        withs_str = "\n".join(f"with {t};" for t in sorted(withs))

        return (
            f"""{header}
--  {self.pkg_name}
--  {'=' * len(self.pkg_name)}
--
--  This package is a high level version of the vectors. It uses a limited
--  number of formal parameters to make instantiation easier and uses
--  default choices for all other parameters. If you need full control over
--  how memory is allocated, whether to use controlled types or not, the growth
--  strategy and so on, please consider using the low-level packages instead.
--{self.storage.doc()}
--{self.elements.doc('elements')}
pragma Ada_2012;
{withs_str}
generic
   type Index_Type is (<>);
{self.elements.formals}
{self.storage.formals}
{self.elements.formals_with_default}package {self.pkg_name}{spark_mode} is

   pragma Assertion_Policy
      (Pre => Suppressible, Ghost => Suppressible, Post => Ignore);

{self.elements.traits}
{self.storage.traits}
   package Vectors is new GAL.Vectors.Generics (Index_Type, Storage.Traits);
   package Cursors renames Vectors.Cursors;  --  Forward, Bidirectional, Random
   package Maps renames Vectors.Maps;

   subtype Vector is Vectors.Vector;
   subtype Cursor is Vectors.Cursor;
   subtype Extended_Index is Vectors.Extended_Index;
   subtype Constant_Returned is Elements.Traits.Constant_Returned;
   subtype Returned is Elements.Traits.Returned;

   No_Element : Cursor renames Vectors.No_Element;
   No_Index   : Index_Type renames Vectors.No_Index;

   procedure Swap
      (Self : in out Cursors.Forward.Container;
       Left, Right : Index_Type)
      renames Vectors.Swap;
{self.storage.subprograms}
   subtype Element_Sequence is Vectors.Impl.M.Sequence with Ghost;
   package Content_Models is new GAL.Properties.SPARK.Content_Models
        (Map_Type     => Vectors.Base_Vector'Class,
         Element_Type => Element_Type,
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
    Vector_Container(
        pkg_name="GAL.Vectors.Definite_Bounded",
        elements=Definite_Elements(),
        storage=Storage_Vector(pkg='Bounded', base='GAL.Controlled_Base'),
        tests=[("Positive", "Integer", None, False, "Integer")],
    ),
    Vector_Container(
        pkg_name="GAL.Vectors.Definite_Unbounded",
        elements=Definite_Elements(),
        storage=Storage_Vector(pkg='Unbounded'),
        tests=[
            ("Positive", "Integer", "GAL.Controlled_Base", True, "Integer"),
        ],
    ),
    Vector_Container(
        pkg_name="GAL.Vectors.Unmovable_Definite_Unbounded",
        elements=Definite_Elements(movable=False, copyable=False),
        storage=Storage_Vector(pkg='Unbounded'),
        tests=[
            ("Positive", "GNATCOLL.Strings.XString", "GAL.Controlled_Base",
             True, "String"),
        ],
    ),
    Vector_Container(
        pkg_name="GAL.Vectors.Indefinite_Bounded",
        elements=Indefinite_Elements(),
        storage=Storage_Vector(pkg='Bounded', base='GAL.Controlled_Base'),
        tests=[
            ("Positive", "Integer", None, False, "Integer"),
            ("Positive", "String", None, False, "String"),
        ],
    ),
    Vector_Container(
        pkg_name="GAL.Vectors.Indefinite_Unbounded",
        elements=Indefinite_Elements(),
        storage=Storage_Vector(pkg='Unbounded'),
        tests=[
            ("Positive", "Integer", "GAL.Controlled_Base", False, "Integer"),
            ("Positive", "String", "GAL.Controlled_Base", True, "String"),
            ("Positive", "GNATCOLL.Strings.XString", "GAL.Controlled_Base",
             True, "String"),
        ],
    ),
    Vector_Container(
        pkg_name="GAL.Vectors.Indefinite_Unbounded_SPARK",
        elements=Indefinite_Elements_SPARK(),
        storage=Storage_Vector(pkg='Unbounded', base="GAL.Limited_Base"),
        tests=[
            ("Positive", "Integer", None, False, "Integer"),
            ("Positive", "String", None, False, "String"),
        ],
    ),
    #    Vector_Container(
    #        pkg_name='GAL.Vectors.Strings',
    #        elements=Array_Elements('Positive', 'Character', 'String'),
    #        storage=Storage_Vector(
    #           pkg='Unbounded', base='GAL.Controlled_Base'),
    #    ),
]
