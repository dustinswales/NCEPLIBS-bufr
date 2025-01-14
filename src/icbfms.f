C> @file
C> @brief Test whether a character string is "missing"
C>
C> @author J. Ator @date 2012-06-07

C> Check whether a
C> character string returned from a previous call to subroutine
C> readlc() was encoded as "missing" (all bits set to 1)
C> within the actual BUFR data subset.
C>
C> @param[in] STR -- character*(*): String
C> @param[in] LSTR -- integer: Length of string, i.e. number of
C>                    characters within STR to be tested
C> @returns icbfms  --  integer:
C>                      - 0 = STR is not "missing"
C>                      - 1 = STR is "missing"
C>
C> @remarks
C> - The use of an integer return code allows this function
C> to be called in a logical context from application programs
C> written in C as well as in Fortran.
C>
C> @author J. Ator @date 2012-06-07
        RECURSIVE FUNCTION ICBFMS ( STR, LSTR ) RESULT ( IRET )

        use modv_vars, only: im8b

        CHARACTER*(*)   STR

        CHARACTER*8     STRZ
        REAL*8          RL8Z

        CHARACTER*16    ZZ

        CHARACTER*16    ZM_BE
        PARAMETER       ( ZM_BE = '202020E076483742' )
C*              10E10 stored as hexadecimal on a big-endian system.

        CHARACTER*16    ZM_LE
        PARAMETER       ( ZM_LE = '42374876E8000000' )
C*              10E10 stored as hexadecimal on a little-endian system.

        EQUIVALENCE(STRZ,RL8Z)

C-----------------------------------------------------------------------

C       Check for I8 integers.

        IF ( IM8B ) THEN
            IM8B = .FALSE.

            CALL X84 ( LSTR, MY_LSTR, 1 )
            IRET = ICBFMS ( STR, MY_LSTR )

            IM8B = .TRUE.
            RETURN
        END IF

        IRET = 0

        NUMCHR = MIN(LSTR,LEN(STR))

C*      Beginning with version 10.2.0 of the NCEPLIBS-bufr, "missing" strings
C*      have always been explicitly encoded with all bits set to 1,
C*      which is the correct encoding per WMO regulations.  However,
C*      prior to version 10.2.0, the NCEPLIBS-bufr stored "missing" strings by
C*      encoding the REAL*8 value of 10E10 into the string, so the
C*      following logic attempts to identify some of these earlier
C       cases, at least for strings between 4 and 8 bytes in length.

        IF ( NUMCHR.GE.4 .AND. NUMCHR.LE.8 ) THEN
            DO II = 1, NUMCHR
                STRZ(II:II) = STR(II:II)
            END DO
            WRITE (ZZ,'(Z16.16)') RL8Z
            I = 2*(8-NUMCHR)+1
            N = 16
            IF ( ZZ(I:N).EQ.ZM_BE(I:N) .OR. ZZ(I:N).EQ.ZM_LE(I:N) ) THEN
                IRET = 1
                RETURN
            END IF
        END IF

C*      Otherwise, the logic below will check for "missing" strings of
C*      any length which are correctly encoded with all bits set to 1,
C*      including those encoded by NCEPLIBS-bufr version 10.2.0 or later.

        DO II=1,NUMCHR
           STRZ(1:1) = STR(II:II)
           IF ( IUPM(STRZ(1:1),8).NE.255 ) RETURN
        ENDDO

        IRET = 1

        RETURN
        END
