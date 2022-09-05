#!/usr/bin/env python3
# Generate high-level packages by combining various traits packages

from generator.container import Container
import generator.lists
import generator.maps
import generator.vectors


containers = [
    *generator.lists.predefined,
    *generator.maps.predefined,
    *generator.vectors.predefined,
]

for v in containers:
    v.write_files()

Container.write_main_driver()
