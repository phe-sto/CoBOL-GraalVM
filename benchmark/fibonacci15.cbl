       identification division.
       program-id. fibonacci15.
      *>****************************************************************
      *> Display the first 15 numbers of the Fibonnaci sequence. This
      *> program was largely inspired by Bryan Flood.
      *>****************************************************************
       data division.
       working-storage section.

         77 fib1 pic 999.
         77 fib2 pic 999.
         77 fib3 pic 999.
         77 i pic 99.
         77 fibst pic xxx.
         77 res pic x(64).

       procedure division.
         move 0 to i
         move 0 to fib1
         move 1 to fib2
         move " " to res
         perform until i greater than 15
           add fib1 to fib2 giving fib3
           move fib2 to fib1
           move fib3 to fib2
           move fib1 to fibst
           string res   delimited by space
                  fibst delimited by size
                  ","   delimited by size into res
           add 1 to i
         end-perform.
         display res "..."
         stop run.