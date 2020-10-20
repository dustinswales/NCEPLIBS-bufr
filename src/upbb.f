C> @file
C> @author WOOLLEN @date 1994-01-06
      
C> THIS SUBROUTINE UNPACKS AND RETURNS A BINARY INTEGER
C>   CONTAINED WITHIN NBITS BITS OF IBAY, STARTING WITH BIT (IBIT+1).
C>   THIS IS SIMILAR TO BUFR ARCHIVE LIBRARY SUBROUTINE UPB, EXCEPT IN
C>   UPBB IBIT IS NOT UPDATED UPON OUTPUT (AND THE ORDER OF ARGUMENTS IS
C>   DIFFERENT).
C>
C> PROGRAM HISTORY LOG:
C> 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C> 1998-10-27  J. WOOLLEN -- MODIFIED TO CORRECT PROBLEMS CAUSED BY IN-
C>                           LINING CODE WITH FPP DIRECTIVES
C> 2003-11-04  J. WOOLLEN -- BIG-ENDIAN/LITTLE-ENDIAN INDEPENDENT (WAS
C>                           IN DECODER VERSION)
C> 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C>                           INTERDEPENDENCIES
C> 2003-11-04  D. KEYSER  -- ADDED CHECK FOR NBITS EQUAL TO ZERO;
C>                           MODIFIED LOGIC TO MAKE IT CONSISTENT WITH
C>                           LOGIC IN UPB; UNIFIED/PORTABLE FOR WRF;
C>                           ADDED DOCUMENTATION (INCLUDING HISTORY)
C>
C> USAGE:    CALL UPBB (NVAL, NBITS, IBIT, IBAY)
C>   INPUT ARGUMENT LIST:
C>     NBITS    - INTEGER: NUMBER OF BITS OF IBAY WITHIN WHICH TO UNPACK
C>                NVAL
C>     IBIT     - INTEGER: BIT POINTER WITHIN IBAY TO START UNPACKING
C>                FROM
C>     IBAY     - INTEGER: *-WORD PACKED BINARY ARRAY CONTAINING PACKED
C>                NVAL
C>
C>   OUTPUT ARGUMENT LIST:
C>     NVAL     - INTEGER: UNPACKED INTEGER
C>
C> REMARKS:
C>    THIS ROUTINE CALLS:        IREV
C>    THIS ROUTINE IS CALLED BY: RCSTPL   RDTREE   UFBGET   UFBTAB
C>                               UFBTAM   UPB      WRITLC
C>                               Normally not called by any application
C>                               programs.
C>
      SUBROUTINE UPBB(NVAL,NBITS,IBIT,IBAY)



      COMMON /HRDWRD/ NBYTW,NBITW,IORD(8)

      DIMENSION IBAY(*)

C----------------------------------------------------------------------
C----------------------------------------------------------------------

C  IF NBITS=0, THEN JUST SET NVAL=0 AND RETURN
C  -------------------------------------------

      IF(NBITS.EQ.0)THEN
        NVAL=0
        GOTO 100
      ENDIF

      NWD = IBIT/NBITW + 1
      NBT = MOD(IBIT,NBITW)
      INT = ISHFT(IREV(IBAY(NWD)),NBT)
      INT = ISHFT(INT,NBITS-NBITW)
      LBT = NBT+NBITS
      IF(LBT.GT.NBITW) THEN
         JNT = IREV(IBAY(NWD+1))
         INT = IOR(INT,ISHFT(JNT,LBT-2*NBITW))
      ENDIF
      NVAL = INT

C  EXIT
C  ----

100   RETURN
      END
