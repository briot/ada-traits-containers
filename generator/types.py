from typing import Literal


Base = Literal[
    'GAL.Controlled_Base',
    'GAL.Limited_Controlled_Base',
    'GAL.Limited_Base',
    'Container_Base_Type']
Pkg = Literal['Unbounded', 'Bounded', 'Unbounded_SPARK']


def is_limited(base: Base) -> bool:
    return base in ('GAL.Limited_Controlled_Base', 'GAL.Limited_Base')


def base_to_str(base: Base) -> str:
    if is_limited(base):
        return ' limited'
    else:
        return ''
