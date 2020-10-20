C> @file
C> @author J @date 2009-07-09
      
C> THIS FUNCTION CHECKS WHETHER AT LEAST ONE "LONG" (I.E.
C>   GREATER THAN 8 BYTES) CHARACTER STRING EXISTS WITHIN THE INTERNAL
C>   DICTIONARY DEFINITION FOR THE TABLE A MESSAGE TYPE GIVEN BY SUBSET.
C>
C> PROGRAM HISTORY LOG:
C> 2009-07-09  J. ATOR    -- ORIGINAL AUTHOR
C> 2014-12-10  J. ATOR    -- USE MODULES INSTEAD OF COMMON BLOCKS
C>
C> USAGE:    LCMGDF (LUNIT, SUBSET)
C>   INPUT ARGUMENT LIST:
C>     LUNIT    - INTEGER: FORTRAN LOGICAL UNIT NUMBER ASSOCIATED WITH
C>                SUBSET DEFINITION
C>     SUBSET   - CHARACTER*8: TABLE A MNEMONIC FOR MESSAGE TYPE
C>
C>   OUTPUT ARGUMENT LIST:
C>     LCMGDF   - INTEGER: RETURN CODE INDICATING WHETHER SUBSET CONTAINS
C>                AT LEAST ONE "LONG" CHARACTER STRING IN ITS DEFINITION
C>                  0 - NO
C>                  1 - YES
C>
C> REMARKS:
C>    THIS ROUTINE CALLS:        BORT     NEMTBA   STATUS
C>    THIS ROUTINE IS CALLED BY: None
C>                               Normally called only by application
C>                               programs.
C>
      INTEGER FUNCTION LCMGDF(LUNIT,SUBSET)



      USE MODA_TABLES

      INCLUDE 'bufrlib.prm'

      CHARACTER*8  SUBSET

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C     Get LUN from LUNIT.

      CALL STATUS(LUNIT,LUN,IL,IM)
      IF (IL.EQ.0) GOTO 900
 
C     Confirm that SUBSET is defined for this logical unit.

      CALL NEMTBA(LUN,SUBSET,MTYP,MSBT,INOD)

C     Check if there's a long character string in the definition.

      NTE = ISC(INOD)-INOD

      DO I = 1, NTE
        IF ( (TYP(INOD+I).EQ.'CHR') .AND. (IBT(INOD+I).GT.64) ) THEN
          LCMGDF = 1
          RETURN
        ENDIF
      ENDDO

      LCMGDF = 0

      RETURN
900   CALL BORT('BUFRLIB: LCMGDF - INPUT BUFR FILE IS CLOSED, IT MUST'//
     . ' BE OPEN')
      END
