C> @file
C> @author WOOLLEN @date 1998-07-08
      
C> THIS SUBROUTINE IS USED TO SPECIFY THE LENGTH OF DATE-TIME
C>   VALUES THAT WILL BE OUTPUT BY FUTURE CALLS TO ANY OF THE BUFR
C>   ARCHIVE LIBRARY SUBROUTINES WHICH READ BUFR MESSAGES (E.G. READMG,
C>   READERME, ETC.).  POSSIBLE VALUES ARE "8" (WHICH IS THE DEFAULT)
C>   AND "10".
C>
C> PROGRAM HISTORY LOG:
C> 1998-07-08  J. WOOLLEN -- ORIGINAL AUTHOR (ENTRY POINT IN READMG)
C> 2002-05-14  J. WOOLLEN -- CHANGED FROM AN ENTRY POINT TO INCREASE
C>                           PORTABILITY TO OTHER PLATFORMS
C> 2003-11-04  J. ATOR    -- ADDED DOCUMENTATION
C> 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C>                           INTERDEPENDENCIES
C> 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED HISTORY
C>                           DOCUMENTATION; OUTPUTS MORE COMPLETE
C>                           DIAGNOSTIC INFO WHEN ROUTINE TERMINATES
C>                           ABNORMALLY
C> 2004-12-20  D. KEYSER  -- CALLS WRDLEN TO INITIALIZE LOCAL MACHINE
C>                           INFORMATION (IN CASE IT HAS NOT YET BEEN
C>                           CALLED), THIS ROUTINE DOES NOT REQUIRE IT
C>                           BUT IT MAY SOMEDAY CALL OTHER ROUTINES THAT
C>                           DO REQUIRE IT
C>
C> USAGE:    CALL DATELEN (LEN)
C>   INPUT ARGUMENT LIST:
C>     LEN      - INTEGER: LENGTH OF DATE-TIME VALUES TO BE OUTPUT BY
C>                READ SUBROUTINES:  *
C>                       8 =   YYMMDDHH (2-digit year)
C>                      10 = YYYYMMDDHH (4-digit year)
C>
C> REMARKS:
C>    THIS ROUTINE CALLS:        BORT     WRDLEN
C>    THIS ROUTINE IS CALLED BY: None
C>                               Normally called only by application
C>                               programs.
C>
      SUBROUTINE DATELEN(LEN)



      COMMON /DATELN/ LENDAT

      CHARACTER*128 BORT_STR

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C  CALL SUBROUTINE WRDLEN TO INITIALIZE SOME IMPORTANT INFORMATION
C  ABOUT THE LOCAL MACHINE (IN CASE IT HAS NOT YET BEEN CALLED)
C  ---------------------------------------------------------------

      CALL WRDLEN

      IF(LEN.NE.8 .AND. LEN.NE.10) GOTO 900
      LENDAT = LEN

C  EXITS
C  -----

      RETURN
900   WRITE(BORT_STR,'("BUFRLIB: DATELEN - INPUT ARGUMENT IS",I4," - '//
     . 'IT MUST BE EITHER 8 OR 10")') LEN
      CALL BORT(BORT_STR)
      END
