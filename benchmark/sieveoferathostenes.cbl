       identification division.
       program-id. sieveoferathosthenes.
      ******************************************************************
      * Cobol sieves of Erathosthenes inspired by Peter Dibble 
      ******************************************************************
       environment division.
       data division.
       working-storage section.
       77  prime                          pic 9(5) comp.
       77  prime-count                    pic 9(5) comp.
       77  i                              pic 9(4) comp.
       77  k                              pic 9(5) comp.
       01  bit-array.
            03 flag occurs 8191 times       pic 9 comp.
       procedure division.
       start-up.
            display "ten iterations".
            perform sieve through sieve-end.
            display "primes found: ", prime-count.
            stop run.
       sieve.
            move zero to prime-count.
            move 1 to i.
            perform init-bits 8191 times.
            move 1 to i.
            perform scan-for-primes through end-scan-for-primes
                 8191 times.
       sieve-end.
            exit.
       init-bits.
            move 1 to flag (i).
            add 1 to i.
       end-init-bits.
            exit.
       scan-for-primes.
            if flag (i) = 0
                 then
                      go to not-prime.
            add i i 1 giving prime.
            display prime
            add i prime giving k.
            perform strikout until k > 8191.
            add 1 to prime-count.
       not-prime.
            add 1 to i.
       end-scan-for-primes.
            exit.
       strikout.
            move 0 to flag (k).
            add prime to k.
       end-program.
            exit.