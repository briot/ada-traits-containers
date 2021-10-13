/****************************************************************************
 *                     Copyright (C) 2015, AdaCore                          *
 *                                                                          *
 * This library is free software;  you can redistribute it and/or modify it *
 * under terms of the  GNU General Public License  as published by the Free *
 * Software  Foundation;  either version 3,  or (at your  option) any later *
 * version. This library is distributed in the hope that it will be useful, *
 * but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- *
 * TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            *
 *                                                                          *
 * As a special exception under Section 7 of GPL version 3, you are granted *
 * additional permissions described in the GCC Runtime Library Exception,   *
 * version 3.1, as published by the Free Software Foundation.               *
 *                                                                          *
 * You should have received a copy of the GNU General Public License and    *
 * a copy of the GCC Runtime Library Exception along with this program;     *
 * see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    *
 * <http://www.gnu.org/licenses/>.                                          *
 *                                                                          *
 ****************************************************************************/

#include <algorithm>
#include <iostream>
#include <vector>
#include <list>
#include <string>
#include <map>
#include <unordered_map>
#include "creport.h"

bool check_element_int(int value) {
   return value > 0;
}
bool check_element_str(std::string s) {
   return s.size() > 0;
}
bool check_element_value_str(std::pair<std::string, std::string> s) {
   return s.second.size() > 0;
}
bool check_element_value_int_int(std::pair<int, int> s) {
   return s.second > 0;
}
bool check_element_value_str_int(std::pair<std::string, int> s) {
   return s.second > 0;
}

int nth_int(int index) {
   return index;
}

std::string nth_str_key(int index) {
   return ' ' + std::to_string(index);
}
std::string nth_str_value(int index) {
   if (index % 2 == 0) {
      return "foo";
   } else {
      return "foofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoo";
   }
}

#define START_GROUP 1
#define SAME_GROUP 0

/**
 * test_cpp_int_list
 */

void fill(std::list<int> &v) {
   for (int c = 1; c <= items_count; c++) {
      v.push_back(nth_int(c));
   }
}

extern "C"
void test_cpp_int_list (void * output) {
   const char* category = "Integer List";
   const char* container = "C++";

   set_column (output, category, container, sizeof(std::list<int>), FAVORITE);

   {
      std::list<int>  v;

      mem_start_test (output, category, container, "fill", START_GROUP);
      fill(v);
      stop_time (output);
   }
   mem_end_test (output);

   {
      //  Initialize V
      std::list<int>  v;
      fill (v);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         std::list<int> v_copy (v);
         stop_time (output);
         v_copy.clear();
      }
      mem_end_test (output);

      {
         int count = 0;
         mem_start_test
            (output, category, container, "cursor loop", START_GROUP);
         for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
            if (check_element_int(*it)) {
               count++;
            }
         }
         mem_end_test (output);
         if (count != items_count) {
            std::cout << "error in cursor loop" << std::endl;
         }
      }

      int count = 0;
      mem_start_test
         (output, category, container, "for-of loop", SAME_GROUP);
      for (auto e : v) {
         if (check_element_int(e)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-of "
            << category << container << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_int);
      mem_end_test (output);
      if (count != items_count) {
          std::cout << "C++ error while counting count_if "
             << category << container << std::endl;
      }
   }
}

/**
 * test_cpp_str_list
 */

void fill(std::list<std::string> &v) {
   for (int c = 1; c <= items_count; c++) {
      v.push_back(nth_str_value(c));
   }
}


extern "C"
void test_cpp_str_list (void * output) {

   const char* category = "String List";
   const char* container = "C++";

   set_column (output, category, container, sizeof(std::list<int>), FAVORITE);

   {
      std::list<std::string> v;
      mem_start_test (output, category, container, "fill", START_GROUP);
      fill (v);
      stop_time (output);
   }
   mem_end_test (output);

   {
      std::list<std::string> v;
      fill (v);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         std::list<std::string> v_copy (v);
         stop_time (output);
      }
      mem_end_test (output);

      {
         int count = 0;
         mem_start_test
            (output, category, container, "cursor loop", START_GROUP);
         for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
            if (check_element_str(*it)) {
               count ++;
            }
         }
         mem_end_test (output);
         if (count != items_count) {
            std::cout << "error in cursor loop" << std::endl;
         }
      }

      int count = 0;
      mem_start_test
         (output, category, container, "for-of loop", SAME_GROUP);
      for (std::string& e : v) {
         if (check_element_str(e)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-of "
            << category << ' ' << container << ' ' << count << std::endl;
      }
   
      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_str);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting count_if "
            << category << container << ' ' << count << std::endl;
      }
   }
}

/**
 * test_cpp_int_vector
 */

void fill(std::vector<int> &v) {
   for (int c = 1; c <= items_count; c++) {
      v.push_back(nth_int(c));
   }
}

extern "C"
void test_cpp_int_vector (void * output) {
   const char* category = "Integer Vector";
   const char* container = "C++";

   set_column (output, category, container, sizeof(std::vector<int>), FAVORITE);

   {
      mem_start_test (output, category, container, "fill", START_GROUP);
      std::vector<int>  v;
      fill(v);
      stop_time(output);
   }
   mem_end_test (output);

   {
      std::vector<int>  v;
      fill(v);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         std::vector<int> v_copy (v);
         stop_time(output);
      }
      mem_end_test (output);

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (check_element_int(*it)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting cursor "
            << category << container << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "for-of loop", SAME_GROUP);
      for (auto e : v) {
         if (check_element_int(e)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-of "
            << category << container << count << std::endl;
      }
   
      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_int);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting count_if "
            << category << container << count << std::endl;
      }
   
      count = 0;
      mem_start_test (output, category, container, "indexed", SAME_GROUP);
      for (auto idx = 0; idx < v.size(); idx++) {
         if (check_element_int(v[idx])) {
            count ++;
         }
      }
      if (count != items_count) {
         std::cout << "C++ error while counting indexed "
            << category << container << count << std::endl;
      }
   }
}

/**
 * test_cpp_str_vector
 */

void fill(std::vector<std::string> &v) {
   for (int c = 1; c <= items_count; c++) {
      v.push_back(nth_str_value(c));
   }
}

extern "C"
void test_cpp_str_vector (void * output) {
   const char* category = "String Vector";
   const char* container = "C++";

   set_column (output, category, container, sizeof(std::vector<int>), FAVORITE);

   {
      mem_start_test (output, category, container, "fill", START_GROUP);
      std::vector<std::string>  v;
      fill (v);
      stop_time(output);
   }
   mem_end_test (output);

   {
      std::vector<std::string>  v;
      fill (v);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         std::vector<std::string> v_copy (v);
         stop_time(output);
      }
      mem_end_test (output);

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (check_element_str(*it)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting cursor "
            << category << container << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "for-of loop", SAME_GROUP);
      for (std::string& e : v) {
         if (check_element_str(e)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-of "
            << category << container << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_str);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting count_if "
            << category << container << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "indexed", SAME_GROUP);
      for (auto idx = 0; idx < v.size(); idx++) {
         if (check_element_str(v[idx])) {
            count ++;
         }
      }
      if (count != items_count) {
         std::cout << "C++ error while counting indexed "
            << category << container << count << std::endl;
      }
   }
}

/**
 * test_cpp_int_int_map
 */

typedef std::map<int, int> int_int_map;

void fill(int_int_map &v) {
   for (int c = 1; c <= items_count; c++) {
      v[nth_int(c)] = nth_int(c);
   }
}

extern "C"
void test_cpp_int_int_map (void * output) {
   const char* category = "Integer-Integer Map";
   const char* container = "C++ ordered";

   set_column (output, category, container, sizeof(int_int_map), FAVORITE);

   {
      mem_start_test (output, category, container, "fill", START_GROUP);
      int_int_map v;
      fill(v);
      stop_time(output);
   }
   mem_end_test (output);

   {
      int_int_map v;
      fill(v);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         int_int_map v_copy (v);
         stop_time(output);
      }
      mem_end_test (output);

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (check_element_int(it->second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
        std::cout << "C++ error while counting cursor "
           << category << container << count << std::endl;
      }

      mem_start_test (output, category, container, "for-of loop", SAME_GROUP);
      count = 0;
      for (auto& e : v) {
         if (check_element_int(e.second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-in "
            << category << container << count << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_value_int_int);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting count_if "
            << category << container << std::endl;
      }

      mem_start_test (output, category, container, "find", START_GROUP);
      count = 0;
      for (int c = 1; c <= items_count; c++) {
         if (check_element_int(v[c])) {
            count++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting find "
            << category << container << std::endl;
      }
   }
}

/**
 * test_cpp_int_int_unordered_map
 */

typedef std::unordered_map<int, int> int_int_unordered_map;

void fill(int_int_unordered_map &v) {
   for (int c = 1; c <= items_count; c++) {
      v[nth_int(c)] = nth_int(c);
   }
}

extern "C"
void test_cpp_int_int_unordered_map (void * output) {

   const char* category = "Integer-Integer Map";
   const char* container = "C++ unordered";

   set_column (output, category, container, sizeof(int_int_unordered_map), FAVORITE);

   {
      mem_start_test (output, category, container, "fill", START_GROUP);
      int_int_unordered_map v;
      fill(v);
      stop_time(output);
   }
   mem_end_test (output);

   {
      int_int_unordered_map v;
      fill(v);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         int_int_unordered_map v_copy (v);
         stop_time(output);
      }
      mem_end_test (output);

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (check_element_int(it->second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting cursor "
            << category << container << count << std::endl;
      }

      mem_start_test (output, category, container, "for-of loop", SAME_GROUP);
      count = 0;
      for (auto& e : v) {
         if (check_element_int(e.second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-in "
            << category << container << count << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_value_int_int);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting count_if "
            << category << container << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "find", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         if (check_element_int(v[c])) {
            count++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting find "
            << category << container << std::endl;
      }
   }
}

/**
 * test_cpp_str_int_map
 */

typedef std::map<std::string, int> str_int_map;

void fill(str_int_map &v) {
   for (int c = 1; c <= items_count; c++) {
      v[nth_str_key(c)] = nth_int(c);
   }
}

extern "C"
void test_cpp_str_int_map (void * output) {

   const char* category = "String-Integer Map";
   const char* container = "C++ ordered";

   set_column (output, category, container, sizeof(str_int_map), FAVORITE);

   {
      mem_start_test (output, category, container, "fill", START_GROUP);
      str_int_map v;
      fill(v);
      stop_time(output);
   }
   mem_end_test (output);

   {
      str_int_map v;
      fill(v);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         str_int_map v_copy (v);
         stop_time(output);
      }
      mem_end_test (output);

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (check_element_int(it->second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting cursor "
            << category << container << count << std::endl;
      }

      mem_start_test (output, category, container, "for-of loop", SAME_GROUP);
      count = 0;
      for (auto& e : v) {
         if (check_element_int(e.second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-in "
            << category << container << count << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_value_str_int);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting count_if "
            << category << container << std::endl;
      }

      mem_start_test (output, category, container, "find", START_GROUP);
      count = 0;
      for (int c = 1; c <= items_count; c++) {
         if (check_element_int(v[nth_str_key(c)])) {
            count++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting find "
            << category << container << std::endl;
      }
   }
}


/**
 * test_cpp_str_str_map
 */

typedef std::map<std::string, std::string> str_str_map;

void fill(str_str_map &v) {
   for (int c = 1; c <= items_count; c++) {
      v[nth_str_key(c)] = nth_str_value(c);
   }
}

extern "C"
void test_cpp_str_str_map (void * output) {

   const char* category = "String-String Map";
   const char* container = "C++ ordered";

   set_column (output, category, container, sizeof(str_str_map), FAVORITE);

   {
      mem_start_test (output, category, container, "fill", START_GROUP);
      str_str_map v;
      fill(v);
      stop_time(output);
   }
   mem_end_test (output);

   {
      str_str_map v;
      fill(v);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         str_str_map v_copy (v);
         stop_time(output);
      }
      mem_end_test (output);

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (check_element_str(it->second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting cursor "
            << category << container << count << std::endl;
      }

      mem_start_test (output, category, container, "for-of loop", SAME_GROUP);
      count = 0;
      for (auto& e : v) {
         if (check_element_str(e.second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-in "
            << category << container << count << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_value_str);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting count_if "
            << category << container << std::endl;
      }

      mem_start_test (output, category, container, "find", START_GROUP);
      count = 0;
      for (int c = 1; c <= items_count; c++) {
         if (check_element_str(v[nth_str_key(c)])) {
            count++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting find "
            << category << container << std::endl;
      }
   }
}

/**
 * test_cpp_str_str_unordered_map
 */

typedef std::unordered_map<std::string, std::string> str_str_unordered_map;

void fill(str_str_unordered_map &v) {
   for (int c = 1; c <= items_count; c++) {
      v[nth_str_key(c)] = nth_str_value(c);
   }
}

extern "C"
void test_cpp_str_str_unordered_map (void * output) {

   const char* category = "String-String Map";
   const char* container = "C++ unordered";

   set_column
      (output, category, container, sizeof(str_str_unordered_map), FAVORITE);

   {
      mem_start_test
         (output, category, container, "fill", START_GROUP);
      str_str_unordered_map v;
      fill(v);
      stop_time(output);
   }
   mem_end_test (output);

   {
      str_str_unordered_map v;
      fill(v);

      mem_start_test
         (output, category, container, "copy", SAME_GROUP);
      {
         str_str_unordered_map v_copy (v);
         stop_time(output);
      }
      mem_end_test (output);

      int count = 0;
      mem_start_test
         (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         //  ??? Using valueStartsWithStr(*it) is twice as slow...
         if (check_element_str(it->second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting cursor "
            << category << container << count << std::endl;
      }

      count = 0;
      mem_start_test
         (output, category, container, "for-of loop", SAME_GROUP);
      for (auto& e : v) {
         if (check_element_str(e.second)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting for-in "
            << category << container << count << std::endl;
      }

      mem_start_test
         (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), check_element_value_str);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting count_if "
            << category << container << std::endl;
      }

      mem_start_test
         (output, category, container, "find", START_GROUP);
      count = 0;
      for (int c = 1; c <= items_count; c++) {
         if (check_element_str(v[nth_str_key(c)])) {
            count++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting find "
            << category << container << std::endl;
      }
   }
}
