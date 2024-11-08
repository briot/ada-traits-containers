Naming and Coding Conventions
=============================

.. highlight:: ada

This section describes some of the conventions and namings used throughout this
library. As much as possible, all containers follow these conventions for
consistency.

  ``Traits``

     This suffix is added to package names that only have formal parameters,
     but provide no new capability on their own. They are used to encapsulate
     multiple related pieces of information, so that other packages can take a
     single instance of such a traits package, instead of a very large set of
     parameters. Although they require extra instantiations in the application
     code, they simplify the overall API.

     examples: ``GAL.Elements.Traits``,
     ``GAL.Cursors.Constant_Forward_Traits``

  ``_Type``

     This suffix is used for formal type parameters of generic packages.  This
     follows the convention already used by the standard Ada container
     packages.  In addition, we provide renamings for these parameters inside
     the generic packages, as in::

          generic
             type Element_Type (<>) is limited private;
          package Traits is
             subtype Element is Element_Type;
          end Traits;

     The renamings are necessary because of the visibility defined by the
     standard. Basically, the compiler hides the declaration of
     ``Element_Type`` when it is known statically and there are therefore
     other ways to access it. For instance, in the following code, the
     declaration of ``A`` is illegal::

          with Cursors;
          package body Pkg is
             package Int is new Traits (Integer);
          
             A : Int.Element_Type;   --  Illegal
             B : Int.Element;
          begin
             null;
          end Pkg;

     For this reason, the subtype declaration ensures that the formal type is
     always illegal. In general, the code should use the subtype rather than
     the formal type. See also the Ada Reference Manual (12.7 10/2) for
     more information.

  Inlining

     A lot of the subprograms in this library are inlined. This is of course
     for performance reasons, since even through a generic instance, the
     compiler is able to completely bypass the cost of calling the subprogram.
     This results in very significant speed up when iterating over large
     containers. This is also an improvement when a function returns an
     unconstrained type (like the various ``Identity`` functions that just
     return their parameter).

  Expression functions

     In addition to being marked inline, a number of functions are written as
     expression functinos. When this function needs to access the private part
     of a package, we generally have a public spec, marked inline, and then in
     the private part the expression function itself.

     There doesn't seem to be a benefit, performance-wise, but this keeps the
     code slightly shorter so has been adopted as a convention.

.. _tagged_and_controlled_types:

  Tagged and controlled types

     All containers provided in this package are implemented as tagged types.
     One of the reasons to do so is to be able to use the dot notation to call
     primitive operations (as in ``Vec.Append`` for instance.

     The more important reason is that most applications will want those
     containers to be controlled types, so that memory is automatically
     released when the container is no longer used.

     Containers are not systematically controlled though, since this is not
     supported for the SPARK language. In such a case, the containers will
     instead extend the ``GAL.Limited_Base``, which makes them limited
     types.
