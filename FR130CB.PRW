#INCLUDE "FINR130.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWCOMMAND.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE QUEBR				1
#DEFINE CLIENT				2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO				6
#DEFINE VENCTO				7
#DEFINE VENCREA				8
#DEFINE BANC				9
#DEFINE VL_ORIG				10
#DEFINE VL_NOMINAL			11
#DEFINE VL_CORRIG			12
#DEFINE VL_VENCIDO			13
#DEFINE NUMBC				14
#DEFINE VL_JUROS			15
#DEFINE ATRASO				16
#DEFINE HISTORICO			17
#DEFINE VL_SOMA				18
#DEFINE FILIA				19
#DEFINE PJSITA				20
#DEFINE IDVOO				21
#DEFINE CENT_CUSTO			22
#DEFINE BAIXA				23
#DEFINE VL_LIQUI			24 


STATIC _nTamSEQ

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FR130CB    ³ Autor ³OSCAR PROX          ³ Data ³ 17/04/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³TITULOS A RECEBER          .                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß           
*/
USER Function FR130CB()// U_FR130CB()

Local oReport

Private cMVBR10925 	:= SuperGetMv("MV_BR10925", ,"2")
Private dDtVenc 	:= dDatabase
Private lBQ10925	:= SuperGetMV("MV_BQ10925",,"2") == "1"
Private cPerg:= "XF130CB"

oReport := ReportDef()
oReport:PrintDialog() //2

Return

//__________________________________________________________________________________________________________________
Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2
Local cPictTit
Local nTamVal, nTamCli, nTamQueb, nTamJur, nTamNBco

oReport := TReport():New("FR130CB",STR0005,cPerg,{|oReport| ReportPrint(oReport)},STR0001+STR0002)

oReport:DisableOrientation(.T.)// Opção de impressão no formato Retrato desabilitada devido a não comportar mais informações.
oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.) // Imprime o total em linhas


//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 33 (Data Base)
PutDtBase()

pergunte(cPerg,.F.)								

cPictTit := PesqPict("SE1","E1_VALOR")
nTamVal	 := TamSx3("E1_VALOR")[1]
nTamCli	 := TamSX3("E1_CLIENTE")[1] + TamSX3("E1_LOJA")[1] + 20 + 2
nTamTit	 := TamSX3("E1_PREFIXO")[1] + TamSX3("E1_NUM")[1] + TamSX3("E1_PARCELA")[1] + 25
nTamBan	 := TamSX3("E1_PORTADO")[1] + TamSX3("E1_SITUACA")[1] + 1
nTamDte	 := TamSx3("E1_EMISSAO")[1]+3
nTamQueb := nTamCli + nTamTit + nTamBan + TamSX3("E1_TIPO")[1] + TamSX3("E1_NATUREZ")[1] + TamSX3("E1_EMISSAO")[1] + TamSX3("E1_VENCTO")[1] + TamSX3("E1_VENCREA")[1] + nTamBan + 2
nTamJur  := TamSX3("E1_JUROS")[1]

nTamNBco := TamSX3("E1_NUMBCO")[1]+20

//Secao 1 --> Analitico
oSection1 := TRSection():New(oReport,STR0079,{"SE1","SA1"},{STR0008,STR0047})//CLIENTE,NUMERO
//Secao 2 --> Sintetico
oSection2 := TRSection():New(oReport,STR0081)
TRCell():New(oSection1,"M0_CODIGO","SM0","EMPRESA"/*Titulo*/,/*Picture*/,12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_FILIAL","SM0","Filial"/*Titulo*/,/*Picture*/,12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CLIENTE",,STR0056,,nTamCli,.F.,,,,,,,.F.)  //"Codigo-Lj-Nome do Cliente"
TRCell():New(oSection1,"TITULO",,STR0057+CRLF+STR0058,,nTamTit,.F.,,,,,,,.T.)  //"Prf-Numero" + "Parcela"
TRCell():New(oSection1,"E1_TIPO","SE1",STR0059,,,.F.,,,,,,,.F.)  //"TP"
TRCell():New(oSection1,"E1_NATUREZ","SE1",STR0060,,+12,.F.,,,,,,,.F.)  //"Natureza"
TRCell():New(oSection1,"E1_EMISSAO","SE1",STR0061+CRLF+STR0062,,nTamDte,.F.,,,,,,,.F.)  //"Data de" + "Emissao"
TRCell():New(oSection1,"E1_VENCTO","SE1",STR0063+CRLF+STR0064,,nTamDte,.F.,,,,,,,.F.)  //"Vencto" + "Titulo"
TRCell():New(oSection1,"E1_VENCREA","SE1",STR0063+CRLF+STR0065,,nTamDte,.F.,,,,,,,.F.)  //"Vencto" + "Real"
TRCell():New(oSection1,"BANCO",,STR0083,,nTamBan,.F.,,,,,,,.F.)  //"Bco St"
TRCell():New(oSection1,"VAL_ORIG",,STR0067,cPictTit,nTamVal+22,.F.,,,,,,,.T.)  //"Valor Original"
TRCell():New(oSection1,"VAL_NOMI",,STR0068+CRLF+STR0069,cPictTit,nTamVal+16,.F.,,,,,,,.T.)  //"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection1,"VAL_CORR",,STR0068+CRLF+STR0070,cPictTit,nTamVal+16,.F.,,,,,,,.T.)  //"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection1,"E1_BAIXA","SE1","BAIXA",,nTamDte,.F.,,,,,,,.F.)  //"BAIXA"
TRCell():New(oSection1,"VAL_VENC",,STR0071+CRLF+STR0069,cPictTit,nTamVal+22,.F.,,,,,,,.T.)  //"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection1,"VAL_LIQUI",,"Vlr.Liq.S/Imp",cPictTit,nTamVal+22,.F.,,,,,,,.T.)  //"Titulos a Vencer" + "Valor Nominal" André
TRCell():New(oSection1,"E1_NUMBCO","SE1",STR0072+CRLF+STR0066,,nTamNBco,.F.,,,,,,,.T.)  //"Num" + "Banco"
TRCell():New(oSection1,"JUROS",,STR0073+CRLF+STR0074,cPictTit,nTamJur,.F.,,,,,,,.T.)  //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"DIA_ATR",,STR0075+CRLF+STR0076,,10,.F.,,,,,,,.T.)  //"Dias" + "Atraso"
TRCell():New(oSection1,"E1_HIST" ,"SE1",STR0077,,23,.F.,,,,,,,.T.)  //"Historico" 19
TRCell():New(oSection1,"VAL_SOMA",,STR0078,cPictTit,38,.F.,,,,,,,.T.)  //"(Vencidos+Vencer)"
TRCell():New(oSection1,"E1_PJSITA","SE1","PJSITA",,,.F.,,,,,,,.T.)
TRCell():New(oSection1,"ID_VOO",,"ID_VOO",,,.F.,,,,,,,.T.)
TRCell():New(oSection1,"CENT_CUSTO",,"CENTRO DE CUSTO",,,.F.,,,,,,,.T.)

TRCell():New(oSection2,"QUEBRA",,STR0008,,nTamQueb-nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_NOMI",,STR0068+CRLF+STR0069,cPictTit,nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_CORR",,STR0068+CRLF+STR0070,cPictTit,nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_VENC",,STR0071+CRLF+STR0069,cPictTit,nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_JUROS",,STR0073+CRLF+STR0074,cPictTit,nTamVal,.F.,,,,,,,.T.)
TRCell():New(oSection2,"TOT_SOMA",,STR0078,cPictTit,nTamVal,.F.,,,,,,,.T.)

oSection1:Cell("BANCO")   :SetHeaderAlign("CENTER")
oSection1:Cell("VAL_ORIG"):SetHeaderAlign("CENTER")
oSection1:Cell("VAL_NOMI"):SetHeaderAlign("CENTER")
oSection1:Cell("VAL_CORR"):SetHeaderAlign("CENTER")
oSection1:Cell("VAL_VENC"):SetHeaderAlign("CENTER")
oSection1:Cell("VAL_LIQUI"):SetHeaderAlign("CENTER")
oSection1:Cell("E1_NUMBCO"):SetHeaderAlign("CENTER")
oSection1:Cell("JUROS")   :SetHeaderAlign("CENTER")
oSection1:Cell("DIA_ATR") :SetHeaderAlign("LEFT")
oSection1:Cell("E1_HIST") :SetHeaderAlign("CENTER")
oSection1:Cell("VAL_SOMA"):SetHeaderAlign("LEFT")
oSection1:Cell("CENT_CUSTO") :SetHeaderAlign("CENTER")
oSection1:Cell("ID_VOO") :SetHeaderAlign("CENTER")

Return oReport

/*
Impressão do Relatório
*/
Static Function ReportPrint(oReport)
Local oSection1  	:= oReport:Section(1)
Local oSection2  	:= oReport:Section(2)
Local nOrdem 		:= oSection1:GetOrder()
Local oBreak
Local oTotVenc
Local oTotCorr

Local aDados[24]
Local dOldDtBase 	:= dDataBase
Local dOldData		:= dDatabase
Local cCond1		:= ""
Local cCond2
Local nTit0			:=0
Local nTit1			:=0
Local nTit2			:=0
Local nTit3			:=0
Local nTit4			:=0
Local nTit5			:=0
Local nTotJ			:=0
Local nTot0			:=0
Local nTot1			:=0
Local nTot2			:=0
Local nTot3			:=0
Local nTot4			:=0
Local nTotTit		:=0
Local nTotJur		:=0
Local nAtraso		:=0
Local nTotAbat		:=0
Local nSaldo		:=0
Local dDataReaj
Local dDataAnt 		:= dDataBase
Local cChaveSe1
Local dDtCtb   	:= CTOD("//")
Local cTipos  		:= ""
Local nTotVenc		:= 0
Local nTotGeral 	:= 0
Local cNomFor		:= ""
Local cNumBco		:= ""
Local cCarAnt 		:= ""
Local lClcMultLj := ( SuperGetMv("MV_JURTIPO",,"") == "L" ) .Or. ( SuperGetMv("MV_LJINTFS", ,.F.) )
Local nMulta	 := 0
// *************************************************
// Utilizada para guardar os abatimentos baixados *
// que devem subtrair o saldo do titulo principal.*
// *************************************************
Local nBx,aAbatBaixa	:= {}
Local ndecs			:= 0
Local nDescont		:= 0
Local cMoeda		:= ""

Local dUltBaixa		:= STOD("")
Local dVencRea		:= STOD("")
Local cFilterUser	:= ""
Local aFiliais 		:= {}

Local nValPcc	  	:= 0
Local cFilQry		:= ""
Local lAS400		:= (Upper(TcSrvType()) != "AS/400" .And. Upper(TcSrvType()) != "ISERIES")
Local cMvDesFin		:= SuperGetMV("MV_DESCFIN",,"I")
Local lFJurCst		:= Existblock("FJURCST")	// Ponto de entrada para calculo de juros

Local lRelCabec		:= .F.
Local cFilNat 		:= ""
Local lAbatIMPBx  	:= .F.
Local aRecSE1Cmp	:= {}

Local cSeq := ""
Local nRecSA1 := 0
Local nTotReg := 0

Local cCampos := ""
Local cQueryP := ""
Local cSelect := ""
Local cOper	:= IIf(Upper(TcGetDb())$'ORACLE.POSTGRES.DB2.INFORMIX','||','+')

Local nCountAbt := 1
Local lVl_Corr   := .T.
Local cListDesc 	:= FN022LSTCB(2)	//Obtem a lista de situacos de cobrancas Descontadas
Local oDlg := Nil
Local cTitul := "Selecione as Empresas a serem contempladas."
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )
Local oChk := Nil
Local lChk := .F.
Local oLbx := Nil
Local aEmps := {}
Local aEmps2:={}
Local aEmps3:={}
Local cEmps:=""
Local cSM0:=""
Local cNomeEmp:="",cUnid:=""
Local j:=0
Local nOpc	:= 0
Local cQuery1:="",cQuery2:="",cQuery3:=""
Local cCliTit:=""

//Local aAreaSEs:=lj7GetArea({"SE1","SE5","SA1","SA6","SED"})
Local _aAux   := {}
Local i       := 0
Local _aAreaSM0 := {}
Local _oAppBk := oApp //Guardo a variavel resposavel por componentes visuais
Local _cEmpAtu , _cFilAtu
Local nCorrig:=0

Private cTitulo		:= ""
Private dBaixa 		:= dDataBase
Private nAbatim		:= 0 
Private nJuros 		:= 0
Private aCliAbt		:= {}	// Clientes com titulos de abatimento
Private lImpSintTbl := oReport:lXlsTable .And. mv_par11 == 1
Private nTotal := 0
Private cEmpNew:="",cNewEmp:="",cEmpbkp:="",cFilbkp:=""
Private cModo:=""

If mv_par07 == 0
	mv_par07 := 1
EndIf
nDecs  := Msdecimais(mv_par07)
cMoeda := Alltrim(Str(mv_par07,2))

dbSelectArea("SM0")
_aAreaSM0 := SM0->(GetArea())
_cEmpAtu := SM0->M0_CODIGO //Guardo a empresa atual
_cFilAtu := SM0->M0_CODFIL //Guardo a filial atual


aEmps:={}
dbSelectArea("SM0")
SM0->(DBGOTOP())
Do While !SM0->(Eof())
	If SM0->M0_CODIGO == cEmpNew .and. SM0->M0_NOME==cNewEmp
		SM0->(dbSkip())
	  	Loop
	EndIf
    AADD(aEmps,{,SM0->M0_CODIGO, SM0->M0_NOME})
    cEmpNew:=SM0->M0_CODIGO// vr a necessidade de passar valor neste momento
    cNewEmp:=SM0->M0_NOME  
	SM0->(dbSkip())
EndDo

SM0->(dbGotop())
//SM0->(dbsetOrder(1))
//SM0->(dbSeek(cEmpAnt+cFilAnt))//empresa posicionada após criar array

DEFINE MSDIALOG oDlg TITLE cTitul FROM 0,0 TO 375,700 PIXEL
oDlg:lEscClose := .F.
	
@ 001,005 LISTBOX oLbx FIELDS HEADER " ", "Empresa","Nome" SIZE 345,162 OF oDlg PIXEL ON dblClick(aEmps[oLbx:nAt,1] := !aEmps[oLbx:nAt,1],oLbx:Refresh())
	
oLbx:SetArray( aEmps )
oLbx:bLine := {|| {Iif(aEmps[oLbx:nAt,1],oOk,oNo),aEmps[oLbx:nAt,2],aEmps[oLbx:nAt,3]}}
	
@ 174,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ON CLICK(aEval(aEmps,{|x| x[1]:=lChk}),oLbx:Refresh())
DEFINE SBUTTON FROM 174, 319 TYPE 1 ACTION ;
(Iif(AScan( aEmps, {|x| x[1]==.T.}) == 0,MsgAlert("Precisa marcar no mínimo uma empresa.",cTitul),(nOpc:=1,oDlg:End()))) ENABLE OF oDlg

DEFINE SBUTTON FROM 174,286 TYPE 2 ACTION (nOpc:=0,oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER 

If nOpc == 1
	For j:=1 to len(aEmps)
		if aEmps[j,1]==.T.
			AADD(aEmps2,{aEmps[j,2], aEmps[j,3]})
		ENDIF 
	Next
EndIF

If nOpc==0
	MsgAlert("Relatório cancelado pois nenhuma empresa foi escolhida.")
	Return
EndIf

aEmps3:={}
For j:=1 to len(aEmps2)
	cEmps+=aEmps2[j,1]+"/"
Next
cEmps:=Substr(cEmps,1,len(cEmps)-1)

Do While !SM0->(Eof())	
		If !SM0->M0_CODIGO $ cEmps
			SM0->(dbSkip())
	  		Loop
		EndIf
    	AADD(aEmps3,{SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOMECOM, SM0->M0_NOME, SM0->M0_Filial})         
		SM0->(dbSkip())
EndDo
cEmpbkp:=cEmpAnt
cFilbkp:=cFilAnt

For j=1 to Len(aEmps3)                         
              
	IncProc()
	If aEmps3[j] [1]<>cSM0
		cSM0      := aEmps3[j] [1]
		cEmpAnt   := aEmps3[j] [1]
		cFilAnt   := aEmps3[j] [2]
		cNomeEmp  := aEmps3[j] [3]
		cUnid     := aEmps3[j] [4]
		
		dbCloseAll() //Fecho todos os arquivos abertos
		OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(aEmps3[j][1] + aEmps3[j][2],.T.)) //Posiciona Empresa
		cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
		cFilAnt := SM0->M0_CODFIL
		OpenFile(cEmpAnt + cFilAnt) //Abro a empresa que eu desejo trabalhar


		oSection1:Cell("EMPRESA"   ):SetValue(cNomeEmp)
		oSection1:Cell("FILIAL"    ):SetBlock( { || aDados[FILIA]    			})
		oSection1:Cell("CLIENTE"   ):SetBlock( { || aDados[CLIENT]    			})
		oSection1:Cell("TITULO"    ):SetBlock( { || aDados[TITUL]     			})
		oSection1:Cell("E1_TIPO"   ):SetBlock( { || aDados[TIPO]      			})
		oSection1:Cell("E1_NATUREZ"):SetBlock( { || MascNat(aDados[NATUREZA]) 	})
		oSection1:Cell("E1_EMISSAO"):SetBlock( { || aDados[EMISSAO]   			})
		oSection1:Cell("E1_VENCTO" ):SetBlock( { || aDados[VENCTO]    			})
		oSection1:Cell("E1_VENCREA"):SetBlock( { || aDados[VENCREA]   			})
		oSection1:Cell("BANCO"     ):SetBlock( { || aDados[BANC]      			})
		oSection1:Cell("VAL_ORIG"  ):SetBlock( { || aDados[VL_ORIG]				})
		oSection1:Cell("VAL_NOMI"  ):SetBlock( { || aDados[VL_NOMINAL]			})
		oSection1:Cell("VAL_CORR"  ):SetBlock( { || aDados[VL_CORRIG]			})
		oSection1:Cell("VAL_VENC"  ):SetBlock( { || aDados[VL_VENCIDO]			})
		oSection1:Cell("VAL_LIQUI" ):SetBlock( { || aDados[VL_LIQUI]			})
		oSection1:Cell("E1_BAIXA"  ):SetBlock( { || aDados[BAIXA]				})
		oSection1:Cell("E1_NUMBCO" ):SetBlock( { || aDados[NUMBC]     			})
		oSection1:Cell("JUROS"     ):SetBlock( { || aDados[VL_JUROS]  			})
		oSection1:Cell("DIA_ATR"   ):SetBlock( { || aDados[ATRASO]    			})
		oSection1:Cell("E1_HIST"   ):SetBlock( { || aDados[HISTORICO] 			})
		oSection1:Cell("VAL_SOMA"  ):SetBlock( { || aDados[VL_SOMA]   			})
		oSection1:Cell("E1_PJSITA" ):SetBlock( { || aDados[PJSITA] 				})
		oSection1:Cell("ID_VOO"    ):SetBlock( { || aDados[IDVOO]   			})	
		oSection1:Cell("CENT_CUSTO" ):SetBlock( { || aDados[CENT_CUSTO]   		})	
		
		oSection1:Cell("VAL_SOMA"):Enable()

		//Cabeçalho do Relatório sintético
		If mv_par11 == 2 //1 = Analitico - 2 = Sintetico
			oSection2:SetHeaderPage()
		Endif
		
		//Relatorio Analitico
		TRPosition():New(oSection1,"SA1",1,{|| xFilial("SA1")+SE1_->E1_CLIENTE+SE1_->E1_LOJA})

		//Define as quebras da sessao, conforme a ordem escolhida //OSCAR TIRAR QUEBRAS
        IF nOrdem == 1 
			oBreak := TRBreak():New(oSection1, {|| SE1_->(E1_FILIAL+E1_CLIENTE+E1_LOJA)} , {|| STR0037 + cNomFor}) //"S U B - T O T A L --->"
			oBreak:OnBreak( { |x,y| cNomFor, FR130TotSoma( oTotCorr, oTotVenc, @nTotVenc, @nTotGeral ) } )
		Endif
		
		
		If mv_par11 == 1 //1 = Analitico - 2 = Sintetico
			//Altera o texto do Total Geral
			oReport:SetTotalText({|| STR0038 + "(" + AllTrim(Str(nTotTit))+" "+If(nTotTit > 1, STR0039, STR0040)+")"})
			TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
			TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
			oTotCorr := TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
			oTotVenc := TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
			oTotVenc := TRFunction():New(oSection1:Cell("VAL_LIQUI"),"","SUM",oBreak,,,,.F.,.T.)
			TRFunction():New(oSection1:Cell("JUROS"),"","SUM",oBreak,,,,.F.,.T.)
			TRFunction():New(oSection1:Cell("VAL_SOMA"),"","ONPRINT",oBreak,,PesqPict("SE1","E1_VALOR"),{|lSection, lReport| If (lReport, nTotGeral, nTotVenc)},.F.,.T.)
		
		Endif
		
		//Nao retire esta chamada. Verifique antes !!!
		//Ela é necessaria para o correto funcionamento da pergunte 35 (Data Base)
		PutDtBase()
		
		
		//Acerta a database de acordo com o parametro
		If mv_par12 == 1    // Considera Data Base
			dBaixa := dDataBase := mv_par23
		Else
			If dDataBase < mv_par23
				dBaixa := dDataBase := mv_par23
			EndIf
		Endif
		
		
		oSection1:Init()
		oSection2:Init()
		

		If !lRelCabec
			If mv_par11 == 1  //1 = Analitico - 2 = Sintetico
				cTitulo := oReport:Title() + STR0080 + " " + GetMv("MV_MOEDA" +cMoeda)  //"Posicao dos Titulos a Receber"+" - Analitico"
			Else
				cTitulo := oReport:Title() + STR0080 + " " + GetMv("MV_MOEDA" +cMoeda)  //"Posicao dos Titulos a Receber"+" - Sintetico"
			EndIf
		EndIf

		If !lRelCabec
			If mv_par11 == 1   //1 = Analitico - 2 = Sintetico
				cTitulo += STR0026 //" - Analitico"
			Else
				cTitulo += STR0027 //" - Sintetico"
			EndIf
		EndIf

		dbSelectArea("SE1")
		dbSelectArea("SA1")

		// Verifica os titulos que possuem qualquer tipo de abatimento, para evitar chamada da SumAbat sem necessidade
		cQuery := "SELECT "
		cQuery += "SE1.E1_CLIENTE, SE1.E1_LOJA "
		cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
		cQuery += "WHERE "
		cQuery += " SE1.E1_TIPO LIKE '%-' " //retirado filtro por filial
		cQuery += "AND SE1.D_E_L_E_T_ = ' ' "
		cQuery += "GROUP BY SE1.E1_CLIENTE, SE1.E1_LOJA "

		cQuery := ChangeQuery(cQuery)
		If !Select( "TRBABT" ) == 0
			TRBABT->(dbCloseArea())
		Endif
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBABT",.T.,.T.)

		While TRBABT->( ! EoF() )
			AAdd( aCliAbt, {TRBABT->( E1_CLIENTE + E1_LOJA ),nCountAbt} )
			TRBABT->( dbSkip() )
			nCountAbt++		
		EndDo

		dbSelectArea( "SE1" )

		TRBABT->( dbCloseArea() )
        cNewEmp:=cSM0
		cFilterUser := oSection1:GetSqlExp("SE1")
		cQueryP := ""
		cCampos := ""
		cQuery  := ""
		
		cSelect:= "SELECT E1_FILIAL, E1_NOMCLI, E1_CLIENTE, E1_LOJA, E1_NUM, E1_PREFIXO,E1_BAIXA,E1_EMISSAO, E1_VENCTO, E1_VENCREA,E1_VENCORI, E1_VALOR, E1_NATUREZ, E1_TIPO, R_E_C_N_O_ , E1_PARCELA,E1_EMIS1,E1_MOVIMEN,E1_SITUACA,E1_PORCJUR,E1_INSS,E1_CSLL,E1_PIS,E1_COFINS,E1_IRRF,E1_ISS," //+ SubStr(cCampos,2)
		cSelect+= " E1_PORTADO, E1_FATURA, E1_TXMOEDA, E1_HIST, E1_ACRESC, E1_SDACRES, E1_DECRESC, E1_SDDECRE, E1_VALJUR, E1_SALDO, E1_MOEDA, E1_NFELETR,E1_MSFIL,E1_SERIE,E1_MSEMP, E1_IDCNAB,E1_NUMBCO,E1_AGEDEP,E1_CONTA,E1_PJSITA,E1_TITPAI"
		cQuery += "  FROM "+RetSqlName("SE1")+" SE1"
		//cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'" //RETIRADO FILTRO POR FILIAL
		cQuery += "   WHERE D_E_L_E_T_ = ' ' "
			
		// Valida se foi informado titulos de abatimentos na pergunta "Imprime tipos"
		If !('-' $ mv_par18)
			cQuery += "   AND E1_TIPO NOT LIKE '%-' "    // Abatimentos serao incluidos na fase 2
		EndIf
		
		IF nOrdem = 1 .and. !lRelCabec
			cChaveSe1 := "SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO"
			cOrder := SqlOrder(cChaveSe1)
			//cCond1	:= "SE1_->E1_CLIENTE <= mv_par02"
			cCond2	:= "SE1_->E1_CLIENTE + SE1_->E1_LOJA"
			cTitulo	+= STR0017  //" - Por Cliente"
			lRelCabec := .T.
		ElseIf nOrdem == 2 .and. !lRelCabec
			cChave := "SE1.E1_FILIAL+SE1.E1_NUM+SE1.E1_TIPO+SE1.E1_PREFIXO+SE1.E1_PARCELA"
			cOrder := SqlOrder(cChave)
			//cCond1	:= "SE1_->E1_NUM <= mv_par06"
			cCond2	:= "SE1_->E1_NUM"
			cTitulo	+= STR0048 //" - Numero/Prefixo"
			lRelCabec := .T.
		Endif

		oReport:SetTitle(cTitulo)

		If mv_par26 == 2
			cQueryP += " AND SE1.E1_VENCTO between '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02) + "'"
		Else
			cQueryP += " AND SE1.E1_VENCREA between '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02) + "'"
		Endif
		cQueryP += " AND SE1.E1_NATUREZ BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
		cQueryP += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' "
		If ( mv_par25 == 2 ) .and. mv_par06 >= mv_par23
			cQueryP += " AND '" + DtoS(mv_par23) + "'"
		Else
			cQueryP += " AND '" + DTOS(mv_par06) + "'"
		Endif
		//cQueryP += " AND SE1.E1_LOJA    between '" + mv_par21        + "' AND '" + mv_par22 + "'"
		cQueryP += " AND SE1.E1_EMIS1  Between '"+ DTOS(mv_par14)+"' AND '"+DTOS(mv_par15)+"'"
		If !Empty(mv_par18) // Deseja imprimir apenas os tipos do parametro 28
			cQueryP += " AND SE1.E1_TIPO IN "+FormatIn(mv_par18,";") 
		ElseIf !Empty(mv_par19) // Deseja excluir os tipos do parametro 29
			cQueryP += " AND SE1.E1_TIPO NOT IN "+FormatIn(mv_par19,";")
		EndIf
		If mv_par10 == 2
			cQueryP += " AND SE1.E1_SITUACA NOT IN " + FormatIn(cListDesc,"|")			//sitcob
		Endif
		//If mv_par12 == 2
			cQueryP += ' AND SE1.E1_SALDO <> 0'
		//Endif
		If mv_par21 == 1
			cQueryP += " AND SE1.E1_FLUXO <> 'N'"
		Endif
		
		//____________________________________________
		// Verifica se deve imprimir outras moedas
		//____________________________________________
		If mv_par17 == 2 // nao imprime
			cQueryP += " AND SE1.E1_MOEDA = "+cMoeda
		Endif

		cQuery += cQueryP			
	    // Fase 1 - Query 1 somente os titulos sem os abatimentos
		cQuery1 := 	 cSelect + cQuery
	    // Fase 2 - Query 2 somente os abatimentos dos titulos listados na Query1
		cQuery2 := cSelect + " FROM "+RetSqlName("SE1")+" TMP " 
		cQuery2 += " WHERE TMP.E1_TIPO LIKE '%-' AND "
		//cQuery2 += "    TMP.E1_FILIAL = '" + xFilial("SE1") + "' AND "
		cQuery2 +=  " 	TMP.E1_TITPAI IN ( "
		cQuery2 += "	SELECT SE1.E1_PREFIXO " + cOper + " SE1.E1_NUM " + cOper 
		cQuery2 += "	SE1.E1_PARCELA " + cOper + " SE1.E1_TIPO " + cOper + " SE1.E1_CLIENTE " + cOper + " SE1.E1_LOJA "
		 
		cQuery2 += cQuery
		cQuery3 :=  cQuery1  + " UNION "  + cQuery2 +  " ORDER BY "+ cOrder		
		cQuery1 := ChangeQuery(cQuery1)
		cQuery3 := ChangeQuery(cQuery3)
		/*/Arquivo gerado .sql - salvo na maquina/*/
		MemoWrite("C:\microsiga\titulos_a_receber"+cNewEmp +".sql",cQuery3)
		
		If !Select( "SE1_" ) == 0
			SE1_->(dbCloseArea())
		Endif
		
		If mv_par20 == 3
			cQuery1 := (cQuery1 + " ORDER BY " + cOrder)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), 'SE1_', .F., .T.)
			//TCQUERY cQuery1 New Alias (cAliasCB)
		Else
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery3), 'SE1_', .F., .T.)
			//TCQUERY cQuery3 New Alias ('SE1_')
		Endif

		cQuery:=""
		cQueryp:=""
		cQuery1:=""
		cQuery2:=""
		cQuery3:=""

		SE1_->(DBGOTOP())
		_cFilAtu:=SE1_->E1_FILIAL
		
		While !SE1_->(Eof()) //.And. &cCond1
			IncProc()

			Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
			If mv_par11 == 1
				Store 0 To nTot0,nTot1,nTot2,nTot3,nTot4,nTotJ
			EndIf
			IF _cFilAtu<>SE1_->E1_FILIAL
				_cFilAtu:=SE1_->E1_FILIAL
				cFilAnt:=_cFilAtu
			EndIF

			//______________________________________________
			// Carrega data do registro para permitir 
			// posterior analise de quebra por mes.   
			//______________________________________________
			dDataAnt :=Iif(mv_par26 = 2, STOD(SE1_->E1_VENCTO), STOD(SE1_->E1_VENCREA))

			cCarAnt := &cCond2

			//___________________________________________________________________
			//Se nao atender a condicao para impressao, despreza o registro
			//___________________________________________________________________
			If !Fr130Cond(cTipos)
				SE1_->(DbSkip())
				Loop
			EndIf
					// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
			dDtCtb	:=	CTOD("//")
			dDtCtb	:= Iif(Empty(SE1_->E1_EMIS1),SE1_->E1_EMISSAO,SE1_->E1_EMIS1)
			SE1->(dbSetOrder(1))
			SE1->(MsSeek(SE1_->E1_FILIAL+SE1_->E1_PREFIXO + SE1_->E1_NUM + SE1_->E1_PARCELA + SE1_->E1_TIPO, .T.))

			If STOD(dDtCtb) < mv_par14 .Or. STOD(dDtCtb) > mv_par15
				SE1_->( dbSkip() )
				Loop
			Endif

			//dbSelectArea("SE1")
			IF (SE1_->E1_TIPO $ MVABATIM	+"/"+MVFUABT  .And. mv_par20 != 1) .Or.;
				(STOD(SE1_->E1_EMISSAO) > mv_par23 .and. mv_par25 == 2)
				IF !Empty(SE1_->E1_TITPAI)
					aAdd( aAbatBaixa , { SE1_->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1_->E1_TITPAI } )
				Else
					cMTitPai := FTITPAI()
					aAdd( aAbatBaixa , { SE1_->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , cMTitPai } )
				EndIf
				SE1_->(dbSkip())
				Loop
			Endif

			//Quando Retroagir saldo, data menor que o solicitado e o titulo estiver
			//baixado nao mostrar no relatorio
			If (mv_par12 == 1 .and. cMVBR10925 == "1" .and. STOD(SE1_->E1_EMISSAO) <= mv_par23 .and. SE1_->E1_TIPO $ "PIS/COF/CSL")
				SE1_->(dbSkip())
				Loop
			EndIf

			// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
			If STOD(SE1_->E1_VENCREA) < dDataBase
				If mv_par09 == 2 .And. RecMoeda(STOD(SE1_->E1_VENCREA),cMoeda) > 0
					dDataReaj := STOD(SE1_->E1_VENCREA)
				Else
					dDataReaj := dDataBase
				EndIf
			Else
				dDataReaj := dDataBase
			EndIf

			If mv_par12 == 1	// Considera Data Base
				//dbSelectArea("SE1")
				SE1->(dbSetOrder(1))
				SE1->(MsSeek(SE1_->E1_FILIAL+SE1_->E1_PREFIXO + SE1_->E1_NUM + SE1_->E1_PARCELA + SE1_->E1_TIPO, .T.))
				nSaldo := SaldoTit(SE1_->E1_PREFIXO,SE1_->E1_NUM,SE1_->E1_PARCELA,SE1_->E1_TIPO,SE1_->E1_NATUREZ,"R",SE1_->E1_CLIENTE,mv_par07,dDataReaj,mv_par23,SE1_->E1_LOJA,,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(STOD(SE1_->E1_EMISSAO),SE1_->E1_MOEDA)),mv_par24,.T.)
				dbSelectArea("SE1_")
				
				//Verifica se existem compensações em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimentações da filial corrente. Nao deve processar quando existe somente uma filial.
				If mv_par27 == 1  .and. ( nSaldo != SE1_->E1_SALDO ) .and. aScan( aRecSE1Cmp , { |x| x[1] == SE1_->( R_E_C_N_O_ )} ) > 0
					proclogatu("INICIO",STR0085) //"PESQUISA DE COMPENSAï¿½ï¿½O DE MULTI-FILIIAS"
					nSaldo -= Round(NoRound( xMoeda( FRVlCompFil("R",SE1_->E1_PREFIXO,SE1_->E1_NUM,SE1_>E1_PARCELA,SE1_->E1_TIPO,SE1_->E1_CLIENTE,SE1_->E1_LOJA,mv_par24,aFiliais,cFilQry,lAS400),;
									SE1_->E1_MOEDA,mv_par07,dDataReaj,ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(SE1_->E1_EMISSAO,SE1_->E1_MOEDA) ) ),;
									nDecs+1),nDecs)
					proclogatu("FIM",STR0085)//Log pesquisa de compensação
				EndIf
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE1_->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1_->E1_DECRESC > 0 .And. SE1_->E1_SDDECRE == 0
					nSAldo -= SE1_->E1_DECRESC
				Endif
				
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE1_->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1_->E1_ACRESC > 0 .And. SE1_->E1_SDACRES == 0
					nSAldo += SE1_->E1_ACRESC
				Endif

				//Se abatimento verifico a data da baixa.
				//Por nao possuirem movimento de baixa no SE5, a saldotit retorna
				//sempre saldo em aberto quando mv_par20 = 1 (Abatimentos = Lista)
				If SE1_->E1_TIPO $ MVABATIM	+"/"+MVFUABT .and. ;
					(stod(SE1_->E1_BAIXA) <= dDataBase .and. !Empty(SE1_->E1_BAIXA)) .or. ;
					(STOD(SE1_->E1_MOVIMEN) <= dDataBase .and. !Empty(SE1_->E1_MOVIMEN))	 .and.;
					SE1_->E1_SALDO == 0
					nSaldo := 0
					IF !Empty(SE1_->E1_TITPAI)
						aAdd( aAbatBaixa , { SE1_->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1_->E1_TITPAI } )
					Else
						cMTitPai := FTITPAI()
						aAdd( aAbatBaixa , { SE1_->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , cMTitPai } )
					EndIf
					aAdd( aAbatBaixa , { SE1_->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) , SE1_->E1_TITPAI } )
				Endif
				//certifica-se de que está posicionado no cliente correto, para que seja deduzido corretamente o IR baixado do saldo do tï¿½tulo.
				cQuery := "SELECT "
				cQuery += "SA1.A1_COD, SA1.A1_LOJA, R_E_C_N_O_,A1_RECPIS,A1_RECCOFI,A1_RECCSLL,A1_NOME,A1_IRBAX,A1_NREDUZ,A1_TEL,A1_DDD  "
				cQuery += "FROM "+RetSqlName("SA1")+" SA1 "
				cQuery += "WHERE "
				cQuery += " SA1.A1_COD =  '"+SE1_->E1_CLIENTE+"' "
				cQuery += "AND SA1.A1_LOJA = '"+SE1_->E1_LOJA+"' "
				cQuery += "AND SA1.D_E_L_E_T_ = ' ' "

				cQuery := ChangeQuery(cQuery)
				If !Select( "SA1_" ) == 0
					SA1_->(dbCloseArea())
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SA1_",.T.,.T.)

				SA1_->(dbGoTop())

				cCliTit:=SA1_->A1_COD

				If cMVBR10925 == "1" .And. lBQ10925
					nRecSA1 := SA1_->R_E_C_N_O_									
				EndIf
				If ( cMVBR10925 == "1" .and. STOD(SE1_->E1_EMISSAO) <= mv_par23 .and. !(SE1_->E1_TIPO $ "PIS/COF/CSL").and. !(SE1_->E1_TIPO $ MVABATIM) ) .AND. ( "S" $ (SA1_->(A1_RECPIS+A1_RECCOFI+A1_RECCSLL) ) )

					nValPcc := SumAbatPCC(SE1_->E1_PREFIXO,SE1_->E1_NUM,SE1_->E1_PARCELA,dBaixa,SE1_->E1_CLIENTE,SE1_->E1_LOJA,mv_par07)
					nSaldo -= nValPcc
					//tratamento para emissï¿½o correta do saldo do tï¿½tulo, quando o PCC+IR estiver na baixa e for realizado baixa parcial.
					If nRecSA1 > 0
						//SE5->(DbSetOrder(7))
						cSeq := "01" 				
						cQuery := "SELECT *"
						cQuery += "FROM "+RetSqlName("SE5")+" SE5 "
						cQuery += "WHERE "
						cQuery += " SE5.D_E_L_E_T_ = ' ' "
						cQuery += "AND E5_FILIAL = '"+SE1_->E1_FILIAL+"'	"
						cQuery += "AND E5_PREFIXO = '"+SE1_->E1_PREFIXO+"'	"
						cQuery += "AND E5_NUMERO = '"+SE1_->E1_NUM+"'	"
						cQuery += "AND E5_PARCELA = '"+SE1_->E1_PARCELA+"'	"
						cQuery += "AND E5_TIPO = '"+SE1_->E1_TIPO+"'	"
						cQuery += "AND E5_CLIFOR = '"+SE1_->E1_CLIENTE+"'	"
						cQuery += "AND E5_LOJA = '"+SE1_->E1_LOJA+"'	"
						cQuery += "Order by E5_FILIAL,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA,E5_SEQ	"
						cQuery := ChangeQuery(cQuery)
						If !Select( "SE5_" ) == 0
							SE5_->(dbCloseArea())
						Endif

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE5_",.T.,.T.)

						SE5_->(dbGoTop())

						while SE5_->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)== SE1_->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)+cSeq .And. nSaldo <> SE1_->E1_SALDO .And. AllTrim(SA1_->A1_IRBAX) = "1" .And. SE5_->E5_VRETIRF > 0			
							nSaldo := Iif(SE5_->E5_DATA < mv_par23,  (nSaldo - SE5_->E5_VRETIRF), nSaldo)
							cSeq := IIF(cSeq > "08", ALLTRIM(STR(VAL(cSeq)+1)), "0" + ALLTRIM(STR(VAL(cSeq)+1)))  	
						EndDo										
					Endif					
				EndIf
				nRecSA1 := 0				
				If SE1_->E1_TIPO == "RA "   //somente para titulos ref adiantamento verifica se nao houve cancelamento da baixa posterior data base (mv_par36)
					nSaldo -= F130TipoBA()
				EndIf
			Else
				//dbSelectArea("SE1")
				SE1->(dbSetOrder(1))
				SE1->(MsSeek(SE1_->E1_FILIAL+SE1_->E1_PREFIXO + SE1_->E1_NUM + SE1_->E1_PARCELA + SE1_->E1_TIPO, .T.))
				nSaldo := xMoeda((SE1_->E1_SALDO+SE1_->E1_SDACRES-SE1_->E1_SDDECRE),SE1_->E1_MOEDA,mv_par07,dDataReaj,ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(STOD(SE1_->E1_EMISSAO),SE1_->E1_MOEDA)))
			Endif

			IF AlLtrim(SE1_->E1_TIPO)=='NF'
				cQuery := "SELECT  "
				cQuery += "SC5.C5_NUM, SC5.C5_NOTA,C5_SERIE,C5_IDFRET  "
				cQuery += "FROM "+RetSqlName("SC5")+" SC5 "
				cQuery += "WHERE "
				cQuery += " SC5.C5_NOTA =  '"+SE1_->E1_NUM+"' "
				cQuery += "AND SC5.C5_CLIENTE = '"+SE1_->E1_CLIENTE+"' "
				cQuery += "AND SC5.C5_LOJACLI = '"+SE1_->E1_LOJA+"' "
				cQuery += "AND SC5.D_E_L_E_T_ = ' ' "

				cQuery := ChangeQuery(cQuery)
				If !Select( "SC5_" ) == 0
					SC5_->(dbCloseArea())
				Endif
				//PEDIDO
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SC5_",.T.,.T.)

				SC5_->(dbGoTop())

				cQuery := "SELECT DISTINCT "
				cQuery += "SD2.D2_PEDIDO, D2_DOC,D2_SERIE,D2_CCUSTO  "
				cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
				cQuery += "WHERE "
				cQuery += " SD2.D2_PEDIDO =  '"+SC5_->C5_NUM+"' "
				cQuery += "AND SD2.D2_DOC =  '"+SE1_->E1_NUM+"' "
				cQuery += "AND SD2.D2_CLIENTE = '"+SE1_->E1_CLIENTE+"' "
				cQuery += "AND SD2.D2_LOJA = '"+SE1_->E1_LOJA+"' "
				cQuery += "AND SD2.D_E_L_E_T_ = ' ' "
				cQuery += "AND SD2.D2_CCUSTO <> ' ' "

				cQuery := ChangeQuery(cQuery)
				If !Select( "SD2_" ) == 0
					SD2_->(dbCloseArea())
				Endif
				//ITENS DA NF
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SD2_",.T.,.T.)

				SD2_->(dbGoTop())

				
				IF ALLTRIM(SC5_->C5_IDFRET)<>""
					aDados[IDVOO] := SC5_->C5_IDFRET
				Else
					aDados[IDVOO] :=""
				ENDIF
				IF SD2_->D2_CCUSTO<>""
					aDados[CENT_CUSTO] := SD2_->D2_CCUSTO
				Else
					aDados[CENT_CUSTO] := ""
				Endif
			Else
				aDados[IDVOO] :=""
				aDados[CENT_CUSTO] := ""
			EndIf

			IF aDados[CENT_CUSTO]<>""
				DBSelectArea("CTT")
				CTT->(DBSetOrder(1))
				aDados[CENT_CUSTO]:=Alltrim(aDados[CENT_CUSTO])+" - "+Posicione("CTT",1,xFilial("CTT")+SD2_->D2_CCUSTO,"CTT_DESC01")
			EndIF
			//Caso exista desconto financeiro (cadastrado na inclusao do titulo),
			//subtrai do valor principal.
			If Empty( SE1_->E1_BAIXA ) .Or. cMvDesFin == "P"
				nDescont := FaDescFin("SE1",dBaixa,SE1_->E1_SALDO,1,.T.,.F.)
				If mv_par07 > 1
					If SE1_->E1_MOEDA == mv_par07
						nDescont := xMoeda((nDescont),1,mv_par07,dDataReaj,ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(STOD(SE1_->E1_EMISSAO),SE1_->E1_MOEDA)))
					Else
						nDescont := xMoeda((nDescont),SE1_->E1_MOEDA,mv_par07,dDataReaj,ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(STOD(SE1_->E1_EMISSAO),SE1_->E1_MOEDA)))
					EndIf
				EndIf
				If nDescont > 0
					nSaldo := nSaldo - nDescont
				Endif
			EndIf

			If ! SE1_->E1_TIPO $ MVABATIM	+"/"+MVFUABT
				If ! (SE1_->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
						!( mv_par12 == 2 .And. nSaldo == 0 )  	// deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

					
					cFilNat:= SE1_->E1_NATUREZ
					
					aTitImp:= F130RETIMP(cFilNat)
					
					If ((nPos := (aScan(aTitImp, {|x| x[1] <> SE1_->E1_TIPO }))) > 0 .and. aTitImp[nPos][2]) .OR.;
						aScan(aAbatBaixa, {|x| ALLTRIM(x[2])==ALLTRIM(SE1_->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)) }) > 0

						//Quando considerar Titulos com emissao futura, eh necessario
						//colocar-se a database para o futuro de forma que a Somaabat()
						//considere os titulos de abatimento
						If mv_par25 == 1
							dOldData := dDataBase
							dDataBase := CTOD("31/12/40")
						Endif

						// Somente verifica abatimentos se existirem titulos deste tipo para o cliente
						If aScan( aCliAbt, { |x| x[1] = SE1_->(E1_CLIENTE + E1_LOJA) } ) > 0
							nAbatim := SomaAbat(SE1_->E1_PREFIXO,SE1_->E1_NUM,SE1_->E1_PARCELA,"R",mv_par07,dDataReaj,SE1_->E1_CLIENTE,SE1_->E1_LOJA)
						Else
							nAbatim := 0
						EndIf

						If mv_par25 == 1
							dDataBase := dOldData
						Endif

						If mv_par20 != 1  //somente deve considerar abatimento no saldo se nao listar

							If STR(nSaldo,17,2) == STR(nAbatim,17,2)
								nSaldo := 0
							ElseIf mv_par20 == 2  //Se nao listar ele diminui do saldo								
								nSaldo-= nAbatim
							Endif
						Else
							// Subtrai o Abatimento caso o mesmo já tenha sido baixado ou não esteja listado no relatorios
							nBx := aScan( aAbatBaixa, {|x| x[2]= SE1_->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA) } )
							If (STOD(SE1_->E1_BAIXA) <= dDataBase .and. !Empty(SE1_->E1_BAIXA) .and. nBx>0)
								aDel( aAbatBaixa , nBx)
								aSize(aAbatBaixa, Len(aAbatBaixa)-1)
								nSaldo-= nAbatim
							EndIf
						EndIf
					Endif
				Endif
			Endif
			nSaldo:=Round(NoRound(nSaldo,3),2)

			//____________________________________________________________
			// Desconsidera caso saldo seja menor ou igual a zero   
			//____________________________________________________________
			If nSaldo <= 0 .AND. Empty(SE1_->E1_BAIXA)//CRIADA CONDIÇÃO  E CRIADA COLUNA COM DATA DA BAIXA
				SE1_->(dbSkip())
				Loop
			Endif

			If SE1_->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par13 == 2
				SE1_->(dbSkip())
				Loop
			Endif
			
			IF cCliTit<>SE1_->E1_CLIENTE
			
				cQuery := "SELECT "
				cQuery += "SA1.A1_COD, SA1.A1_LOJA, R_E_C_N_O_,A1_RECPIS,A1_RECCOFI,A1_RECCSLL,A1_NOME,A1_IRBAX,A1_NREDUZ,A1_TEL,A1_DDD  "
				cQuery += "FROM "+RetSqlName("SA1")+" SA1 "
				cQuery += "WHERE "
				cQuery += " SA1.A1_COD =  '"+SE1_->E1_CLIENTE+"' "
				cQuery += "AND SA1.A1_LOJA = '"+SE1_->E1_LOJA+"' "
				cQuery += "AND SA1.D_E_L_E_T_ = ' ' "

				cQuery := ChangeQuery(cQuery)
				If !Select( "SA1_" ) == 0
					SA1_->(dbCloseArea())
				Endif
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SA1_",.T.,.T.)

				SA1_->(dbGoTop())
				 
				dbSelectArea("SA1")
				SA1->(dbSetOrder(1))
				SA1->(dbSeek(xFilial("SA1")+cCond2))
			EndIf
			
			nRecSA1 := SA1->(RECNO()) 
						
			cQuery := "SELECT *"
			cQuery += "FROM "+RetSqlName("SA6")+" SA6 "
			cQuery += "WHERE "
			cQuery += " SA6.A6_COD =  '"+SE1_->E1_PORTADO+"' "
			cQuery += "AND SA6.D_E_L_E_T_ = ' ' "

			cQuery := ChangeQuery(cQuery)
			If !Select( "SA6_" ) == 0
				SA6_->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SA6_",.T.,.T.)

			SA6_->(dbGoTop())
			aDados[FILIA]:= SE1_->E1_FILIAL
			aDados[CLIENT] := RTrim(SE1_->E1_CLIENTE) + "-" + SE1_->E1_LOJA + "-" + IIF(mv_par16 == 1, SubStr(SA1_->A1_NREDUZ,1,20), SubStr(SA1_->A1_NOME,1,20))
			aDados[TITUL] := SE1_->E1_PREFIXO+"-"+SE1_->E1_NUM+"-"+SE1_->E1_PARCELA
			aDados[TIPO] := SE1_->E1_TIPO
			aDados[NATUREZA] := SE1_->E1_NATUREZ
			aDados[EMISSAO] := STOD(SE1_->E1_EMISSAO)
			aDados[VENCTO] := STOD(SE1_->E1_VENCTO)
			aDados[VENCREA] := STOD(SE1_->E1_VENCREA)
			lVl_Corr := .T.
			aDados[PJSITA] := SE1_->E1_PJSITA
			aDados[VL_LIQUI] := SE1_->E1_SALDO - SE1_->E1_IRRF - SE1_->E1_INSS - SE1_->E1_CSLL - SE1_->E1_COFINS - SE1_->E1_PIS
			//E1_IRRF - E1_ISS - E1_INSS - E1_CSLL - E1_COFINS - E1_PIS
			If mv_par12 == 1  //Recompoe Saldo Retroativo
				//Titulo foi Baixado e Data da Baixa e menor ou igual a Data Base do Relatório
				IF !Empty(SE1_->E1_BAIXA)
					If STOD(SE1_->E1_BAIXA) <= mv_par23 .Or. !Empty( SE1_->E1_PORTADO )
						aDados[BANC] := SE1_->E1_PORTADO+" "+SE1_->E1_SITUACA
					EndIf
				Else
					//Titulo não foi Baixado e foi transferido para Carteira e Data Movimento e menor
					//ou igual a Data Base do Relatório
					If Empty(SE1_->E1_BAIXA) .and. STOD(SE1_->E1_MOVIMEN) <= mv_par23
						aDados[BANC] := SE1_->E1_PORTADO+" "+SE1_->E1_SITUACA
					EndIf
				ENDIF
			Else   // Nao Recompoe Saldo Retroativo
				aDados[BANC] := SE1_->E1_PORTADO+" "+SE1_->E1_SITUACA
			EndIf
			//Se parametro Tit. Emissao Futura = Sim , e se for titulos de impostos gerados na baixa com data posterior a database, e parametro Recompoe Saldo = Sim => Exibier como Abatimento
			lAbatIMPBx := mv_par25 == 1 .AND. STOD(SE1_->E1_EMISSAO) >= mv_par23 .AND. mv_par12 == 1 .AND. SE1_->E1_TIPO $ "PIS/COF/CSL/IRF"
			aDados[VL_ORIG] := Round(NoRound(xMoeda(SE1_->E1_VALOR,SE1_->E1_MOEDA,mv_par07,STOD(SE1_->E1_EMISSAO),ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(SE1_->E1_EMISSAO,SE1_->E1_MOEDA)),0)* If((SE1_->E1_TIPO$MVABATIM +"/"+MVFUABT+"/"+MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM) .OR. lAbatIMPBx, -1,1),nDecs+1),nDecs)
			aDados[VL_NOMINAL] :=0
			aDados[VL_CORRIG]:=0
			aDados[VL_VENCIDO]:=0
			aDados[VL_SOMA]:=0
			
			If SE1_->E1_TIPO $ MVABATIM +"/"+MVFUABT // Caso for título de abatimento, busca o vencimento do título pai
				dVencRea := Posicione("SE1",1,SE1_->E1_FILIAL+SE1_->E1_TITPAI,"E1_VENCREA")
			Else
				dVencRea	:= STOD(SE1_->E1_VENCREA)
			EndIf
			
			If dDataBase > dVencRea	//vencidos
				If mv_par11 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_NOMINAL] := nSaldo * If(SE1_->E1_TIPO$(MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM +"/"+MVFUABT), -1,1)
				EndIf
				// Somente chamad fa070juros se realmente houver necessidade de calculo de juros ou o cï¿½lculo da multa ï¿½ feito pelo SIGALOJA
				If !( SE1_->E1_TIPO $ MVRECANT + "|" + MV_CRNEG ) .And. ( lFJurCst .Or. !Empty(SE1_->E1_VALJUR) .Or. !Empty(SE1_->E1_PORCJUR) .Or. lClcMultLj )
					dUltBaixa := STOD(SE1_->E1_BAIXA)
					If mv_par12 == 1 // se compoem saldo retroativo verifico se houve baixas 
						If !Empty(dUltBaixa) .And. dDataBase < dUltBaixa
							dUltBaixa := FR130DBX() // Ultima baixa até DataBase
						EndIf
					EndIf
					
					nJuros := fa070Juros(mv_par07,nSaldo + IIF(mv_par20 == 2,nAbatim,0) ,"SE1",dUltBaixa)

					If lClcMultLj
						//__________________________________________________________________________
						// Calcula o valor da Multa  :funcao LojxRMul :fonte Lojxrec          
						//__________________________________________________________________________
						nMulta := LojxRMul(,,,nSaldo + IIF(mv_par20 == 2,nAbatim,0),SE1_->E1_ACRESC,STOD(SE1_->E1_VENCREA),dDataBase,,SE1_->E1_MULTA,,SE1_->E1_PREFIXO,SE1_->E1_NUM,SE1_->E1_PARCELA,SE1_->E1_TIPO,SE1_->E1_CLIENTE,SE1_->E1_LOJA,"SE1",.T.)
								  //LojxRMul(,,,nSaldo + IIF(mv_par23 == 2,nAbatim,0),SE1->E1_ACRESC,SE1->E1_VENCREA,dDataBase,,SE1->E1_MULTA,,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,"SE1",.T.)
					EndIf
				EndIf
				
				If mv_par11 == 1 //1 = Analitico - 2 = Sintetico
					nCorrig := (nSaldo+nJuros+nMulta)* If(SE1_->E1_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM +"/"+MVFUABT, -1,1)
					aDados[VL_CORRIG]:= nCorrig
				EndIf

				If SE1_->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .or. (mv_par20 == 1 .and. SE1_->E1_TIPO $ MVABATIM +"/"+MVFUABT)
					nTit0 -= Round(NoRound(xMoeda(SE1_->E1_VALOR,SE1->E1_MOEDA,mv_par07,STOD(SE1_->E1_EMISSAO),ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(SE1_->E1_EMISSAO,SE1_->E1_MOEDA))),ndecs+1),ndecs)
					nTit1 -= (nSaldo)
					nTit2 -= (nSaldo+nJuros+nMulta)
					nTotJur  -= nJuros
				Else
					If !SE1_->E1_TIPO $ MVABATIM	+"/"+MVFUABT
						nTit0 += Round(NoRound(xMoeda(SE1_->E1_VALOR,SE1_->E1_MOEDA,mv_par07,STOD(SE1_->E1_EMISSAO),ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(STOD(SE1_->E1_EMISSAO),SE1_->E1_MOEDA))),ndecs+1),ndecs)
						nTit1 += (nSaldo)
						nTit2 += (nSaldo+nJuros+nMulta)
						nTotJur  += nJuros
					Endif
				Endif
			Else						//a vencer - parei aqui Oscar
				If mv_par11 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_VENCIDO] := nSaldo * If((SE1->E1_TIPO$MV_CRNEG+"/"+MVRECANT+"/"+MVABATIM +"/"+MVFUABT) .OR. lAbatIMPBx, -1,1)
				EndIf
					
				If ! ( SE1_->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM +"/"+MVFUABT) .and. !lAbatIMPBx
					nTit0 += Round(NoRound(xMoeda(SE1_->E1_VALOR,SE1_->E1_MOEDA,mv_par07,STOD(SE1_->E1_EMISSAO),ndecs+1,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(STOD(SE1_->E1_EMISSAO),SE1_->E1_MOEDA))),ndecs+1),ndecs)
					nTit3 += (nSaldo-nTotAbat)
					nTit4 += (nSaldo-nTotAbat)
				Else
					nTit0 -= Round(NoRound(xMoeda(SE1_->E1_VALOR,SE1_->E1_MOEDA,mv_par07,STOD(SE1_->E1_EMISSAO),ndecs+1,Iif(!Empty(SE1->E1_TXMOEDA),SE1->E1_TXMOEDA,RecMoeda(STOD(SE1_->E1_EMISSAO),SE1_->E1_MOEDA))),ndecs+1),ndecs)
					nTit3 -= (nSaldo-nTotAbat)
					nTit4 -= (nSaldo-nTotAbat)
				Endif

			Endif

			If mv_par11 == 1 //1 = Analitico - 2 = Sintetico
				aDados[NUMBC] := SE1_->E1_NUMBCO
			EndIf

			If nJuros > 0

				If mv_par11 == 1 //1 = Analitico - 2 = Sintetico
					aDados[VL_JUROS] := nJuros
				EndIf

				nJuros := 0

			Endif

			nMulta := 0

			If dDataBase > STOD(SE1_->E1_VENCREA) .And. !(SE1_->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
				nAtraso:=dDataBase-STOD(SE1_->E1_VENCTO)
				If Dow(SE1->E1_VENCTO) == 1 .Or. Dow(SE1->E1_VENCTO) == 7
					If Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso := 0
					EndIf
				EndIf
				nAtraso:=If(nAtraso<0,0,nAtraso)
				If nAtraso>0
					If mv_par11 == 1 //1 = Analitico - 2 = Sintetico
						aDados[ATRASO] := nAtraso
					EndIf
				EndIf
			Else
				If !(SE1_->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
					nAtraso:=dDataBase-if(dDataBase==STOD(SE1_->E1_VENCREA),STOD(SE1_->E1_VENCREA),STOD(SE1_->E1_VENCTO))
					nAtraso:=If(nAtraso<0,0,nAtraso)
				Else
					nAtraso:=0
				EndIf
				aDados[ATRASO] := nAtraso
			EndIf
			aDados[BAIXA]:= SE1->E1_BAIXA
			aDados[VL_SOMA]:= nTit2+nTit3

			If mv_par11 == 1 //1 = Analitico - 2 = Sintetico 18
				aDados[HISTORICO] := SubStr(SE1_->E1_HIST,1,25)+IIF(SE1_->E1_TIPO $ MVPROVIS,"*"," ")+ ;
				Iif(Str(xMoeda(SE1_->E1_SALDO,SE1_->E1_MOEDA,mv_par07,dDataReaj,ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(STOD(SE1_->E1_EMISSAO),SE1_->E1_MOEDA))),17,2) ==Str(xMoeda(SE1_->E1_VALOR,SE1_->E1_MOEDA,mv_par07,dDataReaj,ndecs+1,Iif(!Empty(SE1_->E1_TXMOEDA),SE1_->E1_TXMOEDA,RecMoeda(stod(SE1_->E1_EMISSAO),SE1_->E1_MOEDA))),17,2)," ","P")
				
				
				oSection1:PrintLine()
				
			EndIf

			//_________________________________________________
			// Carrega data do registro para permitir 
			// posterior análise de quebra por mes. 
			//_________________________________________________
			dDataAnt := If( mv_par26 = 2, STOD(SE1_->E1_VENCTO), STOD(SE1_->E1_VENCREA))


			If nOrdem == 1 //Cliente
				cNomFor := If(mv_par16 == 1, AllTrim(SA1_->A1_NREDUZ),AllTrim(SA1_->A1_NOME)) 
			EndIF

			cNumBco := SE1_->E1_PORTADO
			

			dDtVenc := STOD(SE1_->E1_EMISSAO)
			nTotVenc:= nTit2+nTit3

			nTotTit ++
			nTit5 ++
			nTotReg++
			cCliTit:=""
			If oReport:nDevice == 6 .And. nTotReg == 60 
				oReport:Pagebreak(.T.)
				oReport:EndPage()	
				nTotReg := 0	
			EndIf
				

			IF nTit5 > 0 .And. nOrdem != 2 .And. mv_par11 == 2 //1 = Analitico - 2 = Sintetico
				SubTot130R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs,oReport,,oSection2)
			ElseIf lImpSintTbl
				oReport:SkipLine()
				oReport:ThinLine()			
				SubTot130R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs,oReport,,oSection2)		
			Endif

            nTotGeral	+= (nTit2+nTit3)

			// Quebra por Cliente.
			// "Salta pagina por cliente?" igual a "Sim" e a ordem eh por cliente ou codigo do cliente
			If mv_par22 == 1 .And. nOrdem == 1 
				oBreak:OnPrintTotal( { || oReport:EndPage() } )	// Finaliza pagina atual
			EndIf

			//dbSelectArea("SE1")
			SE1_->(DBSKIP())
			//mv_par23 = 2 (Nï¿½o Listar) os tï¿½tulos de abatimento nï¿½o serï¿½o impressos,porï¿½m do valor a receber serï¿½o diminuidos os abatimentos.
			
			If mv_par20 == 2 .AND. mv_par11 == 1
				nTit0 -= nAbatim
				nTit1 -= nAbatim
				nTit2 -= nAbatim
				nAbatim := 0
			Endif
			
			nTot0+=nTit0
			nTot1+=nTit1
			nTot2+=nTit2
			nTot3+=nTit3
			nTot4+=nTit4
			nTotJ+=nTotJur

			Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur,nTotAbat
		Enddo

		// Quebra por Cliente.
		// Evitar salto de pagina antes da impressao do total geral
		If mv_par22 == 1 .And. nOrdem == 1 	// Cliente 
			oBreak:OnPrintTotal( { || } )
		EndIf
        oSection1:Finish()
		oSection2:Finish()
	EndIf

Next//loop********

oSection1:Init()
oSection2:Init()
//Total geral para o Relatorio Sintetico
If mv_par11 == 1 .And. nOrdem != 2  //1 = Analitico - 2 = Sintetico
	oReport:SkipLine()
	oReport:ThinLine()
	TotGer130R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs,oReport,,oSection2)
Endif

oSection1:Finish()
//totalizador para formato tabela.
If lImpSintTbl
	oReport:SkipLine()
	oReport:ThinLine()
	TotGer130R(nTot0,nTot1,nTotal,nTot3,nTot4,nTotTit,nTotJ,nDecs,oReport,,oSection2)
EndIf
oSection2:Finish()

dDataBase := dOldDtBase


//retorna a empresa inicial
dbCloseAll() //Fecho todos os arquivos abertos
OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)
dbSelectArea("SM0")
SM0->(dbSetOrder(1))
SM0->(RestArea(_aAreaSM0)) //Restaura Tabela
cFilAnt := SM0->M0_CODFIL //Restaura variaveis de ambiente
cEmpAnt := SM0->M0_CODIGO
	
OpenFile(cEmpAnt + cFilAnt) //Abertura das tabelas
oApp := _oAppBk //Backup do componente visual


Return //Final da Impressao

///___________________________________________________________________________________________
//Imprimir SubTotal do Relatorio							  
//__________________________________________________________________________________________
Static Function SubTot130R(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs,oReport,aDados,oSection)

Local cQuebra := ""

If nOrdem = 1
	//mv_par19 - Imprime Nome?
	cQuebra := If(mv_par16 == 1,Substr(SA1_->A1_NREDUZ,1,30),Substr(SA1_->A1_NOME,1,30))+" "+ STR0054 + Right(cCarAnt,2)//"Loja - "###" Filial - "
Endif

HabiCel(oReport, ( nOrdem == 5 .And. MV_MULNATR ) )

oSection:Cell("QUEBRA"   ):SetBlock({|| cQuebra})
oSection:Cell("TOT_NOMI" ):SetBlock({|| nTit1  })
oSection:Cell("TOT_CORR" ):SetBlock({|| nTit2  })
oSection:Cell("TOT_VENC" ):SetBlock({|| nTit3  })
oSection:Cell("TOT_SOMA" ):SetBlock({|| nTit2+nTit3})
oSection:Cell("TOT_JUROS"):SetBlock({|| nTotJur})

oSection:PrintLine()

Return .T.

/*/
 Imprimir total do relatorio								  

/*/
STATIC Function TotGer130R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs,oReport,aDados,oSection,cTexto)

DEFAULT nDecs := Msdecimais(mv_par07)
DEFAULT cTexto	:= ""		/* GESTAO */

HabiCel(oReport)

If Empty(cTexto)
oSection:Cell("QUEBRA"   ):SetBlock({|| STR0038 +"("+ AllTrim(Str(nTotTit)) +" "+ If(nTotTit > 1, STR0039, STR0040) +")"}) //"TOTAL"
Else
	oSection:Cell("QUEBRA"   ):SetBlock({|| cTexto}) //"TOTAL"
Endif

oSection:Cell("QUEBRA"   ):SetBlock({|| STR0038 +"("+ AllTrim(Str(nTotTit)) +" "+ If(nTotTit > 1, STR0039, STR0040) +")"}) //"TOTAL"
oSection:Cell("TOT_NOMI" ):SetBlock({|| nTot1  })
oSection:Cell("TOT_CORR" ):SetBlock({|| nTot2  })
oSection:Cell("TOT_VENC" ):SetBlock({|| nTot3  })
oSection:Cell("TOT_SOMA" ):SetBlock({|| If(lImpSintTbl, nTotal, (nTot2+nTot3))})
oSection:PrintLine()

Return .T.

//____________________________________________________________________________________________________
STATIC Function HabiCel(oReport, lMultNat)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)

Default lMultNat := .F.

If mv_par11 == 1 //1 =  Analitico - 2 = Sintetico
	If !lMultNat .And. !lImpSintTbl
		oSection1:Cell("CLIENTE"   ):SetSize(50)
		oSection1:Cell("TITULO"    ):Disable()
		oSection1:Cell("E1_TIPO"   ):Hide()
		oSection1:Cell("E1_NATUREZ"):Hide()
		oSection1:Cell("E1_EMISSAO"):Hide()
		oSection1:Cell("E1_VENCTO" ):Hide()
		oSection1:Cell("E1_VENCREA"):Hide()
		oSection1:Cell("VAL_ORIG"  ):Hide()
		oSection1:Cell("BANCO"     ):Hide()
		oSection1:Cell("DIA_ATR"   ):Hide()
		oSection1:Cell("E1_HIST"   ):Disable()
		oSection1:Cell("VAL_SOMA"  ):Enable()

		oSection1:Cell("CLIENTE"   ):HideHeader()
		oSection1:Cell("E1_TIPO"   ):HideHeader()
		oSection1:Cell("E1_NATUREZ"):HideHeader()
		oSection1:Cell("E1_EMISSAO"):HideHeader()
		oSection1:Cell("E1_VENCTO" ):HideHeader()
		oSection1:Cell("E1_VENCREA"):HideHeader()
		oSection1:Cell("VAL_ORIG"  ):HideHeader()
		oSection1:Cell("BANCO"     ):HideHeader()
		oSection1:Cell("DIA_ATR"   ):HideHeader()
	EndIf
Else
	oSection2:Cell("QUEBRA"   ):SetSize(100)
Endif

Return(.T.)


/*
---------------------------------------------------------- RELEASE 3 ---------------------------------------------
*/

/*/
 Acerta parametro database do relatorio                    

/*/
Static Function PutDtBase()
Local aArea		:= GetArea()
Local cPerg		:= Padr("XF130CB",Len(SX1->X1_GRUPO))
Local aHelpPor := aHelpSpa := aHelpEng := {}
dbSelectArea("SX1")
dbSetOrder(1)
If SX1->(MsSeek(cPerg+"33"))
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	SX1->(MsUnlock())
Endif

RestArea(aArea)

Return

/*
Retorna situacao de cobranca do titulo                     
*/
Static Function SituCob(cCarAnt)
Local aArea		:= GetArea()
Local cCart		:= " "

If !Empty(cCarAnt)
	cCart := cCarAnt+" "+Substr(FN022SITCB( SE1_->E1_SITUACA )[9],1,20)
Else
	cCart := "0 "+STR0029
Endif
RestArea(aArea)
Return cCart

/*/__________________________________________________________
 Soma os abatimentos do PCC em caso de saldo retroativo	  
/*/
Static Function SumAbatPCC(cPrefixo,cNumero,cParcela,dDataRef,cCodCli,cLoja,nMoeda)

Local cAlias	:= Alias()
Local nOrdem	:= indexord()
Local cQuery	:= ""
Local nTotPcc	:= 0

DEFAULT nMoeda	:= 1


	cQryAlias := GetNextAlias()

	cQuery	:= " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_TIPO, E1_EMISSAO, E1_VALOR, E1_TXMOEDA, E1_MOEDA, E1_TITPAI, R_E_C_N_O_ RECNO "
	cQuery	+= " FROM "+RetSqlName("SE1")+" "
	cQuery	+= " WHERE " //E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cQuery	+= " E1_PREFIXO = '"+cPrefixo+"' AND "
	cQuery	+= " E1_NUM = '"+cNumero+"' AND "
	cQuery	+= " E1_CLIENTE = '"+cCodCli+"' AND "
	cQuery	+= " E1_LOJA = '"+cLoja+"' AND "
	cQuery	+= " E1_TIPO IN ('PIS','COF','CSL') AND "
	cQuery	+= " E1_EMISSAO <= '"+Dtos(dDataRef)+"' AND "
	cQuery	+= " D_E_L_E_T_ = ' ' "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cQryAlias , .F., .T.)

	While (cQryAlias)->( !Eof() )
		If FTITRAPAI((cQryAlias)->E1_TITPAI) //Verifica se o Titulo PAI e um RA e nao abate o PCC
			nTotPcc += xMoeda((cQryAlias)->E1_VALOR,(cQryAlias)->E1_MOEDA,nMoeda,dDataRef,,If(cPaisLoc=="BRA",(cQryAlias)->E1_TXMOEDA,0))
		EndIf
		(cQryAlias)->(dbSkip())
	EndDo

	(cQryAlias)->(dbCloseArea())


DbSelectArea(cAlias)
DbSetOrder(nOrdem)

Return(nTotPcc)


/*/
Totaliza somatoria da coluna (Vencidos+A Vencer) quando		
 selecionado relatorio por ordem de natureza e parametro		
 MV_MULNATR ativado. 											

/*/
Static Function FR130TotSoma( oTotCorr, oTotVenc, nTotVenc, nTotGeral, nOrdem )

nTotal += nTotVenc	:= IIf(oTotCorr:GetValue() == NIL .OR. oTotVenc:GetValue() == NIL, nTotVenc, oTotCorr:GetValue() + oTotVenc:GetValue())


Return .T.
/*/
 Avalia condicoes para filtrar os registros que serao		
 impressos.													

/*/
Static Function Fr130Cond(cTipos)
Local lRet := .T.
Local dDtContab
Local aArea		:= getArea()
Local aResult	:= {}
//Local lProc		:= cAliasProc <> Nil

DEFAULT _nTamSEQ	:= TAMSX3('E5_SEQ')[1]
// dDtContab para casos em que o campo E1_EMIS1 esteja vazio
dDtContab := Iif(Empty(SE1_->E1_EMIS1),SE1_->E1_EMISSAO,SE1_->E1_EMIS1)


// Filtrar com base no Pto de entrada do Usuario...             

Do Case
Case !Empty(SE1_->E1_BAIXA)
	If mv_par12 == 2 .and. SE1_->E1_SALDO == 0
		lRet := .F.
	Elseif SE1_->E1_SALDO == 0

		If ( mv_par26 == 1 ) .and. STOD(SE1_->E1_BAIXA) <= dDataBase
			lRet := .F.
		Endif
	Endif
//___________________________________________________________
// Verifica se trata-se de abatimento ou somente titulos
// até a data base. 									 
//___________________________________________________________
Case (mv_par20 == 3 .AND. SE1_->E1_TIPO $ MVABATIM +"/"+MVFUABT)
	lRet := .F.

//Verifica se serão impresso titulos provisórios		  

Case SE1_->E1_TIPO $ MVPROVIS .and. mv_par08 == 2
	lRet := .F.

// Verifica se serï¿½ impresso titulos de Adiantamento	  

Case SE1_->E1_TIPO $ MVRECANT+"/"+MV_CRNEG .and. mv_par13 == 2
	lRet := .F.
Case !Empty(cTipos)
	If !(SE1_->E1_TIPO $ cTipos)
	   lRet := .F.
	Endif
Case mv_par20 == 2 // nao imprime
	//___________________________________________________
	// Verifica se deve imprimir outras moedas
	//___________________________________________________
	If SE1_->E1_MOEDA != mv_par07 // verifica moeda do campo=moeda parametro
		lRet := .F.
	Endif
EndCase

If !Empty(SE1_->E1_BAIXA)
	//considera o abatimento do título, após a baixa 
	If !lRet .and. (mv_par26 == 2 .OR. mv_par26 == 3)  .and. mv_par13 == 1 .and. mv_par12 == 1 .and. allTrim(SE1_->E1_TIPO) $ MVABATIM .and. STOD(SE1_->E1_BAIXA) >= dDataBase
		lRet := .T.	 	
	EndIf
EndIf

RestArea(aArea)

Return lRet
//============================================
/*/
  Efetua a validacao na exclusao do titulo					
/*/
//============================================
Static Function F130RETIMP(cFiltro)

Local aTitulos := {}
Local cQuery:=""
//SX2->(DbSetOrder(1))
//SX2->(dbSeek("SED"))
//IF SX2->X2_ARQUIVO == "SED"+cNewEmp+"0 "

	cQuery	:= " SELECT * "
	cQuery	+= " FROM "+RetSqlName("SED")+" "           
	cQuery	+= " WHERE " //E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cQuery	+= " ED_CODIGO = '"+cFiltro+"'  AND "
	cQuery	+= " D_E_L_E_T_ = ' ' "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRC' , .F., .T.)  
//ELSE
//	cQuery	:= " SELECT * "
//	cQuery	+= " FROM "+SX2->X2_ARQUIVO+" "        
//	cQuery	+= " WHERE " //E1_FILIAL = '"+xFilial("SE1")+"' AND "
//	cQuery	+= " ED_CODIGO = '"+cFiltro+"'  AND "
//	cQuery	+= " D_E_L_E_T_ = ' ' "

//	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRC' , .F., .T.)  
//ENDIF
	

IF TRC->ED_CODIGO<>""
//If DbSeek (xFilial("SED")+cFiltro)
	If TRC->ED_CALCIRF=="S"
     	AADD(aTitulos,{MVIRABT, .T.})
 	EndIf
   	If TRC->ED_CALCINS=="S"
       	AADD(aTitulos,{MVINABT,.T.})
   	EndIf
 	If TRC->ED_CALCPIS=="S"
    	 AADD(aTitulos,{MVPIABT,.T.})
 	EndIf
   	If TRC->ED_CALCCOF=="S"
     	AADD(aTitulos,{MVCFABT,.T.})
 	EndIf
   	If TRC->ED_CALCCSL=="S"
     	AADD(aTitulos,{MVCSABT,.T.})
   	EndIf
 	If TRC->ED_CALCISS=="S"
     	AADD(aTitulos,{MVISABT,.T.})
	EndIf
EndIf

//RestArea(aAreaSE1)
TRC->(dbCloseArea())

Return aTitulos
//=================================================================
/*/
  Caso algum titulo de abatimento tenho o campo E1_TITPAI em	
 	branco a função ira preencher para o relatorio ficar correto
/*/
//=================================================================
Static Function FTITPAI()

Local cTitP:=""
Local cQuery:=""

	cQuery	:= " SELECT * "
	cQuery	+= " FROM "+RetSqlName("SE1")+" "
	cQuery	+= " WHERE " //E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cQuery	+= " E1_FILIAL = '"+SE1_->E1_FILIAL+"'  AND "
	cQuery	+= " E1_CLIENTE = '"+SE1_->E1_CLIENTE+"'  AND "
	cQuery	+= " E1_LOJA = '"+SE1_->E1_LOJA+"'  AND "
	cQuery	+= " E1_PREFIXO = '"+SE1_->E1_PREFIXO+"'  AND "
	cQuery	+= " E1_NUM = '"+SE1_->E1_NUM+"'  AND "
	cQuery	+= " E1_PARCELA = '"+SE1_->E1_PARCELA+"' AND "
	cQuery	+= " D_E_L_E_T_ = ' ' "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRE' , .F., .T.)
	TRE->(DBGOTOP())


IF TRE->E1_NUM<>""
	While TRE->(!Eof()) //.and. cChave == xFilial("SE1")+__SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
		If ! TRE->E1_TIPO $ MVABATIM +"/"+MVFUABT
			cTitP := PADR(TRE->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA),TAMSX3('E1_TITPAI')[1])
			Exit
		EndIf
	TRE->(DbSkip())
	EndDo
EndIF

//RestArea(aAreaSE1)
//RestArea(aArea)
TRE->(DBCLOSEAREA())

Return cTitP
//==========================================================
/*/
  Rotina para buscar na SE5 quando titulo eh tipo RA para 	
 	verificar a data de cancelamento que sera gravado no	
 	saldo adequadamente										
/*/
//==========================================================
STATIC Function F130TipoBA()
Local nPosDtCanc := 0
Local nValor := 0
//Local aArea := GetArea()
Local cChave := SE1_->(E1_PREFIXO + E1_NUM +E1_PARCELA +E1_TIPO +E1_CLIENTE +E1_LOJA )
Local cQuery:=""
//Local cMens:=""

	cQuery	:= " SELECT * "
	cQuery	+= " FROM "+RetSqlName("SE5")+ " "
	cQuery	+= " WHERE " //E1_FILIAL = '"+xFilial("SE1")+"' AND "
	cQuery	+= " E5_PREFIXO = '"+SE1_->E1_PREFIXO+"'  AND "
	cQuery	+= " E5_NUMERO = '"+SE1_->E1_NUM+"'  AND "
	cQuery	+= " E5_PARCELA = '"+SE1_->E1_PARCELA+"'  AND "
	cQuery	+= " E5_TIPO = '"+SE1_->E1_TIPO+"'  AND "
	cQuery	+= " E5_CLIENTE = '"+SE1_->E1_CLIENTE+"'  AND "
	cQuery	+= " E5_LOJA = '"+SE1_->E1_LOJA+"'  AND "
	cQuery	+= " D_E_L_E_T_ = ' ' "

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRD' , .F., .T.)
	TRD->(DBGOTOP())

//dbSelectArea("SE5")
//dbSetOrder(7) // filial + prefixo + numero + parcela + tipo + clifor + loja + sequencia
//If DbSeek(xFilial("SE5")+cChave)
IF TRD->E5_NUMERO<>""
	While TRD->(!EOF()) //.and. cChave == SE5->(E5_PREFIXO + E5_NUMERO +E5_PARCELA +E5_TIPO +E5_CLIENTE +E5_LOJA )
		If TRD->E5_TIPODOC == "BA" .and. TRD->E5_SITUACA = 'C'
			If ( nPosDtCanc := At("###[", TRD->E5_HISTOR) ) > 0
				If  STOD(TRD->E5_DATA) <= mv_par23 .And. STOD(SUBS(TRD->E5_HISTOR, nPosDtCanc+4,8)) > mv_par23
					nValor := TRD->E5_VALOR
					Exit
				EndIf
			EndIf
		Endif
		TRD->(dbSkip())
	EndDo
Endif

//RestArea(aArea)
TRD->(DBCLOSEAREA())

Return nValor
//=============================================================
/*/
 Verifica se o titulo de abatimento no campo E1_TITPAI Ã© RA
/*/
//=============================================================
Static Function FTITRAPAI(cTITPAI)
Local aArea    := GetArea()
Local lRet     := .T.
Local nTamPref := 0
Local nTamNum  := 0
Local nTamParc := 0
Local nTamTipo := 0
Local cTipo    := ""
//Controla o Pis Cofins e Csll na RA (1 = Controla retenï¿½ï¿½o de impostos no RA; ou 2 = Nï¿½o controla retenï¿½ï¿½o de impostos no RA(default))
Local lRaRtImp := FRaRtImp()

If !Empty(cTITPAI) .And. lRaRtImp
	//nTamFil  := TAMSX3('E1_FILIAL')[1]
	nTamPref := TAMSX3('E1_PREFIXO')[1]
	nTamNum  := TAMSX3('E1_NUM')[1]
	nTamParc := TAMSX3('E1_PARCELA')[1]
	nTamTipo := TAMSX3('E1_TIPO')[1]
	cTipo    := Subs(cTITPAI,(1+nTamPref+nTamNum+nTamParc),nTamTipo)

	If cTipo $ MVRECANT // Titulo pai e um RA
		lRet := .F.
	EndIf
EndIf
RestArea(aArea)


Return lRet



//-------------------------------------------------------------------
/*/{Protheus.doc} FR130DBX

Busca a data da ultima baixa realizada do titulo a receber atï¿½ a
DataBase do sistema.

@author leonardo.casilva

@since 11/04/2014
@version P1180
 
@return
/*/
//-------------------------------------------------------------------
Static Function FR130DBX()

Local dDataRet := SE1_->E1_VENCREA
Local cQuery	 := "SELECT"

cQuery += " MAX(SE5.E5_DATA) DBAIXA"
cQuery += " FROM "+RetSqlName("SE5")+" SE5 "
cQuery += " WHERE "//SE5.E5_FILIAL IN ('" + xFilial("SE1")  + "') " 
cQuery += " AND SE5.E5_PREFIXO = '" + SE1_->E1_PREFIXO	 + "'"
cQuery += " AND SE5.E5_NUMERO = '"  + SE1_->E1_NUM		 + "'"
cQuery += " AND SE5.E5_PARCELA = '" + SE1_->E1_PARCELA	 + "'"
cQuery += " AND SE5.E5_TIPO = '" 	 + SE1_->E1_TIPO	 	 + "'"
cQuery += " AND SE5.E5_CLIFOR = '"  + SE1_->E1_CLIENTE	 + "'"
cQuery += " AND SE5.E5_LOJA = '"	 + SE1_->E1_LOJA	 	 + "'"
cQuery += " AND SE5.E5_TIPODOC = 'VL'"
cQuery += " AND SE5.E5_DATA <= '" + DTOS(dDataBase) + "'"  
cQuery += " AND SE5.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBDATA",.T.,.T.)

If TRBDATA->(!EOF())
	If !Empty(AllTrim(TRBDATA->DBAIXA))
		dDataRet := STOD(TRBDATA->DBAIXA)
	Endif
EndIf
TRBDATA->(dbCloseArea())

Return dDataRet
