       identification division.
       program-id. mandelbrotset.
      *>**************************************************************** 
      *> Display the Mandelbrot set generator, largely inpired by(c)
      *> 2015 Mike Harris (free software released under gpl).
      *>****************************************************************
       data division.
       working-storage section.
       01 resolutionx          constant 240.
       01 resolutiony          constant 100.
       01 realplanemin         constant -2.5.
       01 realplanemax         constant 0.8.
       01 imaginaryplanemin    constant -1.25.
       01 imaginaryplanemax    constant 1.25.
       01 proportionalx        pic s99v9(16) usage comp-5 value zeros.
       01 proportionaly        pic s99v9(16) usage comp-5 value zeros.
       01 iterationsmax        constant 60.
       01 threshold            constant 10000.
       
       01 screenx              pic 999 usage comp-5.
       01 screeny              pic 999 usage comp-5.
       01 mathplanex           pic s99v9(16) usage comp-5.
       01 mathplaney           pic s99v9(16) usage comp-5.
       
       01 pointx               pic s9(7)v9(8) usage comp-5.
       01 pointy               pic s9(7)v9(8) usage comp-5.
       01 xsquared             pic s9(10)v9(8) usage comp-5.
       01 ysquared             pic s9(10)v9(8) usage comp-5.
       01 iteration            pic 999 value zero.
       01 tempvar              pic s9(5)v9(8) usage comp-5.
       
       procedure division.
       
       compute proportionalx = (realplanemax - realplanemin) /
           (resolutionx - 1)
       compute proportionaly = (imaginaryplanemax - imaginaryplanemin) /
           (resolutiony - 1)
       
       perform varying screeny from 0 by 1 until screeny is equal to
           resolutiony
       
           compute mathplaney = imaginaryplanemin +
               (proportionaly * screeny)
       
           perform varying screenx from 0 by 1 until screenx is equal to
               resolutionx
       
               compute mathplanex = realplanemin +
                   (proportionalx * screenx)
       
               move zero to pointx
               move zero to pointy
               multiply pointx by pointx giving xsquared
               multiply pointy by pointy giving ysquared
       
               perform with test after varying iteration from 0 by 1
                   until iteration >= iterationsmax or
                         xsquared + ysquared >= threshold
                     compute tempvar = xsquared - ysquared + mathplanex
                     compute pointy = 2 * pointx * pointy + mathplaney
                     move tempvar to pointx
                     compute xsquared = pointx * pointx
                     compute ysquared = pointy * pointy
               end-perform
       
               if iteration is equal to iterationsmax
                   display "*" with no advancing
               else
                   display " " with no advancing
               end-if
       
           end-perform
       
           display " "
       
       end-perform
       
       stop run.
       
       end program mandelbrotset.