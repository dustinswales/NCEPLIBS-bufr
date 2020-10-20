C> @file
C> @author WOOLLEN @date 1994-01-06
      
C> THIS FUNCTION UNPACKS AND RETURNS A BINARY INTEGER WORD
C>   CONTAINED WITHIN NBIT BITS OF A BUFR MESSAGE PACKED INTO THE
C>   INTEGER ARRAY MBAY, STARTING WITH THE FIRST BIT OF BYTE NBYT.
C>
C> PROGRAM HISTORY LOG:
C> 1994-01-06  J. WOOLLEN -- ORIGINAL AUTHOR
C> 2003-11-04  J. ATOR    -- ADDED DOCUMENTATION
C> 2003-11-04  S. BENDER  -- ADDED REMARKS/BUFRLIB ROUTINE
C>                           INTERDEPENDENCIES
C> 2003-11-04  D. KEYSER  -- UNIFIED/PORTABLE FOR WRF; ADDED HISTORY
C>                           DOCUMENTATION
C>
C> USAGE:    IUPB (MBAY, NBYT, NBIT)
C>   INPUT ARGUMENT LIST:
C>     MBAY     - INTEGER: *-WORD PACKED BINARY ARRAY CONTAINING BUFR
C>                MESSAGE
C>     NBYT     - INTEGER: BYTE WITHIN MBAY AT WHOSE FIRST BIT TO BEGIN
C>                UNPACKING
C>     NBIT     - INTEGER: NUMBER OF BITS WITHIN MBAY TO BE UNPACKED
C>
C>   OUTPUT ARGUMENT LIST:
C>     IUPB     - INTEGER: UNPACKED INTEGER WORD
C>
C> REMARKS:
C>    THIS ROUTINE CALLS:        UPB
C>    THIS ROUTINE IS CALLED BY: CKTABA   CPYUPD   GETLENS  IUPBS01
C>                               IUPBS3   MSGUPD   MSGWRT   RDMEMS
C>                               RTRCPTB  STBFDX   STNDRD   STRCPT
C>                               UPDS3    WRDXTB   WRITLC
C>                               Normally not called by any application
C>                               programs.
C>
      FUNCTION IUPB(MBAY,NBYT,NBIT)



      DIMENSION MBAY(*)

C----------------------------------------------------------------------
C----------------------------------------------------------------------

      MBIT = (NBYT-1)*8
      CALL UPB(IRET,NBIT,MBAY,MBIT)
      IUPB = IRET
      RETURN
      END
