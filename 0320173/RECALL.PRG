SET TALK OFF
SET ECHO OFF
SET STEP OFF
SET DATE BRIT
SET CENT ON
*
CLEAR
*
WMESANO = '  /    '
WGFIPTOTA = 'GFIPTOTA.DBF'
WESTRUTURA = 'ESTRUTUR.DBF'
*
@ 24,65 GET WMESANO PICT '99/9999' WHEN MENS('Entre com o MES/ANO da GEFIP. <ESC> Retorna: ')
READ
*
IF LASTKEY() = 27
   QUIT
ELSE
   IF FILE(WESTRUTURA)
      DELE FILE &WESTRUTURA
   ENDIF
   *
   IF FILE(WGFIPTOTA)
      USE &WGFIPTOTA
      *
      COPY STRU TO &WESTRUTURA
      *
      ZAP
      *
      USE &WESTRUTURA
      *
      COPY STRU TO &WGFIPTOTA
      *
      USE
   ENDIF
   *
   WFIP = 'FIP' + SUBS(WMESANO,1,2) + SUBS(WMESANO,6,2) + '.DBF'
   *
   IF FILE(WFIP)
      IF FILE('C195.DBF')
         USE COD195
         ZAP
         APPEND FROM C195
         REPL ALL COD WITH [195]
         USE
      ELSE
         USE &WFIP
         COPY TO COD195 FOR COD = [195]
         USE
      ENDIF
      *
      USE &WFIP
      set filter to fora <> 0.00
      set uniq on
      inde on matr to mvinc
      COPY TO MVINC FOR FORA <> 0.00
      USE
      *
      USE &WGFIPTOTA
      APPEND FROM &WFIP
   ENDIF
   *
   WFIP = 'GFIP' + SUBS(WMESANO,1,2) + SUBS(WMESANO,6,2) + '.DBF'
   *
   IF FILE(WFIP)
      DELETE FILE &WFIP
   ENDIF
ENDIF
*
wfaixa01 = 1659.38
wfaixa02 = 2765.66
wfaixa03 = 5531.31
**
** foi acrescentada as rubricas 157 e 137 em 21/03/2017
**
wentra = [101.102.103.108.109.110.111.114.115.118.122.124.125.126.129.130.132.138.139.140.] +;
         [144.147.150.151.152.163.171.174.177.185.194.195.219.231.232.245.250.253.258.264.288.] +;
         [301.302.429.502.558.164.157.137]
wabate = [163.659.662.903]
*
sele 4
use cod195
inde on matr to cod195
*
sele 3
use mvinc
inde on matr to mvinc
*
sele 2
use rapido
zap
inde on FF+matr to rapido
*
sele 1
use gfiptota
inde on FF+matr+cod to gfiptota
set rela to matr into cod195
set rela to matr into mvinc addi
go top
*
do while !eof()
   wisento    = isento
**   wfora      = fora
   *
   wmatr      = matr
   wff        = ff
   wnome      = nome
   wpasep     = pasep
   wdtnasc    = dtnasc
   wdtent     = dtent
**   wmvinc     = mvinc
   wbase      = []
   wvlrbruto  = 0.00
   wvlrabate  = 0.00
   wvlrinsatu = 0.00
   wvlrinsant = 0.00
   wvlrfalta  = 0.00
   wvlrferant = 0.00
   wvlrsalfam = 0.00
   wvlrsalmat = 0.00
   wvlr710    = 0.00
   wconverte  = 0.00
   wdiferenca = 0.00
   wdiferen   = 0.00
   *
   do while (!eof() .and. (wmatr = matr).AND.FF=WFF)
      if cod = [710]
         wvlr710 = valor
         *
         if (at([,],refer) > 0)
            wconverte = val(subs(refer,1,at([,],refer) - 1) + [.] + subs(refer,at([,],refer) + 1))
         else
            wconverte = val(refer)
         endif
         *
         wvlrbruto = wvlrbruto + wconverte
         wvlrferant = wconverte
      endif
      *
      if cod$wentra
         if cod = [501]
            wvlrsalfam = valor
         endif
         *
         if cod = [502]
            wvlrsalmat = valor
         endif
         *
         wvlrbruto = wvlrbruto + valor
      else
         if cod$wabate
            wvlrabate = wvlrabate + valor
            *
            if cod = [659]
               wvlrfalta = valor
            endif
         else
            if cod = [650]
               wvlrinsant = valor
            endif
         endif
      endif
      *
      sele 3
      seek wmatr
      if found()
         wfora = fora
         wmvinc = [S]
      else
         wfora = 0.00
         wmvinc = [ ]
      endif
      sele 1
      *
      sele 4
      seek wmatr
      if found()
         wexonerado = [S]
      else
         wexonerado = [ ]
      endif
      sele 1
      *
      skip
   enddo
   *
   wvlrbruto = wvlrbruto - wvlrabate
   *
   if (wvlrbruto <= wfaixa01)
      wvlrinsatu = wvlrbruto * 0.08
   else
      if ((wvlrbruto > wfaixa01) .and. (wvlrbruto <= wfaixa02))
         wvlrinsatu = wvlrbruto * 0.09
      else
         if (wvlrbruto > wfaixa02)
            wvlrinsatu = wvlrbruto * 0.11
         endif
      endif
   endif
   *
   if (wvlrbruto > 5531.31)
   *   wvlrinsatu = 5531.31 * 0.11
      wvlrinsatu = 608.44
   endif
   *
   wbase = trim(ltrim(str(wvlrbruto,15,2)))
   *
   sele 2
   *
   wdiferenca = wvlrinsatu - (wvlrinsant + wvlr710)
**   if wmatr="024225"
**   ? wnome
**   ? wdiferenca
**   ? wvlrinsatU
**   ? wvlrinsant + WVLR710
**   ? wvlr710
**   wait
**   endif
   wdiferen   = wdiferenca
   *
   append blank
   repl matr with wmatr, ff with wff, isento with wisento, fora with wfora, nome with wnome, pasep with wpasep,;
        dtnasc with wdtnasc, dtent with wdtent, valor with wvlrbruto,;
        inssant with wvlrinsant + wvlr710, inssatu with wvlrinsatu, diferenca with wdiferenca,;
        vlrfalta with wvlrfalta, vlrferant with wvlrferant, vlrsalfam with wvlrsalfam,;
        vlrsalmat with wvlrsalmat, codlota with [0000000], lotacao with [ASSEMB LEGISLATIVA EST CEARA],;
        base with wbase, mvinc with wmvinc
   repl exonerado with wexonerado
   *
   sele 1
enddo
*
close data
*
copy file rapido.dbf to gfip0317.dbf
*
QUIT
*
//////////////////////////////////////
func mens(wstr,wpara,wlin,wcor,waviso)
//////////////////////////////////////
  local cor:= if(wcor = nil.or.!iscolor(),setcolor('w+/b'),setcolor(wcor)),i,j,k
  *
  setcursor(0)
  *
  if waviso # nil; tone(450,7); endif
  *
  if wpara = nil; wpara:= .f.; endif
  *
  if wlin = nil; wlin:= 24; endif
  *
  K:= setcolor('n/n'); @ wlin,0; setcolor(k)
  *
  for i:= 1 to len(wstr) / 2
      @ wlin,40 - i say subs(wstr,1,i)
      @ wlin,40 say subs(wstr,len(wstr) - i + 1,i)
      *
      j:= 0; do while j++ # 15; enddo
  next
  *
  @ wlin,0; @ wlin,(80 - len(wstr)) / 2 say wstr
  *
  if wpara; inkey(0); endif
  *
  setcolor(cor); setcursor(1)
  *
  return(.t.)

