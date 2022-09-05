from typing import List, Sequence
from .test import Test
import os


class Container:
    all_tests: List["Container"] = []

    def __init__(
            self,
            pkg_name: str,
            tests: Sequence[Test],
            ):
        Container.all_tests.append(self)

        self.pkg_name = pkg_name
        self.test_pkg = pkg_name.replace("GAL.", "Tests_").replace(".", "_")
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
                        f"      (Result   : in out Report.Output'Class;\n"
                        f"       Favorite : Boolean);\n"
                    )
                f.write(f"end {self.test_pkg};")

            adb_withs = set([
                f"with {self.pkg_name};",
                "with Test_Support;",
            ])
            for t in self.tests:
                for w in t.withs:
                    adb_withs.add('with %s;' % w)

            with open("%s/%s.adb" % (test_generated, testname), "w") as f:
                f.write("\n".join(sorted(adb_withs)))
                f.write(f"\npackage body {self.test_pkg} is\n")
                for idx, t in enumerate(self.tests):
                    f.write(t.code(idx))
                f.write(f"end {self.test_pkg};")

    @classmethod
    def write_main_driver(cls) -> None:
        with open("tests/generated/main-run_all.adb", "w") as f:
            f.write('pragma Style_Checks (Off);\n')
            for cont in cls.all_tests:
                if cont.tests:
                    f.write(f"with {cont.test_pkg};\n")
            f.write("with Test_Support;\n")
            f.write("separate (Main)\n")
            f.write("procedure Run_All is\nbegin\n")
            for cont in cls.all_tests:
                for idx, t in enumerate(cont.tests):
                    f.write(
                        f"   Run_Test\n"
                        f'     ("{t.test_name()}",\n'
                        f"      {cont.test_pkg}.Test{idx}'Access,\n"
                        f"      {cont.test_pkg}.Test_Perf{idx}'Access,\n"
                        f"      Favorite => {t.favorite});\n"
                    )
            f.write("""end Run_All;""")

    def ads(self) -> str:
        return ""

    def adb(self) -> str:
        return ""
