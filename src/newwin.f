C> @file
C> @brief Computes the ending index of the window.
C>
C> ### Program History Log
C> Date | Programmer | Comments
C> -----|------------|----------
C> 1994-01-06 | J. Woollen | Original author.
C> 1998-07-08 | J. Woollen | Replaced call to cray "abort" with call to bort().
C> 1999-11-18 | J. Woollen | Increase number of open bufr files to 32.
C> 2002-05-14 | J. Woollen | Removed old cray compiler directives.
C> 2003-11-04 | S. Bender  | Added remarks/bufrlib routine interdependencies.
C> 2003-11-04 | D. Keyser  | maxjl increased to 16000; unified/portable for wrf; documentation; outputs more diagnostic info.
C> 2009-03-31 | J. Woollen | Added documentation.
C> 2009-05-07 | J. Ator    | Use lstjpb instead of lstrpc.
C> 2014-12-10 | J. Ator    | Use modules instead of common blocks.
C>
C> @author Woollen @date 1994-01-06
      
C> Given an index within the internal jump/link table which
C> points to the start of an "rpc" window (which is the iteration of an 8-bit
C> or 16-bit delayed replication sequence), this subroutine computes
C> the ending index of the window. Alternatively, if the given index
C> points to the start of a "sub" window (which is the first node of a
C> subset), then the subroutine returns the index of the last node.
C>
C> @note See the docblock in bufr archive library subroutine getwin() for an
C> explanation of "windows" within the context of a bufr data subset.
C>
C> @param[in] LUN - integer: i/o stream index into internal memory arrays.
C> @param[in] IWIN - integer: starting index of window iteration.
C> @param[out] JWIN - integer: ending index of window iteration.
C>
C> @author WOOLLEN @date 1994-01-06
      SUBROUTINE NEWWIN(LUN,IWIN,JWIN)

      USE MODA_USRINT

      CHARACTER*128 BORT_STR

C----------------------------------------------------------------------
C----------------------------------------------------------------------

      IF(IWIN.EQ.1) THEN

C        This is a "SUB" (subset) node, so return JWIN as pointing to
C        the last value of the entire subset. 

         JWIN = NVAL(LUN)
         GOTO 100
      ENDIF

C     Confirm that IWIN points to an RPC node and then compute JWIN.

      NODE = INV(IWIN,LUN)
      IF(LSTJPB(NODE,LUN,'RPC').NE.NODE) GOTO 900
      JWIN = IWIN+VAL(IWIN,LUN)

C  EXITS
C  -----

100   RETURN
900   WRITE(BORT_STR,'("BUFRLIB: NEWWIN - LSTJPB FOR NODE",I6,'//
     . '" (LSTJPB=",I5,") DOES NOT EQUAL VALUE OF NODE, NOT RPC '//
     . '(IWIN =",I8,")")') NODE,LSTJPB(NODE,LUN,'RPC'),IWIN
      CALL BORT(BORT_STR)
      END
