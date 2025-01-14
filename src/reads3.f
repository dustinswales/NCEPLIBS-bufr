C> @file
C> @brief Read the Section 3 descriptors from a BUFR message.
C>
C> @author J. Ator @date 2009-03-23

C> Read the Section 3 descriptors from the
C> BUFR message in mbay(1,lun), then use the BUFR master tables
C> to generate the necessary information for those descriptors within
C> the internal BUFR table arrays.
C>
C> @param[in] LUN - integer: file ID
C>
C> @author J. Ator @date 2009-03-23
        SUBROUTINE READS3 ( LUN )

        use bufrlib

        use modv_vars, only: maxnc, mxcnem

        use moda_sc3bfr
        use moda_bitbuf
        use moda_dscach
        use moda_s3list

        COMMON /QUIET/  IPRT

        CHARACTER*6     NUMB,ADN30

        CHARACTER*55    CSEQ

        CHARACTER*128   ERRSTR

        LOGICAL         INCACH

        SAVE    IREPCT

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------

C*      Check whether the appropriate BUFR master table information has
C*      already been read into internal memory for this message.

        IF ( IREADMT ( LUN ) .EQ. 1 ) THEN

C*        NO (i.e. we just had to read in new master table information
C*        for this message), so reset some corresponding values in
C*        other parts of the library.

          CALL DXINIT ( LUN, 0 )
          ITMP = IGETTDI ( 0 )
          IREPCT = 0
          NCNEM = 0
        ENDIF

C*      Unpack the list of Section 3 descriptors from the message.

        CALL UPDS3 ( MBAY(1,LUN), MAXNC, CDS3, NCDS3 )
        DO II = 1, NCDS3
          IDS3(II) = IFXY( CDS3(II) )
        ENDDO

C*      Is the list of Section 3 descriptors already in the cache?

C*      The cache is a performance-enhancing device which saves
C*      time when the same descriptor sequences are encountered
C*      over and over within the calling program.  Time is saved
C*      because the below calls to subroutines STSEQ and MAKESTAB
C*      are bypassed whenever a list is already in the cache.

        INCACH = .FALSE.
        IF ( NCNEM .GT. 0 ) THEN
          II = 1
          DO WHILE ( (.NOT.INCACH) .AND. (II.LE.NCNEM) )
            IF ( NCDS3 .EQ. NDC(II) ) THEN
              JJ = 1
              INCACH = .TRUE.
              DO WHILE ( (INCACH) .AND. (JJ.LE.NCDS3) )
                IF ( IDS3(JJ) .EQ. IDCACH(II,JJ) ) THEN
                  JJ = JJ + 1
                ELSE
                  INCACH = .FALSE.
                ENDIF
              ENDDO
              IF (INCACH) THEN

C*              The list is already in the cache, so store the
C*              corresponding Table A mnemonic into MODULE SC3BFR
C*              and return.

                IF ( IPRT .GE. 2 ) THEN
        CALL ERRWRT('+++++++++++++++++++++++++++++++++++++++++++++++++')
        ERRSTR = 'BUFRLIB: READS3 - RE-USED CACHE LIST FOR ' // CNEM(II)
        CALL ERRWRT(ERRSTR)
        CALL ERRWRT('+++++++++++++++++++++++++++++++++++++++++++++++++')
        CALL ERRWRT(' ')
                ENDIF
                TAMNEM(LUN) = CNEM(II)
                RETURN
              ENDIF
            ENDIF
            II = II + 1
          ENDDO
        ENDIF

C*      Get the next available index within the internal Table A.

        N = IGETNTBI ( LUN, 'A' )

C*      Generate a Table A mnemonic and sequence description.

        WRITE ( TAMNEM(LUN), '(A5,I3.3)') 'MSTTB', N
        CSEQ = 'TABLE A MNEMONIC ' // TAMNEM(LUN)

C*      Store the Table A mnemonic and sequence into the cache.

        NCNEM = NCNEM + 1
        IF ( NCNEM .GT. MXCNEM ) GOTO 900
        CNEM(NCNEM) = TAMNEM(LUN)
        NDC(NCNEM) = NCDS3
        DO JJ = 1, NCDS3
          IDCACH(NCNEM,JJ) = IDS3(JJ)
        ENDDO
        IF ( IPRT .GE. 2 ) THEN
        CALL ERRWRT('+++++++++++++++++++++++++++++++++++++++++++++++++')
        ERRSTR = 'BUFRLIB: READS3 - STORED CACHE LIST FOR ' //
     .    CNEM(NCNEM)
        CALL ERRWRT(ERRSTR)
        CALL ERRWRT('+++++++++++++++++++++++++++++++++++++++++++++++++')
        CALL ERRWRT(' ')
        ENDIF

C*      Get an FXY value to use with this Table A mnemonic.

        IDN = IGETTDI ( LUN )
        NUMB = ADN30 ( IDN, 6 )

C*      Store all of the information for this mnemonic within the
C*      internal Table A.

        CALL STNTBIA ( N, LUN, NUMB, TAMNEM(LUN), CSEQ )

C*      Store all of the information for this sequence within the
C*      internal Tables B and D.

        CALL STSEQ_C ( LUN, IREPCT, IDN, TAMNEM(LUN), CSEQ, IDS3,
     .                 NCDS3 )

C*      Update the jump/link table.

        CALL MAKESTAB

        RETURN
900     CALL BORT('BUFRLIB: READS3 - MXCNEM OVERFLOW')
        END
