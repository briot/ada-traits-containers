from .types import Base, Pkg, is_limited


class Storage:
    def __init__(self, container: str, pkg: Pkg, base: Base, extra_actual=""):
        self.pkg = pkg
        self.base = base
        self.withs = set([
            f"GAL.{container}s.Storage.{pkg}"
        ])
        self.formals = (
            "   type Container_Base_Type is abstract tagged limited private;\n"
            if base == 'Container_Base_Type'
            else ""
        )
        self.subprograms = (
            ""
            if not is_limited(base)
            else f"""
   function Copy (Self : {container}'Class) return {container}'Class;
   --  Return a deep copy of Self
"""
        )

        bounds = (
            ""
            if pkg != 'Bounded'
            else " (Self.Capacity)"
        )
        self.body = (
            ""
            if not is_limited(base)
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
            f"   package Storage is new GAL.{container}s.Storage.{pkg}\n"
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

    def doc(self) -> str:
        """
        Return the high-level documentation to put in generated packages
        """
        if self.pkg == 'Unbounded':
            return """
--  Unbounded:
--  ----------
--  This container can store any number of elements, and will grow as needed.
--  It requires memory allocations for the container itself."""

        elif self.pkg == "Unbounded_SPARK":
            return """
--  Unbounded SPARK:
--  ----------
--  This container can store any number of elements, and will grow as needed.
--  It requires memory allocations for the container itself.
--  Internally, memory is managed as a single big array so that we can have
--  SPARK pre and post conditions.
"""

        elif self.pkg == 'Bounded':
            return """
--  Bounded:
--  ----------
--  This container can store up to a maximum number of elements, as specified
--  by the discriminant. As a result, it doesn't need memory allocations for
--  the container itself."""

        else:
            raise ValueError(f"Unknown storage type {self.pkg}")
