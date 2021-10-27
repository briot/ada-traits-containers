pragma Ada_2012;
with Ada.Numerics.Discrete_Random;

package GAL.Algo.Random with SPARK_Mode is

   --------------------
   -- Random numbers --
   --------------------

   generic
      type Discrete_Type is (<>);
      type Generator_Type is limited private;
      with procedure Random
         (Self : in out Generator_Type; Result : out Discrete_Type);
   package Uniform_Random_Traits is
      subtype Discrete is Discrete_Type;
      subtype Generator is Generator_Type;
      procedure Rand
         (Self : in out Generator; Result : out Discrete) renames Random;
   end Uniform_Random_Traits;
   --  Generates a uniformly distributed random number on the whole range of
   --  Discrete. This could a simple wrapper around Ada's standard facilities
   --  (see below for such a pre-made wrapper), or a custom implementation (for
   --  instance a reproducible sequence for use in some testsuites).
   --
   --  Random is implemented as a procedure, not a function, so that it is
   --  easier to use for proofs in the SPARK context.

   generic
      with package Random is new Uniform_Random_Traits (<>);
      Min, Max : Random.Discrete;
   procedure Ranged_Random
      (Self : in out Random.Generator; Result : out Random.Discrete)
      with Inline;
   --  Returns a random number in the range Min..Max
   --  This is optimized so that if this range is the full range for the
   --  discrete type, no additional test or operation is needed. Thus
   --  algorithms should take a Uniform_Random_Traits, and instantiate this
   --  function as needed.
   --  This is similar to the GNAT.Random package, but since the range is
   --  given by formal parameters, the compiler can optimize the code
   --  significantly more.

   generic
      type Discrete_Type is (<>);
   package Default_Random is
      package Ada_Random is new Ada.Numerics.Discrete_Random (Discrete_Type);

      subtype Generator is Ada_Random.Generator;
      procedure Reset (Gen : Generator) renames Ada_Random.Reset;
      procedure Reset (Gen : Generator; Initiator : Integer)
         renames Ada_Random.Reset;
      --  Used by applications, but not directly by this library, since
      --  algorithms always take an already initialized generator as parameter

      procedure Random (Gen : in out Generator; Result : out Discrete_Type)
         with Inline;
      --  Wrapper around Ada_Random.Random

      package Traits is new Uniform_Random_Traits
        (Discrete_Type  => Discrete_Type,
         Generator_Type => Generator,
         Random         => Random);
   end Default_Random;
   --  A default implementation of random numbers based on the standard Ada
   --  random number generator.

end GAL.Algo.Random;
