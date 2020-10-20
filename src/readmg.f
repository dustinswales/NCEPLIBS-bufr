C> @file
C> @author WOOLLEN @date 1994-01-06
      
C> THIS SUBROUTINE READS THE NEXT BUFR MESSAGE FROM LOGICAL
C>   UNIT NUMBER ABS(LUNXX) INTO AN INTERNAL MESSAGE BUFFER (I.E. ARRAY
C>   MBAY IN MODULE BITBUF).  ABS(LUNXX) SHOULD ALREADY BE OPENED
C>   FOR INPUT OPERATIONS.  IF LUNXX < 0, THEN A READ ERROR FROM
C>   ABS(LUNXX) IS TREATED THE SAME AS THE END-OF-FILE (EOF) CONDITION;
C>   OTHERWISE, BUFR ARCHIVE LIBRARY SUBROUTINE BORT IS NORMALLY CALLED
C>   IN SUCH SITUATIONS.  ANY DX DICTIONARY MESSAGES ENCOUNTERED WITHIN
C>   ABS(LUNXX) ARE AUTOMATICALLY PROCESSED AND STORED INTERNALLY, SO A
C>   SUCCESSFUL RETURN FROM THIS SUBROUTINE WILL ALWAYS RESULT IN A BUFR
C>   MESSAGE CONTAINING ACTUAL DATA VALUES.
C>
C> PROGRAM HISTORY LOG:
C> 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C> 1996-11-25  J. WOOLLEN -- MODIFIED TO EXIT GRACEFULLY WHEN THE BUFR
C>                           FILE IS POSITIONED AFTER AN "END-OF-FILE"
C> 1998-07-08  J. WOOLLEN -- REPLACED CALL TO CRAY LIBRARY ROUTINE
C>                           "ABORT" WITH CALL TO NEW INTERNAL BUFRLIB
C>                           ROUTINE "BORT"; MODIFIED TO MAKE Y2K
C>                           COMPLIANT
C> 1999-11-18  J. WOOLLEN -- THE NUMBER OF BUFR FILES WHICH CAN BE
C>                           OPENED AT ONE TIME INCREASED FROM 10 TO 32
C>                           (NECESSARY IN ORDER TO PROCESS MULTIPLE
C>                           BUFR FILES UNDER THE MPI); MODIFIED WITH
C>                           SEMANTIC ADJUSTMENTS TO AMELIORATE COMPILER
C>                           COMPLAINTS FROM LINUX BOXES (INCREASES
C>                           PORTABILITY)
C> 2000-09-19  J. WOOLLEN -- REMOVED MESSAGE DECODING LOGIC THAT HAD
C>                           BEEN REPLICATED IN THIS AND OTHER READ
C>                           ROUTINES AND CONSOLIDATED IT INTO A NEW
C>                           ROUTINE CKTABA, CALLED HERE, WHICH IS
C>                           ENHANCED TO ALLOW COMPRESSED AND STANDARD
C>                           BUFR MESSAGES TO BE READ; MAXIMUM MESSAGE
C>                           LENGTH INCREASED FROM 10,000 TO 20,000
C>                           BYTES
C> 2002-05-14  J. WOOLLEN -- REMOVED ENTRY POINT DATELEN (IT BECAME A
C>                           SEPARATE ROUTINE IN THE BUFRLIB TO INCREASE
C>                           PORTABILITY TO OTHER PLATFORMS)
C> 2003-11-04  J. ATOR    -- ADDED DOCUMENTATION
C> 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C>                           INTERDEPENDENCIES
C> 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED HISTORY
C>                           DOCUMENTATION; OUTPUTS MORE COMPLETE
C>                           DIAGNOSTIC INFO WHEN ROUTINE TERMINATES
C>                           ABNORMALLY
C> 2004-08-09  J. ATOR    -- MAXIMUM MESSAGE LENGTH INCREASED FROM
C>                           20,000 TO 50,000 BYTES
C> 2005-11-29  J. ATOR    -- ADDED RDMSGW AND RDMSGB CALLS TO SIMULATE
C>                           READIBM; ADDED LUNXX < 0 OPTION TO SIMULATE
C>                           READFT
C> 2009-03-23  J. ATOR    -- ADD LOGIC TO ALLOW SECTION 3 DECODING;
C>                           ADD LOGIC TO PROCESS INTERNAL DICTIONARY
C>                           MESSAGES 
C> 2012-06-07  J. ATOR    -- DON'T RESPOND TO INTERNAL DICTIONARY
C>                           MESSAGES IF SECTION 3 DECODING IS BEING USED
C> 2012-09-15  J. WOOLLEN -- CONVERT TO C LANGUAGE I/O INTERFACE;
C>                           REMOVE CODE TO REREAD MESSAGE AS BYTES;
C>                           REPLACE FORTRAN BACKSPACE WITH C BACKBUFR
C> 2014-12-10  J. ATOR    -- USE MODULES INSTEAD OF COMMON BLOCKS
C>
C> USAGE:    CALL READMG (LUNXX, SUBSET, JDATE, IRET)
C>   INPUT ARGUMENT LIST:
C>     LUNXX    - INTEGER: ABSOLUTE VALUE IS FORTRAN LOGICAL UNIT NUMBER
C>                FOR BUFR FILE (IF LUNXX IS LESS THAN ZERO, THEN READ
C>                ERRORS FROM ABS(LUNXX) ARE TREATED THE SAME AS EOF)
C>
C>   OUTPUT ARGUMENT LIST:
C>     SUBSET   - CHARACTER*8: TABLE A MNEMONIC FOR TYPE OF BUFR MESSAGE
C>                BEING READ
C>     JDATE    - INTEGER: DATE-TIME STORED WITHIN SECTION 1 OF BUFR
C>                MESSAGE BEING READ, IN FORMAT OF EITHER YYMMDDHH OR
C>                YYYYMMDDHH, DEPENDING ON DATELEN() VALUE
C>     IRET     - INTEGER: RETURN CODE:
C>                       0 = normal return
C>                      -1 = there are no more BUFR mesages in ABS(LUNXX)
C>
C> REMARKS:
C>    THIS ROUTINE CALLS:        BORT     CKTABA   ERRWRT   IDXMSG
C>                               RDBFDX   RDMSGW   READS3   STATUS
C>                               WTSTAT   BACKBUFR 
C>    THIS ROUTINE IS CALLED BY: IREADMG  READNS   RDMGSB   REWNBF
C>                               UFBINX   UFBPOS
C>                               Also called by application programs.
C>
      SUBROUTINE READMG(LUNXX,SUBSET,JDATE,IRET)



      USE MODA_MSGCWD
      USE MODA_SC3BFR
      USE MODA_BITBUF

      INCLUDE 'bufrlib.prm'

      COMMON /QUIET / IPRT

      CHARACTER*128 ERRSTR
      CHARACTER*8 SUBSET

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

      IRET = 0
      LUNIT = ABS(LUNXX)

C  CHECK THE FILE STATUS
C  ---------------------

      CALL STATUS(LUNIT,LUN,IL,IM)
      IF(IL.EQ.0) GOTO 900
      IF(IL.GT.0) GOTO 901
      CALL WTSTAT(LUNIT,LUN,IL,1)

C  READ A MESSAGE INTO THE INTERNAL MESSAGE BUFFER
C  -----------------------------------------------

1     CALL RDMSGW(LUNIT,MBAY(1,LUN),IER)
      IF(IER.EQ.-1) GOTO 200

C  PARSE THE MESSAGE SECTION CONTENTS
C  ----------------------------------

      IF(ISC3(LUN).NE.0) CALL READS3(LUN)
      CALL CKTABA(LUN,SUBSET,JDATE,IRET)

C  LOOK FOR A DICTIONARY MESSAGE
C  -----------------------------

      IF(IDXMSG(MBAY(1,LUN)).NE.1) RETURN

C     This is an internal dictionary message that was
C     generated by the BUFRLIB archive library software.

      IF(ISC3(LUN).NE.0) RETURN

C     Section 3 decoding isn't being used, so backspace the
C     file pointer and then use subroutine RDBFDX to read in
C     all such dictionary messages (they should be stored
C     consecutively!) and reset the internal tables.

      CALL BACKBUFR(LUN) 
      CALL RDBFDX(LUNIT,LUN)

      IF(IPRT.GE.1) THEN
      CALL ERRWRT('++++++++++++++BUFR ARCHIVE LIBRARY+++++++++++++++++')
      ERRSTR = 'BUFRLIB: READMG - INTERNAL DICTIONARY MESSAGE READ;'//
     .' ACCOUNT FOR IT THEN READ IN NEXT MESSAGE WITHOUT RETURNING'
      CALL ERRWRT(ERRSTR)
      CALL ERRWRT('++++++++++++++BUFR ARCHIVE LIBRARY+++++++++++++++++')
      CALL ERRWRT(' ')
      ENDIF

C     Now go read another message.

      GOTO 1

C  EOF ON ATTEMPTED READ
C  ---------------------

200   CALL WTSTAT(LUNIT,LUN,IL,0)
      INODE(LUN) = 0
      IDATE(LUN) = 0
      SUBSET = ' '
      JDATE = 0
      IRET = -1
      RETURN

C  EXITS
C  -----

900   CALL BORT('BUFRLIB: READMG - INPUT BUFR FILE IS CLOSED, IT MUST'//
     . ' BE OPEN FOR INPUT')
901   CALL BORT('BUFRLIB: READMG - INPUT BUFR FILE IS OPEN FOR OUTPUT'//
     . ', IT MUST BE OPEN FOR INPUT')
902   CALL BORT('BUFRLIB: READMG - ERROR READING A BUFR MESSAGE')
      END
