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

bool IsLessEqual2 (int i) { return i <= 2; }
bool valueIsLessEqual2 (const std::pair<int, int> val) { return val.second <= 2;}
bool IsEqualItemsCount (int i) { return i == items_count; }
bool startsWithB (const std::string& s) { return s[0] == 'b'; };
bool startsWithStr (const std::string& s) { return s[0] == 'f'; }
bool valueStartsWithStr (const std::pair<std::string, std::string> s) {
   return s.second[0] == 'f';
}
bool valueStartsWithF (const std::pair<std::string, std::string> s) {
   return s.second[0] == 'f';
}

#define START_GROUP 1
#define SAME_GROUP 0

/**
 * test_cpp_int_list
 */

extern "C"
void test_cpp_int_list (void * output) {
   const char* category = "Integer List";
   const char* container = "C++";

   set_column (output, category, container, sizeof(std::list<int>), FAVORITE);

   for (int r = 0; r < repeat_count; r++) {
      {
         std::list<int>  v;

         mem_start_test (output, category, container, "fill", START_GROUP);
         for (int c = 1; c <= items_count; c++) {
            v.push_back(c);
         }
         stop_time (output);
         v.clear();
         mem_end_test (output);
      }

      {
         //  Initialize V
         std::list<int>  v;
         for (int c = 1; c <= items_count; c++) {
            v.push_back(c);
         }

         mem_start_test (output, category, container, "copy", SAME_GROUP);
         {
            std::list<int> v_copy (v);
            stop_time (output);
            v_copy.clear();
            mem_end_test (output);
         }

         {
            int count = 0;
            mem_start_test
               (output, category, container, "cursor loop", START_GROUP);
            for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
               count += (*it > 0);
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
            if (e <= 2) {
               count ++;
            }
         }
         mem_end_test (output);
         if (count != 2) {
            std::cout << "C++ error while counting" << std::endl;
         }

         mem_start_test (output, category, container, "count_if", SAME_GROUP);
         count = std::count_if (v.begin(), v.end(), IsLessEqual2);
         mem_end_test (output);
         if (count != 2) {
             std::cout << "C++ error while counting" << std::endl;
         }
      }
   }
}

/**
 * test_cpp_str_list
 */

void fill(std::list<std::string> &v) {
   for (int c = 1; c <= items_count; c++) {
      if (c % 2 == 0) {
         v.push_back("foo");
      } else {
         v.push_back("foofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoo");
      }
   }
}


extern "C"
void test_cpp_str_list (void * output) {

   const char* category = "String List";
   const char* container = "C++";

   set_column (output, category, container, sizeof(std::list<int>), FAVORITE);

   for (int r = 0; r < repeat_count; r++) {

      {
         std::list<std::string> v;
         mem_start_test (output, category, container, "fill", START_GROUP);
         fill (v);
         stop_time (output);
         v.clear();
         mem_end_test (output);
      }

      {
         std::list<std::string> v;
         fill (v);

         mem_start_test (output, category, container, "copy", SAME_GROUP);
         {
            std::list<std::string> v_copy (v);
            stop_time (output);
            v_copy.clear();
            mem_end_test (output);
         }

         {
            int count = 0;
            mem_start_test
               (output, category, container, "cursor loop", START_GROUP);
            for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
               count += ((*it).size() > 0);
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
            if (startsWithStr(e)) {
               count ++;
            }
         }
         mem_end_test (output);
         if (count != items_count) {
            std::cout << "C++ error while counting" << std::endl;
         }
   
         mem_start_test (output, category, container, "count_if", SAME_GROUP);
         count = std::count_if (v.begin(), v.end(), startsWithStr);
         mem_end_test (output);
         if (count != items_count) {
            std::cout << "C++ error while counting" << std::endl;
         }
      }
   }
}

/**
 * test_cpp_int_vector
 */

extern "C"
void test_cpp_int_vector (void * output) {
   const char* category = "Integer Vector";
   const char* container = "C++";

   set_column (output, category, container, sizeof(std::vector<int>), FAVORITE);

   for (int r = 0; r < repeat_count; r++) {
      std::vector<int>  v;

      mem_start_test (output, category, container, "fill", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         v.push_back(c);
      }
      mem_end_test (output);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         std::vector<int> v_copy (v);
         mem_end_test (output);
      }

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (*it <= 2) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != 2) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "for-of loop", SAME_GROUP);
      for (auto e : v) {
         if (e <= 2) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != 2) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), IsLessEqual2);
      mem_end_test (output);
      if (count != 2) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "indexed", SAME_GROUP);
      for (auto idx = 0; idx < v.size(); idx++) {
         if (v[idx] <= 2) {
            count ++;
         }
      }
      if (count != 2) {
         std::cout << "C++ error while counting" << count << std::endl;
      }
   }
}

/**
 * test_cpp_str_vector
 */


extern "C"
void test_cpp_str_vector (void * output) {
   const char* category = "String Vector";
   const char* container = "C++";

   set_column (output, category, container, sizeof(std::vector<int>), FAVORITE);

   for (int r = 0; r < repeat_count; r++) {
      std::vector<std::string>  v;

      mem_start_test (output, category, container, "fill", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         if (c % 2 == 0) {
            v.push_back("foo");
         } else {
            v.push_back("foofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoo");
         }
      }
      mem_end_test (output);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         std::vector<std::string> v_copy (v);
         mem_end_test (output);
      }

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (startsWithStr(*it)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "for-of loop", SAME_GROUP);
      for (std::string& e : v) {
         if (startsWithStr(e)) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), startsWithStr);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "indexed", SAME_GROUP);
      for (auto idx = 0; idx < v.size(); idx++) {
         if (startsWithStr(v[idx])) {
            count ++;
         }
      }
      if (count != items_count) {
         std::cout << "C++ error while counting" << count << std::endl;
      }
   }
}

/**
 * test_cpp_int_int_map
 */

extern "C"
void test_cpp_int_int_map (void * output) {
   typedef std::map<int, int> int_int_map;

   const char* category = "IntInt Map";
   const char* container = "C++ ordered";

   set_column (output, category, container, sizeof(int_int_map), FAVORITE);

   for (int r = 0; r < repeat_count; r++) {
      int_int_map v;

      mem_start_test (output, category, container, "fill", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         v[c] = c;
      }
      mem_end_test (output);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         int_int_map v_copy (v);
         mem_end_test (output);
      }

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (it->second <= 2) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != 2) {
        std::cout << "C++ error while counting" << count << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "for-in/of loop", SAME_GROUP);
      for (auto& e : v) {
         if (e.second <= 2) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != 2) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), valueIsLessEqual2);
      mem_end_test (output);
      if (count != 2) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "indexed", SAME_GROUP);
      for (int r = 1; r <= items_count; r++) {
         if (v[r] <= 2) {
            count ++;
         }
      }
      if (count != 2) {
         std::cout << "C++ error while counting" << std::endl;
      }

      mem_start_test (output, category, container, "find", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         if (IsLessEqual2(v[c])) {
            count++;
         }
      }
      mem_end_test (output);
   }
}

/**
 * test_cpp_int_int_unordered_map
 */

extern "C"
void test_cpp_int_int_unordered_map (void * output) {
   typedef std::unordered_map<int, int> int_int_unordered_map;

   const char* category = "IntInt Map";
   const char* container = "C++ unordered";

   set_column (output, category, container, sizeof(int_int_unordered_map), FAVORITE);

   for (int r = 0; r < repeat_count; r++) {
      int_int_unordered_map v;

      mem_start_test (output, category, container, "fill", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         v[c] = c;
      }
      mem_end_test (output);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         int_int_unordered_map v_copy (v);
         mem_end_test (output);
      }

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (it->second <= 2) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != 2) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "for-in/of loop", SAME_GROUP);
      for (auto& e : v) {
         if (e.second <= 2) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != 2) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), valueIsLessEqual2);
      mem_end_test (output);
      if (count != 2) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "indexed", START_GROUP);
      for (int r = 1; r <= items_count; r++) {
         if (v[r] <= 2) {
            count ++;
         }
      }
      if (count != 2) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "find", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         if (IsLessEqual2(v[c])) {
            count++;
         }
      }
      mem_end_test (output);
   }
}

/**
 * test_cpp_str_str_map
 */

extern "C"
void test_cpp_str_str_map (void * output) {
   typedef std::map<std::string, std::string> str_str_map;

   const char* category = "StrStr Map";
   const char* container = "C++ ordered";

   set_column (output, category, container, sizeof(str_str_map), FAVORITE);

   for (int r = 0; r < repeat_count; r++) {
      str_str_map v;

      mem_start_test (output, category, container, "fill", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         v[std::to_string(c)] = "foo";
      }
      mem_end_test (output);

      mem_start_test (output, category, container, "copy", SAME_GROUP);
      {
         str_str_map v_copy (v);
         mem_end_test (output);
      }

      int count = 0;
      mem_start_test (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         if (startsWithStr(it->second)) {  // value
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "for-in/of loop", SAME_GROUP);
      for (auto& e : v) {
         if (startsWithStr(e.second)) { // value
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      mem_start_test (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), valueStartsWithStr);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test (output, category, container, "indexed", START_GROUP);
      for (int r = 1; r <= items_count; r++) {
         if (startsWithStr(v["1"])) {
            count ++;
         }
      }
      if (count != items_count) {
         std::cout << "C++ error while counting" << std::endl;
      }

      mem_start_test (output, category, container, "find", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         if (startsWithStr(v[std::to_string(c)])) {
            count++;
         }
      }
      mem_end_test (output);
   }
}

/**
 * test_cpp_str_str_unordered_map
 */

extern "C"
void test_cpp_str_str_unordered_map (void * output) {
   typedef std::unordered_map<std::string, std::string> str_str_unordered_map;

   const char* category = "StrStr Map";
   const char* container = "C++ unordered";

   set_column
      (output, category, container, sizeof(str_str_unordered_map), FAVORITE);

   for (int r = 0; r < repeat_count; r++) {
      str_str_unordered_map v;

      mem_start_test
         (output, category, container, "fill", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         v[std::to_string(c)] = "foo";
      }
      mem_end_test (output);

      mem_start_test
         (output, category, container, "copy", SAME_GROUP);
      {
         str_str_unordered_map v_copy (v);
         mem_end_test (output);
      }

      int count = 0;
      mem_start_test
         (output, category, container, "cursor loop", START_GROUP);
      for (auto it = v.begin(), __end=v.end(); it != __end; ++it) {
         //  ??? Using valueStartsWithStr(*it) is twice as slow...
         if (startsWithStr(it->second)) {  // value
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      count = 0;
      mem_start_test
         (output, category, container, "for-in/of loop", SAME_GROUP);
      for (auto& e : v) {
         if (startsWithStr(e.second)) { // value
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << count << std::endl;
      }

      mem_start_test
         (output, category, container, "count_if", SAME_GROUP);
      count = std::count_if (v.begin(), v.end(), valueStartsWithStr);
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test
         (output, category, container, "indexed", START_GROUP);
      for (int r = 1; r <= items_count; r++) {
         if (startsWithStr(v["1"])) {
            count ++;
         }
      }
      mem_end_test (output);
      if (count != items_count) {
         std::cout << "C++ error while counting" << std::endl;
      }

      count = 0;
      mem_start_test
         (output, category, container, "find", START_GROUP);
      for (int c = 1; c <= items_count; c++) {
         if (startsWithStr(v[std::to_string(c)])) {
            count++;
         }
      }
      mem_end_test (output);
   }
}
