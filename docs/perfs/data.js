var data = {
   "repeat_count": 5,
   "items_count": 200000,
   "tests": [
      {
       "name": "C++",
       "category": "Integer List",
       "favorite": true,
       "size": 24,
       "tests": {
          "fill": {
             "duration": 0.002784000,
             "group":true,
             "allocated": 4800000,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 200000
        },
          "copy": {
             "duration": 0.002869000,
             "group":false,
             "allocated": 4800000,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 200000
        },
          "cursor loop": {
             "duration": 0.000357000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.000352000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000349000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Def Bounded",
       "category": "Integer List",
       "favorite": false,
       "size": 2400032,
       "tests": {
          "fill": {
             "duration": 0.000341806,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "copy": {
             "duration": 0.000075561,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "cursor loop": {
             "duration": 0.000288194,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.000288170,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000309849,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Def Unbounded",
       "category": "Integer List",
       "favorite": false,
       "size": 32,
       "tests": {
          "fill": {
             "duration": 0.001515024,
             "group":true,
             "allocated": 9600000,
             "allocs": 400000,
             "reallocs": 0,
             "frees": 400000
        },
          "copy": {
             "duration": 0.001517901,
             "group":false,
             "allocated": 9600000,
             "allocs": 400000,
             "reallocs": 0,
             "frees": 400000
        },
          "cursor loop": {
             "duration": 0.000425156,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.000220463,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000425486,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Indef Bounded",
       "category": "Integer List",
       "favorite": false,
       "size": 3200032,
       "tests": {
          "fill": {
             "duration": 0.001642064,
             "group":true,
             "allocated": 800000,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 200000
        },
          "copy": {
             "duration": 0.001475624,
             "group":false,
             "allocated": 800000,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 200000
        },
          "cursor loop": {
             "duration": 0.000277055,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.000288220,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000278768,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Indef Unbounded",
       "category": "Integer List",
       "favorite": false,
       "size": 32,
       "tests": {
          "fill": {
             "duration": 0.003153984,
             "group":true,
             "allocated": 5600000,
             "allocs": 400000,
             "reallocs": 0,
             "frees": 400000
        },
          "copy": {
             "duration": 0.003268239,
             "group":false,
             "allocated": 5600000,
             "allocs": 400000,
             "reallocs": 0,
             "frees": 400000
        },
          "cursor loop": {
             "duration": 0.000725683,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.000564312,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000546738,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Indef_SPARK Unbounded_SPARK",
       "category": "Integer List",
       "favorite": false,
       "size": 40,
       "tests": {
          "fill": {
             "duration": 0.002854963,
             "group":true,
             "allocated": 10754528,
             "allocs": 200001,
             "reallocs": 30,
             "frees": 200001
        },
          "copy": {
             "duration": 0.002478510,
             "group":false,
             "allocated": 4118112,
             "allocs": 200001,
             "reallocs": 0,
             "frees": 200001
        },
          "cursor loop": {
             "duration": 0.000324333,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.000314509,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000325517,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "C++",
       "category": "String List",
       "favorite": true,
       "size": 24,
       "tests": {
          "fill": {
             "duration": 0.005642000,
             "group":true,
             "allocated": 14800000,
             "allocs": 300000,
             "reallocs": 0,
             "frees": 300000
        },
          "copy": {
             "duration": 0.006710000,
             "group":false,
             "allocated": 14800000,
             "allocs": 300000,
             "reallocs": 0,
             "frees": 300000
        },
          "cursor loop": {
             "duration": 0.002110000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.001983000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.001232000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Indef Bounded",
       "category": "String List",
       "favorite": false,
       "size": 4800032,
       "tests": {
          "fill": {
             "duration": 0.005104515,
             "group":true,
             "allocated": 3196004,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 200000
        },
          "copy": {
             "duration": 0.002557327,
             "group":false,
             "allocated": 3196004,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 200000
        },
          "cursor loop": {
             "duration": 0.001551372,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.001568348,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.001542100,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Indef Unbounded",
       "category": "String List",
       "favorite": false,
       "size": 32,
       "tests": {
          "fill": {
             "duration": 0.006529429,
             "group":true,
             "allocated": 9596004,
             "allocs": 400000,
             "reallocs": 0,
             "frees": 400000
        },
          "copy": {
             "duration": 0.004290056,
             "group":false,
             "allocated": 9596004,
             "allocs": 400000,
             "reallocs": 0,
             "frees": 400000
        },
          "cursor loop": {
             "duration": 0.001616121,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.001577157,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.001646734,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Indef_SPARK Unbounded_SPARK",
       "category": "String List",
       "favorite": false,
       "size": 40,
       "tests": {
          "fill": {
             "duration": 0.005911765,
             "group":true,
             "allocated": 18127796,
             "allocs": 200001,
             "reallocs": 30,
             "frees": 200001
        },
          "copy": {
             "duration": 0.002850100,
             "group":false,
             "allocated": 8173172,
             "allocs": 200001,
             "reallocs": 0,
             "frees": 200001
        },
          "cursor loop": {
             "duration": 0.003295770,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.003266352,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.003265336,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "C++",
       "category": "Integer Vector",
       "favorite": true,
       "size": 24,
       "tests": {
          "fill": {
             "duration": 0.003419000,
             "group":true,
             "allocated": 2097148,
             "allocs": 19,
             "reallocs": 0,
             "frees": 18
        },
          "copy": {
             "duration": 0.000027000,
             "group":false,
             "allocated": 800000,
             "allocs": 1,
             "reallocs": 0,
             "frees": 0
        },
          "cursor loop": {
             "duration": 0.000028000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.000021000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000027000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "indexed": {
             "duration": 0.000000000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "Ada Array",
       "category": "Integer Vector",
       "favorite": false,
       "size": 800000,
       "tests": {
          "fill": {
             "duration": 0.000000014,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "C++",
       "category": "String Vector",
       "favorite": true,
       "size": 24,
       "tests": {
          "fill": {
             "duration": 0.002227000,
             "group":true,
             "allocated": 21977184,
             "allocs": 100019,
             "reallocs": 0,
             "frees": 18
        },
          "copy": {
             "duration": 0.001563000,
             "group":false,
             "allocated": 11600000,
             "allocs": 100001,
             "reallocs": 0,
             "frees": 0
        },
          "cursor loop": {
             "duration": 0.000375000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-of loop": {
             "duration": 0.000391000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000239000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "indexed": {
             "duration": 0.000000000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "C++ unordered",
       "category": "IntInt Map",
       "favorite": true,
       "size": 56,
       "tests": {
          "fill": {
             "duration": 0.003343000,
             "group":true,
             "allocated": 8734968,
             "allocs": 200015,
             "reallocs": 0,
             "frees": 14
        },
          "copy": {
             "duration": 0.002084000,
             "group":false,
             "allocated": 6008488,
             "allocs": 200001,
             "reallocs": 0,
             "frees": 0
        },
          "cursor loop": {
             "duration": 0.000313000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-in/of loop": {
             "duration": 0.000278000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000257000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "indexed": {
             "duration": 0.000000000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "find": {
             "duration": 0.000426000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "C++ ordered",
       "category": "IntInt Map",
       "favorite": true,
       "size": 48,
       "tests": {
          "fill": {
             "duration": 0.013971000,
             "group":true,
             "allocated": 8000000,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 0
        },
          "copy": {
             "duration": 0.002374000,
             "group":false,
             "allocated": 8000000,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 0
        },
          "cursor loop": {
             "duration": 0.001103000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-in/of loop": {
             "duration": 0.000952000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.000809000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "indexed": {
             "duration": 0.000000000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "find": {
             "duration": 0.009049000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "C++ unordered",
       "category": "StrStr Map",
       "favorite": true,
       "size": 56,
       "tests": {
          "fill": {
             "duration": 0.025325000,
             "group":true,
             "allocated": 21534968,
             "allocs": 200015,
             "reallocs": 0,
             "frees": 14
        },
          "copy": {
             "duration": 0.012400000,
             "group":false,
             "allocated": 18808488,
             "allocs": 200001,
             "reallocs": 0,
             "frees": 0
        },
          "cursor loop": {
             "duration": 0.007860000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-in/of loop": {
             "duration": 0.003497000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.003465000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "indexed": {
             "duration": 0.001025000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "find": {
             "duration": 0.010142000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "C++ ordered",
       "category": "StrStr Map",
       "favorite": true,
       "size": 48,
       "tests": {
          "fill": {
             "duration": 0.025426000,
             "group":true,
             "allocated": 19200000,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 0
        },
          "copy": {
             "duration": 0.006651000,
             "group":false,
             "allocated": 19200000,
             "allocs": 200000,
             "reallocs": 0,
             "frees": 0
        },
          "cursor loop": {
             "duration": 0.002231000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "for-in/of loop": {
             "duration": 0.002047000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "count_if": {
             "duration": 0.003014000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "indexed": {
             "duration": 0.000000000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "find": {
             "duration": 0.017417000,
             "group":true,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        }
      }},
      {
       "name": "C++ Boost",
       "category": "Graph",
       "favorite": true,
       "size": 56,
       "tests": {
          "fill": {
             "duration": 0.009239000,
             "group":true,
             "allocated": 25599929,
             "allocs": 599999,
             "reallocs": 0,
             "frees": 0
        },
          "dfs, no visitor": {
             "duration": 0.010695000,
             "group":true,
             "allocated": 38548696,
             "allocs": 21,
             "reallocs": 0,
             "frees": 21
        },
          "dfs, visitor": {
             "duration": 0.000000000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "dfs-recursive, visitor": {
             "duration": 0.000000000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "is_acyclic": {
             "duration": 0.000000000,
             "group":false,
             "allocated": 0,
             "allocs": 0,
             "reallocs": 0,
             "frees": 0
        },
          "scc": {
             "duration": 0.011257000,
             "group":true,
             "allocated": 44230888,
             "allocs": 3160,
             "reallocs": 0,
             "frees": 3159
        }
      }}
   ]
};
