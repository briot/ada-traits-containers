#include <iostream>                  // for std::cout
#include <utility>                   // for std::pair
#include <algorithm>                 // for std::for_each
#include <boost/graph/graph_traits.hpp>

// Suppress warnings about deprecated functions
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#include <boost/graph/adjacency_list.hpp>
#pragma GCC diagnostic pop

#include <boost/graph/depth_first_search.hpp>
#include <boost/graph/strong_components.hpp>
#include <creport.h>

extern "C"
void test_cpp_graph(void* output) {
  using namespace boost;

  const char* category = "Graph";
  const char* container = "C++ Boost";

  // create a typedef for the Graph type
  typedef adjacency_list<vecS, vecS, bidirectionalS> Graph;

  const int num_vertices = items_count;

  set_column (output, category, container, sizeof(Graph), FAVORITE);
  
  for (int r = 0; r < repeat_count; r++) {
     mem_start_test (output, category, container, "fill", START_GROUP);
     Graph g(num_vertices);
     for (int i = 0; i < num_vertices - 1; i++) {
        add_edge(i, i + 1, g);
     }
     mem_end_test (output);

     mem_start_test
        (output, category, container, "dfs, no visitor", START_GROUP);
     default_dfs_visitor vis;
     depth_first_search (g, visitor (vis));
     mem_end_test (output);

     add_edge(num_vertices / 10, 3, g);
     add_edge(2 * num_vertices / 10, num_vertices - 1, g);

     mem_start_test (output, category, container,  "dfs, visitor", SAME_GROUP);
     end_test_not_run (output);

     mem_start_test
        (output, category, container, "dfs-recursive, visitor", SAME_GROUP);
     end_test_not_run (output);

     mem_start_test (output, category, container, "is_acyclic", SAME_GROUP);
     end_test_not_run (output);

     mem_start_test (output, category, container, "scc", START_GROUP);
     std::vector<int> c(num_vertices);
     int num = strong_components(
           g,
           make_iterator_property_map(c.begin(), get(vertex_index, g)));
     mem_end_test (output);
  }
}
