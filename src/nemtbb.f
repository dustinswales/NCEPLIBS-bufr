C> @file
C> @author WOOLLEN @date 1994-01-06
      
C> THIS SUBROUTINE CHECKS ALL OF THE PROPERTIES (E.G. FXY
C>   VALUE, UNITS, SCALE FACTOR, REFERENCE VALUE, ETC.) OF A SPECIFIED
C>   MNEMONIC WITHIN THE INTERNAL BUFR TABLE B ARRAYS (IN MODULE
C>   TABABD) IN ORDER TO VERIFY THAT THE VALUES OF THOSE PROPERTIES
C>   ARE ALL LEGAL AND WELL-DEFINED.  IF ANY ERRORS ARE FOUND, THEN AN
C>   APPROPRIATE CALL IS MADE TO BUFR ARCHIVE LIBRARY SUBROUTINE BORT.
C>
C> PROGRAM HISTORY LOG:
C> 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C> 1995-06-28  J. WOOLLEN -- INCREASED THE SIZE OF INTERNAL BUFR TABLE
C>                           ARRAYS IN ORDER TO HANDLE BIGGER FILES
C> 1998-07-08  J. WOOLLEN -- REPLACED CALL TO CRAY LIBRARY ROUTINE
C>                           "ABORT" WITH CALL TO NEW INTERNAL BUFRLIB
C>                           ROUTINE "BORT"; CORRECTED SOME MINOR ERRORS
C> 1999-11-18  J. WOOLLEN -- CHANGED CALL TO FUNCTION "VAL$" TO "VALX"
C>                           (IT HAS BEEN RENAMED TO REMOVE THE
C>                           POSSIBILITY OF THE "$" SYMBOL CAUSING
C>                           PROBLEMS ON OTHER PLATFORMS)
C> 2003-11-04  J. ATOR    -- ADDED DOCUMENTATION
C> 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C>                           INTERDEPENDENCIES
C> 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED HISTORY
C>                           DOCUMENTATION; OUTPUTS MORE COMPLETE
C>                           DIAGNOSTIC INFO WHEN ROUTINE TERMINATES
C>                           ABNORMALLY
C> 2014-12-10  J. ATOR    -- USE MODULES INSTEAD OF COMMON BLOCKS
C>
C> USAGE:    CALL NEMTBB (LUN, ITAB, UNIT, ISCL, IREF, IBIT)
C>   INPUT ARGUMENT LIST:
C>     LUN      - INTEGER: I/O STREAM INDEX INTO INTERNAL MEMORY ARRAYS
C>     ITAB     - INTEGER: POSITIONAL INDEX INTO INTERNAL BUFR TABLE B
C>                ARRAYS FOR MNEMONIC TO BE CHECKED
C>
C>   OUTPUT ARGUMENT LIST:
C>     UNIT     - CHARACTER*24: UNITS OF MNEMONIC
C>     ISCL     - INTEGER: SCALE FACTOR OF MNEMONIC
C>     IREF     - INTEGER: REFERENCE VALUE OF MNEMONIC
C>     IBIT     - INTEGER: BIT WIDTH OF MNEMONIC
C>
C> REMARKS:
C>    THIS ROUTINE CALLS:        BORT     IFXY     VALX
C>    THIS ROUTINE IS CALLED BY: CHEKSTAB RESTD    TABENT
C>                               Normally not called by any application
C>                               programs.
C>
      SUBROUTINE NEMTBB(LUN,ITAB,UNIT,ISCL,IREF,IBIT)

      USE MODA_TABABD

      CHARACTER*128 BORT_STR
      CHARACTER*24  UNIT
      CHARACTER*8   NEMO
      REAL*8        MXR

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

      MXR = 1E11-1

      IF(ITAB.LE.0 .OR. ITAB.GT.NTBB(LUN)) GOTO 900

C  PULL OUT TABLE B INFORMATION
C  ----------------------------

      IDN  = IDNB(ITAB,LUN)
      NEMO = TABB(ITAB,LUN)( 7:14)
      UNIT = TABB(ITAB,LUN)(71:94)
      ISCL = VALX(TABB(ITAB,LUN)( 95: 98))
      IREF = VALX(TABB(ITAB,LUN)( 99:109))
      IBIT = VALX(TABB(ITAB,LUN)(110:112))

C  CHECK TABLE B CONTENTS
C  ----------------------

      IF(IDN.LT.IFXY('000000')) GOTO 901
      IF(IDN.GT.IFXY('063255')) GOTO 901

      IF(ISCL.LT.-999 .OR. ISCL.GT.999) GOTO 902
      IF(IREF.LE.-MXR .OR. IREF.GE.MXR) GOTO 903
      IF(IBIT.LE.0) GOTO 904
      IF(UNIT(1:5).NE.'CCITT' .AND. IBIT.GT.32      ) GOTO 904
      IF(UNIT(1:5).EQ.'CCITT' .AND. MOD(IBIT,8).NE.0) GOTO 905

C  EXITS
C  -----

      RETURN
900   WRITE(BORT_STR,'("BUFRLIB: NEMTBB - ITAB (",I7,") NOT FOUND IN '//
     . 'TABLE B")') ITAB
      CALL BORT(BORT_STR)
901   WRITE(BORT_STR,'("BUFRLIB: NEMTBB - INTEGER REPRESENTATION OF '//
     . 'DESCRIPTOR FOR TABLE B MNEMONIC ",A," (",I7,") IS OUTSIDE '//
     . 'RANGE 0-16383 (16383 -> 0-63-255)")') NEMO,IDN
      CALL BORT(BORT_STR)
902   WRITE(BORT_STR,'("BUFRLIB: NEMTBB - SCALE VALUE FOR TABLE B '//
     .'MNEMONIC ",A," (",I7,") IS OUTSIDE RANGE -999 TO 999")')
     . NEMO,ISCL
      CALL BORT(BORT_STR)
903   WRITE(BORT_STR,'("BUFRLIB: NEMTBB - REFERENCE VALUE FOR TABLE B'//
     .' MNEMONIC ",A," (",I7,") IS OUTSIDE RANGE +/- 1E11-1")')
     . NEMO,IREF
      CALL BORT(BORT_STR)
904   WRITE(BORT_STR,'("BUFRLIB: NEMTBB - BIT WIDTH FOR NON-CHARACTER'//
     . ' TABLE B MNEMONIC ",A," (",I7,") IS > 32")') NEMO,IBIT
      CALL BORT(BORT_STR)
905   WRITE(BORT_STR,'("BUFRLIB: NEMTBB - BIT WIDTH FOR CHARACTER '//
     . 'TABLE B MNEMONIC ",A," (",I7,") IS NOT A MULTIPLE OF 8")')
     . NEMO,IBIT
      CALL BORT(BORT_STR)
      END
