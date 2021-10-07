var data = {
  "repeat_count": 5,
  "items_count": 200000,
  "tests": [
    {
      "name": "C++",
      "category": "Integer List",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.97100003808737E-03,
            1.18300004396588E-03,
            1.09999999403954E-03,
            1.01000000722706E-03,
            1.10600003972650E-03
          ],
          "group": true,
          "allocated": " 4800000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 200000
        },
        "copy": {
          "duration": [
            3.06800007820129E-03,
            1.32399995345622E-03,
            1.12999998964369E-03,
            1.15300004836172E-03,
            1.18799996562302E-03
          ],
          "allocated": " 4800000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            3.23999993270263E-04,
            4.93000028654933E-04,
            2.39000000874512E-04,
            4.90000005811453E-04,
            2.57000006968156E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 200000
        },
        "for-of loop": {
          "duration": [
            3.07000009343028E-04,
            4.53999993624166E-04,
            2.37000000197440E-04,
            4.75000008009374E-04,
            2.46999989030883E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.20000001718290E-04,
            5.21000009030104E-04,
            2.11999999010004E-04,
            4.14000009186566E-04,
            2.16999993426725E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 24,
      "allocated": " 48000000",
      "allocs": 2000000,
      "reallocs": 0,
      "frees": 2000000
    },
    {
      "name": "C++",
      "category": "String List",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            4.47499984875321E-03,
            2.39400006830692E-03,
            2.37199990078807E-03,
            2.32500000856817E-03,
            2.34599993564188E-03
          ],
          "group": true,
          "allocated": " 14800000",
          "allocs": 300000,
          "reallocs": 0,
          "frees": 300000
        },
        "copy": {
          "duration": [
            7.23800016567111E-03,
            3.81299993023276E-03,
            3.68400011211634E-03,
            4.52699977904558E-03,
            5.15699991956353E-03
          ],
          "allocated": " 14800000",
          "allocs": 300000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.75099994521588E-03,
            1.72800000291318E-03,
            1.85400003101677E-03,
            1.88800005707890E-03,
            1.77600001916289E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 300000
        },
        "for-of loop": {
          "duration": [
            1.71500002034009E-03,
            1.77700002677739E-03,
            1.81699998211116E-03,
            1.83099997229874E-03,
            1.44499994348735E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.09399994835258E-03,
            1.26199994701892E-03,
            1.31299998611212E-03,
            1.31800002418458E-03,
            1.03799998760223E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 24,
      "allocated": " 148000000",
      "allocs": 3000000,
      "reallocs": 0,
      "frees": 3000000
    },
    {
      "name": "C++",
      "category": "Integer Vector",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            1.59999995958060E-04,
            1.48999999510124E-04,
            1.46999998833053E-04,
            1.46999998833053E-04,
            1.67999998666346E-04
          ],
          "group": true,
          "allocated": " 2097148",
          "allocs": 19,
          "reallocs": 0,
          "frees": 19
        },
        "copy": {
          "duration": [
            2.70000000455184E-05,
            2.59999997069826E-05,
            2.40000008489005E-05,
            2.40000008489005E-05,
            2.49999993684469E-05
          ],
          "allocated": " 800000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            2.20000001718290E-05,
            2.30000005103648E-05,
            2.30000005103648E-05,
            2.20000001718290E-05,
            2.30000005103648E-05
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 1
        },
        "for-of loop": {
          "duration": [
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.80000003840541E-05,
            2.70000000455184E-05,
            2.70000000455184E-05,
            2.59999997069826E-05,
            2.70000000455184E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 1
        }
      },
      "size": 24,
      "allocated": " 14487044",
      "allocs": 101,
      "reallocs": 0,
      "frees": 101
    },
    {
      "name": "Ada Array",
      "category": "Integer Vector",
      "tests": {
        "fill": {
          "duration": [
            1.55000001541339E-04,
            1.10000000859145E-05,
            1.10000000859145E-05,
            1.10000000859145E-05,
            1.10000000859145E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            1.90000006114133E-04,
            2.09999998332933E-05,
            2.09999998332933E-05,
            1.99999994947575E-05,
            1.99999994947575E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            3.30000002577435E-05,
            2.90000007225899E-05,
            2.90000007225899E-05,
            2.90000007225899E-05,
            2.80000003840541E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.09999998332933E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 800000,
      "allocated": " 0",
      "allocs": 0,
      "reallocs": 0,
      "frees": 0
    },
    {
      "name": "C++",
      "category": "String Vector",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.25299992598593E-03,
            2.11500003933907E-03,
            2.24300008267164E-03,
            2.09599989466369E-03,
            2.15400010347366E-03
          ],
          "group": true,
          "allocated": " 21977184",
          "allocs": 100019,
          "reallocs": 0,
          "frees": 100019
        },
        "copy": {
          "duration": [
            1.61599996499717E-03,
            1.58200005535036E-03,
            1.82100001256913E-03,
            1.59100000746548E-03,
            1.51600001845509E-03
          ],
          "allocated": " 11600000",
          "allocs": 100001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            4.14999987697229E-04,
            7.30999978259206E-04,
            5.87999995332211E-04,
            3.61999991582707E-04,
            5.02999988384545E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 100001
        },
        "for-of loop": {
          "duration": [
            4.22999990405515E-04,
            6.43000006675720E-04,
            5.70999982301146E-04,
            3.67000000551343E-04,
            4.94999985676259E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.39000000874512E-04,
            4.36000002082437E-04,
            2.73999990895391E-04,
            2.41999994614162E-04,
            2.58999993093312E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            1.18899997323751E-03,
            1.35399994906038E-03,
            1.20299996342510E-03,
            1.46099994890392E-03,
            1.15699996240437E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 100001
        }
      },
      "size": 24,
      "allocated": " 167887224",
      "allocs": 1000101,
      "reallocs": 0,
      "frees": 1000101
    },
    {
      "name": "C++ unordered",
      "category": "IntInt Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            3.46100004389882E-03,
            3.49900010041893E-03,
            3.52100003510714E-03,
            3.38699994608760E-03,
            3.55700007639825E-03
          ],
          "group": true,
          "allocated": " 8734968",
          "allocs": 200015,
          "reallocs": 0,
          "frees": 200015
        },
        "copy": {
          "duration": [
            2.17500003054738E-03,
            2.21799989230931E-03,
            2.11800006218255E-03,
            2.08500004373491E-03,
            2.21999990753829E-03
          ],
          "allocated": " 6008488",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            3.60000005457550E-04,
            2.87000002572313E-04,
            3.35999997332692E-04,
            2.81999993603677E-04,
            3.07999987853691E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 200001
        },
        "for-in/of loop": {
          "duration": [
            3.26000008499250E-04,
            2.77000013738871E-04,
            2.69999989541247E-04,
            2.68000003416091E-04,
            2.84999987343326E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.34000006457791E-04,
            2.34000006457791E-04,
            2.30999998166226E-04,
            2.43999995291233E-04,
            2.34999999520369E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            4.83000010717660E-04,
            4.49999992270023E-04,
            4.52999986009672E-04,
            4.55000001238659E-04,
            4.53999993624166E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            4.55000001238659E-04,
            4.32000000728294E-04,
            4.38999995822087E-04,
            4.32000000728294E-04,
            4.38999995822087E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 56,
      "allocated": " 73717280",
      "allocs": 2000080,
      "reallocs": 0,
      "frees": 2000080
    },
    {
      "name": "C++ ordered",
      "category": "IntInt Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            1.31959998980165E-02,
            1.28410002216697E-02,
            1.27999996766448E-02,
            1.25059997662902E-02,
            1.28420004621148E-02
          ],
          "group": true,
          "allocated": " 8000000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 200000
        },
        "copy": {
          "duration": [
            3.57900001108646E-03,
            7.23099987953901E-03,
            3.14199994318187E-03,
            5.33600011840463E-03,
            4.02199989184737E-03
          ],
          "allocated": " 8000000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.28399999812245E-03,
            2.12300010025501E-03,
            1.40199996531010E-03,
            2.46100011281669E-03,
            1.80299999192357E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 200000
        },
        "for-in/of loop": {
          "duration": [
            1.25600001774728E-03,
            1.44599995110184E-03,
            1.07200001366436E-03,
            2.37899995408952E-03,
            1.60099996719509E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.07400002889335E-03,
            1.17199996020645E-03,
            8.31999990623444E-04,
            1.07500003650784E-03,
            8.92999989446253E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            9.53400041908026E-03,
            9.41899977624416E-03,
            9.42800007760525E-03,
            1.06429997831583E-02,
            9.33100003749132E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            9.48200002312660E-03,
            9.31700039654970E-03,
            9.44199971854687E-03,
            1.03679997846484E-02,
            9.27499961107969E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 48,
      "allocated": " 80000000",
      "allocs": 2000000,
      "reallocs": 0,
      "frees": 2000000
    },
    {
      "name": "C++ unordered",
      "category": "StrStr Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.43829991668463E-02,
            3.23089994490147E-02,
            2.32330001890659E-02,
            2.44020000100136E-02,
            2.25789994001389E-02
          ],
          "group": true,
          "allocated": " 21534968",
          "allocs": 200015,
          "reallocs": 0,
          "frees": 200015
        },
        "copy": {
          "duration": [
            1.76669992506504E-02,
            1.67239997535944E-02,
            1.35719999670982E-02,
            1.50279998779297E-02,
            1.33990002796054E-02
          ],
          "allocated": " 18808488",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.24890003353357E-02,
            9.92900040000677E-03,
            9.76500008255243E-03,
            8.55400040745735E-03,
            9.29600000381470E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 200001
        },
        "for-in/of loop": {
          "duration": [
            7.58899981155992E-03,
            4.72200009971857E-03,
            4.12000017240644E-03,
            3.87799995951355E-03,
            4.20799991115928E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            8.43700021505356E-03,
            4.21799998730421E-03,
            3.75099992379546E-03,
            5.84799982607365E-03,
            4.92500001564622E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            1.19500001892447E-03,
            1.04899995494634E-03,
            1.15300004836172E-03,
            1.07100000604987E-03,
            1.09000003430992E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            1.69750005006790E-02,
            1.40990000218153E-02,
            1.20099997147918E-02,
            1.26560004428029E-02,
            1.14010004326701E-02
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 56,
      "allocated": " 201717280",
      "allocs": 2000080,
      "reallocs": 0,
      "frees": 2000080
    },
    {
      "name": "C++ ordered",
      "category": "StrStr Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.59729996323586E-02,
            2.50569991767406E-02,
            2.57590003311634E-02,
            2.63710003346205E-02,
            2.67680007964373E-02
          ],
          "group": true,
          "allocated": " 19200000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 200000
        },
        "copy": {
          "duration": [
            7.44700012728572E-03,
            1.18100000545382E-02,
            8.64099990576506E-03,
            1.24599998816848E-02,
            9.32999979704618E-03
          ],
          "allocated": " 19200000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            2.50099995173514E-03,
            2.49200011603534E-03,
            2.60500004515052E-03,
            2.46399990282953E-03,
            2.90500000119209E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 200000
        },
        "for-in/of loop": {
          "duration": [
            2.31599994003773E-03,
            2.47099995613098E-03,
            2.36400007270277E-03,
            2.31699994765222E-03,
            2.73300008848310E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            3.01399989984930E-03,
            3.48099996335804E-03,
            3.13699990510941E-03,
            3.34300007671118E-03,
            3.57800000347197E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            5.47999981790781E-03,
            5.54999988526106E-03,
            5.65799977630377E-03,
            5.56300021708012E-03,
            5.53200021386147E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            2.00779996812344E-02,
            1.89260002225637E-02,
            1.94470006972551E-02,
            2.00599990785122E-02,
            1.90450008958578E-02
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 48,
      "allocated": " 192000000",
      "allocs": 2000000,
      "reallocs": 0,
      "frees": 2000000
    },
    {
      "name": "Ada12 Bounded",
      "category": "Integer List",
      "tests": {
        "fill": {
          "duration": [
            4.87000012071803E-04,
            3.03000007988885E-04,
            3.07999987853691E-04,
            3.16999998176470E-04,
            3.15999990561977E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            8.98000027518719E-04,
            7.00000018696301E-05,
            7.00000018696301E-05,
            7.00000018696301E-05,
            9.60000033956021E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            3.03000007988885E-04,
            2.96999991405755E-04,
            2.91000003926456E-04,
            2.88999988697469E-04,
            3.22999985655770E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            3.07000009343028E-04,
            3.06000001728535E-04,
            3.11999989207834E-04,
            3.12999996822327E-04,
            3.06000001728535E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            3.06000001728535E-04,
            3.04999994114041E-04,
            3.06000001728535E-04,
            3.75000003259629E-04,
            3.04999994114041E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 2400040,
      "allocated": " 0",
      "allocs": 0,
      "reallocs": 0,
      "frees": 0
    },
    {
      "name": "Ada12 Definite Unbounded",
      "category": "Integer List",
      "tests": {
        "fill": {
          "duration": [
            2.04399996437132E-03,
            1.20900000911206E-03,
            1.62400002591312E-03,
            1.13600003533065E-03,
            1.14499998744577E-03
          ],
          "group": true,
          "allocated": " 4800000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            2.18600011430681E-03,
            2.54800007678568E-03,
            1.31399999372661E-03,
            1.07700005173683E-03,
            1.40099995769560E-03
          ],
          "allocated": " 4800000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            3.11999989207834E-04,
            1.08499999623746E-03,
            2.81999993603677E-04,
            6.39999983832240E-04,
            2.54000013228506E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            2.77000013738871E-04,
            7.69999984186143E-04,
            2.65000009676442E-04,
            5.77000027988106E-04,
            2.46999989030883E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.24000003072433E-04,
            5.10999991092831E-04,
            2.24999996135011E-04,
            4.79999987874180E-04,
            2.22000002395362E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 40,
      "allocated": " 48000000",
      "allocs": 2000000,
      "reallocs": 0,
      "frees": 2000000
    },
    {
      "name": "Ada12 Indefinite Unbounded",
      "category": "Integer List",
      "tests": {
        "fill": {
          "duration": [
            2.07799999043345E-03,
            2.18100007623434E-03,
            2.08000000566244E-03,
            2.36500008031726E-03,
            2.18400009907782E-03
          ],
          "group": true,
          "allocated": " 5600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            4.14199987426400E-03,
            2.54100002348423E-03,
            2.45500006712973E-03,
            2.69600003957748E-03,
            2.54600006155670E-03
          ],
          "allocated": " 5600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.76799995824695E-03,
            1.05800002347678E-03,
            1.04600004851818E-03,
            1.12000002991408E-03,
            1.18200003635138E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            1.60299998242408E-03,
            1.07400002889335E-03,
            1.01500004529953E-03,
            1.07600004412234E-03,
            1.10500003211200E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            8.18000000435859E-04,
            5.97000005654991E-04,
            5.79999992623925E-04,
            5.78999985009432E-04,
            5.81000000238419E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 40,
      "allocated": " 56000000",
      "allocs": 4000000,
      "reallocs": 0,
      "frees": 4000000
    },
    {
      "name": "Ada12 Nochecks Def unbounded",
      "category": "Integer List",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            1.11700000707060E-03,
            1.28399999812245E-03,
            1.16800004616380E-03,
            1.10600003972650E-03,
            1.10400002449751E-03
          ],
          "group": true,
          "allocated": " 4800000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            1.09100004192442E-03,
            1.33799994364381E-03,
            1.11399998422712E-03,
            1.17900001350790E-03,
            1.16400001570582E-03
          ],
          "allocated": " 4800000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            2.88000010186806E-04,
            6.50000001769513E-04,
            2.41999994614162E-04,
            4.87000012071803E-04,
            2.54000013228506E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            2.60000000707805E-04,
            5.89000002946705E-04,
            2.39000000874512E-04,
            5.64999994821846E-04,
            2.50999990385026E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.28000004426576E-04,
            4.68999991426244E-04,
            2.22999995457940E-04,
            5.74000005144626E-04,
            2.20999994780868E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 40,
      "allocated": " 48000024",
      "allocs": 2000003,
      "reallocs": 0,
      "frees": 2000000
    },
    {
      "name": "Indef Unbounded",
      "category": "Integer List",
      "tests": {
        "fill": {
          "duration": [
            4.66000009328127E-03,
            2.79600010253489E-03,
            3.02900001406670E-03,
            2.77299992740154E-03,
            2.80599994584918E-03
          ],
          "group": true,
          "allocated": " 5600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            5.16799977049232E-03,
            3.37999989278615E-03,
            3.05800000205636E-03,
            3.16200009547174E-03,
            3.01299989223480E-03
          ],
          "allocated": " 5600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.34900002740324E-03,
            1.09499995596707E-03,
            1.26100005581975E-03,
            1.11299997661263E-03,
            9.75999981164932E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            9.84000042080879E-04,
            1.04700005613267E-03,
            1.21200003195554E-03,
            1.19700003415346E-03,
            9.59999975748360E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            5.63999987207353E-04,
            6.14000018686056E-04,
            6.67000014800578E-04,
            6.30000024102628E-04,
            5.78999985009432E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 56000024",
      "allocs": 4000003,
      "reallocs": 0,
      "frees": 4000000
    },
    {
      "name": "Def Unbounded",
      "category": "Integer List",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            1.39999995008111E-03,
            1.35000003501773E-03,
            1.62500003352761E-03,
            1.34700001217425E-03,
            1.37800001539290E-03
          ],
          "group": true,
          "allocated": " 4800000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            1.54800002928823E-03,
            1.37600000016391E-03,
            1.46299996413291E-03,
            1.36600004043430E-03,
            1.40199996531010E-03
          ],
          "allocated": " 4800000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            4.98000008519739E-04,
            3.22000007145107E-04,
            4.83999989228323E-04,
            3.22999985655770E-04,
            4.57999994978309E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            4.86000004457310E-04,
            3.23999993270263E-04,
            4.53999993624166E-04,
            3.20999999530613E-04,
            4.53999993624166E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            4.22000011894852E-04,
            3.11999989207834E-04,
            4.29000006988645E-04,
            3.15000012051314E-04,
            4.32000000728294E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 48000024",
      "allocs": 2000003,
      "reallocs": 0,
      "frees": 2000000
    },
    {
      "name": "Def Bounded",
      "category": "Integer List",
      "tests": {
        "fill": {
          "duration": [
            7.23999983165413E-04,
            7.22999975550920E-04,
            6.94999995175749E-04,
            7.35000008717179E-04,
            7.19000003300607E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            9.50000030570664E-05,
            8.70000003487803E-05,
            6.90000015310943E-05,
            7.00000018696301E-05,
            7.40000032237731E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            2.92000011540949E-04,
            2.96999991405755E-04,
            2.92000011540949E-04,
            2.93999997666106E-04,
            2.92000011540949E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            2.92000011540949E-04,
            2.92000011540949E-04,
            2.91000003926456E-04,
            2.92000011540949E-04,
            2.91000003926456E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.77000013738871E-04,
            2.76000006124377E-04,
            2.74999998509884E-04,
            2.74999998509884E-04,
            2.76000006124377E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 2400032,
      "allocated": " 24",
      "allocs": 3,
      "reallocs": 0,
      "frees": 0
    },
    {
      "name": "Limited Indef_Spark Unbounded_Spark",
      "category": "Integer List",
      "tests": {
        "fill": {
          "duration": [
            3.08799999766052E-03,
            2.70400010049343E-03,
            2.79700011014938E-03,
            2.71599995903671E-03,
            2.71399994380772E-03
          ],
          "group": true,
          "allocated": " 10754528",
          "allocs": 200001,
          "reallocs": 30,
          "frees": 0
        },
        "copy": {
          "duration": [
            2.37099989317358E-03,
            2.33000004664063E-03,
            2.44700000621378E-03,
            2.48000002466142E-03,
            2.39100004546344E-03
          ],
          "allocated": " 4118112",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            4.29000006988645E-04,
            4.15999995311722E-04,
            4.38999995822087E-04,
            4.36000002082437E-04,
            4.07999992603436E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            3.44000000040978E-04,
            3.52000002749264E-04,
            3.64000006811693E-04,
            4.07999992603436E-04,
            3.57000011717901E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            3.26000008499250E-04,
            3.26000008499250E-04,
            3.53999988874421E-04,
            3.37000004947186E-04,
            3.26000008499250E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 40,
      "allocated": " 74363200",
      "allocs": 2000010,
      "reallocs": 150,
      "frees": 2000010
    },
    {
      "name": "Ada12 Indefinite Unbounded",
      "category": "String List",
      "tests": {
        "fill": {
          "duration": [
            4.82599996030331E-03,
            3.89400008134544E-03,
            4.96499985456467E-03,
            4.20199986547232E-03,
            6.08900003135204E-03
          ],
          "group": true,
          "allocated": " 13600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            4.82300017029047E-03,
            4.70500020310283E-03,
            6.67899986729026E-03,
            9.39099956303835E-03,
            7.69399991258979E-03
          ],
          "allocated": " 13600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.55199994333088E-03,
            4.03899978846312E-03,
            1.43599999137223E-03,
            2.94600008055568E-03,
            1.53000000864267E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            1.77500001154840E-03,
            4.31900005787611E-03,
            1.45900005009025E-03,
            3.18400003015995E-03,
            1.61599996499717E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.32999999914318E-03,
            2.55300011485815E-03,
            1.41599995549768E-03,
            2.24400009028614E-03,
            1.19900004938245E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 40,
      "allocated": " 136000000",
      "allocs": 4000000,
      "reallocs": 0,
      "frees": 4000000
    },
    {
      "name": "Ada12 Nochecks Indef Unbounded",
      "category": "String List",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            3.73100000433624E-03,
            4.49200021103024E-03,
            4.14100009948015E-03,
            5.46200014650822E-03,
            3.75099992379546E-03
          ],
          "group": true,
          "allocated": " 13600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            1.16069996729493E-02,
            8.00999999046326E-03,
            1.04700000956655E-02,
            7.06700002774596E-03,
            1.07450000941753E-02
          ],
          "allocated": " 13600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            3.91400000080466E-03,
            1.53300003148615E-03,
            3.33700003102422E-03,
            1.85600004624575E-03,
            4.26799990236759E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            4.17600013315678E-03,
            1.57199997920543E-03,
            3.55400005355477E-03,
            1.88600004184991E-03,
            4.51500015333295E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.94900010339916E-03,
            1.18799996562302E-03,
            3.08499997481704E-03,
            1.24500005040318E-03,
            2.77799996547401E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 40,
      "allocated": " 136000024",
      "allocs": 4000003,
      "reallocs": 0,
      "frees": 4000000
    },
    {
      "name": "Unbounded of Indef",
      "category": "String List",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            4.91299992427230E-03,
            4.22000000253320E-03,
            4.79699997231364E-03,
            4.51799994334579E-03,
            5.73700014501810E-03
          ],
          "group": true,
          "allocated": " 13600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            5.53999980911613E-03,
            7.37399980425835E-03,
            5.96700003370643E-03,
            1.27550000324845E-02,
            5.94600010663271E-03
          ],
          "allocated": " 13600000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.71900005079806E-03,
            3.36900004185736E-03,
            1.66900001931936E-03,
            2.56199995055795E-03,
            1.66299997363240E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            1.72399997245520E-03,
            3.27200000174344E-03,
            1.62999995518476E-03,
            2.43299989961088E-03,
            1.68800004757941E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.33999995887280E-03,
            1.90999999176711E-03,
            1.32799998391420E-03,
            1.82100001256913E-03,
            1.29399995785207E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 136000024",
      "allocs": 4000003,
      "reallocs": 0,
      "frees": 4000000
    },
    {
      "name": "Unbounded of Unbounded_String",
      "category": "String List",
      "tests": {
        "fill": {
          "duration": [
            1.48350000381470E-02,
            1.44300004467368E-02,
            1.77020002156496E-02,
            1.43269998952746E-02,
            1.72049999237061E-02
          ],
          "group": true,
          "allocated": " 20800000",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            5.65900001674891E-03,
            8.64600017666817E-03,
            5.16200019046664E-03,
            8.45099985599518E-03,
            5.09299989789724E-03
          ],
          "allocated": " 9600000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            5.74100017547607E-03,
            9.19499993324280E-03,
            5.72900008410215E-03,
            8.73699970543385E-03,
            5.64400013536215E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            7.45999999344349E-03,
            1.01570002734661E-02,
            7.61700002476573E-03,
            1.01990001276135E-02,
            7.47299985960126E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            5.55399991571903E-03,
            7.90899991989136E-03,
            5.66999986767769E-03,
            7.94299971312284E-03,
            5.66799985244870E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 152000024",
      "allocs": 3000003,
      "reallocs": 0,
      "frees": 3000000
    },
    {
      "name": "Limited Unbounded_SPARK of Indef_SPARK",
      "category": "String List",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            1.22579997405410E-02,
            7.39599997177720E-03,
            4.36699995771050E-03,
            4.32799989357591E-03,
            4.12999978289008E-03
          ],
          "group": true,
          "allocated": " 22131792",
          "allocs": 200001,
          "reallocs": 30,
          "frees": 0
        },
        "copy": {
          "duration": [
            3.88500001281500E-03,
            3.94900003448129E-03,
            3.70600004680455E-03,
            3.85099998675287E-03,
            3.68499988690019E-03
          ],
          "allocated": " 12177168",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.49000005330890E-03,
            1.49199995212257E-03,
            1.43499998375773E-03,
            1.49499997496605E-03,
            1.41499994788319E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            1.41300004906952E-03,
            1.42800004687160E-03,
            1.53500004671514E-03,
            1.43900001421571E-03,
            1.45800004247576E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.35499995667487E-03,
            1.41499994788319E-03,
            1.36899994686246E-03,
            1.47599994670600E-03,
            1.42200000118464E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 40,
      "allocated": " 171544800",
      "allocs": 2000010,
      "reallocs": 150,
      "frees": 2000010
    },
    {
      "name": "Ada12 Bounded",
      "category": "Integer Vector",
      "tests": {
        "fill": {
          "duration": [
            6.09999988228083E-05,
            1.89999991562217E-05,
            1.89999991562217E-05,
            1.89999991562217E-05,
            1.89999991562217E-05
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            2.80000003840541E-05,
            2.40000008489005E-05,
            2.30000005103648E-05,
            2.30000005103648E-05,
            2.20000001718290E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            7.59999966248870E-05,
            7.00000018696301E-05,
            7.59999966248870E-05,
            7.69999969634227E-05,
            7.20000025467016E-05
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            8.39999993331730E-05,
            8.29999989946373E-05,
            8.29999989946373E-05,
            8.39999993331730E-05,
            8.29999989946373E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            8.39999993331730E-05,
            8.29999989946373E-05,
            8.39999993331730E-05,
            8.39999993331730E-05,
            8.39999993331730E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            8.36000021081418E-04,
            8.44999973196536E-04,
            8.35000013466924E-04,
            8.36000021081418E-04,
            8.36000021081418E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 800024,
      "allocated": " 0",
      "allocs": 0,
      "reallocs": 0,
      "frees": 0
    },
    {
      "name": "Ada12 Definite Unbounded",
      "category": "Integer Vector",
      "tests": {
        "fill": {
          "duration": [
            1.65999997989275E-04,
            1.55999994603917E-04,
            1.53999993926845E-04,
            1.53000000864267E-04,
            1.53999993926845E-04
          ],
          "group": true,
          "allocated": " 2097224",
          "allocs": 19,
          "reallocs": 0,
          "frees": 18
        },
        "copy": {
          "duration": [
            3.19999999192078E-05,
            2.59999997069826E-05,
            2.59999997069826E-05,
            2.49999993684469E-05,
            2.70000000455184E-05
          ],
          "allocated": " 800004",
          "allocs": 1,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            7.69999969634227E-05,
            7.00000018696301E-05,
            7.10000022081658E-05,
            7.00000018696301E-05,
            7.10000022081658E-05
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            7.40000032237731E-05,
            6.50000001769513E-05,
            7.10000022081658E-05,
            7.10000022081658E-05,
            7.00000018696301E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            6.19999991613440E-05,
            5.70000011066440E-05,
            4.89999983983580E-05,
            5.19999994139653E-05,
            5.19999994139653E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            8.37999978102744E-04,
            8.35000013466924E-04,
            8.35000013466924E-04,
            8.51000018883497E-04,
            8.58000013977289E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 14486140",
      "allocs": 100,
      "reallocs": 0,
      "frees": 100
    },
    {
      "name": "Ada12 Indefinite Unbounded",
      "category": "Integer Vector",
      "tests": {
        "fill": {
          "duration": [
            2.53499997779727E-03,
            2.48500006273389E-03,
            2.51400005072355E-03,
            2.40499991923571E-03,
            2.46599991805851E-03
          ],
          "group": true,
          "allocated": " 4994448",
          "allocs": 200019,
          "reallocs": 0,
          "frees": 18
        },
        "copy": {
          "duration": [
            2.01499997638166E-03,
            1.98900001123548E-03,
            2.10499996319413E-03,
            2.28799995966256E-03,
            2.04699998721480E-03
          ],
          "allocated": " 2400008",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            2.26999996812083E-04,
            2.39000000874512E-04,
            2.11000005947426E-04,
            2.47999996645376E-04,
            1.99000001884997E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            2.01000002562068E-04,
            2.81999993603677E-04,
            2.01000002562068E-04,
            2.13999999687076E-04,
            2.09000005270354E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.46999998833053E-04,
            1.55000001541339E-04,
            1.46999998833053E-04,
            1.44000005093403E-04,
            1.50000007124618E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            8.82000022102147E-04,
            9.28000023122877E-04,
            8.82000022102147E-04,
            8.88000009581447E-04,
            8.84999986737967E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 36972280",
      "allocs": 2000100,
      "reallocs": 0,
      "frees": 2000100
    },
    {
      "name": "Ada12 Nochecks Definite Unbounded",
      "category": "Integer Vector",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            1.69999999343418E-04,
            1.57999995280989E-04,
            1.57999995280989E-04,
            1.59999995958060E-04,
            1.59000002895482E-04
          ],
          "group": true,
          "allocated": " 2097224",
          "allocs": 19,
          "reallocs": 0,
          "frees": 18
        },
        "copy": {
          "duration": [
            2.70000000455184E-05,
            2.90000007225899E-05,
            2.70000000455184E-05,
            2.90000007225899E-05,
            2.59999997069826E-05
          ],
          "allocated": " 800004",
          "allocs": 1,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            7.00000018696301E-05,
            7.10000022081658E-05,
            7.10000022081658E-05,
            7.30000028852373E-05,
            7.30000028852373E-05
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            5.70000011066440E-05,
            5.70000011066440E-05,
            5.70000011066440E-05,
            5.70000011066440E-05,
            5.70000011066440E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            5.70000011066440E-05,
            5.70000011066440E-05,
            5.70000011066440E-05,
            5.80000014451798E-05,
            5.70000011066440E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            8.38999985717237E-04,
            8.36000021081418E-04,
            8.35000013466924E-04,
            8.41000000946224E-04,
            8.35000013466924E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 14486148",
      "allocs": 101,
      "reallocs": 0,
      "frees": 100
    },
    {
      "name": "Indef Unbounded",
      "category": "Integer Vector",
      "tests": {
        "fill": {
          "duration": [
            2.58899992331862E-03,
            2.52999993972480E-03,
            2.31299991719425E-03,
            2.49399989843369E-03,
            2.35900003463030E-03
          ],
          "group": true,
          "allocated": " 5777216",
          "allocs": 200001,
          "reallocs": 27,
          "frees": 0
        },
        "copy": {
          "duration": [
            2.26400000974536E-03,
            2.22199992276728E-03,
            2.10299994796515E-03,
            2.29900004342198E-03,
            2.16899998486042E-03
          ],
          "allocated": " 2400000",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            2.18000001041219E-04,
            2.26999996812083E-04,
            1.86999997822568E-04,
            3.19999991916120E-04,
            2.73000012384728E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            1.92999999853782E-04,
            1.93999992916360E-04,
            1.74000000697561E-04,
            2.26999996812083E-04,
            2.64000002061948E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.48999999510124E-04,
            1.55999994603917E-04,
            1.61000003572553E-04,
            1.59000002895482E-04,
            1.53000000864267E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            1.42000004416332E-04,
            1.42999997478910E-04,
            1.42000004416332E-04,
            1.44999998155981E-04,
            1.38999996124767E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 40886088",
      "allocs": 2000011,
      "reallocs": 135,
      "frees": 2000010
    },
    {
      "name": "Def Unbounded",
      "category": "Integer Vector",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            1.57000002218410E-04,
            1.53999993926845E-04,
            1.51999993249774E-04,
            1.51999993249774E-04,
            1.51999993249774E-04
          ],
          "group": true,
          "allocated": " 2488608",
          "allocs": 1,
          "reallocs": 27,
          "frees": 0
        },
        "copy": {
          "duration": [
            2.90000007225899E-05,
            2.70000000455184E-05,
            2.59999997069826E-05,
            2.59999997069826E-05,
            2.59999997069826E-05
          ],
          "allocated": " 800000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            7.10000022081658E-05,
            6.39999998384155E-05,
            7.10000022081658E-05,
            7.00000018696301E-05,
            7.00000018696301E-05
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            9.00000013643876E-05,
            9.10000017029233E-05,
            8.70000003487803E-05,
            8.70000003487803E-05,
            9.00000013643876E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            6.29999994998798E-05,
            6.29999994998798E-05,
            6.39999998384155E-05,
            7.00000018696301E-05,
            6.90000015310943E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.30000005103648E-05,
            2.30000005103648E-05,
            2.30000005103648E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 16443048",
      "allocs": 11,
      "reallocs": 135,
      "frees": 10
    },
    {
      "name": "Def Bounded",
      "category": "Integer Vector",
      "tests": {
        "fill": {
          "duration": [
            3.38000012561679E-04,
            3.34000011207536E-04,
            3.34000011207536E-04,
            3.34999989718199E-04,
            3.33000003593042E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            2.90000007225899E-05,
            2.30000005103648E-05,
            2.20000001718290E-05,
            2.20000001718290E-05,
            2.20000001718290E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            7.79999973019585E-05,
            7.00000018696301E-05,
            6.50000001769513E-05,
            6.39999998384155E-05,
            6.39999998384155E-05
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            6.90000015310943E-05,
            6.19999991613440E-05,
            7.00000018696301E-05,
            7.00000018696301E-05,
            7.00000018696301E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            6.29999994998798E-05,
            6.29999994998798E-05,
            6.90000015310943E-05,
            7.00000018696301E-05,
            6.90000015310943E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            2.30000005103648E-05,
            2.30000005103648E-05,
            2.30000005103648E-05,
            2.20000001718290E-05,
            2.40000008489005E-05
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 800024,
      "allocated": " 8",
      "allocs": 1,
      "reallocs": 0,
      "frees": 0
    },
    {
      "name": "Limited Indef_SPARK Unbounded_SPARK",
      "category": "Integer Vector",
      "tests": {
        "fill": {
          "duration": [
            6.97499979287386E-03,
            6.96199992671609E-03,
            6.93299993872643E-03,
            7.06000020727515E-03,
            7.13999988511205E-03
          ],
          "group": true,
          "allocated": " 7436296",
          "allocs": 614798,
          "reallocs": 0,
          "frees": 414797
        },
        "copy": {
          "duration": [
            2.23600002937019E-03,
            2.12200009264052E-03,
            2.11500003933907E-03,
            2.23500002175570E-03,
            2.24799988791347E-03
          ],
          "allocated": " 2400000",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            3.81999998353422E-04,
            3.30999988364056E-04,
            1.95999993593432E-04,
            2.05999996978790E-04,
            2.07999997655861E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            3.61000013072044E-04,
            2.80999985989183E-04,
            1.90999999176711E-04,
            1.97000001207925E-04,
            2.01999995624647E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.61999996635132E-04,
            1.59000002895482E-04,
            1.59000002895482E-04,
            1.63000004249625E-04,
            1.57000002218410E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            1.42000004416332E-04,
            1.42000004416332E-04,
            1.48000006447546E-04,
            1.44000005093403E-04,
            1.40999996801838E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 49181480",
      "allocs": 4073995,
      "reallocs": 0,
      "frees": 4073995
    },
    {
      "name": "Ada12 Indefinite Unbounded",
      "category": "String Vector",
      "tests": {
        "fill": {
          "duration": [
            3.62000009045005E-03,
            3.31799988634884E-03,
            3.32599994726479E-03,
            3.38599993847311E-03,
            3.30099998973310E-03
          ],
          "group": true,
          "allocated": " 15588744",
          "allocs": 200019,
          "reallocs": 0,
          "frees": 18
        },
        "copy": {
          "duration": [
            3.19500011391938E-03,
            3.07100010104477E-03,
            2.74299993179739E-03,
            2.85000004805624E-03,
            2.77299992740154E-03
          ],
          "allocated": " 10400008",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.18400005158037E-03,
            9.98000032268465E-04,
            1.11099996138364E-03,
            1.00100005511194E-03,
            1.01000000722706E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            6.45000021904707E-04,
            5.37000014446676E-04,
            7.96000007539988E-04,
            6.14000018686056E-04,
            7.30000028852373E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.69999989541247E-04,
            2.83000001218170E-04,
            3.44000000040978E-04,
            3.11999989207834E-04,
            3.67000000551343E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            8.96000012289733E-04,
            8.98999976925552E-04,
            9.35000018216670E-04,
            8.96000012289733E-04,
            9.84000042080879E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 129943760",
      "allocs": 2000100,
      "reallocs": 0,
      "frees": 2000100
    },
    {
      "name": "Ada12 Nochecks Indefinite Unbounded",
      "category": "String Vector",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            3.57199995778501E-03,
            3.40700009837747E-03,
            3.75699996948242E-03,
            3.53899993933737E-03,
            3.35099990479648E-03
          ],
          "group": true,
          "allocated": " 15588744",
          "allocs": 200019,
          "reallocs": 0,
          "frees": 18
        },
        "copy": {
          "duration": [
            2.80499993823469E-03,
            2.80099990777671E-03,
            3.00900009460747E-03,
            2.82600009813905E-03,
            2.92899995110929E-03
          ],
          "allocated": " 10400008",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            9.91999986581504E-04,
            9.92999994195998E-04,
            1.00000004749745E-03,
            9.94000001810491E-04,
            1.13200000487268E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            5.61999971978366E-04,
            5.82000007852912E-04,
            5.87999995332211E-04,
            4.83000010717660E-04,
            8.00999987404794E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.89999996311963E-04,
            2.85999994957820E-04,
            3.15999990561977E-04,
            2.64000002061948E-04,
            3.68999986676499E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            9.74000024143606E-04,
            8.96000012289733E-04,
            9.06999979633838E-04,
            8.97000019904226E-04,
            9.21999977435917E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 129943768",
      "allocs": 2000101,
      "reallocs": 0,
      "frees": 2000100
    },
    {
      "name": "Indef Unbounded",
      "category": "String Vector",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.78099998831749E-03,
            2.75300000794232E-03,
            2.77599995024502E-03,
            2.77499994263053E-03,
            2.68699997104704E-03
          ],
          "group": true,
          "allocated": " 17154432",
          "allocs": 200001,
          "reallocs": 27,
          "frees": 0
        },
        "copy": {
          "duration": [
            2.90800002403557E-03,
            2.76000006124377E-03,
            2.92199989780784E-03,
            2.90600000880659E-03,
            2.92899995110929E-03
          ],
          "allocated": " 10400000",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            5.92999975197017E-04,
            7.38999980967492E-04,
            5.90000010561198E-04,
            5.70999982301146E-04,
            7.63999996706843E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            5.86999987717718E-04,
            7.14999972842634E-04,
            5.28000004123896E-04,
            4.87999990582466E-04,
            7.25999998394400E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            3.15999990561977E-04,
            3.68999986676499E-04,
            2.84000008832663E-04,
            2.84000008832663E-04,
            3.45999986166134E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            2.60000000707805E-04,
            3.00000014249235E-04,
            2.50999990385026E-04,
            2.50999990385026E-04,
            2.73999990895391E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 137772168",
      "allocs": 2000011,
      "reallocs": 135,
      "frees": 2000010
    },
    {
      "name": "Limited Indef_SPARK Unbounded_SPARK",
      "category": "String Vector",
      "tests": {
        "fill": {
          "duration": [
            8.18699970841408E-03,
            8.46400018781424E-03,
            8.26899986714125E-03,
            8.47500003874302E-03,
            8.43099970370531E-03
          ],
          "group": true,
          "allocated": " 32086488",
          "allocs": 614798,
          "reallocs": 0,
          "frees": 414797
        },
        "copy": {
          "duration": [
            2.96900002285838E-03,
            3.07000009343028E-03,
            2.90900003165007E-03,
            3.04499990306795E-03,
            2.96299997717142E-03
          ],
          "allocated": " 10400000",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.45500001963228E-03,
            1.53200002387166E-03,
            1.74199999310076E-03,
            1.48300000000745E-03,
            1.73500005621463E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-of loop": {
          "duration": [
            1.45300000440329E-03,
            1.47300004027784E-03,
            1.59300002269447E-03,
            1.46900000981987E-03,
            1.56400003470480E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.36999995447695E-03,
            1.73799996264279E-03,
            1.41999998595566E-03,
            1.40199996531010E-03,
            1.45099998917431E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            1.31600000895560E-03,
            1.37600000016391E-03,
            1.28600001335144E-03,
            1.36999995447695E-03,
            1.39300001319498E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 212432440",
      "allocs": 4073995,
      "reallocs": 0,
      "frees": 4073995
    },
    {
      "name": "Ada12 ordered definite unbounded",
      "category": "IntInt Map",
      "tests": {
        "fill": {
          "duration": [
            1.14200003445148E-02,
            9.74799972027540E-03,
            9.79600008577108E-03,
            9.87500045448542E-03,
            1.04400003328919E-02
          ],
          "group": true,
          "allocated": " 8000000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            3.46800009720027E-03,
            5.82899991422892E-03,
            3.05399997159839E-03,
            5.54500008001924E-03,
            3.41199990361929E-03
          ],
          "allocated": " 8000000",
          "allocs": 200000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.45199999678880E-03,
            1.84599997010082E-03,
            1.47699995432049E-03,
            1.60099996719509E-03,
            1.25600001774728E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            1.00499996915460E-03,
            1.55100005213171E-03,
            1.37600000016391E-03,
            1.32799998391420E-03,
            1.17599999066442E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            7.31999985873699E-04,
            1.08700001146644E-03,
            8.29999975394458E-04,
            9.29999980144203E-04,
            8.65000009071082E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            8.01599957048893E-03,
            7.84699991345406E-03,
            7.64199998229742E-03,
            8.01100023090839E-03,
            7.88300018757582E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            7.59400008246303E-03,
            7.60499993339181E-03,
            7.67099997028708E-03,
            8.03400017321110E-03,
            7.83899985253811E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 56,
      "allocated": " 80000000",
      "allocs": 2000000,
      "reallocs": 0,
      "frees": 2000000
    },
    {
      "name": "Ada12 hashed definite unbounded",
      "category": "IntInt Map",
      "tests": {
        "fill": {
          "duration": [
            8.64099990576506E-03,
            3.77600011415780E-03,
            3.79500002600253E-03,
            3.51599999703467E-03,
            3.63099994137883E-03
          ],
          "group": true,
          "allocated": " 9491984",
          "allocs": 200014,
          "reallocs": 0,
          "frees": 13
        },
        "copy": {
          "duration": [
            2.42800009436905E-03,
            2.70200008526444E-03,
            2.42600007914007E-03,
            2.43099988438189E-03,
            2.40099988877773E-03
          ],
          "allocated": " 6345936",
          "allocs": 200001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            4.18999989051372E-04,
            3.91999987186864E-04,
            3.98000003769994E-04,
            5.59000007342547E-04,
            3.76000010874122E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            3.57999990228564E-04,
            3.34999989718199E-04,
            3.58999997843057E-04,
            5.75000012759119E-04,
            3.48000001395121E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.65000009676442E-04,
            2.70999997155741E-04,
            2.68000003416091E-04,
            3.03999986499548E-04,
            2.69999989541247E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            2.83000001218170E-04,
            2.81999993603677E-04,
            2.83000001218170E-04,
            2.88000010186806E-04,
            2.83000001218170E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            2.54999991739169E-04,
            2.55999999353662E-04,
            2.55999999353662E-04,
            2.57000006968156E-04,
            2.54999991739169E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 48,
      "allocated": " 79189600",
      "allocs": 2000075,
      "reallocs": 0,
      "frees": 2000075
    },
    {
      "name": "Ada12 hashed definite bounded",
      "category": "IntInt Map",
      "tests": {
        "fill": {
          "duration": [
            6.66000007186085E-04,
            6.56999996863306E-04,
            6.75000017508864E-04,
            7.13000015821308E-04,
            6.32999988738447E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            8.75000027008355E-04,
            1.44999998155981E-04,
            1.42999997478910E-04,
            1.48999999510124E-04,
            1.40999996801838E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            1.48199999239296E-03,
            1.46800000220537E-03,
            1.46800000220537E-03,
            1.49199995212257E-03,
            1.45500001963228E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            1.41599995549768E-03,
            1.40499998815358E-03,
            1.41100003384054E-03,
            1.41699996311218E-03,
            1.41100003384054E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            1.37299997732043E-03,
            1.37600000016391E-03,
            1.39999995008111E-03,
            1.37800001539290E-03,
            1.36999995447695E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            3.16999998176470E-04,
            3.16999998176470E-04,
            3.15999990561977E-04,
            3.16999998176470E-04,
            3.16999998176470E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            3.03000007988885E-04,
            3.00000014249235E-04,
            3.00000014249235E-04,
            3.00000014249235E-04,
            3.00000014249235E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 3973000,
      "allocated": " 40",
      "allocs": 5,
      "reallocs": 0,
      "frees": 0
    },
    {
      "name": "Hashed Def Def Unbounded",
      "category": "IntInt Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.40999995730817E-03,
            2.09000008180737E-03,
            2.15599988587201E-03,
            2.19999998807907E-03,
            2.29400000534952E-03
          ],
          "group": true,
          "allocated": " 9087696",
          "allocs": 9,
          "reallocs": 0,
          "frees": 8
        },
        "copy": {
          "duration": [
            2.01900000683963E-03,
            1.78699998650700E-03,
            1.60399999003857E-03,
            1.68099999427795E-03,
            1.61299994215369E-03
          ],
          "allocated": " 6815752",
          "allocs": 1,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            4.79999987874180E-04,
            4.22999990405515E-04,
            4.10999986343086E-04,
            4.59000002592802E-04,
            4.22000011894852E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            4.21000004280359E-04,
            4.18999989051372E-04,
            4.14999987697229E-04,
            4.33000008342788E-04,
            4.22000011894852E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            4.03999991249293E-04,
            4.18999989051372E-04,
            4.00999997509643E-04,
            4.14000009186566E-04,
            4.03000012738630E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            3.76000010874122E-04,
            3.76000010874122E-04,
            3.76000010874122E-04,
            3.76000010874122E-04,
            3.76999989384785E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            3.76000010874122E-04,
            3.76000010874122E-04,
            3.76000010874122E-04,
            3.76000010874122E-04,
            3.76000010874122E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 79517280",
      "allocs": 55,
      "reallocs": 0,
      "frees": 50
    },
    {
      "name": "Hashed Linear Probing Def Def Unbounded",
      "category": "IntInt Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.14300001971424E-03,
            2.16999999247491E-03,
            2.20900005660951E-03,
            2.13799998164177E-03,
            2.34799995087087E-03
          ],
          "group": true,
          "allocated": " 9087696",
          "allocs": 9,
          "reallocs": 0,
          "frees": 8
        },
        "copy": {
          "duration": [
            1.58399995416403E-03,
            1.60600000526756E-03,
            1.58200005535036E-03,
            1.71999994199723E-03,
            1.67599995620549E-03
          ],
          "allocated": " 6815752",
          "allocs": 1,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            4.36000002082437E-04,
            4.18000010540709E-04,
            4.22000011894852E-04,
            4.57999994978309E-04,
            4.37999988207594E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            4.71000006655231E-04,
            4.07999992603436E-04,
            4.07999992603436E-04,
            4.41999989561737E-04,
            4.06000006478280E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            4.61999996332452E-04,
            4.21000004280359E-04,
            4.00999997509643E-04,
            4.27999999374151E-04,
            4.03999991249293E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            3.80000012228265E-04,
            3.76000010874122E-04,
            3.77999996999279E-04,
            3.76000010874122E-04,
            3.76000010874122E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            3.95000010030344E-04,
            3.76000010874122E-04,
            3.76000010874122E-04,
            3.76000010874122E-04,
            3.76000010874122E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 79517240",
      "allocs": 50,
      "reallocs": 0,
      "frees": 50
    },
    {
      "name": "Ada12 Ordered Indefinite Unbounded",
      "category": "StrStr Map",
      "tests": {
        "fill": {
          "duration": [
            3.90189997851849E-02,
            3.84679995477200E-02,
            3.88959981501102E-02,
            3.93050014972687E-02,
            4.00910004973412E-02
          ],
          "group": true,
          "allocated": " 18360004",
          "allocs": 600000,
          "reallocs": 0,
          "frees": 0
        },
        "copy": {
          "duration": [
            1.70910004526377E-02,
            2.13939994573593E-02,
            1.76870003342628E-02,
            2.11919993162155E-02,
            1.83760002255440E-02
          ],
          "allocated": " 18360004",
          "allocs": 600000,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            3.78299993462861E-03,
            3.52200004272163E-03,
            3.13000008463860E-03,
            3.25699988752604E-03,
            3.52100003510714E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            2.80399993062019E-03,
            2.45500006712973E-03,
            2.05000001005828E-03,
            2.13699997402728E-03,
            2.09400011226535E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            3.21300001814961E-03,
            3.32599994726479E-03,
            2.92199989780784E-03,
            2.95000011101365E-03,
            3.06200003251433E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            1.06159998103976E-02,
            1.04440003633499E-02,
            1.00480001419783E-02,
            1.06509998440742E-02,
            1.03110000491142E-02
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            2.88789998739958E-02,
            2.94630005955696E-02,
            2.93729994446039E-02,
            3.00740003585815E-02,
            2.93719992041588E-02
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 56,
      "allocated": " 183600040",
      "allocs": 6000000,
      "reallocs": 0,
      "frees": 6000000
    },
    {
      "name": "Ada12 Hashed Indefinite Unbounded",
      "category": "StrStr Map",
      "tests": {
        "fill": {
          "duration": [
            4.34189997613430E-02,
            2.01350003480911E-02,
            2.04099994152784E-02,
            2.02500000596046E-02,
            2.11379993706942E-02
          ],
          "group": true,
          "allocated": " 19851988",
          "allocs": 600014,
          "reallocs": 0,
          "frees": 13
        },
        "copy": {
          "duration": [
            1.00290002301335E-02,
            9.97999962419271E-03,
            1.04689998552203E-02,
            1.00600002333522E-02,
            9.45900008082390E-03
          ],
          "allocated": " 16705940",
          "allocs": 600001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            5.03600016236305E-03,
            4.27199993282557E-03,
            4.30899998173118E-03,
            4.79899998754263E-03,
            4.46699978783727E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            1.81199994403869E-03,
            1.76500005181879E-03,
            1.52199994772673E-03,
            1.77199998870492E-03,
            1.55100005213171E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            3.01699992269278E-03,
            3.43300006352365E-03,
            2.96199996955693E-03,
            3.42600001022220E-03,
            2.99800001084805E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            1.38699996750802E-03,
            1.39300001319498E-03,
            1.38499995227903E-03,
            1.38200004585087E-03,
            1.43199996091425E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            7.77000002563000E-03,
            7.74799985811114E-03,
            8.85699968785048E-03,
            7.85600021481514E-03,
            7.91000016033649E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 48,
      "allocated": " 182789680",
      "allocs": 6000080,
      "reallocs": 0,
      "frees": 6000075
    },
    {
      "name": "Hashed Indef-Indef Unbounded",
      "category": "StrStr Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.40279994904995E-02,
            3.15070003271103E-02,
            2.51650009304285E-02,
            2.50410009175539E-02,
            2.52930000424385E-02
          ],
          "group": true,
          "allocated": " 31424852",
          "allocs": 400009,
          "reallocs": 0,
          "frees": 8
        },
        "copy": {
          "duration": [
            1.69099997729063E-02,
            1.65979992598295E-02,
            1.66950002312660E-02,
            1.68890003114939E-02,
            1.66369993239641E-02
          ],
          "allocated": " 24958668",
          "allocs": 400001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            2.55000009201467E-03,
            2.83199991099536E-03,
            2.79899989254773E-03,
            2.83299991860986E-03,
            2.93399998918176E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            2.41399998776615E-03,
            2.44199996814132E-03,
            2.49000010080636E-03,
            2.68099992536008E-03,
            2.83199991099536E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.32900003902614E-03,
            2.83099990338087E-03,
            2.71299993619323E-03,
            2.40899994969368E-03,
            2.63800006359816E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            9.61999990977347E-04,
            9.60999983362854E-04,
            9.39999998081475E-04,
            9.39999998081475E-04,
            9.44999977946281E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            1.41820004209876E-02,
            1.33840003982186E-02,
            1.40779996290803E-02,
            1.32550001144409E-02,
            1.38779999688268E-02
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 281917640",
      "allocs": 4000055,
      "reallocs": 0,
      "frees": 4000050
    },
    {
      "name": "Hashed Linear Probing Indef-Indef Unbounded",
      "category": "StrStr Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.47380007058382E-02,
            2.46610008180141E-02,
            2.39240005612373E-02,
            2.42819990962744E-02,
            2.42069996893406E-02
          ],
          "group": true,
          "allocated": " 31424852",
          "allocs": 400009,
          "reallocs": 0,
          "frees": 8
        },
        "copy": {
          "duration": [
            1.74230001866817E-02,
            1.64819993078709E-02,
            1.69879999011755E-02,
            1.64769999682903E-02,
            1.69450007379055E-02
          ],
          "allocated": " 24958668",
          "allocs": 400001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            2.88600008934736E-03,
            3.38799995370209E-03,
            2.79799988493323E-03,
            3.29899997450411E-03,
            2.85400007851422E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            2.39700009115040E-03,
            2.72600003518164E-03,
            2.40399991162121E-03,
            2.41399998776615E-03,
            2.40099988877773E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            2.36999988555908E-03,
            2.37099989317358E-03,
            2.29199999012053E-03,
            2.34499992802739E-03,
            2.35199998132885E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            9.41000005695969E-04,
            9.60999983362854E-04,
            9.61999990977347E-04,
            9.39999998081475E-04,
            9.44000028539449E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            1.43839996308088E-02,
            1.34260002523661E-02,
            1.43120000138879E-02,
            1.34699996560812E-02,
            1.40699995681643E-02
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 281917640",
      "allocs": 4000055,
      "reallocs": 0,
      "frees": 4000050
    },
    {
      "name": "Limited Hashed Indef_SPARK-Indef_SPARK Unbounded_SPARK",
      "category": "StrStr Map",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            2.46089994907379E-02,
            2.46479995548725E-02,
            2.41470001637936E-02,
            2.45760008692741E-02,
            2.42359992116690E-02
          ],
          "group": true,
          "allocated": " 31424852",
          "allocs": 400009,
          "reallocs": 0,
          "frees": 8
        },
        "copy": {
          "duration": [
            1.65839996188879E-02,
            1.63599997758865E-02,
            1.64349991828203E-02,
            1.62170007824898E-02,
            1.64640005677938E-02
          ],
          "allocated": " 24958668",
          "allocs": 400001,
          "reallocs": 0,
          "frees": 0
        },
        "cursor loop": {
          "duration": [
            5.47299999743700E-03,
            5.59299997985363E-03,
            5.87099976837635E-03,
            5.78100001439452E-03,
            5.79900015145540E-03
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "for-in/of loop": {
          "duration": [
            4.72800014540553E-03,
            4.67099994421005E-03,
            4.70599997788668E-03,
            4.61999978870153E-03,
            4.41800011321902E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "count_if": {
          "duration": [
            4.27300017327070E-03,
            4.35800012201071E-03,
            4.41899988800287E-03,
            4.40699979662895E-03,
            4.56999987363815E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "indexed": {
          "duration": [
            4.48800018057227E-03,
            4.49599977582693E-03,
            4.49099997058511E-03,
            4.49799979105592E-03,
            4.50100004673004E-03
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "find": {
          "duration": [
            1.78289990872145E-02,
            1.77769996225834E-02,
            1.79660003632307E-02,
            1.78520008921623E-02,
            1.81019995361567E-02
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 32,
      "allocated": " 281917600",
      "allocs": 4000050,
      "reallocs": 0,
      "frees": 4000050
    },
    {
      "name": "C++ Boost",
      "category": "Graph",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            9.25599969923496E-03,
            1.12950000911951E-02,
            1.16990003734827E-02,
            1.19850002229214E-02,
            1.17290001362562E-02
          ],
          "group": true,
          "allocated": " 25599929",
          "allocs": 599999,
          "reallocs": 0,
          "frees": 600002
        },
        "dfs, no visitor": {
          "duration": [
            9.74200014024973E-03,
            9.49500035494566E-03,
            9.02399979531765E-03,
            9.05099976807833E-03,
            9.20899957418442E-03
          ],
          "group": true,
          "allocated": " 38548696",
          "allocs": 21,
          "reallocs": 0,
          "frees": 21
        },
        "dfs, visitor": {
          "duration": [
          ]
        },
        "dfs-recursive, visitor": {
          "duration": [
          ]
        },
        "is_acyclic": {
          "duration": [
          ]
        },
        "scc": {
          "duration": [
            7.80100002884865E-03,
            7.94399995356798E-03,
            7.60299991816282E-03,
            7.53200007602572E-03,
            7.49599980190396E-03
          ],
          "group": true,
          "allocated": " 44231096",
          "allocs": 3166,
          "reallocs": 0,
          "frees": 3163
        }
      },
      "size": 56,
      "allocated": " 541898605",
      "allocs": 3015930,
      "reallocs": 0,
      "frees": 3015930
    },
    {
      "name": "custom graph",
      "category": "Graph",
      "tests": {
        "dfs, no visitor": {
          "duration": [
            6.00999977905303E-04,
            5.62999979592860E-04,
            5.54000027477741E-04,
            6.24999986030161E-04,
            5.56999992113560E-04
          ],
          "group": true,
          "allocated": " 1600000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "dfs, visitor": {
          "duration": [
            5.56999992113560E-04,
            5.64999994821846E-04,
            5.54000027477741E-04,
            5.75000012759119E-04,
            5.54000027477741E-04
          ],
          "allocated": " 1600000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "dfs-recursive, visitor": {
          "duration": [
            5.31999976374209E-04,
            4.04999998863786E-04,
            3.58999997843057E-04,
            3.61999991582707E-04,
            3.53000010363758E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "size": 200000,
      "allocated": " 16000040",
      "allocs": 15,
      "reallocs": 0,
      "frees": 10
    },
    {
      "name": "adjacency list",
      "category": "Graph",
      "favorite": true,
      "tests": {
        "fill": {
          "duration": [
            4.93399985134602E-03,
            4.79499995708466E-03,
            4.80000022798777E-03,
            4.67400019988418E-03,
            4.85800020396709E-03
          ],
          "group": true,
          "allocated": " 14399968",
          "allocs": 400000,
          "reallocs": 0,
          "frees": 0
        },
        "dfs, no visitor": {
          "duration": [
            3.03000002168119E-03,
            2.87500000558794E-03,
            2.95799993909895E-03,
            3.10899992473423E-03,
            3.07499989867210E-03
          ],
          "group": true,
          "allocated": " 2600000",
          "allocs": 2,
          "reallocs": 0,
          "frees": 2
        },
        "is_acyclic": {
          "duration": [
            2.92199989780784E-03,
            2.95399990864098E-03,
            3.00700007937849E-03,
            2.87600001320243E-03,
            3.03200003691018E-03
          ],
          "allocated": " 2600000",
          "allocs": 2,
          "reallocs": 0,
          "frees": 2
        },
        "scc": {
          "duration": [
            3.93400015309453E-03,
            4.18299995362759E-03,
            3.82099999114871E-03,
            3.59299988485873E-03,
            3.54399997740984E-03
          ],
          "group": true,
          "allocated": " 4000016",
          "allocs": 5,
          "reallocs": 0,
          "frees": 3
        }
      },
      "size": 40,
      "allocated": " 207055696",
      "allocs": 2000202,
      "reallocs": 204,
      "frees": 2000176
    },
    {
      "name": "Standard Ada",
      "category": "Sorting",
      "favorite": true,
      "tests": {
        "random-vec-10000": {
          "duration": [
            6.07999972999096E-04
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "sorted-vec-10000": {
          "duration": [
            3.56000004103407E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "reversed-vec-10000": {
          "duration": [
            4.03999991249293E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "constant-vec-10000": {
          "duration": [
            1.86999997822568E-04
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "random-vec-1million": {
          "duration": [
            9.32800024747849E-02
          ],
          "group": true,
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "sorted-vec-1million": {
          "duration": [
            4.48409989476204E-02
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "reversed-vec-1million": {
          "duration": [
            5.09999990463257E-02
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        },
        "constant-vec-1million": {
          "duration": [
            2.54769995808601E-02
          ],
          "allocated": " 0",
          "allocs": 0,
          "reallocs": 0,
          "frees": 0
        }
      },
      "allocated": " 0",
      "allocs": 0,
      "reallocs": 0,
      "frees": 0
    },
    {
      "name": "quicksort",
      "category": "Sorting",
      "favorite": true,
      "tests": {
        "random-vec-10000": {
          "duration": [
            4.00999997509643E-04
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "sorted-vec-10000": {
          "duration": [
            5.60000007681083E-05
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "reversed-vec-10000": {
          "duration": [
            5.80000014451798E-05
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "constant-vec-10000": {
          "duration": [
            1.57999995280989E-04
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "random-vec-1million": {
          "duration": [
            5.74879981577396E-02
          ],
          "allocated": " 4000000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "sorted-vec-1million": {
          "duration": [
            8.09600017964840E-03
          ],
          "allocated": " 4000000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "reversed-vec-1million": {
          "duration": [
            8.45399964600801E-03
          ],
          "allocated": " 4000000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "constant-vec-1million": {
          "duration": [
            1.55769996345043E-02
          ],
          "allocated": " 4000000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        }
      },
      "allocated": " 16160000",
      "allocs": 8,
      "reallocs": 0,
      "frees": 8
    },
    {
      "name": "quicksort_pure",
      "category": "Sorting",
      "tests": {
        "random-vec-10000": {
          "duration": [
            4.67000005301088E-04
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "sorted-vec-10000": {
          "duration": [
            7.20000025467016E-05
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "reversed-vec-10000": {
          "duration": [
            7.40000032237731E-05
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "constant-vec-10000": {
          "duration": [
            9.20000020414591E-05
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "random-vec-1million": {
          "duration": [
            6.29620030522346E-02
          ],
          "allocated": " 4000000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "sorted-vec-1million": {
          "duration": [
            9.09299962222576E-03
          ],
          "allocated": " 4000000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "reversed-vec-1million": {
          "duration": [
            9.19399969279766E-03
          ],
          "allocated": " 4000000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "constant-vec-1million": {
          "duration": [
            1.16929998621345E-02
          ],
          "allocated": " 4000000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        }
      },
      "allocated": " 16160000",
      "allocs": 8,
      "reallocs": 0,
      "frees": 8
    },
    {
      "name": "insertion-sort",
      "category": "Sorting",
      "tests": {
        "random-vec-10000": {
          "duration": [
            2.66459994018078E-02
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "sorted-vec-10000": {
          "duration": [
            7.00000009601354E-06
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "reversed-vec-10000": {
          "duration": [
            5.24829998612404E-02
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "constant-vec-10000": {
          "duration": [
            5.26040010154247E-02
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        }
      },
      "allocated": " 160000",
      "allocs": 4,
      "reallocs": 0,
      "frees": 4
    },
    {
      "name": "shell-sort",
      "category": "Sorting",
      "tests": {
        "random-vec-10000": {
          "duration": [
            5.76000020373613E-04
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "sorted-vec-10000": {
          "duration": [
            4.60000010207295E-05
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "reversed-vec-10000": {
          "duration": [
            1.25000005937181E-04
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "constant-vec-10000": {
          "duration": [
            7.54679962992668E-02
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        }
      },
      "allocated": " 160000",
      "allocs": 4,
      "reallocs": 0,
      "frees": 4
    },
    {
      "name": "shell2-sort",
      "category": "Sorting",
      "tests": {
        "random-vec-10000": {
          "duration": [
            5.15000021550804E-04
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "sorted-vec-10000": {
          "duration": [
            3.60000012733508E-05
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "reversed-vec-10000": {
          "duration": [
            8.80000006873161E-05
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        },
        "constant-vec-10000": {
          "duration": [
            6.29639998078346E-02
          ],
          "allocated": " 40000",
          "allocs": 1,
          "reallocs": 0,
          "frees": 1
        }
      },
      "allocated": " 160000",
      "allocs": 4,
      "reallocs": 0,
      "frees": 4
    }
  ]
};
