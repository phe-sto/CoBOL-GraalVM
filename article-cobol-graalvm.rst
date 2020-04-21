Compile and execute CoBOL with GraalVM and GnuCOBOL
===================================================

==============================================
GraalVM the polyglot Virtual Machine by Oracle
==============================================

The GraalVM supports various languages, Java, JavaScript, Ruby, Python, R, WebAssembly, C/C++[1]_.
In another document[2]_ Oracle explains the VM can be an interpreter from native codes using compiler called a Low-Level Virtual Machine (LLVM). Those native code being C, C++, FORTRAN, Rust, COBOL, and Go.
It is now getting even more exiting! As a former mainframe/CoBOL developer, I would like to see those billion lines of CoBOL modernized in a more open environments.

===================
CoBOL modernization
===================

This article's goal is to explain how the GraalVM could be running CoBOL on pretty much any platform. IT departments, mainly in financial institutions and governments are desperately seeking CoBOL and mainframe experts
but the lack of training course and the repelling Z/OS TSO environment are not encouraging vocations.
Another major issue with those technologies resides in the costs of mainframe licenses. I think, hope, both could be solved developing CoBOL in modern environments.
In case you don't know, rewriting the code and just shutting down the mainframes is not an option, see this great article_.

--------
GnuCOBOL
--------

Using Flex and Bison for lexical parsing, GnuCOBOL_ can transpile CoBOL to C. It can directly compile CoBOL using your platform toolchain but it is not our goal here, as we want to execute it with GraalVM.
There are many CoBOL compilers out there. This one implement major part of CoBOL 1985, 2002 and several extensions of other compilers.
This compiler and it's dependency libcob can easily be installed using synaptic package manager command ``apt-get install open-cobol``. Open CoBOL is the former name of GnuCOBOL, it can be checked that way::

   chrichri@chrichri-debian:~$ cobc -version
   cobc (GnuCOBOL) 2.2.0
   Copyright (C) 2017 Free Software Foundation, Inc.
   License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
   This is free software; see the source for copying conditions.  There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
   Written by Keisuke Nishida, Roger While, Ron Norman, Simon Sobisch, Edward Hart
   Built     Jul 17 2018 20:29:40
   Packaged  Sep 06 2017 18:48:43 UTC
   C version "7.3.0"

----------------------
Native code in GraalVM
----------------------

If not already installed, GraalVM installation_ is described on their website. Executing native code require a GraalVM package call llvm-toolchain_.
On my system I already have ``clang`` and ``lli`` so I created symlinks ``clang-gu`` and ``lli-gu``. I prefer to create a symlink with a different name for ``clang`` and ``lli`` executables rather that extending the path which will required the use of ``update-alternatives``.
A great medium_ post from an Oracle collaborator detail the GraalVM llvm-toolchain.

--------------------------------------------
Compiling CoBOL C intermediate and execution
--------------------------------------------

Let use the Mandelbrot set implemented in CoBOL in our example, see ``mandelbrot.cob``::

          identification division.
          program-id. MandelbrotSet.
          
          data division.
          working-storage section.
          01 ResolutionX             constant 240.
          01 ResolutionY             constant 100.
          01 RealPlaneMin            constant -2.5.
          01 RealPlaneMax            constant 0.8.
          01 ImaginaryPlaneMin    constant -1.25.
          01 ImaginaryPlaneMax    constant 1.25.
          01 ProportionalX           pic S99V9(16) usage comp-5 value zeros.
          01 ProportionalY           pic S99V9(16) usage comp-5 value zeros.
          01 IterationsMax           constant 60.
          01 Threshold               constant 10000.
          
          01 ScreenX                    pic 999 usage comp-5.
          01 ScreenY                    pic 999 usage comp-5.
          01 MathPlaneX              pic S99V9(16) usage comp-5.
          01 MathPlaneY              pic S99V9(16) usage comp-5.
          
          01 PointX                     pic S9(7)V9(8) usage comp-5.
          01 PointY                     pic S9(7)V9(8) usage comp-5.
          01 XSquared                pic S9(10)V9(8) usage comp-5.
          01 YSquared                pic S9(10)V9(8) usage comp-5.
          01 Iteration               pic 999 value zero.
          01 TempVar                    pic S9(5)V9(8) usage comp-5.
          
          procedure division.
          
          compute ProportionalX = (RealPlaneMax - RealPlaneMin) /
              (ResolutionX - 1)
          compute ProportionalY = (ImaginaryPlaneMax - ImaginaryPlaneMin) /
              (ResolutionY - 1)
          
          perform varying ScreenY from 0 by 1 until ScreenY is equal to
              ResolutionY
          
              compute MathPlaneY = ImaginaryPlaneMin +
                     (ProportionalY * ScreenY)
          
              perform varying ScreenX from 0 by 1 until ScreenX is equal to
                     ResolutionX
          
                     compute MathPlaneX = RealPlaneMin +
                         (ProportionalX * ScreenX)
          
                     move zero to PointX
                     move zero to PointY
                     multiply PointX by PointX giving XSquared
                     multiply PointY by PointY giving YSquared
          
                     perform with test after varying Iteration from 0 by 1
                         until Iteration >= IterationsMax or
                                  XSquared + YSquared >= Threshold
                              compute TempVar = XSquared - YSquared + MathPlaneX
                              compute PointY = 2 * PointX * PointY + MathPlaneY
                              move TempVar to PointX
                              compute XSquared = PointX * PointX
                              compute YSquared = PointY * PointY
                     end-perform
          
                     if Iteration is equal to IterationsMax
                         display "*" with no advancing
                     else
                         display " " with no advancing
                     end-if
              end-perform
          
              display " "
          
          end-perform
          stop run.
          end program MandelbrotSet.
          

^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Producing the C intermediate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using GnuCOBOL, the C intermediate can be produced with the following command::

   cobc -C -x mandelbrot.cob

The project should look like::

   .
   ├── mandelbrot.c
   ├── mandelbrot.c.h
   ├── mandelbrot.c.l.h
   └── mandelbrot.cob

^^^^^^^^^^^^^^^^^^^^^^^^^^^
Compiling C to LLVM bytcode
^^^^^^^^^^^^^^^^^^^^^^^^^^^

One point not completely clear from their documentation, is the difference with the regular Clang.

.. WARNING::

   On contrary to regular Clang, Graal one compile directly to LLVM bytecode without ``-emit-llvm``. Do not mix regular LLVM toolchain with GraalVM toolchain in general.

Don't forget to include the ``libcob`` dependency with ``-lcob``, our compiling command is::

   clang-gu mandelbrot.c -o bin/mandelbrot-graal.bc -lcob


The project should look like::

   .
   ├── bin
   │   └── mandelbrot-graal.bc
   ├── mandelbrot.c
   ├── mandelbrot.c.h
   ├── mandelbrot.c.l.h
   └── mandelbrot.cob


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Execution in the LLVM interpreter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The LLVM interpreter ``lli`` command::

   lli-gu ./bin/mandelbrot-graal.bc
                                                                                                                                                               
Christophe Brun, https://www.papit.fr/

.. _article: https://thenewstack.io/cobol-everywhere-will-maintain/
.. _GnuCOBOL: https://open-cobol.sourceforge.io/
.. _installation: https://www.graalvm.org/docs/getting-started/
.. _llvm-toolchain: https://www.graalvm.org/docs/reference-manual/languages/llvm/#llvm-toolchain
.. _medium: https://medium.com/graalvm/graalvm-llvm-toolchain-f606f995bf

.. [1] https://www.graalvm.org/docs/why-graal/
.. [2] https://www.graalvm.org/uploads/graalvm-language-level-virtualization-oracle-tech-papers.pdf