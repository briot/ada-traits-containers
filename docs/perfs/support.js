var app = angular.module('containers', []);

// How to display info
var Display_Type = {
   PERCENT: 0,
   MS: 1
};

app.
run(function($rootScope) {
   $rootScope.display = Display_Type.PERCENT;
}).

factory('Reftime', function() {
   /**
    * A category of tests if generally for a given container and element_type.
    * They correspond to a table displayed in the output. They include their
    * own reference times and list of tests.
    * @constructor
    * @param {str} name   The name of the category.
    */
   function Category(name) {
      this.name = name;
      this.containers = [];  // List of containers in this category
      this.test_names = [];  // List of tests run for any container in this
                             // category
      this.is_ref_test = {}; // List of tests that are references

   }

   /**
    * Get the list of categories and their attributes from the data generated
    * by the tests.
    * @return {array<Category>} the list of categories.
    */
   Category.compute = function() {
      var result = [];
      var seen = {};   // {name->Category}

      angular.forEach(data.tests, function(container) {
         var cat = seen[container.category];
         if (!cat) {
            cat = seen[container.category] = new Category(container.category);
            result.push(cat);
         }

         cat.containers.push(container);

         container.allocated = 0;
         container.allocs = 0;
         container.frees = 0;
         container.reallocs = 0;

         // Compute mean execution time for each tests
         angular.forEach(container.tests, function(test) {
            container.allocated += test.allocated;
            container.allocs += test.allocs;
            container.frees += test.frees;
            container.reallocs += test.reallocs;
         });
      });

      angular.forEach(result, function(cat) {
         var seen = {};  // Set of tests known for this category
         var refs = {};  // Name -> test   the reference tests
         var ref_test = undefined;  // Current ref test (a Test object)

         angular.forEach(cat.containers, function(container) {
            angular.forEach(container.tests, function(test, name) {
               if (!seen[name]) {
                  seen[name] = {};
                  cat.test_names.push(name);
               }
               if (test.group) {
                  cat.is_ref_test[name] = true;
                  ref_test = refs[name];
                  if (!ref_test) {
                     ref_test = test;
                     refs[name] = ref_test;
                  }
               } else {
                  ref_test = refs[name] || ref_test;
                  if (ref_test === undefined) {
                     window.console.error('Unknown reference test for', name);
                  }
               }
               test.ref = ref_test;
            });
         });
      });

      return result;
   };

   /**
    * This class is used to compute percents compared to various reference
    * times.
    */
   function Reftime() {
      this.data = {
         categories: Category.compute(),  // list of Category
         repeat_count: data.repeat_count,
         items_count: data.items_count
      };
   }

   return new Reftime;
}).

controller('ResultsCtrl', function($scope, Reftime) {
   $scope.data = Reftime.data;  // from global variable
}).

controller('HeaderCtrl', function(Reftime, $scope) {
   $scope.data = Reftime.data;
}).

/**
 * Display memory usage for a test
 */
directive('ctMem', function() {
   return {
      scope: {
         testname: '=ctMem',
         container: '='
      },
      controller: function($scope, Reftime, $rootScope) {
         $scope.test = $scope.container.tests[$scope.testname];
      },
   template:
      '<div class="mem" ng-if="test && $root.show_test_allocs">' +
         '<div ng-if="test.allocated">{{test.allocated | kb}}</div>' +
         '<div ng-if="test.allocs">+{{test.allocs}}</div>' +
         '<div ng-if="test.reallocs">@{{test.reallocs}}</div>' +
         '<div ng-if="test.frees">-{{test.frees}}</div>' +
      '</div>'
   };
}).

directive('ctDuration', function($rootScope) {
   // Compute display info for a test
   function compute_test_data(test) {
      var ref = test.ref;

      if (ref != test) {
         //  ??? We do this for every test that share the same ref
         compute_test_data(ref);
      }
      test.slow = test.duration > ref.duration * 1.05;

      switch (Number($rootScope.display)) {
         case Display_Type.PERCENT:
            return (test.duration / ref.duration * 100).toFixed(0) + '%';
         case Display_Type.MS:
            return (test.duration * 1000).toFixed(2);
         default:
            return '-';
      }
   }

   return {
      scope: {
         testname: '=ctDuration',
         container: '='
      },
      controller: function($scope, Reftime, $rootScope) {
         $scope.test = $scope.container.tests[$scope.testname];
         $scope.display;  // what to display

         if ($scope.test && $scope.test.duration) {
            $rootScope.$watch('[info,display]', function() {
               $scope.display = compute_test_data($scope.test);
            }, true);
         }
      },
      template: '<span ng-if="test"' +
           ' ng-class="{worse:test.slow, comment:test.comment}"' +
           ' title="{{test.comment}}">' +
           '<span>{{display}}</span>' +
         '</span>'
   };
}).

filter('kb', function() {
   return function(value) {
      if (!value) {
         return '0';
      } else if (value > 1000000) {
         return (value / 1000000).toFixed(0) + 'Mb';
      } else if (value > 1000) {
         return (value / 1000).toFixed(0) + 'kb';
      } else {
         return value + 'b';
      }
   };
});
