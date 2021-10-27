pragma Ada_2012;
with System.Storage_Pools;  use System.Storage_Pools;
with System.Pool_Global;

package GAL.Pools with SPARK_Mode is

   generic
      type Storage_Pool is new Root_Storage_Pool with private;
      Pool : in out Storage_Pool;
   package Pools with SPARK_Mode => Off is
   end Pools;
   --  This package provides a way to pass storage pools as a generic parameter
   --  to other packages.
   --  Such storage pools are limited types, and thus need to be passed as
   --  access types. Furthermore, to avoid the need for dynamic dispatching, we
   --  also pass the type of the storage pool itself, rather than use a class
   --  wide type.

   package Global_Pool is new Pools
      (Storage_Pool  => System.Pool_Global.Unbounded_No_Reclaim_Pool,
       Pool => System.Pool_Global.Global_Pool_Object);
   --  The default storage pool used by the GNAT runtime (a direct use of
   --  malloc and free).

end GAL.Pools;
