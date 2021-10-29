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

// create a typedef for the Graph type
typedef boost::adjacency_list<
   boost::vecS,
   boost::vecS,
   boost::bidirectionalS
   > Graph;

void fill_chain(Graph & g) {
   for (int i = 0; i < items_count - 1; i++) {
      add_edge(i, i + 1, g);
   }
   add_edge(items_count / 10, 3, g);
   add_edge(2 * items_count / 10, items_count - 1, g);
}

void fill_complete(Graph &g) {
  for (int v = 0; v < 10000 - 1; v++) {

     //  ??? for a non-directed graph, we should use "int u = v+1"
     for (int u = 0; u < 10000 - 1; u++) {
        if (u != v) {
           add_edge(v, u, g);
        }
     }
  }
}

void run_test(
      void* output,
      const char* category,
      const char* container,
      void (*filler)(Graph& g)
   )
{
  using namespace boost;
  set_column (output, category, container, sizeof(Graph), FAVORITE);

  mem_start_test (output, category, container, "fill", START_GROUP);
  {
     Graph g;
     filler(g);
     stop_time (output);
  }
  mem_end_test (output);

  {
     Graph g;
     filler(g);

     mem_start_test
        (output, category, container, "dfs", START_GROUP);
     default_dfs_visitor vis;
     depth_first_search (g, visitor (vis));
     mem_end_test (output);

     mem_start_test
        (output, category, container, "dfs-recursive", SAME_GROUP);
     end_test_not_run (output);

     mem_start_test (output, category, container, "is_acyclic", SAME_GROUP);
     end_test_not_run (output);

     {
        mem_start_test (output, category, container, "scc", START_GROUP);
        std::vector<int> c(items_count);
        int num = strong_components(
              g,
              make_iterator_property_map(c.begin(), get(vertex_index, g)));
        stop_time(output);
     }
     mem_end_test (output);
  }
}


extern "C"
void test_cpp_graph(void* output) {
   run_test(output, "Integer Graph (chain)",    "Boost", &fill_chain);
   run_test(
      output, "Integer Graph (complete, small)", "Boost", &fill_complete);
}
