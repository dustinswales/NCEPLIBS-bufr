C> @file
C> @author ATOR @date 2017-10-17
	
C> THIS SUBROUTINE READS MASTER CODE/FLAG TABLE INFORMATION
C>   FROM TWO SEPARATE (I.E. ONE STANDARD AND ONE LOCAL) ASCII FILES
C>   AND THEN MERGES IT INTO AN INTERNAL MEMORY STRUCTURE.  EACH OF THE
C>   TWO INPUT FILES MUST ALREADY BE INDIVIDUALLY SORTED IN ASCENDING
C>   ORDER WITH RESPECT TO THE FXY NUMBERS.
C>
C> PROGRAM HISTORY LOG:
C> 2017-10-17  J. ATOR    -- ORIGINAL AUTHOR
C>
C> USAGE:    CALL RDMTBF ( LUNSTF, LUNLTF )
C>
C>   INPUT ARGUMENT LIST:
C>     LUNSTF   - INTEGER: FORTRAN LOGICAL UNIT NUMBER OF ASCII FILE
C>                CONTAINING STANDARD CODE/FLAG TABLE INFORMATION
C>     LUNLTF   - INTEGER: FORTRAN LOGICAL UNIT NUMBER OF ASCII FILE
C>                CONTAINING LOCAL CODE/FLAG TABLE INFORMATION
C>
C> REMARKS:
C>    THIS ROUTINE CALLS:        ADN30    BORT     GETNTBE  GETTBH
C>                               INITTBF  SNTBFE   SORTTBF  WRDLEN
C>    THIS ROUTINE IS CALLED BY: IREADMT
C>                               Not normally called by any application
C>                               programs.
C>
	SUBROUTINE RDMTBF ( LUNSTF, LUNLTF )



	CHARACTER*160	STLINE, LTLINE
	CHARACTER*128	BORT_STR
	CHARACTER*6	CMATCH, ADN30

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C	Call WRDLEN to initialize some important information about the
C	local machine, just in case it hasn't already been called.

	CALL WRDLEN

C	Initialize the internal memory structure, including allocating
C	space for it in case this hasn't already been done.

	CALL INITTBF

C	Read and parse the header lines of both files.

	CALL GETTBH ( LUNSTF, LUNLTF, 'F', IMT, IMTV, IOGCE, ILTV )
	
C	Read through the remainder of both files, merging the
C	contents into a unified internal memory structure.

	CALL GETNTBE ( LUNSTF, ISFXYN, STLINE, IERS )
	CALL GETNTBE ( LUNLTF, ILFXYN, LTLINE, IERL )
	DO WHILE ( ( IERS .EQ. 0 ) .OR. ( IERL .EQ. 0 ) )
	  IF ( ( IERS .EQ. 0 ) .AND. ( IERL .EQ. 0 ) ) THEN
	    IF ( ISFXYN .EQ. ILFXYN ) THEN
	      CMATCH = ADN30 ( ISFXYN, 6 )
	      GOTO 900
	    ELSE IF ( ISFXYN .LT. ILFXYN ) THEN
	      CALL SNTBFE ( LUNSTF, ISFXYN, STLINE )
	      CALL GETNTBE ( LUNSTF, ISFXYN, STLINE, IERS )
	    ELSE
	      CALL SNTBFE ( LUNLTF, ILFXYN, LTLINE )
	      CALL GETNTBE ( LUNLTF, ILFXYN, LTLINE, IERL )
	    ENDIF
	  ELSE IF ( IERS .EQ. 0 ) THEN
	    CALL SNTBFE ( LUNSTF, ISFXYN, STLINE )
	    CALL GETNTBE ( LUNSTF, ISFXYN, STLINE, IERS )
	  ELSE IF ( IERL .EQ. 0 ) THEN
	    CALL SNTBFE ( LUNLTF, ILFXYN, LTLINE )
	    CALL GETNTBE ( LUNLTF, ILFXYN, LTLINE, IERL )
	  ENDIF
	ENDDO

C	Sort the contents of the internal memory structure.

	CALL SORTTBF

	RETURN
 900	WRITE(BORT_STR,'("BUFRLIB: RDMTBF - STANDARD AND LOCAL'//
     . ' CODE/FLAG TABLE FILES BOTH CONTAIN SAME FXY NUMBER: ",5A)')
     .	 CMATCH(1:1), '-', CMATCH(2:3), '-', CMATCH(4:6)	
	CALL BORT(BORT_STR)
	END
