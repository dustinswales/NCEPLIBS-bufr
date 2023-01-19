C> @file
C> @brief Copy BUFR DX table information within internal memory.
C>
C> ### Program History Log
C> Date | Programmer | Comments
C> -----|------------|----------
C> 1994-01-06 | J. Woollen | Original author.
C> 1995-06-28 | J. Woollen | Increased the size of internal bufr table arrays in order to handle bigger files.
C> 1999-11-18 | J. Woollen | Increased open files from 10 to 32 (necessary for mpi).
C> 2003-11-04 | S. Bender  | Added remarks/bufrlib routine interdependencies.
C> 2003-11-04 | D. Keyser  | Unified/portable for wrf; added documentation (including history).
C> 2014-12-10 | J. Ator    | Use modules instead of common blocks.
C>
C> @author Woollen @date 1994-01-06

C> This subroutine copies all of the BUFR DX table information from
C> one unit to another within internal memory.
C>
C> @param[in] LUD - integer: I/O stream index into internal memory
C>                  arrays for input unit.
C> @param[in] LUN - integer: I/O stream index into internal memory
C>                  arrays for output unit.
C>
C> @author Woollen @date 1994-01-06

      SUBROUTINE CPBFDX(LUD,LUN)

      USE MODA_MSGCWD
      USE MODA_TABABD

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C  INITIALIZE THE DICTIONARY TABLE PARTITION
C  -----------------------------------------

      CALL DXINIT(LUN,0)

C  COPY ONE TABLE PARTITION TO ANOTHER
C  -----------------------------------

c  .... Positional index for Table A mnem.
      INODE(LUN) = INODE(LUD)

c  .... Set the number of Table A entries
      NTBA(LUN) = NTBA(LUD)
c  .... Set the number of Table B entries
      NTBB(LUN) = NTBB(LUD)
c  .... Set the number of Table D entries
      NTBD(LUN) = NTBD(LUD)

c  .... Copy Table A entries
      DO I=1,NTBA(LUD)
c  .... Message type
      IDNA(I,LUN,1) = IDNA(I,LUD,1)
c  .... Message subtype
      IDNA(I,LUN,2) = IDNA(I,LUD,2)
c  .... Table A entries
      TABA(I,LUN) = TABA(I,LUD)
c  .... Pointer indices into internal tbl
      MTAB(I,LUN) = MTAB(I,LUD)
      ENDDO

c  .... Copy Table B entries
      DO I=1,NTBB(LUD)
c  .... Integer repr. of FXY descr.
      IDNB(I,LUN) = IDNB(I,LUD)
c  .... Table B entries
      TABB(I,LUN) = TABB(I,LUD)
      ENDDO

c  .... Copy Table D entries
      DO I=1,NTBD(LUD)
c  .... Integer repr. of FXY descr.
      IDND(I,LUN) = IDND(I,LUD)
c  .... Table B entries
      TABD(I,LUN) = TABD(I,LUD)
      ENDDO

      RETURN
      END
