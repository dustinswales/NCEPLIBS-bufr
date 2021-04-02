set(fortran_src
  ${CMAKE_CURRENT_BINARY_DIR}/bvers.f
  modv_BMISS.f90
  modv_MAXCD.F
  modv_MAXJL.F
  modv_MAXMEM.F
  modv_MAXMSG.F
  modv_MAXNC.f90
  modv_MAXSS.F
  modv_MAXTBA.F
  modv_MAXTBB.F
  modv_MAXTBD.F
  modv_MXBTM.F
  modv_MXBTMSE.F
  modv_MXCDV.F
  modv_MXCNEM.f90
  modv_MXCSB.F
  modv_MXDXTS.F
  modv_MXH4WLC.f90
  modv_MXLCC.F
  modv_MXMSGL.F
  modv_MXMTBB.F
  modv_MXMTBD.F
  modv_MXMTBF.F
  modv_MXNAF.f90
  modv_MXNRV.F
  modv_MXRST.F
  modv_MXS.f90
  modv_MXS01V.F
  modv_MXTAMC.F
  modv_MXTCO.F
  modv_NFILES.F
  moda_bitbuf.F
  moda_bitmaps.F
  moda_bufrmg.F
  moda_bufrsr.F
  moda_comprs.F
  moda_comprx.F
  moda_dscach.F
  moda_h4wlc.F
  moda_idrdm.F
  moda_ifopbf.F
  moda_ival.F
  moda_ivttmp.F
  moda_lushr.F
  moda_mgwa.F
  moda_mgwb.F
  moda_msgcwd.F
  moda_msglim.F
  moda_msgmem.F
  moda_mstabs.F
  moda_nmikrp.F
  moda_nrv203.F
  moda_nulbfr.F
  moda_rdmtb.F
  moda_rlccmn.F
  moda_s01cm.F
  moda_sc3bfr.F
  moda_stbfr.F
  moda_stcode.F
  moda_tababd.F
  moda_tables.F
  moda_ufbcpl.F
  moda_unptyp.F
  moda_usrbit.F
  moda_usrint.F
  moda_usrtmp.F
  moda_xtab.F
  adn30.f
  atrcpt.f
  ${CMAKE_CURRENT_BINARY_DIR}/bfrini.f90
  blocks.f
  bort.f
  bort2.f
  cadn30.f
  capit.f
  chekstab.f
  chrtrna.f
  cktaba.f
  closmg.f
  cmpmsg.f
  cmsgini.f
  cnved4.f
  codflg.f
  conwin.f
  copybf.f
  copymg.f
  copysb.f
  cpbfdx.f
  cpdxmm.f
  cpymem.f
  cpyupd.f
  datebf.F
  datelen.f
  digit.f
  drfini.f
  drstpl.f
  dumpbf.f
  dxdump.f
  dxinit.f
  dxmini.f
  elemdx.f
  errwrt.f
  exitbufr.f
  fstag.f
  getabdb.f
  getbmiss.f
  getcfmng.f
  getlens.f
  getntbe.f
  gets1loc.f
  gettagpr.f
  gettagre.f
  gettbh.f
  getvalnb.f
  getwin.f
  hold4wlc.f
  i4dy.f
  ibfms.f
  icbfms.f
  ichkstr.f
  icmpdx.f
  icopysb.f
  idn30.f
  idxmsg.f
  ifbget.f
  ifxy.f
  igetdate.f
  igetfxy.f
  igetmxby.f
  igetntbi.f
  igetntbl.f
  igetprm.f
  igetrfel.f
  igetsc.f
  igettdi.f
  imrkopr.f
  inctab.f
  invcon.f
  invmrg.f
  invtag.f
  invwin.f
  iok2cpy.f
  iokoper.f
  ipkm.f
  ipks.f
  ireadmg.f
  ireadmm.f
  ireadns.f
  ireadsb.f
  ishrdx.f
  isize.f
  istdesc.f
  iupb.f
  iupbs01.f
  iupbs3.f
  iupm.f
  iupvs01.f
  jstchr.f
  jstnum.f
  lcmgdf.f
  lmsg.f
  lstjpb.f
  makestab.f
  maxout.f
  mesgbc.f
  mesgbf.f
  minimg.f
  mrginv.f
  msgfull.f
  msgini.f
  msgupd.f
  msgwrt.f
  mtfnam.f
  mtinfo.f
  mvb.f
  nemdefs.f
  nemock.f
  nemspecs.f
  nemtab.f
  nemtba.f
  nemtbax.f
  nemtbb.f
  nemtbd.f
  nenubd.f
  nevn.f
  newwin.f
  nmsub.f
  nmwrd.f
  numbck.f
  numtab.f
  numtbd.f
  nvnwin.f
  nwords.f
  nxtwin.f
  openbt.f
  openmb.f
  openmg.f
  pad.f
  padmsg.f
  parstr.f
  parusr.f
  parutg.f
  pkb.f
  pkbs1.f
  pkc.f
  pkftbv.f
  pktdd.f
  posapx.f
  rcstpl.f
  rdbfdx.f
  rdcmps.f
  rdmemm.f
  rdmems.f
  rdmgsb.f
  rdmsgw.f
  rdmtbb.f
  rdmtbd.f
  rdmtbf.f
  rdtree.f
  rdusdx.f
  readdx.f
  readerme.f
  readlc.f
  readmg.f
  readmm.f
  readns.f
  reads3.f
  readsb.f
  rewnbf.f
  rjust.f
  rsvfvm.f
  rtrcpt.f
  rtrcptb.f
  seqsdx.f
  setblock.f
  setbmiss.f
  setvalnb.f
  sntbbe.f
  sntbde.f
  sntbfe.f
  status.f
  stbfdx.f
  stdmsg.f
  stndrd.f
  stntbi.f
  stntbia.f
  strbtm.f
  strcln.f
  strcpt.f
  string.f
  strnum.f
  strsuc.f
  tabent.f
  tabsub.f
  trybump.f
  ufbcnt.f
  ufbcpy.f
  ufbcup.f
  ufbdmp.f
  ufbevn.f
  ufbget.f
  ufbin3.f
  ufbint.f
  ufbinx.f
  ufbmem.f
  ufbmex.f
  ufbmms.f
  ufbmns.f
  ufbovr.f
  ufbpos.f
  ufbqcd.f
  ufbqcp.f
  ufbrep.f
  ufbrms.f
  ufbrp.f
  ufbrw.f
  ufbseq.f
  ufbsp.f
  ufbstp.f
  ufbtab.f
  ufbtam.f
  ufdump.f
  upb.f
  upbb.f
  upc.f
  upds3.f
  upftbv.f
  ups.f
  uptdd.f
  usrtpl.f
  valx.f
  wrcmps.f
  wrdxtb.f
  writcp.f
  writdx.f
  writlc.f
  writsa.f
  writsb.f
  wrtree.f
  wtstat.f
  arallocf.F
  ardllocf.F
  closbf.F
  ireadmt.F
  irev.F
  isetprm.F
  openbf.F
  pkvs01.F
  wrdlen.F
  fortran_open.f90
  fortran_close.f90
  bufr_interface.f90)

set(c_src
  arallocc.c
  ardllocc.c
  bort_exit.c
  ccbfl.c
  cmpia.c
  cmpstia1.c
  cmpstia2.c
  cobfl.c
  cpmstabs.c
  crbmg.c
  cread.c
  cwbmg.c
  dlloctbf.c
  icvidx.c
  inittbf.c
  nummtb.c
  rbytes.c
  restd.c
  sorttbf.c
  srchtbf.c
  strtbfe.c
  stseq.c
  wrdesc.c)

set(c_hdr
  ${CMAKE_CURRENT_BINARY_DIR}/bufrlib.h
  cfe.h
  cobfl.h
  cread.h
  mstabs.h
  bufr_interface.h)
