       IDENTIFICATION DIVISION.
       PROGRAM-ID. FACTORIAL.
      ******************************************************************
      * Cobol factorial till 16 largely inspired
      * from http://progopedia.com/example/factorial/340/
      ******************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.

         77 fact pic 9(15) comp.
         77 n pic 99.
         77 i pic 99.
         77 ist pic XX.
         77 factst pic X(18).

       PROCEDURE DIVISION.
         move 16 to n
         move 0 to i
         move 1 to fact
         perform until i greater than n
           move i to ist
           move fact to factst
           display ist "! = " factst
           add 1 to i
           multiply i by fact
             on size error display "value too big"
           end-multiply
         end-perform.
         stop run.