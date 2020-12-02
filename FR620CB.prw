#Include "FINR620.CH"
#Include "PROTHEUS.CH"


/*/
MOVIMENTAÇÃO BANCÁRIA
/*/
USER Function FR620CB()// U_FR620CB()

Local oReport
Local aAreaR4	:= GetArea()

Private nOrdena
Private lPccBxCr	:= FPccBxCr()


//If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
//Else
//	Return FinR620R3() // Executa versão anterior do fonte
//Endif

RestArea(aAreaR4)

Return

/*
DEFINIÇÃO DO RELATÓRIO
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local cReport 	:= "FR620CB" 		// Nome do relatorio
Local cDescri 	:= STR0001 +;		//"Este programa ir  emitir a rela‡„o da movimenta‡„o banc ria"
						STR0002 +;	//"de acordo com os parametros definidos pelo usuario. Poder  ser"
						STR0003		//"impresso em ordem de data disponivel,banco,natureza ou dt.digita‡„o."
Local cTitulo 	:= STR0021 			//"Relacao da Movimentacao Bancaria"
Local cPerg		:= "XF620"			// Nome do grupo de perguntas
Local aOrdem	:= {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0034)}  //"Por Dt.Dispo"###"Por Banco"###"Por Natureza"###"Dt.Digitacao"###"Por Dt. Movimentacao"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//criação das perguntas
ValidSx1(cPerg)

pergunte(cPerg,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oReport := TReport():New(cReport, cTitulo, {|| AdmSelecFil(cPerg,17,.T.,@aSelFil,"SE5",.F.)}, {|oReport| ReportPrint(oReport, cTitulo)}, cDescri)
oReport := TReport():New(cReport, cTitulo, cPerg,{|oReport| ReportPrint(oReport, cTitulo)}, cDescri)


If MV_PAR07 == 1			//Analitico
	oReport:SetLandscape()	//Imprime o relatorio no formato paisagem
Else                 		//Sintetico
	oReport:SetPortrait()	//Imprime o relatorio no formato retrato
EndIf


oReport:HideParamPage(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                        ³
//³                      Definicao das Secoes                              ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 01                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, STR0035, /*"SE5"*/, aOrdem) //"Saldo anterior dos bancos"
DbSelectArea('SX3')
DbSetOrder(2)
DbSeek('E5_BANCO')
cDescBanco	:=	 X3Titulo("E5_BANCO")
DbSeek('E5_AGENCIA')
cDescAge		:=	 X3Titulo("E5_AGENCIA")
DbSeek('E5_CONTA')
cDescConta	:=	 X3Titulo("E5_CONTA")
DbSeek('E5_NATUREZ')
cDescNat  	:=	 X3Titulo("E5_NATUREZ")
DbSeek('E5_DOCUMEN')
cDescDoc		:=	 X3Titulo("E5_DOCUMEN")
DbSeek('E5_HISTOR')
cDescHist 	:=	 X3Titulo("E5_HISTOR")


TRCell():New(oSection1, "TXTSALDO"     , "" , STR0031 , , 17 ,/*lPixel*/,{ || STR0031 } )	//"Saldo anterior a "
TRCell():New(oSection1, "DATA"   		, "" , STR0042 , PesqPict("SE5","E5_DATA") , TamSX3("E5_DATA")[1]+2 ,/*lPixel*/,/*CodeBlock*/)	//"DATA"
TRCell():New(oSection1, "TODOSBCO"     , "" , STR0032 	, , 22 ,/*lPixel*/,{ || STR0032 })		//" (Todos os bancos): "
TRCell():New(oSection1, "BANCO"   		, "" , cDescBanco , PesqPict("SE5","E5_BANCO")   , TamSX3("E5_BANCO")[1]   	,/*lPixel*/,/*CodeBlock*/)	//"BCO"
TRCell():New(oSection1, "AGENCIA"		, "" , cDescAGE	, PesqPict("SE5","E5_AGENCIA")	, TamSX3("E5_AGENCIA")[1] ,/*lPixel*/,/*CodeBlock*/)	//"AGENCIA"
TRCell():New(oSection1, "CONTA"    		, "" , cDescCONTA , PesqPict("SE5","E5_CONTA")  	, TamSX3("E5_CONTA")[1]	   ,/*lPixel*/,/*CodeBlock*/)	//"CONTA"
TRCell():New(oSection1, "SALDOANTERIOR", "" , STR0041 , PesqPict("SE8","E8_SALANT")	, TamSX3("E8_SALANT")[1]	 ,/*lPixel*/,/*CodeBlock*/)

oSection1:Cell("TODOSBCO"):Disable()
oSection1:Cell("SALDOANTERIOR"):SetHeaderAlign("RIGHT")
oSection1:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 02                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oReport, STR0036, {"SE5","SA6","SED","SM0"}, aOrdem) //"Movimentacao Bancaria"

TRCell():New(oSection2, "M0_CODIGO"		,"SM0"	,"EMPRESA"/*Titulo*/,/*Picture*/,12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2, "M0_FILIAL"		,"SM0"	,"FILIAL"/*Titulo*/,/*Picture*/,12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2, "DATA"			, "SE5" , STR0042 	, PesqPict("SE5","E5_DTDISPO")	, TamSX3("E5_DTDISPO")[1]+4	,/*lPixel*/,/*CodeBlock*/)	//"DATA"
TRCell():New(oSection2, "BANCO"   		, "SE5" , cDescBANCO	, PesqPict("SE5","E5_BANCO")    , TamSX3("E5_BANCO")[1]  	,/*lPixel*/,{|| SE5->E5_BANCO}/*CodeBlock*/)	//"BCO"
TRCell():New(oSection2, "AGENCIA"		, "SE5" , cDescAGE	, PesqPict("SE5","E5_AGENCIA")	, TamSX3("E5_AGENCIA")[1]	,/*lPixel*/,{|| SE5->E5_AGENCIA}/*CodeBlock*/)	//"AGENCIA"
TRCell():New(oSection2, "CONTA"    		, "SE5" , cDescCONTA	, PesqPict("SE5","E5_CONTA")  	, TamSX3("E5_CONTA")[1]		,/*lPixel*/,{|| SE5->E5_CONTA}/*CodeBlock*/)	//"CONTA"
TRCell():New(oSection2, "NATUREZA"		, "SE5" , cDescNAT 	, PesqPict("SE5","E5_NATUREZ")	, TamSX3("E5_NATUREZ")[1],/*lPixel*/,{|| MascNat(SE5->E5_NATUREZ)}/*CodeBlock*/)	//"NATUREZA"
TRCell():New(oSection2, "DOCUMENTO" 	, "SE5" , cDescDOC 	, PesqPict("SE5","E5_NUMCHEQ")  , TamSX3("E5_NUMCHEQ")[1]+1	,/*lPixel*/,{|| SE5->E5_NUMCHEQ}/*CodeBlock*/)	//"DOCUMENTO"
TRCell():New(oSection2, "ENTRADA"		, "" 	, STR0038 	, PesqPict("SE5","E5_VALOR")    , TamSX3("E5_VALOR")[1]+1   ,/*lPixel*/,/*CodeBlock*/)	//"ENTRADA"
TRCell():New(oSection2, "SAIDA"    		, ""    , STR0039 	, PesqPict("SE5","E5_VALOR")    , TamSX3("E5_VALOR")[1]+1  	,/*lPixel*/,/*CodeBlock*/)	//"SAIDA"
TRCell():New(oSection2, "VLRMOV"        , ""    , "Vlr.Mov." 	, PesqPict("SE5","E5_VALOR")    , TamSX3("E5_VALOR")[1]+1  	,/*lPixel*/,/*CodeBlock*/)	//"SAIDA"
TRCell():New(oSection2, "SALDOATUAL"	, "" 	, STR0040 	, PesqPict("SE8","E8_SALANT")  	, TamSX3("E8_SALANT")[1]+1 	,/*lPixel*/,/*CodeBlock*/)	//"SALDO ATUAL"
TRCell():New(oSection2, "SEPARADOR"		, ""	, ""		 	, ,2,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection2, "HISTORICO"		, ""	, cDescHIST 	, PesqPict("SE5","E5_HISTOR")   , TamSX3("E5_HISTOR")[1]	,/*lPixel*/,{|| SE5->E5_HISTOR}/*CodeBlock*/)	//"HISTORICO"
TRCell():New(oSection2, "CENT_CUSTO"	, ""	, "CENT_CUSTO" 	, PesqPict("SE5","E5_CCC") , TamSX3("E5_CCC")[1]+1 ,/*lPixel*/,/*CodeBlock*/) //CENTRO DE CUSTO
//TRCell():New(oSection2, "CENT_CUSTO_CR"	, "SD2"	  , "CENT_CUSTO_CR" 	, PesqPict("SD2","D2_CCUSTO")   , TamSX3("D2_CCUSTO")[1]	,/*lPixel*/,{|| SD2->D2_CCUSTO}/*CodeBlock*/)	//"CENT_CUSTO_CR"
//TRCell():New(oSection2, "CENT_CUSTO_CP"	, "SD1"	  , "CENT_CUSTO_CP" 	, PesqPict("SD1","D1_CC")   , TamSX3("D1_CC")[1]	,/*lPixel*/,{|| SD1->D1_CC}/*CodeBlock*/)	//"CENT_CUSTO_CP"

TrPosition():New(oSection2,'SA6',1,{|| xFilial('SA6')+ SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA })
TrPosition():New(oSection2,'SED',1,{|| xFilial('SED')+ SE5->E5_NATUREZ })

//Faz o alinhamento do texto da celula
oSection2:Cell("ENTRADA"   ):SetHeaderAlign("RIGHT")
oSection2:Cell("SAIDA"     ):SetHeaderAlign("RIGHT")
oSection2:Cell("SALDOATUAL"):SetHeaderAlign("RIGHT")
oSection2:Cell("VLRMOV"):SetHeaderAlign("RIGHT")

oSection2:SetHeaderPage()	//Define o cabecalho da secao como padrao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 03                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


oSection3 := TRSection():New(oReport, STR0037, /*a/cAlias*/, aOrdem) //"Totais"

TRCell():New(oSection3, "TXTTOTAL"     , "" , STR0033 	, , 08 ,/*lPixel*/,{ || STR0033 } )	//"Total : "
TRCell():New(oSection3, "FILORIG"	   , "" , SX3->(RetTitle("E5_FILORIG"))	, PesqPict("SE5","E5_FILORIG")	, TamSX3("E5_FILORIG")[1]	,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection3, "DATA"   	   , "" , STR0042		, PesqPict("SE5","E5_DATA")  		, TamSX3("E5_DATA")[1]+4 		,/*lPixel*/,/*CodeBlock*/)	//"DATA"
TRCell():New(oSection3, "BANCO"   		, "" , cDescBanco , PesqPict("SE5","E5_BANCO")    	, TamSX3("E5_BANCO")[1]   	,/*lPixel*/,/*CodeBlock*/)	//"BCO"
TRCell():New(oSection3, "AGENCIA"		, "" , cDescAGE   , PesqPict("SE5","E5_AGENCIA")	, TamSX3("E5_AGENCIA")[1]	,/*lPixel*/,/*CodeBlock*/)	//"AGENCIA"
TRCell():New(oSection3, "CONTA"    		, "" , cDescConta , PesqPict("SE5","E5_CONTA")  	, TamSX3("E5_CONTA")[1]		,/*lPixel*/,/*CodeBlock*/)	//"CONTA"
TRCell():New(oSection3, "NATUREZA"		, "" , cDescNat	, PesqPict("SE5","E5_NATUREZ")	, 18	,/*lPixel*/,/*CodeBlock*/)	//"NATUREZA", 40 ,/*lPixel*/,/*CodeBlock*/)	//"NATUREZA"
TRCell():New(oSection3, "ENTRADA"		, "" , STR0038 , PesqPict("SE5","E5_VALOR")    	, TamSX3("E5_VALOR")[1]+1  ,/*lPixel*/,/*CodeBlock*/)	//"ENTRADA"
TRCell():New(oSection3, "SAIDA"    		, "" , STR0039 , PesqPict("SE5","E5_VALOR")    	, TamSX3("E5_VALOR")[1]+1 	,/*lPixel*/,/*CodeBlock*/)	//"SAIDA"
TRCell():New(oSection3, "VLRMOV"        , ""    , "Vlr.Mov." 	, PesqPict("SE5","E5_VALOR")    , TamSX3("E5_VALOR")[1]+1  	,/*lPixel*/,/*CodeBlock*/)	//"SAIDA"
TRCell():New(oSection3, "SALDOATUAL"	, "" , STR0040 , PesqPict("SE8","E8_SALANT")  	, TamSX3("E8_SALANT")[1]+1 	,/*lPixel*/,/*CodeBlock*/)	//"SALDO ATUAL"
TRCell():New(oSection3, "SEPARADOR"		, ""	  , ""		 	, ,2,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection3, "HISTORICO"		, ""	  , cDescHIST 	, PesqPict("SE5","E5_HISTOR")   , TamSX3("E5_HISTOR")[1]	,/*lPixel*/,{|| REPLICATE("-",TamSX3("E5_HISTOR")[1])}/*CodeBlock*/)	//"HISTORICO"

//Oculta as colunas

oSection3:Cell("DATA"    ):Hide()
oSection3:Cell("AGENCIA" ):Hide()
oSection3:Cell("CONTA"   ):Hide()
oSection3:Cell("NATUREZA"):Hide()
oSection3:Cell("SALDOATUAL"):Hide()
oSection3:Cell("BANCO"   ):Hide()



oSection3:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrint ºAutor³ Marcio Menon       º Data ³  07/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o objeto oReport definido na funcao ReportDef.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPO1 - Objeto TReport do relatorio                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport, cTitulo)

Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(2)
Local oSection3 	:= oReport:Section(3)
Local nOrdem		:= oReport:Section(1):GetOrder()

Local CbCont, CbTxt
Local nTotEnt := 0,nTotSai := 0,nGerEnt := 0,nGerSai := 0,nColuna := 0,lContinua := .T.
Local nValor,cDoc
Local lVazio  := .T.
Local nMoeda

#IFDEF TOP
	Local ni
	Local aStru 	:= SE5->(dbStruct())
	Local cIndice	:= SE5->(IndexKey())
#ENDIF

Local cIndex
Local cHistor
Local cChaveSe5
Local nTxMoeda		:=0
Local nMoedaBco	:=	1
Local nCasas		:= GetMv("MV_CENT"+(IIF(MV_PAR05 > 1 , STR(MV_PAR05,1),"")))
//Local bWhile   	:= { || IF( mv_par12 == 1, .T., SE5->E5_FILIAL == xFilial("SE5") ) }
Local nTotSaldo 	:= 0
Local aSaldo
Local nGerSaldo 	:= 0
Local nSaldoAtual := 0
Local lFirst 		:= .T.
Local nTxMoedBc	:= 0
Local cPict 		:= ""
Local nA				:= 0
Local cFilterUser := ""
Local lF620Qry 	:= ExistBlock("F620QRY")
Local cQueryAdd 	:= ""
Local nSaldoAnt 	:= 0
Local lImpSaldo 	:= .F.
Local nAscan 		:= 0
Local cAnterior 	:= ""
Local nBancos 		:= 0
Local cCond2 		:= ""
Local cCond3 		:= ""
Local cMoeda		:= ""
Local cFilterSA6	:=	oSection2:GetAdvplExp('SA6')
Local cFilterSE5	:=	oSection2:GetAdvplExp('SE5')
Local cFilterSED	:=	oSection2:GetAdvplExp('SED')
Local lPrimeiro 	:= 	.T.
Local lCxLoja 		:= GetNewPar("MV_CXLJFIN",.F.)

//consolidação - troca de empresas
Local _aAreaSM0 := {}
Local _oAppBk := oApp //Guardo a variavel resposavel por componentes visuais
Local _cEmpAtu , _cFilAtu
//Dialog
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
Local aEmps4:={}
Local aEmpAtu:={}
Local cEmps:=""
Local cSM0:=""
Local cNomeEmp:="",cUnid:=""
Local j:=0
Local y:=0
Local nOpc	:= 0
Local cNewEmp
Local cEmpNew
Local nTamValor := 19//TamSX3("E5_VALOR")[1]
Local nVlrMov   := 0

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

For j=1 to Len(aEmps3)                         
              
	IncProc()
	If aEmps3[j] [1]<>cSM0
		cSM0      := aEmps3[j][1]
		cEmpAnt   := aEmps3[j][1]
		cFilAnt   := aEmps3[j][2]
		cNomeEmp  := aEmps3[j][3]
		cUnid     := aEmps3[j][4]
		
		dbCloseAll() //Fecho todos os arquivos abertos
		OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(aEmps3[j][1] + aEmps3[j][2],.T.)) //Posiciona Empresa
		cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
		cFilAnt := SM0->M0_CODFIL
		OpenFile(cEmpAnt + cFilAnt) //Abro a empresa que eu desejo trabalhar

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso so'exista uma empresa/filial ou o SE5 seja compartilhado³
		//³ nao ha' necessidade de ser processado por filiais            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		nOrdena := nOrdem
		aEmps4:= AClone(aEmps3)
		For y:=1 to len(aEmps4) 
			IF aEmps4[y][1]==cSM0
				AADD(aEmpAtu,{aEmps4[y][1], aEmps4[y][2]})
			ENDIF
		Next

		#IFDEF TOP
			aSaldo := GetSaldo(.F., nMoeda,"","",mv_par01,"   ","ZZZ",aEmpAtu)
		#ENDIF


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso a ordem for por banco, deve-se retirar da array os bancos que mesmo com saldo, não tenham ³
		//³ sofrido movimentacoes para o periodo especificado na parametrizacao                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If nOrdem == 2
			#IFDEF TOP
				IF TcSrvType() != "AS/400"
					aSaldoAux := {}
					For nA := 1 to len(aSaldo)
						cQrySld := " SELECT COUNT(*) AS QTD FROM SE5" +cSM0 +"0 SE5 " //"+RetSQLName("SE5")+" SE5 "//ALTERADO OSCAR
						cQrySld += " WHERE SE5.E5_BANCO = '"+aSaldo[nA,2]+"' "
						cQrySld += " AND SE5.E5_AGENCIA = '"+aSaldo[nA,3]+"' "
						cQrySld += " AND SE5.E5_CONTA = '"  +aSaldo[nA,4]+"' "
						cQrySld += " AND SE5.E5_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
						cQrySld += " AND SE5.D_E_L_E_T_ = ' ' "
						cQrySld := ChangeQuery(cQrySld)

						If Select("SE5SLD") > 0
							SE5SLD->(dbCloseArea())
						EndIf
						dbUseArea(.T., "TOPCONN", TCGenQry(,,cQrySld), 'SE5SLD', .T., .T.)
						If SE5SLD->QTD > 0
							aAdd(aSaldoAux,aSaldo[nA])
						EndIf
					Next
					If MV_PAR09 == 2 //Não inclui bancos sem movimentos
						aSaldo := aSaldoAux
					EndIf
					nA := 0
					If Select("SE5SLD") > 0
						SE5SLD->(dbCloseArea())
					EndIf
				Else
			#ENDIF
					aSaldoAux := {}
					For nA := 1 to len(aSaldo)
						se5->(dbSetOrder(1))
						se5->(dbSeek(xFilial("SE5")+DTOS(mv_par01)+aSaldo[nA][2]+aSaldo[nA][3]+aSaldo[nA][4],.T.))
						lPrimeiro := .T.

						While SE5->( !Eof() .And. lPrimeiro )
							If SE5->(Eof()) .Or. (aSaldo[nA][2]+aSaldo[nA][3]+aSaldo[nA][4]) <> SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA) .Or. (SE5->E5_DATA < mv_par01 .Or. SE5->E5_DATA > mv_par02)

							Else
								aAdd(aSaldoAux,aSaldo[nA])
								lPrimeiro := .F.
							Endif
							SE5 -> ( dbSkip() )
						EndDo
						If 	MV_PAR09 == 1 .And. lPrimeiro
							aAdd(aSaldoAux,aSaldo[nA])
						EndIf
					Next
					aSaldo := aSaldoAux
					nA := 0
			#IFDEF TOP
				Endif
			#ENDIF
		Endif

		If MV_PAR05 == 0
			MV_PAR05 := 1
		Endif
		cMoeda := Str(MV_PAR05,1,0)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Defini‡„o dos cabe‡alhos												  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If MV_PAR07 == 1
			cTitulo := STR0008 //"Relacao da Movimentacao Bancaria em "
			If nOrdem == 3 .And. MV_PAR08 == 1 // Ordem de natureza nao sera impresso os saldos
				oSection2:Cell("SALDOATUAL"):Disable()
			Else
				oSection2:Cell("SALDOATUAL"):Enable()
			Endif
		Else
			cTitulo := STR0026 //"Movimentação Bancária em "
			oSection2:Cell("DATA"):Hide()
			If nOrdem == 1
				oSection2:Cell("DATA"):Setsize(10)
			Else
				oSection2:Cell("DATA"):Setsize(30)
			Endif
			oSection2:Cell("BANCO"):Hide()
			oSection2:Cell("BANCO"):SetTitle("")
			oSection2:Cell("AGENCIA"):Hide()
			oSection2:Cell("AGENCIA"):SetTitle("")
			oSection2:Cell("CONTA"):Hide()
			oSection2:Cell("CONTA"):SetTitle("")
			oSection2:Cell("NATUREZA"):Hide()
			oSection2:Cell("NATUREZA"):SetTitle("")
			oSection2:Cell("DOCUMENTO"):Hide()
			oSection2:Cell("DOCUMENTO"):SetTitle("")
			oSection2:Cell("HISTORICO"):Hide()
			oSection2:Cell("HISTORICO"):SetTitle("")
			oSection2:Cell("CENT_CUSTO"):Hide()
			oSection2:Cell("CENT_CUSTO"):SetTitle("")

			If MV_PAR08 == 1
				oSection2:Cell("SALDOATUAL"):Enable()
			Else
				oSection2:Cell("SALDOATUAL"):Disable()
			EndIf
		Endif

		nMoeda	:= MV_PAR05
		cTitulo  += GetMv("MV_MOEDA"+Str(nMoeda,1)) + STR0028 + If(MV_PAR07==1, STR0029, STR0030) + STR0028 //" - "###"Analitico"###"Sintetico"###" - "

		dbSelectArea("SE5")

		#IFDEF TOP
				cQuery := "SELECT * "
				cQuery += " FROM SE5" +cSM0 +"0 SE5 "//RetSqlName("SE5")//ALTERADO OSCAR
				cQuery += " WHERE D_E_L_E_T_ = ' '"
		#ENDIF

		If nOrdem == 1
			cTitulo += OemToAnsi(STR0011)  //" por data"
			#IFDEF TOP
				cCondicao 	:= ".T."
				cCond2 		:= "SE5_->E5_DTDISPO"

				/* GESTAO - inicio */
				cOrder		:= "E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
				/* GESTAO - fim */

			#ENDIF
		Elseif nOrdem == 2
			cTitulo += OemToAnsi(STR0013)  //" por Banco"
			SE5->(dbSetOrder(3))
			#IFDEF TOP
				cCondicao 	:= ".T."
				cCond2 := "SE5_->E5_BANCO+SE5_->E5_AGENCIA+SE5_->E5_CONTA"
				cIndice := SE5->(IndexKey())

				/* GESTAO - inicio */
				cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1)) + "+SE5_->E5_FILIAL"
				/* GESTAO - fim */

				cOrder	:= "E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL+E5_DTDISPO+R_E_C_N_O_+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO"
			#ENDIF
		Elseif nOrdem == 3
			cTitulo += OemToAnsi(STR0014)  //" por Natureza"
			SE5->(dbSetOrder(4))
			#IFDEF TOP
				cCondicao 	:= ".T."
				cCond2		:= "SE5_->E5_NATUREZ"
				cIndice := SE5->(IndexKey())

				/* GESTAO - inicio */
				cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1))+"+E5_FILIAL"
			/* GESTAO - fim */

				cOrder := cIndice
			#ENDIF
		Elseif nOrdem == 4 // Digitacao
			cCond2	  := "SE5_->E5_DTDIGIT"
			#IFDEF TOP
				/* GESTAO - inicio */
				cCondicao 	:= ".T."
				cOrder	 := "DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
				/* GESTAO - fim */
			#ENDIF
		ElseIf nOrdem >= 5 // Data da Movimentacao
			cCond2 := "SE5_->E5_DATA"
			#IFDEF TOP
				/* GESTAO - inicio */
				cCondicao 	:= ".T."
				cOrder := "DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
				/* GESTAO - fim */
			#ENDIF
		EndIF

		#IFDEF TOP
				cQuery += " AND E5_SITUACA <> 'C'"
				cQuery += " AND E5_NUMCHEQ <> '%*'"
				cQuery += " AND (E5_VENCTO <= E5_DATA Or E5_ORIGEM ='FINA087A' Or E5_ORIGEM ='FINA070' Or E5_ORIGEM ='FINA200' Or E5_ORIGEM ='FINA740')" 
				cQuery += " AND E5_DTDISPO BETWEEN '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02)       + "'"
				//cQuery += " AND E5_BANCO BETWEEN   '" + mv_par03        + "' AND '" + mv_par04       + "'"
				If !Empty(oSection2:GetSqlExp('SE5'))
					cQuery += " AND (" +oSection2:GetSqlExp('SE5')+")"
				Endif
				cQuery += " AND E5_BANCO <> '   '"
				//cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par05        + "' AND '" + mv_par06       + "'"
				cQuery += " AND E5_DTDIGIT BETWEEN '" + DTOS(MV_PAR03)        + "' AND '" + DTOS(MV_PAR04)       + "'"
				cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','BA','MT','CM','D2','J2','M2','C2','V2','CX','CP','TL')"
				
				If cPaisLoc <> "BRA"
					cQuery += " AND ((E5_TIPODOC = 'VL' AND E5_TIPO ='CH' AND E5_RECPAG ='P' ) OR E5_TIPO <> 'CH') "
				EndIf
				
				If lF620Qry
					cQueryAdd := ExecBlock("F620QRY", .F., .F.)
					If ValType(cQueryAdd) == "C"
						cQuery += " AND ( " + cQueryAdd + ")"
					EndIf
				EndIf
				cQuery += " ORDER BY " + SqlOrder(cOrder)

				cQuery := ChangeQuery(cQuery)

				dbSelectAre("SE5")
				//dbCloseArea()
				/*/Arquivo gerado .sql - salvo na maquina/*/
				MemoWrite("C:\microsiga\Movimentos_Bancários"+cSM0 +".sql",cQuery)
		
				If !Select( "SE5_" ) == 0
					SE5_->(dbCloseArea())
				Endif

				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5_', .T., .T.)//ALTERAR TABELA

		#ENDIF
		dbSelectAre("SE5_")
		oReport:SetMeter(Len(aSaldo))
		oReport:SetTitle(cTitulo)	//Altera o Titulo do relatorio

		For nBancos := 1 To IIf(nOrdem == 2, Len(aSaldo), 1)

			nTotEnt:=0
			nTotSai:=0
			nTotSaldo := 0
			lImpSaldo := (lFirst .And. nOrdem != 3) // Indica se o saldo anterior deve ser impresso

			DBSelectArea("SE5")
			DBSetOrder(1)
			//SE5->(DBSEEK(SE5_->E5_FILIAL+SE5_->E5_DATA+SE5_->E5_BANCO+SE5_->E5_AGENCIA+SE5_->E5_CONTA+SE5_->E5_NUMCHEQ))
			SE5->(DBGOTO(SE5_->R_E_C_N_O_))//UTILIZADO POIS NÃO ENCONTREI UM FILTRO QUE FOSSE EFICAZ PARA TODOS OS CASOS;
			If nOrdem == 2
				nSaldoAtual := 0
			Endif
			nSaldoAnt := 0

			// Pesquisa o saldo bancario
			If (Empty(cFilterUser) .And. nOrdem == 2) .Or. nOrdem <> 2
				If MV_PAR08 == 1 .And. lImpSaldo
					nSaldoAnt := 0
					If nOrdem == 2 // Ordem de banco
						If cPaisLoc	# "BRA" .OR. FXMultSld()
							SA6->(DbSetOrder(1))
							SA6->(DbSeek(xFilial()+aSaldo[nBancos][2]+aSaldo[nBancos][3]+aSaldo[nBancos][4]))
							nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
						EndIf
						If (!Empty(aSaldo[nBancos][2]) .And. !Empty(aSaldo[nBancos][3]) .And. !Empty(aSaldo[nBancos][4]))
							cCond3:=aSaldo[nBancos][2]+aSaldo[nBancos][3]+aSaldo[nBancos][4]
						Else
							cCond3 := "EOF"
						EndIf
						nAscan := Ascan(aSaldo, {|e| e[2]+e[3]+e[4] == cCond3 } )
						If nAscan > 0
							nSaldoAnt := Round(xMoeda(aSaldo[nAscan][6],nMoedaBco,MV_PAR05,IIf(SE5_->(EOF()),dDataBase,E5_DTDISPO),nCasas+1,nTxMoedBc),nCasas)
						Else
							nSaldoAnt := 0
						Endif
						lFirst := .T.
					Else
						// Na primeira vez, soma todos os saldos de todos os bancos
						If lFirst
							// Soma os saldos de todos os bancos
							For nA := 1 To Len(aSaldo)
								nSaldoAnt += Round(xMoeda(aSaldo[nA][6],MoedaBco(aSaldo[nA][2],aSaldo[nA][3],aSaldo[nA][4]),MV_PAR05,IIf(SE5_->(EOF()),dDataBase,E5_DTDISPO),nCasas+1,nTxMoedBc),nCasas)
							Next
							lFirst := .F.
						Else
							// Apos a impressao da primeira linha, o saldo Anterior sera igual ao
							// saldo atual, impresso na ultima linha, antes da quebra de data
							If ( cPaisLoc == "BRA" )
								nSaldoAnt := nSaldoAtual
							Else
								nSaldoAnt := Round(xMoeda(nSaldoAtual,nMoedaBco,MV_PAR05,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
							Endif
						Endif
					Endif

					cPict := tm(nSaldoAnt,18,nCasas)

					oSection1:Cell("DATA"   ):SetBlock( { || DTOC(mv_par01) } )
					oSection1:Cell("BANCO"  ):Disable()
					oSection1:Cell("AGENCIA"):Disable()
					oSection1:Cell("CONTA"  ):SetSize(11)

					If nOrdem == 2
						oSection1:Cell("TODOSBCO"):Disable()
						oSection1:Cell("BANCO"   ):Enable()
						oSection1:Cell("BANCO"   ):SetBlock( { || aSaldo[nBancos][2] } )
						oSection1:Cell("AGENCIA" ):Enable()
						oSection1:Cell("AGENCIA" ):SetBlock( { || aSaldo[nBancos][3] } )
						oSection1:Cell("CONTA"   ):Enable()
						oSection1:Cell("CONTA"   ):SetSize(20)
						oSection1:Cell("CONTA"   ):SetBlock( { || aSaldo[nBancos][4] } )
					Else
						oSection1:Cell("TODOSBCO"):Enable()
					EndIf
						oSection1:Cell("SALDOANTERIOR"):SetBlock( { || nSaldoAnt } )
						oSection1:Cell("SALDOANTERIOR"):Picture( cPict )
						nSaldoAtual := nSaldoAnt
						
						oSection1:Init()
						oSection1:PrintLine()
						oSection1:Finish()
				Else
					oSection1:Disable()	 //Desabilita a secao dos saldos
				Endif

			EndIf

			//While SE5_->(!Eof()) .And. EVAL(bWhile) .And. &cCondicao .and. lContinua
			While SE5_->(!Eof()) .And. &cCondicao .and. lContinua

				#IFNDEF TOP
					If !Fr620Skip1()
						SE5_->(dbSkip())
						Loop
					EndIf
				#ENDIF

				oReport:IncMeter()

				IF SE5_->E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(SE5_->E5_NUMCHEQ) .and. !(SE5_->E5_TIPODOC $ "TR#TE")
					SE5_->(dbSkip())
					Loop
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Na transferencia somente considera nestes numerarios 		  ³
				//³ No Fina100 ‚ tratado desta forma.                    		  ³
				//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
				//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
				//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
				//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
				//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE5_->E5_TIPODOC $ "TR/TE" .and. Empty(SE5_->E5_NUMERO)
					If !(SE5_->E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
						SE5_->(dbSkip())
						Loop
					Endif
				Endif

				If SE5_->E5_TIPODOC $ "TR/TE" .and. (Substr(SE5_->E5_NUMCHEQ,1,1)=="*" ;
					.or. Substr(SE5_->E5_DOCUMEN,1,1) == "*" )
					SE5_->(dbSkip())
					Loop
				Endif

				If SE5_->E5_MOEDA == "CH" .and. (IsCaixaLoja(SE5_->E5_BANCO) .And. !lCxLoja .And. SE5_->E5_TIPODOC $ "TR/TE")		// Sangria
					SE5_->(dbSkip())
					Loop
				Endif

				cAnterior := &cCond2
				nTotEnt	 := 0
				nTotSai	 := 0
				nTotSaldo := 0

				If nOrdem == 2
					lImpSaldo 	:= (lFirst .And. nOrdem != 3) // Indica se o saldo anterior deve ser impresso
					//nSaldoAtual 	:= 0
					//nSaldoAnt 	:= 0
				EndIf

				If nOrdem == 2
					cCond3  := "SE5_->E5_BANCO=='"+aSaldo[nBancos][2]+"' .And. SE5_->E5_AGENCIA=='"+aSaldo[nBancos][3]+"' .And. SE5_->E5_CONTA=='"+aSaldo[nBancos][4]+"'"
					// Nao processa a movimentacao caso o banco nao esteja no array aSaldo
					If aScan(aSaldo, {|e| e[2]+e[3]+e[4] == SE5_->(E5_BANCO+E5_AGENCIA+E5_CONTA) } ) == 0
						SE5_->(dbSkip())
						Loop
					EndIf
				Else
					cCond3:=".T."
				Endif

				//While SE5_->(!EOF()) .and. &cCond2 = cAnterior .and. EVAL(bWhile) .and. lContinua .And. &cCond3
 				While SE5_->(!EOF()) .and. &cCond2 = cAnterior .and. lContinua .And. &cCond3

					oSection2:Init()
					DBSelectArea("SE5")
					//DBSetOrder(1)
					SE5->(DBGOTO(SE5_->R_E_C_N_O_))//UTILIZADO POIS NÃO ENCONTREI UM FILTRO QUE FOSSE EFICAZ PARA TODOS OS CASOS;

					IF Empty(SE5_->E5_BANCO)
						SE5_->(dbSkip())
						Loop
					Endif

					oReport:IncMeter()

					IF SE5_->E5_SITUACA == "C"
						SE5_->(dbSkip())
						Loop
					EndIF

					IF SE5_->E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(SE5_->E5_NUMCHEQ) .and. !(SE5_->E5_TIPODOC $ "TR#TE")
						SE5_->(dbSkip())
						Loop
					EndIF

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Na transferencia somente considera nestes numerarios 		  ³
					//³ No Fina100 ‚ tratado desta forma.                    		  ³
					//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
					//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
					//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
					//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
					//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SE5_->E5_TIPODOC $ "TR/TE" .and. Empty(SE5_->E5_NUMERO)
						If !(SE5_->E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
							SE5_->(dbSkip())
							Loop
						Endif
					Endif

					If SE5_->E5_TIPODOC $ "TR/TE" .and. (Substr(SE5_->E5_NUMCHEQ,1,1)=="*" ;
						.or. Substr(SE5_->E5_DOCUMEN,1,1) == "*" )
						SE5_->(dbSkip())
						Loop
					Endif

					If SE5_->E5_MOEDA == "CH" .and. (IsCaixaLoja(SE5_->E5_BANCO) .And. !lCxLoja .And. SE5_->E5_TIPODOC $ "TR/TE")		// Sangria
						SE5_->(dbSkip())
						Loop
					Endif

					IF SE5_->E5_VENCTO > SE5_->E5_DATA .AND.;
						! alltrim(Upper(SE5_->E5_ORIGEM)) == "FINA087A" .AND.;
						! alltrim(Upper(SE5_->E5_ORIGEM)) == "FINA070" .AND.;
						! alltrim(Upper(SE5_->E5_ORIGEM)) == "FINA200" .AND.;
						! alltrim(Upper(SE5_->E5_ORIGEM)) == "FINA740"
						SE5_->(dbSkip())
						Loop
					EndIF

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se esta' FORA dos parametros                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF (E5_DTDISPO < mv_par01) .or. (E5_DTDISPO > mv_par02)
						SE5_->(dbSkip())
						Loop
					Endif

					IF (E5_DTDIGIT < MV_PAR03) .or. (E5_DTDIGIT > MV_PAR04)
						SE5_->(dbSkip())
						Loop
					EndIF

					IF SE5_->E5_TIPODOC $ "DCüJRüMTüBAüMTüCMüD2/J2/M2/C2/V2/CX/CP/TL"
						SE5_->(dbSkip())
						Loop
					Endif

					//  Para o Sigaloja, quando for sangria e nao for R$, nÆo listar nos
					// movimentos bancarios

					If (SE5_->E5_TIPODOC == "SG") .And. (!SE5_->E5_MOEDA $ "R$"+IIf(cPaisLoc=="BRA","","/$ ")) //Sangria com moeda <> R$
						SE5_->(dbSkip())
						Loop
					EndIf

					If SubStr(SE5_->E5_NUMCHEQ,1,1)=="*"      //cheque para juntar (PA)
						SE5_->(dbSkip())
						Loop
					Endif

					If !Empty( SE5_->E5_MOTBX )
						If !MovBcoBx(SE5_->E5_MOTBX)
							SE5_->(dbSkip())
							Loop
						Endif
					Endif

					If !Empty(cFilterSE5) .And. !SE5_->(&(cFilterSE5))
						SE5->(dbSkip())
						Loop
					Endif
					If !Empty(cFilterSA6)
						SA6->(DbSetOrder(1))
						IF !SA6->(MsSeek(xFilial()+SE5_->E5_BANCO+SE5_->E5_AGENCIA+SE5_->E5_CONTA))
							SE5_->(dbSkip())
							Loop
						Endif
					Endif
					If !Empty(cFilterSED)
						SED->(DbSetOrder(1))
						SED->(MsSeek(xFilial()+SE5_->E5_NATUREZ))
						If !SED->(&(cFilterSED))
							SE5_->(dbSkip())
							Loop
						Endif
					Endif
							
					If cPaisLoc	# "BRA" .OR. FXMultSld()
						SA6->(DbSetOrder(1))
						SA6->(MsSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
						nMoedaBco := Max(SA6->A6_MOEDA,1)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nTxMoedBc := SE5->E5_TXMOEDA
						If MV_PAR05 > 1 .and. !Empty(E5_VLMOED2)
							nTxMoeda := RecMoeda(E5_DTDISPO,MV_PAR05)
							nTxMoeda := if(nTxMoeda=0,1,nTxMoeda)
							nValor 	:= Round(xMoeda(E5_VALOR,nMoedaBco,MV_PAR05,,nCasas+1,nTxMoedBc,nTxMoeda),nCasas)
						Else
							nValor 	:= Round(xMoeda(E5_VALOR,nMoedaBco,MV_PAR05,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
						Endif
					Else
						nValor := xMoeda(E5_VALOR,1,MV_PAR05,E5_DATA)
					Endif
					lVazio := .F.
					// Calcula saldo atual
					// Se for troco(E5_MOEDA=="TC") nao altera o valor do Saldo Atual
					nSaldoAtual := If(E5_RECPAG = "R",nSaldoAtual+nValor,/*Iif(E5_MOEDA<>"TC",*/nSaldoAtual-nValor/*,nSaldoAtual)*/)

					If MV_PAR07 == 1	//Analitico

						oSection2:Cell("M0_CODIGO"):SetBlock( { || cNomeEmp   } )
						oSection2:Cell("M0_FILIAL"):SetBlock( { || SE5_->E5_FILORIG	  } )
						oSection2:Cell("DATA"):SetBlock( { || If(nOrdem != 5, SE5->E5_DTDISPO, SE5->E5_DATA) } )

						If Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 14
							cDoc := Alltrim(E5_DOCUMEN) + if(!empty(E5_DOCUMEN).and. !empty(E5_NUMCHEQ),"-","") + Alltrim(E5_NUMCHEQ )
						ELSEIF Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <> Nil
							cDoc := SUBSTR(Alltrim(E5_DOCUMEN) + if(!empty(E5_DOCUMEN).and. !empty(E5_NUMCHEQ),"-","") + Alltrim(E5_NUMCHEQ ),1,14)
						Endif

						If Empty(cDoc)
							cDoc := Alltrim(E5_PREFIXO)+if(!empty(E5_PREFIXO),"-","")+;
									Alltrim(E5_NUMERO )+if(!empty(E5_PARCELA),"-"+E5_PARCELA,"")
						Endif

						If Substr( cDoc,1,1 ) == "*"
							SE5_->(dbSkip())
							Loop
						Endif

						oSection2:Cell("DOCUMENTO"):SetBlock( { || cDoc } )

						If E5_RECPAG = "R"
							oSection2:Cell("ENTRADA"):SetBlock  ( { || nValor } )
							oSection2:Cell("ENTRADA"):SetPicture( Tm(nValor,nTamValor,MsDecimais(MV_PAR05)) )
							oSection2:Cell("SAIDA"  ):SetBlock  ( { ||  } )
						Else
							oSection2:Cell("SAIDA"  ):SetBlock  ( { || nValor } )
							oSection2:Cell("SAIDA"  ):SetPicture( Tm(nValor,nTamValor,MsDecimais(MV_PAR05)) )
							oSection2:Cell("ENTRADA"):SetBlock  ( { ||  } )
						EndIF
						
						nVlrMov := E5_VALOR
						
						If E5_RECPAG = "R"
							oSection2:Cell("VLRMOV"):SetBlock  ( { || nVlrMov } )
						Else
							nVlrMov := E5_VALOR * -1
							oSection2:Cell("VLRMOV"):SetBlock  ( { || nVlrMov } )
						EndIF
						
						//TRCell():New(oSection2, "VLRMOV"        , ""    , "Vlr.Mov." 	, PesqPict("SE5","E5_VALOR")    , TamSX3("E5_VALOR")[1]+1  	,/*lPixel*/,/*CodeBlock*/)	//"SAIDA"

						If nOrdem != 3 .And. MV_PAR08 == 1
							oSection2:Cell("SALDOATUAL"):SetBlock( { || nSaldoAtual } )
							oSection2:Cell("SALDOATUAL"):SetPicture( Tm(nSaldoAtual,nTamValor,MsDecimais(MV_PAR05)) )
						Else
							oSection2:Cell("SALDOATUAL"):Disable()
						EndIf
					Else
						oSection2:Disable()
					EndIf

					If E5_RECPAG = "R"
						nTotEnt += nValor
					Else
						// Se for troco(E5_MOEDA=="TC") ignora a soma no Total de Saida
						//nTotSai += Iif(SE5->E5_MOEDA<>"TC",nValor,0)
						nTotSai += nValor
					EndIf

					nTotSaldo += nSaldoAtual

					If MV_PAR07 == 1
						If MV_PAR06 == 1	// Imprime normalmente
							oSection2:Cell("HISTORICO"):SetBlock( { || SE5->E5_HISTOR } )
						Else					// Busca historico do titulo
							If E5_RECPAG == "R"
								cHistor		:= E5_HISTOR
								cChaveSe5	:=xFilial("SE1",SE5->E5_FILORIG) + E5_PREFIXO + ;
													E5_NUMERO + E5_PARCELA + ;
													E5_TIPO
								dbSelectArea("SE1")
								DbSetOrder(1)
								dbSeek( cChaveSe5 )
								oSection2:Cell("HISTORICO"):SetBlock( { || If(Empty(SE1->E1_HIST), cHistor, SE1->E1_HIST) } )
							Else
								cHistor		:= E5_HISTOR
								cChaveSe5	:= xFilial("SE2",SE5->E5_FILORIG) + E5_PREFIXO + ;
													E5_NUMERO + E5_PARCELA + ;
													E5_TIPO	 + E5_CLIFOR
								dbSelectArea("SE2")
								SE2->(DbSetOrder(1))
								If SE5->E5_TIPODOC == "CH"
									dbSelectArea("SEF")
									SEF->(dbSetOrder(1))
									SEF->(dbSeek(xFilial("SEF",SE5->E5_FILORIG)+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ))
									While !SEF->(Eof()) .And. SEF->(EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM) ==;
											xFilial("SEF",SE5->E5_FILORIG)+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ
										If Empty(SEF->EF_IMPRESS)
											SEF->(dbSkip())
										Else
											Exit
										EndIf
									EndDo
									SE2->(dbSeek(xFilial("SE2",SE5->E5_FILORIG)+SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_FORNECE)))
								Else
									SE2->(dbSeek(cChaveSe5))
								EndIf
								oSection2:Cell("HISTORICO"):SetBlock( { || If(Empty(SE2->E2_HIST), cHistor, SE2->E2_HIST) } )
							Endif
						Endif
					Endif

					//Tratativa de Centro de custo 
					IF E5_RECPAG = "R"
						dbSelectArea("SD2")
						SD2->(dbSetOrder(3))
						SD2->(dbSeek(xFilial("SD2",SE5->E5_FILORIG)+SE5->E5_NUMERO+SE5->E5_PREFIXO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						oSection2:Cell("CENT_CUSTO"):SetBlock( { || If(Empty(SE5->E5_CCC), SD2->D2_CCUSTO+" - "+Posicione("CTT",1,xFilial("CTT")+SD2->D2_CCUSTO,"CTT_DESC01"), SE5->E5_CCC+" - "+Posicione("CTT",1,xFilial("CTT")+SE5->E5_CCC,"CTT_DESC01")) } )
						
					ELSE
						dbSelectArea("SD1")
						SD1->(dbSetOrder(1))
						SD1->(dbSeek(xFilial("SD1",SE5->E5_FILORIG)+SE5->E5_NUMERO+SE5->E5_PREFIXO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						oSection2:Cell("CENT_CUSTO"):SetBlock( { || If(Empty(SE5->E5_CCC), SD2->D2_CCUSTO+" - "+Posicione("CTT",1,xFilial("CTT")+SD2->D2_CCUSTO,"CTT_DESC01"), SE5->E5_CCC+" - "+Posicione("CTT",1,xFilial("CTT")+SE5->E5_CCC,"CTT_DESC01")) } )
									
					ENDIF

					oSection2:PrintLine()

					//dbSelectArea("SE5")
					SE5_->(dbSkip())
				Enddo

				oSection2:Finish()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao dos totais das secoes.                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( nTotEnt + nTotSai ) != 0

					IF nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 5		//Data Dispo. # Digitacao # Data Movimentacao
						oSection2:Enable()
						If nOrdem == 1 .AND. oreport:oPage:LPORTRAIT //retrato
							oSection3:Cell("DATA"):SetSize(12)
						Endif				
						
						If nOrdem == 4 .Or. nOrdem == 5 
							If MV_PAR07 == 1 .AND. oreport:oPage:LPORTRAIT//analitico e retrato
								oSection3:Cell("DATA"):SetSize(13)
							ElseIf MV_PAR07 == 1 .AND. !oreport:oPage:LPORTRAIT//analitico e paisagem
								oSection3:Cell("DATA"):SetSize(12)
							Endif
										
							If MV_PAR07 != 1 .AND. oreport:oPage:LPORTRAIT//sintetico e retrato
								oSection3:Cell("DATA"):SetSize(29)
							ElseIf MV_PAR07 != 1 .AND. !oreport:oPage:LPORTRAIT//sintetico e paisagem
								oSection3:Cell("DATA"):SetSize(31)
							Endif				
						Endif
						oSection3:Cell("DATA"):Show()
						oSection3:Cell("DATA"):SetBlock( { || DTOC(STOD(cAnterior)) } )
						
						If MV_PAR07 != 1
						oSection3:Cell("BANCO"  ):Disable()
						Endif
						
					Elseif nOrdem == 2 	//Banco
						oSection3:Cell("DATA"   ):Hide()
						oSection3:Cell("BANCO"  ):Show()
						oSection3:Cell("AGENCIA"):Show()
						oSection3:Cell("CONTA"  ):Show()
						oSection3:Cell("BANCO"  ):SetBlock( { || Substr(cAnterior,1,3)  } )
						oSection3:Cell("AGENCIA"):SetBlock( { || Substr(cAnterior,4,5)  } )
						oSection3:Cell("CONTA"  ):SetBlock( { || Substr(cAnterior,9,10) } )
						oSection3:Cell("NATUREZA"):Hide()
						
						If MV_PAR07 != 1 //Sintetico
							If 	!oreport:oPage:LPORTRAIT// Paisagem
								oSection3:Cell("NATUREZA"):SetSize(31)
							Else
								oSection3:Cell("NATUREZA"):SetSize(26)//Retrato
							Endif
								oSection3:Cell("NATUREZA"):Hide()
						Endif
											
					ElseIf nOrdem == 3	//Natureza
						oSection2:Enable()
						oSection2:Cell("SALDOATUAL"):SetTitle("")
						oSection3:Cell("DATA"   ):Disable()
						oSection3:Cell("BANCO"  ):Disable()
						oSection3:Cell("AGENCIA"):Disable()
						oSection3:Cell("CONTA"  ):Disable()
						dbSelectArea("SED")
						dbSeek(xFilial("SED")+cAnterior)
						
							
						If MV_PAR07 == 1 .AND. oreport:oPage:LPORTRAIT//Analitico e Retrato
							oSection3:Cell("NATUREZA"):SetSize(57)
						ElseIf MV_PAR07 == 1 .AND. !oreport:oPage:LPORTRAIT//Analitico e Paisagem
							oSection3:Cell("NATUREZA"):SetSize(57)
						Endif
										
						If MV_PAR07 != 1 .AND. oreport:oPage:LPORTRAIT//Sintetico e Retrato
							oSection3:Cell("NATUREZA"):SetSize(56)
						ElseIf MV_PAR07 != 1 .AND. !oreport:oPage:LPORTRAIT//Sintetico e Paisagem
							oSection3:Cell("NATUREZA"):SetSize(71)
						Endif
										
						oSection3:Cell("NATUREZA"):Show()
						oSection3:Cell("NATUREZA"):SetBlock( { || AllTrim(MascNat(cAnterior)) + " - " + Substr(SED->ED_DESCRIC,1,30) } )
					EndIf

						oSection3:Cell("ENTRADA"):SetBlock  ( { || nTotEnt } )
						oSection3:Cell("ENTRADA"):SetPicture( Tm(nTotEnt,nTamValor,MsDecimais(MV_PAR05)) )
						oSection3:Cell("SAIDA"  ):SetBlock  ( { || nTotSai } )
						oSection3:Cell("SAIDA"  ):SetPicture( Tm(nTotSai,nTamValor,MsDecimais(MV_PAR05)) )
						
					If nOrdem != 3 .And. MV_PAR08 == 1
						oSection3:Cell("SALDOATUAL"):Show()
						oSection3:Cell("SALDOATUAL"):SetBlock( { || nSaldoAtual } )
						oSection3:Cell("SALDOATUAL"):SetPicture( Tm(nSaldoAtual,nTamValor,MsDecimais(MV_PAR05)) )
					Else
						oSection3:Cell("SALDOATUAL"):Disable()
					Endif


					oSection3:Init()
					oSection3:PrintLine()
					oSection3:Finish()

					nGerEnt 	 += nTotEnt
					nGerSai 	 += nTotSai
					nGerSaldo += (nSaldoAnt + nTotEnt - nTotSai)
					nSaldoAnt := 0
					nTotSaldo := 0
					nTotEnt   := 0
					nTotSai   := 0

				Endif
				//dbSelectArea("SE5")
				If nOrdem == 2
					Exit
				EndIf
			EndDo
		Next
		//msgalert("Trocou de Empresa")
	EndIf
Next
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do total geral.		                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nGerEnt+nGerSai) != 0
	oSection3:Cell("TXTTOTAL"):SetSize(21)
		If nOrdem == 1
			If MV_PAR07 == 1 .AND. oreport:oPage:LPORTRAIT//Analitico e Retrato
				oSection3:Cell("TXTTOTAL"):SetSize(21)
			ElseIf MV_PAR07 == 1 .AND. !oreport:oPage:LPORTRAIT//Analitico e Paisagem
				oSection3:Cell("TXTTOTAL"):SetSize(22)
			Endif
								
			If MV_PAR07 != 1 .AND. oreport:oPage:LPORTRAIT//Sintetico e Retrato
				oSection3:Cell("TXTTOTAL"):SetSize(26)
			ElseIf MV_PAR07 != 1 .AND. !oreport:oPage:LPORTRAIT//Sintetico e Paisagem
				oSection3:Cell("TXTTOTAL"):SetSize(22)
			Endif	
		Endif
				
		If nOrdem == 4 .Or. nOrdem == 5
			If MV_PAR07 == 1 .AND. oreport:oPage:LPORTRAIT//Analitico e Retrato
				oSection3:Cell("TXTTOTAL"):SetSize(21)
			ElseIf MV_PAR07 == 1 .AND. !oreport:oPage:LPORTRAIT//Analitico e Paisagem
				oSection3:Cell("TXTTOTAL"):SetSize(22)
			Endif
										
			If MV_PAR07 != 1 .AND. oreport:oPage:LPORTRAIT//Sintetico e Retrato
				oSection3:Cell("TXTTOTAL"):SetSize(24)
			ElseIf MV_PAR07 != 1 .AND. !oreport:oPage:LPORTRAIT//Sintetico e Paisagem
				oSection3:Cell("TXTTOTAL"):SetSize(22)
			Endif	
		Endif
		
	oSection3:Cell("TXTTOTAL"):SetBlock ( { || STR0017 } )	//"Total Geral : "
	oSection3:Cell("DATA"    ):Hide()
	oSection3:Cell("BANCO"   ):Hide()
	oSection3:Cell("AGENCIA" ):Hide()
	oSection3:Cell("CONTA"   ):Disable()
	
	If nOrdem == 2//Banco
		If MV_PAR07 == 1 .AND. oreport:oPage:LPORTRAIT//Analitico e Retrato
			oSection3:Cell("NATUREZA"):SetSize(16)
		ElseIf MV_PAR07 == 1 .AND. !oreport:oPage:LPORTRAIT//Analitico e Paisagem
			oSection3:Cell("NATUREZA"):SetSize(17)
		Endif
				
		If MV_PAR07 != 1 .AND. oreport:oPage:LPORTRAIT//Sintetico e Retrato
			oSection3:Cell("NATUREZA"):SetSize(29)
		ElseIf MV_PAR07 != 1 .AND. !oreport:oPage:LPORTRAIT//Sintetico e Paisagem
			oSection3:Cell("NATUREZA"):SetSize(30)
		Endif	
		
	ElseIf nOrdem == 3 //natureza
		If MV_PAR07 == 1 .AND. oreport:oPage:LPORTRAIT//Analitico e Retrato
			oSection3:Cell("NATUREZA"):SetSize(44)
		ElseIf MV_PAR07 == 1 .AND. !oreport:oPage:LPORTRAIT//Analitico e Paisagem
			oSection3:Cell("NATUREZA"):SetSize(44)
		Endif
				
		If MV_PAR07 != 1 .AND. oreport:oPage:LPORTRAIT//Sintetico e Retrato
			oSection3:Cell("NATUREZA"):SetSize(43)
		ElseIf MV_PAR07 != 1 .AND. !oreport:oPage:LPORTRAIT//Sintetico e Paisagem
			oSection3:Cell("NATUREZA"):SetSize(58)
		Endif
	Else
		oSection3:Cell("NATUREZA"):SetSize(16)
	EndIf
	
	oSection3:Cell("NATUREZA"):Hide()
	oSection3:Cell("ENTRADA" ):SetBlock  ( { || nGerEnt } )
	oSection3:Cell("ENTRADA" ):SetPicture( Tm(nGerEnt,nTamValor,MsDecimais(MV_PAR05)) )
	oSection3:Cell("SAIDA"   ):SetBlock  ( { || nGerSai } )
	oSection3:Cell("SAIDA"   ):SetPicture( Tm(nGerEnt,nTamValor,MsDecimais(MV_PAR05)) )
	oSection3:Cell("SALDOATUAL"):SetBlock( { || nGerSaldo } )
	oSection3:Cell("SALDOATUAL"):SetPicture( Tm(nGerEnt,nTamValor,MsDecimais(MV_PAR05)) )
EndIf

oSection3:Init()
oSection3:PrintLine()
oSection3:Finish()

If lVazio
	oReport:SkipLine()
	oReport:PrintText("***** " + STR0018 + " *****")	//"Nao existem lancamentos neste periodo"
EndIf

dbSelectArea("SE5")
dbCloseArea()
ChKFile("SE5")
dbSelectArea("SE5")
dbSetOrder(1)

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

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetSaldo ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obter os saldos dos bancos do SA6                          º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ lConsFil    -> Considera filiais                           º±±
±±º          ³ nMoeda      -> Codigo da moeda                             º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ aRet[n] = .F.,Banco,Agencia,Conta,Nome,Saldo               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR140 - Alterado por Oscar Prox                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSaldo( lConsFil, nMoeda, cFilDe, cFilAte, dDataSaldo, cBancoDe, cBancoAte, aEmpAtu )
Local aRet     := {}
Local aArea    := GetArea()
Local aAreaSa6 := SA6->(GetArea())
Local aAreaSe8 := SE8->(GetArea())
Local cTrbBanco                   
Local cTrbAgencia                 
Local cTrbConta                   
Local cTrbNome                    
Local nTrbSaldo                   
Local cIndSE8  := ""				
Local cSavFil  := SM0->M0_CODFIL 	
Local aAreaSm0 := SM0->(GetArea())
Local nAscan

Local lContinua		:= .F.
Local y:=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dbSelectArea("SM0")
If !lConsFil
	cFilDe  := "01"//IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )//BRANCO A ZZZ
	cFilAte := "ZZ"//IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Endif
dbSeek(cEmpAnt+cFilDe,.T.)
lSelFil := .F.
lContinua := !Eof() .and. M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL <= cFilAte


While lContinua //.AND. aEmpAtu[y][1] == M0_CODIGO
	//If lSelFil

	cFilAnt := aEmpAtu[y][2]  


	DbSelectArea("SA6")
	MsSeek( xFilial("SA6") )

	While SA6->(!Eof()) .And. SA6->A6_FILIAL == xFilial("SA6")
		If !(SA6->A6_COD >= cBancoDe .And. SA6->A6_COD <= cBancoAte)
			SA6->(DBSkip())
			Loop
		EndIf
		If SA6->A6_FLUXCAI $ "S " .Or.  nOrdena == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica banco a banco a disponibilidade imediata    		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE8")
			cTrbBanco  := SA6->A6_COD
			cTrbAgencia:= SA6->A6_AGENCIA
			cTrbConta  := SA6->A6_NUMCON
			cTrbNome   := SA6->A6_NREDUZ
			Aadd(aRet,{.F.,cTrbBanco,cTrbAgencia,cTrbConta,cTrbNome,0,nMoeda, xMoeda(SA6->A6_LIMCRED,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),MV_PAR05)})
			// Pesquiso o saldo na data anterior a data solicitada
			If MsSeek(xFilial("SE8")+SA6->(A6_COD+A6_AGENCIA+A6_NUMCON), .T.)
				While SE8->(!EOF())	.And. SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) ==	SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And. xFilial("SE8") == SE8->E8_FILIAL
					SE8->(dbSkip())
				End
				DbSkip(-1)
				While SE8->(!Bof()) .And. SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) ==	SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And. xFilial("SE8") == SE8->E8_FILIAL	.And.;
						SE8->E8_DTSALAT >= dDataSaldo
					SE8->(dbSkip( -1 ))
				End
			EndIf
			While SE8->(!Eof()) .And. SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) == SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And. xFilial("SE8") == SE8->E8_FILIAL .And.;
	            SE8->E8_DTSALAT < dDataSaldo
				nTrbSaldo := xMoeda(SE8->E8_SALATUA,1,nMoeda)
				// Pesquisa banco+agencia+conta, para nao exibir saldos duplicados.
				nAscan := Ascan(aRet, {|e| e[2]+e[3]+e[4] == cTrbBanco+cTrbAgencia+cTrbConta})
				If nAscan > 0
					aRet[nAscan][6] := aRet[nAscan][6] + nTrbSaldo
				Else
					Aadd(aRet,{.F.,cTrbBanco,cTrbAgencia,cTrbConta,cTrbNome,nTrbSaldo,nMoeda, xMoeda(SA6->A6_LIMCRED,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),MV_PAR05)})
				Endif
				SE8->(DbSkip())
			EndDo
		Endif
		dbSelectArea("SA6")
		SA6->(dbSkip())
	End
		
	If Empty(xFilial("SA6")) .And.;
		Empty(xFilial("SE8"))
		Exit
	Endif
	y++//contador
	lContinua := !Eof() .and. aEmpAtu[y][1] == cEmpAnt .and.  aEmpAtu[y][2] <= cFilAte

EndDo

SM0->(RestArea(aAreaSM0))
cFilAnt := cSavFil

If ( !Empty(cIndSE8) )
	dbSelectArea("SE8")
	RetIndex("SE8")
	dbClearFilter()
	Ferase(cIndSE8+OrdBagExt())
EndIf

SA6->(RestArea(aAreaSa6))
SE8->(RestArea(aAreaSe8))
RestArea(aArea)

Return aRet

//-------------------------------------------------------------------
/*{PROTHEUS.DOC} ValidSX1
MONTAGEM DA TELA DE PERGUNTAS

@AUTHOR OSCAR ALDERETE
@SINCE 19/07/2018
@VERSION 1.0
*/
//-------------------------------------------------------------------
Static Function ValidSX1( cPerg )
Local i, j
Local aRegs         := {}
 
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)
 
aAdd( aRegs, { cPerg,"01","A partir da data : ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd( aRegs, { cPerg,"02","Ate a data       : ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd( aRegs, { cPerg,"03","Da Data de digitação : ","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd( aRegs, { cPerg,"04","Ate a data de digitação : ","",""   ,"mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd( aRegs, { cPerg,"05","Moeda ?	 "			 		 ,"","","mv_ch5","N",02,0,0,"G","VerifMoeda(mv_par05) ","mv_par05","","",""," 1","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd( aRegs, { cPerg,"06","Imp. Histórico ?	 "			 ,"","","mv_ch6","N",01,0,0,"C","","mv_par06","Da Movimentacao","","","","","Do Titulo","","","","","","","","","","","","","","","","","","",""})
aAdd( aRegs, { cPerg,"07","Imprime ?	 "				 ,"","","mv_ch7","N",01,0,0,"C","","mv_par07","Analitico","","","","","Sintético","","","","","","","","","","","","","","","","","","","",""})
aAdd( aRegs, { cPerg,"08","Imprime Saldos?"				 ,"","","mv_ch8","N",01,0,0,"C","","mv_par08","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})
aAdd( aRegs, { cPerg,"09","Inclui Bancos sem movimentos?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})

 
For i := 1 to Len( aRegs )
    If !SX1->(DbSeek( cPerg + aRegs[ i, 2 ] ))
        RecLock("SX1", .T. )
        For j := 1 To fCount()
            If j <= Len( aRegs[ i ] )
                FieldPut( j, aRegs[ i, j ] )
            Endif
        Next
        MsUnlock()
    Endif
Next
 
Return