C> @file
C> @author WOOLLEN @date 1994-01-06
      
C> THIS SUBROUTINE COPIES AN ENTIRE BUFR FILE FROM LOGICAL
C>   UNIT LUNIN TO LOGICAL UNIT LUNOT.
C>
C> PROGRAM HISTORY LOG:
C> 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C> 1998-07-08  J. WOOLLEN -- REPLACED CALL TO CRAY LIBRARY ROUTINE
C>                           "ABORT" WITH CALL TO NEW INTERNAL BUFRLIB
C>                           ROUTINE "BORT"
C> 2000-09-19  J. WOOLLEN -- MAXIMUM MESSAGE LENGTH INCREASED FROM
C>                           10,000 TO 20,000 BYTES
C> 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C>                           INTERDEPENDENCIES
C> 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED
C>                           DOCUMENTATION (INCLUDING HISTORY); OUTPUTS
C>                           MORE COMPLETE DIAGNOSTIC INFO WHEN ROUTINE
C>                           TERMINATES ABNORMALLY
C> 2004-08-09  J. ATOR    -- MAXIMUM MESSAGE LENGTH INCREASED FROM
C>                           20,000 TO 50,000 BYTES
C> 2005-11-29  J. ATOR    -- USE RDMSGW AND NMWRD
C> 2012-09-15  J. WOOLLEN -- CONVERT TO C LANGUAGE I/O INTERFACE
C>                           USE READMG AND COPYMG TO COPY FILE
C> 2014-12-10  J. ATOR    -- USE MODULES INSTEAD OF COMMON BLOCKS
C>
C> USAGE:    CALL COPYBF (LUNIN, LUNOT)
C>   INPUT ARGUMENT LIST:
C>     LUNIN    - INTEGER: FORTRAN LOGICAL UNIT NUMBER FOR INPUT BUFR
C>                FILE
C>     LUNOT    - INTEGER: FORTRAN LOGICAL UNIT NUMBER FOR OUTPUT BUFR
C>                FILE
C>
C>   INPUT FILES:
C>     UNIT "LUNIN" - BUFR FILE
C>
C>   OUTPUT FILES:
C>     UNIT "LUNOT" - BUFR FILE
C>
C> REMARKS:
C>    THIS ROUTINE CALLS:        BORT     CLOSBF   IUPBS01  MSGWRT
C>                               OPENBF   RDMSGW   STATUS   WRDLEN
C>    THIS ROUTINE IS CALLED BY: None
C>                               Normally called only by application
C>                               programs.
C>
      SUBROUTINE COPYBF(LUNIN,LUNOT)

      USE MODA_MGWA

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C  CALL SUBROUTINE WRDLEN TO INITIALIZE SOME IMPORTANT INFORMATION
C  ABOUT THE LOCAL MACHINE (IN CASE IT HAS NOT YET BEEN CALLED)
C  ---------------------------------------------------------------

      CALL WRDLEN

C  CHECK BUFR FILE STATUSES
C  ------------------------

      CALL STATUS(LUNIN,LUN,IL,IM)
      IF(IL.NE.0) GOTO 900
      CALL STATUS(LUNOT,LUN,IL,IM)
      IF(IL.NE.0) GOTO 901

C  CONNECT THE FILES FOR READING/WRITING TO THE C-I-O INTERFACE 
C  ------------------------------------------------------------

      CALL OPENBF(LUNIN,'INX',LUNIN)
      CALL OPENBF(LUNOT,'OUX',LUNIN)

C  READ AND COPY A BUFR FILE ON UNIT LUNIN TO UNIT LUNOT
C  -----------------------------------------------------

1     CALL RDMSGW(LUNIN,MGWA,IER)
      IF(IER.EQ.0) THEN      
         CALL MSGWRT(LUNOT,MGWA,IUPBS01(MGWA,'LENM'))
         GOTO 1
      ENDIF

C  FREE UP THE FILE CONNECTIONS FOR THE TWO FILES
C  ----------------------------------------------

      CALL CLOSBF(LUNIN)
      CALL CLOSBF(LUNOT) 

C  EXITS
C  -----

      RETURN
900   CALL BORT
     . ('BUFRLIB: COPYBF - INPUT BUFR FILE IS OPEN, IT MUST BE CLOSED')
901   CALL BORT
     . ('BUFRLIB: COPYBF - OUTPUT BUFR FILE IS OPEN, IT MUST BE CLOSED')
      END
