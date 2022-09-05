from typing import Set


class Elements:
    def __init__(self) -> None:
        self.descr: str
        self.withs: Set[str]
        self.formals: str
        self.formals_with_default: str
        self.traits: str

    def equal(self) -> str:
        ...

    def doc(self, ctx: str) -> str:
        """
        Generate the high-level documentation
        """
        ...


class Definite_Elements(Elements):
    def __init__(self, name="Element", movable=True, copyable=True) -> None:
        self.descr = "Def"
        self.withs = set([
            "GAL.Elements.Definite"
        ])
        self.formals = f"   type {name}_Type is private;\n"
        self.formals_with_default = (
            f"   with procedure Free (E : in out {name}_Type) is null;\n"
        )
        self.traits = (
            f"   package {name}s is new GAL.Elements.Definite\n"
            f"      ({name}_Type, Free => Free, Movable => {movable},"
            f" Copyable => {copyable});"
        )

    def equal(self) -> str:
        return ""

    def doc(self, ctx: str) -> str:
        return f"""
--  Definite {ctx}:
--  ----------{'-' * len(ctx)}
--  This container can only store {ctx} whose size is known at compile time.
--  In exchange, it doesn't need any memory allocation when adding new
--  {ctx}."""


class Indefinite_Elements(Elements):
    def __init__(self, name="Element") -> None:
        self.descr = "Indef"
        self.name = name
        self.withs = set([
            "GAL.Elements.Indefinite",
            "GAL.Pools",
        ])
        self.formals = f"   type {name}_Type (<>) is private;\n"
        self.formals_with_default = (
            f"   with procedure Free (E : in out {name}_Type) is null;\n"
        )
        self.traits = (
            f"   package {name}s is new GAL.Elements.Indefinite\n"
            f"      ({name}_Type, Free => Free,"
            f" Pool => GAL.Pools.Global_Pool);"
        )

    def equal(self) -> str:
        return (
            f"""
   function "=" (Left : {self.name}_Type; Right : {self.name}s.Traits.Stored) return Boolean
        is (Left = Right.all) with Inline;"""
        )

    def doc(self, ctx: str) -> str:
        return f"""
--  Indefinite {ctx}:
--  -----------{'-' * len(ctx)}
--  These lists can store indefinite {ctx}, for which the size is not known
--  at runtime. This includes strings, arrays, class wide types and so on. In
--  exchange for this generality, each {ctx} will require extra memory
--  allocations."""


class Indefinite_Elements_SPARK(Elements):
    def __init__(self, name="Element") -> None:
        self.descr = "Indef_SPARK"
        self.name = name
        self.withs = set([
            "GAL.Elements.Indefinite_SPARK",
            "GAL.Pools",
        ])
        self.formals = f"   type {name}_Type (<>) is private;\n"
        self.formals_with_default = ""
        self.traits = (
            f"   package {name}s is new GAL.Elements.Indefinite_SPARK\n"
            f"      ({name}_Type, Pool => GAL.Pools.Global_Pool);"
        )

    def equal(self) -> str:
        return (
            f"""
   function "=" (Left : {self.name}_Type; Right : {self.name}s.Stored) return Boolean
        is (Left = {self.name}s.Impl.To_Element (Right))
        with Inline;"""
        )

    def doc(self, ctx: str) -> str:
        return f"""
--  Indefinite SPARK {ctx}:
--  -----------------{'-' * len(ctx)}
--  These lists can store indefinite {ctx}, for which the size is not known
--  at runtime. This includes strings, arrays, class wide types and so on. In
--  exchange for this generality, each {ctx} will require extra memory
--  allocations.
--  For compatibility with SPARK, we hide the internal access types, and always
--  return a copy of the {ctx} rather than an access to it."""


class Array_Elements(Elements):
    def __init__(self, index: str, element: str, array: str) -> None:
        self.descr = "Array"
        self.withs = set([
            "GAL.Elements.Arrays",
            "GAL.Pools",
        ])
        self.array = array
        self.formals = ""
        self.formals_with_default = ""
        self.traits = (
            f"   package Elements is new GAL.Elements.Arrays\n"
            f"     ({index}, {element}, {array}, GAL.Pools.Global_Pool);"
        )
