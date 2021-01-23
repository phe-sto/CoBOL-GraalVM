       identification division.
       program-id. recursivefactorial.
      *>****************************************************************
      *> Calculate the factorial of number from 0 to 33 and dispaly it.
      *>****************************************************************
       environment division.
       data division.
       working-storage section.
       01 numb pic 9(4) value 33.
       01 fact pic 9(38) value 0.
       local-storage section.
       01 num pic 9(4).
       procedure division.
       move numb to num.
           if numb = 0
               move 1 to fact
           else
               subtract 1 from numb
               call "recursivefactorial"
               multiply num by fact
           end-if.
       display num "! = " fact.
       goback.
       end program recursivefactorial.