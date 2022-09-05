from typing import Set


class Test:
    def __init__(self):
        self.withs: Set[str]
        self.favorite: bool

    def code(self, idx: int) -> str:
        ...

    def test_name(self) -> str:
        ...
