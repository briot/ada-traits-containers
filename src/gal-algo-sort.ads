package GAL.Algo.Sort is

   pragma Pure;

   type Shell_Sort_Gaps is array (Natural range <>) of Integer;
   Ciura_Gaps : constant Shell_Sort_Gaps :=
     (1, 4, 10, 23, 57, 132, 301, 701);
   Sedgewick_Gaps : constant Shell_Sort_Gaps :=
     (1, 8, 23, 77, 281, 1073, 4193, 16577, 65921, 262913);
   --  Configuration for the shell sort algorithm

end GAL.Algo.Sort;
