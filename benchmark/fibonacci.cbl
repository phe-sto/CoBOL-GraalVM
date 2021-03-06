
      *>**************************************************************** 
      *>Author: Christophe Brun
      *>Date: 06/03/2021
      *>Purpose: Compute Fibonacci Numbers
      *>Tectonics: cobc
      *>**************************************************************** 
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FIB.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01  N0             BINARY-C-LONG VALUE 0.
       01  N1             BINARY-C-LONG VALUE 1.
       01  SWAP           BINARY-C-LONG VALUE 1.
       01  RESULT         PIC Z(20)9.
       01  I              BINARY-C-LONG VALUE 0.
       PROCEDURE DIVISION.
       MOVE N0 TO RESULT.
       DISPLAY RESULT.
       MOVE N1 TO RESULT.
       DISPLAY RESULT.
       PERFORM VARYING I FROM 1 BY 1 UNTIL I = 15
               ADD N0 TO N1 GIVING SWAP
               MOVE N1 TO N0
               MOVE SWAP TO N1
               MOVE SWAP TO RESULT
               DISPLAY RESULT
       END-PERFORM.
      *>  END THE PROGRAM WITH A MESSAGE
       DISPLAY "THE PROGRAM HAS COMPLETED AND WILL NOW END".
       END PROGRAM FIB.
       GOBACK.