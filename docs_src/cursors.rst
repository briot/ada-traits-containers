Vectors and Properties
======================

.. highlight:: ada

In a lot of libraries, traversing a container and retrieving elements is
done via a unique type (named ``Cursor`` in the standard Ada containers for
instance).

Tying those two notions of traversing and retrieving is however somewhat
limiting, and forces code duplication.

Cursors
-------

There are multiple ways to access the elements of a containers. Those depend
on both the type of the container (not all containers can provide all kinds
of iteration), as well as the need of algorithms.

All containers provide cursors, which you can use to traverse the container.

All the containers provided in this library have operations to retrieve the
element pointed to by a cursor. Those are generally called ``Element``.

Things are a bit more complex in the case of maps, since you might want to
retrieve either the key pointed to by the cursor, or the actual element. So
two operations are provided (``As_Element`` and ``As_Key``).

Cursor traits
-------------

The purpose of this library is to write reusable algorithms, which can be
used with any kind of container, even those not provided in this library.

For this, the algorithms need general notions like "give me all elements in
the container". As you might have guessed, this is provided by the use of
one of the traits packages defined in :file:`conts-cursors.ads`:

  ``Forward_Cursors``

      are the least capable. They are mostly meant to iterate all elements
      of the container in a container-defined order, from beginning to end,
      with no possibility to move backward. Algorithms should use those if
      all they need it to look at each element of the container at most
      once.

   ``Bidirectional_Cursors``

      allow traversing in both directions (forward or backward). They are
      slightly more flexible that forward_cursors. They are often implemented
      by all containers that store their data in memory. But they would not
      be applicable when accessing an element also removes it from the
      container, like reading from a socket for instance.

   ``Random_Access_Cursors``

      let users access elements in any direction and at any place within the
      container. Those cursors generally take the form of an index, so are
      easy to manipulate and create by application. They apply to array-like
      containers where the position of an element in memory can easily be
      computed.

Note that it would often be possible to emulate a random_access cursor from a
forward_cursor (you would have to always start from the first element in the
container, and move forward n times). This is however highly inefficient.

All containers provide one or more of these traits packages, depending on their
built-in capabilities and whether they are able to execute the corresponding
cursor operations in constant time (so a list does not provide a random_access
cursor for instance).

Property maps
-------------

The cursor traits packages we described above are only about moving cursors.
They do not provide any way to retrieve the element associated with the cursor,
or to modify it.

This retrieval is left to an orthogonal set of traits packages, named property
maps.

Say we were creating an algorithm that executes a callback for each element
in any container. It would need to iterate, so would receive an instance
of a ``Forward_Cursors`` traits package. It then needs to be able to retrieve
the element before it can execute the callback.

But what element are we talking about ? Is this the element_type ? or in the
case of a map is it the key_type ? Or maybe some other value computed
indirectly from one of those ? Or perhaps by looking into another container
in parallel ?

Instead of having a lot of versions of ``Forward_Cursors`` that return each
of the possibility we describe, we instead pass a second parameter to our
algorithm, which receives a cursors and returns the element. The simplest
approach would be to pass an access-to-subprogram, for instance::

    generic
       with package Elements is new Element_Traits (<>);
       with package Cursors is new Conts.Cursors.Forward_Cursors (<>);
       with function Get
          (C : Cursors.Container; C : Cursors.Cursor_Type)
          return Element_Type;
    procedure My_Algorithm (C : Cursors.Container);

This is the usual profile we would use when working with standard Ada
containers. However, this assumes that the container and the cursor are
enough to retrieve the element we are interested in (likely true in a large
majority of cases, but not all).

So we would instead write it as::

    generic
       with package Cursors is new Conts.Cursors.Forward_Cursors (<>);
       with package Maps is new Conts.Properties.Read_Only_Maps
          (Key_Type => Cursors.Cursor_Type, others => <>);
    procedure My_Algorithm
       (C   : Cursors.Container;
        Map : Maps.Map_Type);

So now the algorithm would iterate with cursors, then ``Get`` from the
map and the cursor the element to use (which is visible nowhere in the
spec, so left entirely to the user). The same algorithm can be used to
retrieve keys from a map, elements from a map, or a record containing
both for instance. It can also be used to retrieve data not stored in
the container itself, only stored in a separate map object.

In a large majority of cases, the container itself acts as the map, so
the library would also provide a simpler version of the algorithm
as::

    generic
       with package Cursors is new Conts.Cursors.Forward_Cursors (<>);
       with package Maps is new Conts.Properties.Read_Only_Maps
          (Key_Type => Cursors.Cursor_Type,
           Map_Type => Cursors.Container,
           others => <>);
    procedure My_Algorithm_Internal (C : Cursors.Container);

The true power of those properties maps come into play when manipulating
graphs. Algorithms often need to associate extra temporary data with the
vertices of the graph (like a color, to know whether a vertex was already
visited for instance).

We could of course store that color directly in the vertices. But then,
what happens if we run the algorithm twice concurrently, they would both
see the color set by the other instance of the algorithm. Or what happens
when another algorithm comes along and needs to store a distance. Do we
have to modify the definition of vertices ?

Also what happens if the graph is actually some data structure we do not
control and cannot change because it is defined somewhere in user code,
and only used via traits packages ?

In those cases, we use property maps as external objects, which exist
for instance in each running instance of the algorithm. That way they
do not interfere with one another. They can store additional data if they
so wish. This of course comes at a minor extra performance cost since we
need to look up those properties in a separate container.
