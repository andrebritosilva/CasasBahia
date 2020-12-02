#Include "Protheus.Ch"
#Include "Rwmake.Ch" 
#Include "TopConn.Ch"

#DEFINE TAM_VALOR  20
#DEFINE TAM_CONTA   17
#DEFINE AJUST_CONTA  10

Static lFWCodFil := .T. 
Static cTpValor  := "D"
Static __cSegOfi := ""   

Static _oCTBR400

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçao    ¦ CBCTB01R ¦RODRIGO T. SILVA    ¦ Data ¦ 20/06/18            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RAZÃO CENTRO DE CUSTO                                      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Projeto  ¦ GRUPO CB                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function CBCTB01R()
	
	Local oReportCB
	Local aOrdBag     	:= {}
	Local cArqMov     	:= ""
	Local lOk 			:= .T.
	Local aCtbMoeda		:= {}
	Local nDivide		:= 1
	Local aArea 		:= GetArea()
	Local lRet          := .T.
	Local i:= 0
	
	Private nomeProg  	:= "CBCTB01R"
	Private cAliasMov   := ""
	Private cPerg		:= Padr("CBCTB01R",10)
	Private lTodasFil	:= .F.
	Private aSelGp		:= {}
 	private _cTabFor    := '' 
 	private _cTabCli    := ''
	
	AjusteSx1()
	
	Pergunte(cPerg,.T.)

	aCtbMoeda  	:= CtbMoeda(mv_par11) // Moeda?
	
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
	    lOk := .F.
	Endif
	
	If mv_par13 == 1 .And. Len( aSelGp ) <= 0
		aSelGp := CBGETGP(@lTodasFil)
		If Len( aSelGp ) <= 0
			lOk := .F.
		EndIf
	EndIf 
	
	If lOk
		oReportCB := ReportDef(aCtbMoeda,nDivide)
		oReportCB:PrintDialog()
	EndIf
 
	RestArea(aArea)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRUE070A  ºAutor  ³Microsiga           º Data ³  06/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef(aCtbMoeda,nDivide)
	
	Local oReportCB
	Local oSectionCB
	Local cDesc1 		:= "Este programa ira imprimir o Razão Contabil CC"
	Local cDesc2 		:= "de acordo com os parametros solicitados pelo Usuario"
	Local cDesc3		:= "usuario."
	Local xI
	Local oBreak
	Local aSetOfBook 	:= CTBSetOf("")	
    Local cPicture 		:= aSetOfBook[4]      
	Local nDecimais 	:= DecimalCTB(aSetOfBook,MV_PAR11)
	Local cDescMoeda 	:= aCtbMoeda[2]
	Local aTamConta		:= TAMSX3("CT1_CONTA")
	Local aTamCusto		:= TAMSX3("CT3_CUSTO")
	Local nTamConta		:= Len(CriaVar("CT1_CONTA"))
	Local nTamHist		:= If(cPaisLoc$"CHI|ARG",29,40)
	Local nTamItem		:= Len(CriaVar("CTD_ITEM"))
	Local nTamCLVL		:= Len(CriaVar("CTH_CLVL"))
	Local nTamLote		:= Len(CriaVar("CT2_LOTE")+CriaVar("CT2_SBLOTE")+CriaVar("CT2_DOC")+CriaVar("CT2_LINHA"))
	Local nTamData		:= 10	
	Local cSayCusto		:= CtbSayApro("CTT")
	Local titulo		:= "Razão Contabil C. Custo"
	Local aTamVal		:= TAMSX3("CT2_VALOR")
	Local _cNomFil      := ''
		
	oReportCB := TReport():New(nomeProg,titulo,,{|oReportCB| ReportPrint(oReportCB,aSetOfBook,cDescMoeda,cSayCusto,nDivide)},cDesc1+cDesc2+cDesc3)
	oReportCB:SetLandscape(.T.)
	oReportCB:SetTotalInLine(.F.)
	oReportCB:ShowHeader()	
	
	oSectionCB := TRSection():New(oReportCB, Titulo ,{"cArqTmp",'CT2'},,,)

	TRCell():New(oSectionCB,"EMP" 						,"cArqTmp",,,02,.F.,{||cArqTmp->EMP})
	TRCell():New(oSectionCB,"FILIAL" 					,"cArqTmp",,,06,.F.,{||cArqTmp->FILORI})
	TRCell():New(oSectionCB,"DESCR FILIAL" 				,"cArqTmp",,,06,.F.,{||cArqTmp->NOMFIL })
	TRCell():New(oSectionCB,"DATA" 						,"cArqTmp",,,10,.F.,{||DTOC(cArqTmp->DATAL)})
	TRCell():New(oSectionCB,"CONTA CONTÁBIL" 			,"cArqTmp",,,aTamConta[1],.F.,{||cArqTmp->CONTA})
	TRCell():New(oSectionCB,"DESCRIÇÃO CONTA CONTÁBIL" 	,"cArqTmp",,,40,.F.,{||cArqTmp->DESCRI})
	TRCell():New(oSectionCB,"CENTRO DE CUSTO" 			,"cArqTmp",,,aTamCusto[1],.F.,{||cArqTmp->CCUSTO})
	TRCell():New(oSectionCB,"DESCRIÇÃO CENTRO DE CUSTO" ,"cArqTmp",,,40,.F.,{||cArqTmp->DESCCC})
	TRCell():New(oSectionCB,"LOTE/SUB/DOC/LINHA" 		,"cArqTmp",,,20,.F.,{||cArqTmp->LOTE+cArqTmp->SUBLOTE+cArqTmp->DOC+cArqTmp->LINHA})
	TRCell():New(oSectionCB,"HISTORICO" 				,"cArqTmp",,,60,.F.,{||cArqTmp->HISTORICO})
	TRCell():New(oSectionCB,"CODIGO FOR/CLI" 			,"cArqTmp",,,12,.F.,{||cArqTmp->CODFOR})
	TRCell():New(oSectionCB,"FORNECEDOR/CLIENTE" 		,"cArqTmp",,,50,.F.,{||cArqTmp->FORNE})
	TRCell():New(oSectionCB,"PEDIDO " 					,"cArqTmp",,,50,.F.,{||cArqTmp->PEDIDO}) 
	//TRCell():New(oSectionCB,"ID. VOO"					,"cArqTmp",,,08,.F.,{||cArqTmp->IDVOO}) 
	TRCell():New(oSectionCB,"XPARTIDA" 					,"cArqTmp",,,aTamConta[1],.F.,{||cArqTmp->XPARTIDA})
	TRCell():New(oSectionCB,"ITEM CONTA" 				,"cArqTmp",,,nTamItem,.F.,{||cArqTmp->ITEM})
	TRCell():New(oSectionCB,"COD CL VAL" 				,"cArqTmp",,,nTamCLVL,.F.,{||cArqTmp->CLVL})
	TRCell():New(oSectionCB,"DEBITO" 					,"cArqTmp",,,aTamVal[1]+2,.F.,{||cArqTmp->LANCDEB*(-1)})
	TRCell():New(oSectionCB,"CREDITO" 					,"cArqTmp",,,aTamVal[1]+2,.F.,{||cArqTmp->LANCCRD})
	TRCell():New(oSectionCB,"SALDO ATUAL" 				,"cArqTmp",,,aTamVal[1]+2,.F.,{||(cArqTmp->LANCDEB*(-1)) + cArqTmp->LANCCRD})
	
Return oReportCB

 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRUE070A  ºAutor  ³Microsiga           º Data ³  06/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReportCB,aSetOfBook,cDescMoeda,cSayCusto,nDivide)

	Local oSectionCB 	:= oReportCB:Section(1)

	Local aTamConta		:= TAMSX3("CT1_CONTA")
	Local aTamCusto		:= TAMSX3("CTT_CUSTO") 
	Local aTamVal		:= TAMSX3("CT2_VALOR")
	Local aCtbMoeda		:= {}
	Local aSaveArea 	:= GetArea()                       
	Local aCampos
	Local cChave
	Local aChave		:= {}
	Local nTamHist		:= Len(CriaVar("CT2_HIST"))
	Local nTamItem		:= Len(CriaVar("CTD_ITEM"))
	Local nTamCLVL		:= Len(CriaVar("CTH_CLVL"))
	Local nDecimais		:= 0    
	Local cMensagem		:= " O plano gerencial nao esta disponivel nesse relatorio. "
	Local lCriaInd 		:= .F.
	Local nTamFilial 	:= IIf( lFWCodFil, FWGETTAMFILIAL, TamSx3( "CT2_FILIAL" )[1] )
	Local cTableNam1 	:= ""
	Local lNumAsto      := Iif(cPaisLoc == "PAR" .And. CT2->(FieldPos("CT2_NACSEQ")) > 0, .T., .F.)
	Local nX 		    := 0
 

	Pergunte(cPerg,.F.)
	
	cContaIni	:= mv_par03
	cContaFim	:= mv_par04
	cCustoIni	:= mv_par05
	cCustoFim	:= mv_par06
	cItemIni	:= mv_par07
	cItemFim    := mv_par08
	cCLVLIni    := mv_par09
	cCLVLFim    := mv_par10
	cMoeda      := mv_par11
	dDataIni	:= mv_par01
	dDataFim	:= mv_par02
	cSaldo		:= mv_par12
	nGrupo		:= mv_par13
	
	// Retorna Decimais
	aCtbMoeda := CTbMoeda(cMoeda)
	nDecimais := aCtbMoeda[5]
	                
	aCampos :={	{ "CONTA"		, "C", aTamConta[1]	, 0 },;  		// Codigo da Conta
				{ "XPARTIDA"   	, "C", aTamConta[1] , 0 },;			// Contra Partida
				{ "TIPO"       	, "C", 01			, 0 },;			// Tipo do Registro (Debito/Credito/Continuacao)
				{ "LANCDEB"		, "N", aTamVal[1]+2	, nDecimais },; // Debito
				{ "LANCCRD"		, "N", aTamVal[1]+2	, nDecimais },; // Credito
				{ "SALDOSCR"	, "N", aTamVal[1]+2	, nDecimais },; // Saldo
				{ "TPSLDANT"	, "C", 01			, 0 },; 		// Sinal do Saldo Anterior => Consulta Razao
				{ "TPSLDATU"	, "C", 01			, 0 },; 		// Sinal do Saldo Atual => Consulta Razao			
				{ "HISTORICO"	, "C", nTamHist   	, 0 },;			// Historico
				{ "CCUSTO"		, "C", aTamCusto[1]	, 0 },;			// Centro de Custo
				{ "ITEM"		, "C", nTamItem		, 0 },;			// Item Contabil
				{ "CLVL"		, "C", nTamCLVL		, 0 },;			// Classe de Valor
				{ "DATAL"		, "D", 10			, 0 },;			// Data do Lancamento
				{ "LOTE" 		, "C", 06			, 0 },;			// Lote
				{ "SUBLOTE" 	, "C", 03			, 0 },;			// Sub-Lote
				{ "DOC" 		, "C", 06			, 0 },;			// Documento
				{ "LINHA"		, "C", 03			, 0 },;			// Linha
				{ "SEQLAN"		, "C", 03			, 0 },;			// Sequencia do Lancamento
				{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico
				{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original
				{ "FILORI"		, "C", nTamFilial	, 0 },;			// Filial Original
				{ "NOMFIL"		, "C", 100			, 0 },;			// Filial Original
				{ "NOMOV"		, "L", 01			, 0 },;			// Conta Sem Movimento
				{ "FILIAL"		, "C", nTamFilial	, 0 },;         // Filial do Sistema
				{ "EMP"			, "C", 02			, 0 },;         // Grupo de Empresa
				{ "DESCRI"		, "C", 40			, 0 },;         // Descrição Conta
				{ "DESCCC"		, "C", 40			, 0 },;         // Descrição CC
				{ "CODFOR"		, "C", 12  			, 0 },;   		// Cod Fornecedor
				{ "PEDIDO"		, "C", 40  			, 0 },;   		// Nro Pedido 
				{ "FORNE"		, "C", 50  			, 0 }} 			// Fornecedor { "IDVOO"		, "C", 08  			, 0 },;   		// Nro Pedido
	
	//Apaga a tabela temporária do banco caso já exista
	If _oCTBR400 <> Nil
		_oCTBR400:Delete()
	    _oCTBR400 := Nil
	Endif

	//-------------------
	//Criação do objeto
	//-------------------
	_oCTBR400 := FWTemporaryTable():New("cArqTmp")
	_oCTBR400:SetFields( aCampos )

	lCriaInd := .T.

	cChave 	:= "EMP+FILIAL+CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	aChave	:= {"EMP","FILIAL","CCUSTO","CONTA","DATAL","LOTE","SUBLOTE","DOC","LINHA","EMPORI","FILORI"}

	If lCriaInd
		_oCTBR400:AddIndex("1", aChave)
	Endif	
	        
	//------------------
	//Criação da tabela
	//------------------
	_oCTBR400:Create()
	
	cTableNam1 		:= _oCTBR400:GetRealName()        

	DbSelectarea("cArqTmp")
	DbSetOrder(1)

	For nX	:= 1 To Len(aSelGp)

		// Monta Arquivo para gerar o Razao
		CBRaz01(cContaIni,cContaFim,cCustoIni,cCustoFim,cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,aSelGp[nX],cSaldo,nGrupo)
	
	Next nX	
	
	oReportCB:SetMeter(("cArqTmp")->(Reccount()))
	oSectionCB:Init()

    Dbselectarea("cArqTmp")
    Dbgotop()
	Do While !("cArqTmp")->(EOF())
		If oReportCB:Cancel()
			Exit
		EndIf	
		oSectionCB:Cell('Razão Centro de Custo')
		oSectionCB:PrintLine()
		oReportCB:IncMeter()
		("cArqTmp")->(DbSkip())
	EndDo

	oSectionCB:Finish()

	("cArqTmp")->(dbCloseArea())

	RestArea(aSaveArea)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRUE070A  ºAutor  ³Microsiga           º Data ³  06/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjusteSX1()

	Local nXX 		:= 0
	Local aPerg		:= {}
	
	aAdd( aPerg, {"Data Inicial                  ?", "D", 08, 00, "G", "", "", "", "", ""							, ""	, "" } )  //01
	aAdd( aPerg, {"Data Final                    ?", "D", 08, 00, "G", "", "", "", "", ""							, ""	, "" } )  //02
	aAdd( aPerg, {"Da Conta                      ?", "C", 20, 00, "G", "", "", "", "", ""							, "CT1"	, "" } )  //03
	aAdd( aPerg, {"Ate a Conta                   ?", "C", 20, 00, "G", "", "", "", "", ""							, "CT1"	, "" } )  //04
	aAdd( aPerg, {"Do C.Custo                    ?", "C", 09, 00, "G", "", "", "", "", ""							, "CTT"	, "" } )  //05
	aAdd( aPerg, {"Ate o C.Custo                 ?", "C", 09, 00, "G", "", "", "", "", ""							, "CTT"	, "" } )  //06
	aAdd( aPerg, {"Do Item Conta                 ?", "C", 09, 00, "G", "", "", "", "", ""							, "CTD"	, "" } )  //07
	aAdd( aPerg, {"Ate o Item Conta              ?", "C", 09, 00, "G", "", "", "", "", ""							, "CTD"	, "" } )  //08
	aAdd( aPerg, {"Da Class Vl                   ?", "C", 09, 00, "G", "", "", "", "", ""							, "CTH"	, "" } )  //09
	aAdd( aPerg, {"Ate a Class Vl                ?", "C", 09, 00, "G", "", "", "", "", ""							, "CTH"	, "" } )  //10
	aAdd( aPerg, {"Moeda                         ?", "C", 02, 00, "G", "", "", "", "", ""							, "CTO"	, "" } )  //11
	aAdd( aPerg, {"Imprime Saldos                ?", "C", 01, 00, "G", "", "", "", "", ""							, "SLD"	, "" } )  //12
	aAdd( aPerg, {"Seleciona Grupos              ?", "N", 01, 00, "C", "Sim", "Nao", "", "", ""						, ""	, "" } )  //13
	
	For nXX := 1 To Len(aPerg)
		If !SX1->(Dbseek( cPerg + StrZero(nXX, 2)))
			Reclock("SX1",.T.)
			SX1->X1_GRUPO 		:= cPerg
			SX1->X1_ORDEM		:= StrZero(nXX, 2)
			SX1->X1_VARIAVL		:= "mv_ch" + Chr( nXX +96 )
			SX1->X1_VAR01		:= "mv_par" + StrZero(nXX,2)
			SX1->X1_PRESEL		:= 1
			SX1->X1_PERGUNT		:= aPerg[ nXX , 01 ]
			SX1->X1_TIPO 		:= aPerg[ nXX , 02 ]
			SX1->X1_TAMANHO		:= aPerg[ nXX , 03 ]
			SX1->X1_DECIMAL		:= aPerg[ nXX , 04 ]
			SX1->X1_GSC  		:= aPerg[ nXX , 05 ]
			SX1->X1_DEF01		:= aPerg[ nXX , 06 ]
			SX1->X1_DEF02		:= aPerg[ nXX , 07 ]
			SX1->X1_DEF03		:= aPerg[ nXX , 08 ]
			SX1->X1_DEF04		:= aPerg[ nXX , 09 ]
			SX1->X1_DEF05		:= aPerg[ nXX , 10 ]
			SX1->X1_F3   		:= aPerg[ nXX , 11 ]
			SX1->X1_HELP   		:= aPerg[ nXX , 12 ]
			SX1->(MsUnlock())
		EndIf
	Next nXX
	
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbRazao  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbRazao(oMeter,Dlg,lEnd,cContaIni,cContaFim,		   ³±±
±±³			  ³cCustoIni,cCustoFim, cItemIni,cItemFim,cCLVLIni,cCLVLFim,   ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo)                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
Static Function CBRaz01(cContaIni,cContaFim,cCustoIni,cCustoFim,cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,aSelGp,cSaldo,nGrupo)

	Local cCpoChave			:= ""
	Local cTmpChave			:= ""
	Local cContaI			:= ""
	Local cContaF			:= ""
	Local cCustoI			:= ""
	Local cCustoF			:= ""
	Local cValid			:= ""
	Local cItemI			:= ""
	Local cItemF			:= ""
	Local cClVlI			:= ""
	Local cClVlF			:= ""
	Local cVldEnt			:= ""
	Local cAlias			:= ""
	Local cFilMoeda			:= ""
	Local cAliasCT2			:= "CT2"
	Local bCond				:= {||.T.}
	Local cQryFil			:= '' // variavel de condicional da query
	Local cTmpCT2Fil		
	Local cQuery			:= ""
	Local cOrderBy			:= ""
	Local nI				:= 0
	Local aStru				:= {}
	Local cContaRang		:= ""
	Local cItemRang			:= ""
	Local cClasRang			:= ""
	Local cQryTemp			:= ""
	Local cAliasTemp		:= GetNextAlias()
	Local cFil_Save
	Local nX
	Local lNumAsto     		:= .F.
	Local caArqCt1			:= ""	
	Local caArqCtt			:= ""
	Local caArqCt2			:= ""
	Local cRetorno          := ""
	Local lFiltro           := .T.
	DEFAULT aSelGp  := {}
	
	SaveInter()//Usado o Save Inter para salvar as Variaveis

	If nGrupo == 1
		// SX3 
		dbUseArea(.T.,"CTREECDX", "\SYSTEM\SX2"+aSelGp+"0.DTC","TMA",.T.)
		cIndA := CriaTrab(NIL,.F.)
		IndRegua("TMA",cIndA,"X2_CHAVE",,,"Selecionando Registros...")
	       
		Dbselectarea("TMA")
		Dbgotop()
		If Dbseek("CT1")
			caArqCt1	:= Alltrim(TMA->X2_ARQUIVO)	
		EndIf
		Dbselectarea("TMA")
		Dbgotop()
		If Dbseek("CTT")
			caArqCtt	:= Alltrim(TMA->X2_ARQUIVO)	
		EndIf
		Dbselectarea("TMA")
		Dbgotop()
		If Dbseek("CT2")
			caArqCt2	:= Alltrim(TMA->X2_ARQUIVO)	
		EndIf 
		
		Dbselectarea("TMA")
		Dbgotop()
		If Dbseek("SA2")
			_cTabFor := Alltrim(TMA->X2_ARQUIVO)	
		EndIf 
			
		Dbselectarea("TMA")
		Dbgotop()
		If Dbseek("SA1")
			_cTabCli := Alltrim(TMA->X2_ARQUIVO)	
		EndIf    
		
		TMA->(DbClosearea())   
		
	Else
		caArqCt1	:= RetSqlname("CT1")
		caArqCtt	:= RetSqlname("CTT")
		caArqCt2	:= RetSqlname("CT2")
	Endif
	
	cCustoI	:= CCUSTOINI
	cCustoF	:= CCUSTOFIM
	cContaI	:= CCONTAINI
	cContaF	:= CCONTAFIM
	cItemI	:= CITEMINI
	cItemF	:= CITEMFIM
	cClvlI	:= CCLVLINI
	cClVlF 	:= CCLVLFIM
	
	cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "
	
	cRetorno := U_xValUser(aSelGp)
	
	If "@" $ cRetorno //Se o usuário tiver acesso Full não será necessário filtrar por filial
		lFiltro := .F. 
	EndIf
	
	If Empty(cCustoIni)
		cCustoIni := PadR( cCustoIni ,Len(CTT->CTT_CUSTO) )
	Endif
	
	dbSelectArea("CT2")
	dbSetOrder(4)
	//Verificando se foi selecionado o tipo Range e se ja esta preenchido
	If Empty(cCustoIni)
		cValid	:= 	"CT2_CCD > '" + cCustoIni + "'  AND  " +;
					"CT2_CCD <= '" + cCustoFim + "'"
	Else
		cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'" +;
					"AND CT2_CCD <= '" + cCustoFim + "'"
	EndIf
	cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'" +;
					"AND CT2_DEBITO <= '" + cContaFim + "'" +;
					"AND CT2_ITEMD >= '" + cItemIni + "'" +;
					"AND CT2_ITEMD <= '" + cItemFim + "'" +;
					"AND CT2_CLVLDB >= '" + cClVlIni + "'" +;
					"AND CT2_CLVLDB <= '" + cClVlFim + "'"

	cOrderBy	:= " CT2_FILIAL, CT2_CCD, CT2_DATA "
	cAliasCT2	:= "cAliasCT2"
	
	cQuery	:= " SELECT CT2.R_E_C_N_O_ REGIS, CT2.*, "
	cQuery	+= "( SELECT CT1_DESC01 FROM "+caArqCt1+" CT1A WHERE CT1A.CT1_CONTA = CT2.CT2_DEBITO AND CT1A.D_E_L_E_T_ <> '*' ) AS DESCRI, "
	cQuery	+= "( SELECT CTT_DESC01 FROM "+caArqCtt+" CTTA WHERE CTTA.CTT_CUSTO = CT2.CT2_CCD AND CTTA.D_E_L_E_T_ <> '*' ) AS DESCCC "
	cQuery	+= " FROM "+caArqCt2+" CT2 "
	If !lFiltro
		cQuery	+= " WHERE  D_E_L_E_T_ = ' ' AND CT2_FILIAL <> '**' AND " 
	Else
		cQuery	+= " WHERE  D_E_L_E_T_ = ' ' AND CT2_FILIAL " + cRetorno + " AND "
	EndIf
	
	If(!Empty(cValid))
		cQuery	+= cValid + " AND "
	EndIf
	cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
	cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
	If(!Empty(cVldEnt))
		cQuery	+= cVldEnt+ " AND "
	EndIf
	cQuery	+= cFilMoeda + " AND "
	cQuery	+= " CT2_TPSALD = '"+ cSaldo + "'"
	cQuery	+= " AND (CT2_DC = '1' OR CT2_DC = '3')"
	
	cQuery   += " AND CT2_VALOR <> 0 "
	
	
		// Para testes
		//cQuery	+= " AND CT2_DEBITO = '31201009'"
	
	cQuery	+= " ORDER BY "+ cOrderBy
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
	aStru := CT2->(dbStruct())
	
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next ni
	
	dbSelectArea(cAliasCT2)
	While !Eof()
		CBGrvRAZ(cMoeda,cSaldo,"1",cAliasCT2,aSelGp,caArqCt2)
		dbSelectArea(cAliasCT2)
		dbSkip()
	EndDo
	If ( Select ( "cAliasCT2" ) <> 0 )
		dbSelectArea ( "cAliasCT2" )
		dbCloseArea ()
	Endif
	
	dbSelectArea("CT2")
	dbSetOrder(5)
	
	cVldEnt := ""
	cValid  :=	 ""
		
	If Empty(cCustoIni)
			cValid 	:= 	"CT2_CCC > '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'"
	Else
		cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "'" +;
						"AND CT2_CCC <= '" + cCustoFim + "'"
	EndIf
	cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "'" +;
					"AND CT2_CREDIT <= '" + cContaFim + "'" +;
					"AND CT2_ITEMC >= '" + cItemIni + "'" +;
					"AND CT2_ITEMC <= '" + cItemFim + "'" +;
					"AND CT2_CLVLCR >= '" + cClVlIni + "'" +;
					"AND CT2_CLVLCR <= '" + cClVlFim + "'"
				
	cOrderBy:= " CT2_FILIAL, CT2_CCC, CT2_DATA "
	
	cAliasCT2	:= "cAliasCT2"
	
	cQuery	:= " SELECT CT2.R_E_C_N_O_ REGIS, CT2.*, "
	cQuery	+= "( SELECT CT1_DESC01 FROM "+caArqCt1+" CT1A WHERE CT1A.CT1_CONTA = CT2.CT2_CREDIT AND CT1A.D_E_L_E_T_ <> '*' ) AS DESCRI, "
	cQuery	+= "( SELECT CTT_DESC01 FROM "+caArqCtt+" CTTA WHERE CTTA.CTT_CUSTO = CT2.CT2_CCC AND CTTA.D_E_L_E_T_ <> '*' ) AS DESCCC "
	cQuery	+= " FROM "+caArqCt2+" CT2 "
	
	If !lFiltro
		cQuery	+= " WHERE  D_E_L_E_T_ = ' ' AND CT2_FILIAL <> '**' AND " 
	Else
		cQuery	+= " WHERE  D_E_L_E_T_ = ' ' AND CT2_FILIAL " + cRetorno + " AND "
	EndIf       
	
	If(!Empty(cValid))	
		cQuery	+= cValid + " AND "
	EndIf
	cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
	cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
	If(!Empty(cVldEnt))
		cQuery	+= cVldEnt+ " AND "
	EndIf
	cQuery	+= cFilMoeda + " AND "
	cQuery	+= " CT2_TPSALD = '"+ cSaldo + "' AND "
	cQuery	+= " (CT2_DC = '2' OR CT2_DC = '3') AND "
	cQuery	+= " CT2_VALOR <> 0  "
 
	
   		// Para testes
		//cQuery	+= "AND CT2_CREDIT = '31201009'"
			
	cQuery	+= " ORDER BY "+ cOrderBy
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
	
	aStru := CT2->(dbStruct())
	
	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C'
			TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		Endif
	Next ni
	
	dbSelectArea(cAliasCT2)
	While !Eof()
		CBGrvRAZ(cMoeda,cSaldo,"2",cAliasCT2,aSelGp,caArqCt2)
		dbSelectArea(cAliasCT2)
		dbSkip()
	EndDo
	
	If ( Select ( "cAliasCT2" ) <> 0 )
		dbSelectArea ( "cAliasCT2" )
		dbCloseArea ()
	Endif
	
	RestInter()
	CtbTmpErase(cTmpCT2Fil)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBCTB01R  ºAutor  ³Microsiga           º Data ³  06/20/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CBGrvRAZ(cMoeda,cSaldo,cTipo,cAliasCT2,aSelGp,caArqCt2)

	Local cConta
	Local cContra
	Local cCusto
	Local cItem
	Local cCLVL
	Local cChave   		:= ""
	Local lFind   		:= .F.
	Local lImpCPartida 	:= GetNewPar("MV_IMPCPAR",.T.)
	Local lNumAsto     	:= Iif(cPaisLoc == "PAR" .And. CT2->(FieldPos("CT2_NACSEQ")) > 0, .T., .F.)
	
	DEFAULT cAliasCT2	:= "CT2"
	
	If cTipo == "1"
		cConta 	:= (cAliasCT2)->CT2_DEBITO
		cContra	:= (cAliasCT2)->CT2_CREDIT
		cCusto	:= (cAliasCT2)->CT2_CCD
		cItem	:= (cAliasCT2)->CT2_ITEMD
		cCLVL	:= (cAliasCT2)->CT2_CLVLDB
	EndIf	

	If cTipo == "2"
		cConta 	:= (cAliasCT2)->CT2_CREDIT
		cContra := (cAliasCT2)->CT2_DEBITO
		cCusto	:= (cAliasCT2)->CT2_CCC
		cItem	:= (cAliasCT2)->CT2_ITEMC
		cCLVL	:= (cAliasCT2)->CT2_CLVLCR
	EndIf	
	
	// Buscando Informações referentes ao Pedido e fornecedor.
	_aForn  := _BuscaForn( (cAliasCT2)->CT2_FILIAL, (cAliasCT2)->REGIS, caArqCt2 )
	_cNomFil:= FWFilialName( aSelGp,(cAliasCT2)->CT2_FILIAL,2 )
	
 	dbSelectArea("cArqTmp")
	dbSetOrder(1)	
	RecLock("cArqTmp",.T.)
	
	Replace FILIAL		With (cAliasCT2)->CT2_FILIAL
	Replace DATAL		With (cAliasCT2)->CT2_DATA
	Replace TIPO		With cTipo
	Replace LOTE		With (cAliasCT2)->CT2_LOTE
	Replace SUBLOTE		With (cAliasCT2)->CT2_SBLOTE
	Replace DOC			With (cAliasCT2)->CT2_DOC
	Replace LINHA		With (cAliasCT2)->CT2_LINHA
	Replace CONTA		With  cConta
	Replace NOMFIL		With  _cNomFil
	Replace XPARTIDA	With  cContra
	Replace CCUSTO		With  cCusto
	Replace ITEM		With  cItem
	Replace CLVL		With  cCLVL
	Replace HISTORICO	With (cAliasCT2)->CT2_HIST
	Replace EMPORI		With (cAliasCT2)->CT2_EMPORI
	Replace FILORI		With (cAliasCT2)->CT2_FILORI
	Replace SEQHIST		With (cAliasCT2)->CT2_SEQHIST
	Replace SEQLAN		With (cAliasCT2)->CT2_SEQLAN
	Replace NOMOV		With .F.							// Conta com movimento
	Replace EMP			With aSelGp
	//Replace FORNE		With (cAliasCT2)->CT2_CODFOR
	Replace CODFOR		With _aForn[01]
	Replace FORNE		With _aForn[02]
	Replace	PEDIDO		With _aForn[03]   
	//Replace	IDVOO  	With _aForn[04]   
	Replace DESCRI		With (cAliasCT2)->DESCRI
	Replace DESCCC		With (cAliasCT2)->DESCCC
	
 	If cTipo == "1"
		Replace LANCDEB	With LANCDEB + (cAliasCT2)->CT2_VALOR
	EndIf	
	If cTipo == "2"
		Replace LANCCRD	With LANCCRD + (cAliasCT2)->CT2_VALOR
	EndIf	    
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf		
	
	If (LANCDEB + LANCCRD) = 0
		DbDelete()
	Endif
	MsUnlock()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBGETGP   ºAutor  ³Rafael Gama         º Data ³  05/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adm_Opcoes de pesquisa por filiais existente no cadastro deº±±
±±º          ³ empresa                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±³Retorno   ³ aSelFil(Contem todas as filiais da empresa selecionada)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³ SIGACTB, SIGAATF, SIGAFIN                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CBGETGP(lTodasFil,lSohFilEmp,cAlias,lSohFilUn,lHlp)                                  

	Local cEmpresa 	:= cEmpAnt
	Local cTitulo	:= ""
	Local MvPar		:= ""
	Local MvParDef	:= ""
	Local nI 		:= 0
	Local aArea 	:= GetArea() 					 // Salva Alias Anterior 
	Local nReg	    := 0
	Local nSit		:= 0
	Local aSit		:= {}
	Local aSit_Ant	:= {}
	Local aFil 		:= {}	
	Local nTamFil	:= 2
	Local lDefTop 	:= IIF( FindFunction("IfDefTopCTB"), IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
	Local nInc		:= 0    
	Local aSM0		:= AdmAbreSM0()
	Local aFilAtu	:= {}
	Local aFil_Ant
	Local lGestao	:= AdmGetGest()
	Local lFWCompany := FindFunction( "FWCompany" )
	Local cEmpFil 	:= " "
	Local cUnFil	:= " "
	Local nTamEmp	:= 0
	Local nTamUn	:= 0
	Local lOk		:= .T.
	
	Default lTodasFil 	:= .F.
	Default lSohFilEmp 	:= .F.	//Somente filiais da empresa corrente (Gestao Corporativa)
	Default lSohFilUn 	:= .F.	//Somente filiais da unidade de negocio corrente (Gestao Corporativa)
	Default lHlp		:= .T.
	Default cAlias		:= ""
	
	/*
	Defines do SM0
	SM0_GRPEMP  // Código do grupo de empresas
	SM0_CODFIL  // Código da filial contendo todos os níveis (Emp/UN/Fil)
	SM0_EMPRESA // Código da empresa
	SM0_UNIDNEG // Código da unidade de negócio
	SM0_FILIAL  // Código da filial
	SM0_NOME    // Nome da filial
	SM0_NOMRED  // Nome reduzido da filial
	SM0_SIZEFIL // Tamanho do campo filial
	SM0_LEIAUTE // Leiaute do grupo de empresas
	SM0_EMPOK   // Empresa autorizada
	SM0_GRPEMP  // Código do grupo de empresas 
	SM0_USEROK  // Usuário tem permissão para usar a empresa/filial
	SM0_RECNO   // Recno da filial no SIGAMAT
	SM0_LEIAEMP // Leiaute da empresa (EE)
	SM0_LEIAUN  // Leiaute da unidade de negócio (UU)
	SM0_LEIAFIL // Leiaute da filial (FFFF)
	SM0_STATUS  // Status da filial (0=Liberada para manutenção,1=Bloqueada para manutenção)
	SM0_NOMECOM // Nome Comercial
	SM0_CGC     // CGC
	SM0_DESCEMP // Descricao da Empresa
	SM0_DESCUN  // Descricao da Unidade
	SM0_DESCGRP // Descricao do Grupo
	*/
	
	If !IsBlind()
		PswOrder(1)
		If PswSeek( __cUserID, .T. )
	
			aSit		:= {}
			aFilNome	:= {}
			aFilAtu		:= FWArrFilAtu( cEmpresa, cFilAnt )

			If Len( aFilAtu ) > 0
				cTitulo := "Grupos de Empresas"
			EndIf
	
			// Adiciona as filiais que o usuario tem permissão
			For nInc := 1 To Len( aSM0 )
				If (((ValType(aSM0[nInc][SM0_EMPOK]) == "L" .And. aSM0[nInc][SM0_EMPOK]) .Or. ValType(aSM0[nInc][SM0_EMPOK]) <> "L") .And. aSM0[nInc][SM0_USEROK] )
						
					If Ascan(aSit, {|x| x[1] == aSM0[nInc][SM0_GRPEMP] }) == 0
						
						AAdd(aSit, {aSM0[nInc][SM0_GRPEMP],aSM0[nInc][SM0_DESCGRP]})
						MvParDef += aSM0[nInc][SM0_GRPEMP]
						nI++
					Endif
				Endif	
			Next
			If Len( aSit ) <= 0
				// Se não tem permissão ou ocorreu erro nos dados do usuario, pego a filial corrente.
				Aadd(aSit, aFilAtu[2]+" - "+aFilAtu[7] )
				MvParDef := aFilAtu[2]
				nI++
			EndIf
		EndIf
			
		aFil := {}
		If CbOpcoes(@MvPar,cTitulo,aSit,MvParDef,,,.F.,nTamFil,nI,.T.,,,,,,,,.T.)
			nSit := 1 
			For nReg := 1 To len(mvpar) Step nTamFil  // Acumula as filiais num vetor 
				If SubSTR(mvpar, nReg, nTamFil) <> Replicate("*",nTamFil)
			 		AADD(aFil, SubSTR(mvpar, nReg, nTamFil) ) 
				endif	
				nSit++
			next
			If Empty(aFil) .And. lHlp 
	 	  		Help(" ",1,"ADMFILIAL",,"Por favor selecionar pelo menos uma filial",1,0)		//
			EndIF
				
			If Len(aFil) == Len(aSit)
				lTodasFil := .T.	
			EndIf 
		Endif
	
	EndIf
	
	RestArea(aArea)  
	
Return(aFil)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AdmOpcoes ³ Autor ³ Totvs                 ³ Data ³03/10/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecao de Opcoes                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³<Vide Parametros Formais>								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³<Vide Parametros Formais>								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

Static Function CbOpcoes(	uVarRet,cTitulo,aOpcoes,cOpcoes,nLin1,nCol1,l1Elem,nTam,nElemRet,lMultSelect,lComboBox,cCampo,lNotOrdena,lNotPesq,lForceRetArr,cF3,lVisual,lColunada)
                    	
	Local aListBox			:= {}
	Local aSvKeys			:= GetKeys()
	Local aAdvSize			:= {}
	Local aInfoAdvSize		:= {}
	Local aObjCoords		:= {}
	Local aObjSize			:= {}
	Local aButtons			:= {}
	Local aX3Box			:= {}
	
	Local bSvF3				:= SetKey( VK_F3  , NIL )
	Local bSetF3			:= { || NIL }
	Local bSet15			:= { || NIL }
	Local bSet24			:= { || NIL }
	Local bSetF4			:= { || NIL }
	Local bSetF5			:= { || NIL }
	Local bSetF6			:= { || NIL }
	Local bCapTrc			:= { || NIL }
	Local bDlgInit			:= { || NIL }
	Local bOrdena			:= { || NIL }
	Local bPesquisa			:= { || NIL }
	
	Local cCodOpc			:= ""
	Local cDesOpc			:= ""
	Local cCodDes			:= ""
	Local cPict				:= "@E 999999"
	Local cVarQ				:= ""
	Local cReplicate		:= ""
	Local cTypeRet			:= ""
	
	Local lExistCod			:= .F.
	Local lSepInCod			:= .F.
	
	Local nOpcA				:= 0
	Local nFor				:= 0
	Local nAuxFor			:= 1
	Local nOpcoes			:= 0
	Local nListBox			:= 0
	Local nElemSel			:= 0
	Local nInitDesc			:= 1
	Local nTamPlus1			:= 0
	Local nSize				:= 0
	
	Local oSize
	Local a1stRow			:= {}
	Local a2ndRow			:= {}
	Local a3rdRow			:= {}
	
	Local oDlg	
	Local oListbox		:= NIL
	Local oElemSel      	:= NIL
	Local oElemRet		:= NIL
	Local oOpcoes			:= NIL
	Local oFontNum		:= NIL
	Local oFontTit		:= NIL
	Local oBtnMarcTod		:= NIL
	Local oBtnDesmTod		:= NIL
	Local oBtnInverte		:= NIL
	Local oGrpOpc			:= NIL
	Local oGrpRet			:= NIL
	Local oGrpSel			:= NIL
	
	Local uRet				:= NIL
	Local uRetF3			:= NIL  
	
	DEFAULT uVarRet			:= &( ReadVar() )
	DEFAULT cTitulo			:= OemToAnsi( "Escolha os Grupos" )	//
	DEFAULT aOpcoes			:= {}
	DEFAULT cOpcoes			:= ""
	DEFAULT l1Elem			:= .F.
	DEFAULT lMultSelect 	:= .T.
	DEFAULT lComboBox		:= .F.
	DEFAULT cCampo			:= ""
	DEFAULT lNotOrdena		:= .F.
	DEFAULT lNotPesq		:= .F.
	DEFAULT lForceRetArr	:= .F.
	DEFAULT lVisual			:= .F.
	DEFAULT lColunada		:= .F.
	
	Begin Sequence
	
		uRet				:= uVarRet
		cTypeVarRet			:= ValType( uVarRet )
		cTypeRet			:= IF( lForceRetArr , "A" , ValType( uRet ) )
		lMultSelect 		:= !( l1Elem )
		nSize				:= If(lColunada,20,0)	
			
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Coloca o Ponteiro do Cursor em Estado de Espera			   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		//CursorWait()
	
			IF !( lComboBox )
				DEFAULT nTam	:= 1
				nTamPlus1		:= ( nTam + 1 )
				IF ( ( nOpcoes := Len( aOpcoes ) ) > 0 )
					For nFor := 1 To nOpcoes
						If !lColunada
						    IF !Empty( cOpcoes )
							    cCodOpc		:= SubStr( cOpcoes , nAuxFor , nTam )
						    	lExistCod	:= .F.
						    	nInitDesc	:= 1
						    	IF !( " <-> "		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 5 ) ) .and. ;
						    	   !( " <=> "		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 5 ) ) .and. ;
			  	   			       !( " <-> "		== SubStr( aOpcoes[ nFor ] , nTam      , 5 ) ) .and. ;
						    	   !( " <=> "		== SubStr( aOpcoes[ nFor ] , nTam      , 5 ) ) 
						    		IF !( "<->"		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 3 ) ) .and. ;
						    		   !( "<=>"		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 3 ) ) .and. ;
						    		   !( " - "		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 3 ) ) .and. ;
						    		   !( " = "		== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 3 ) ) .and. ;
						    		   !( "<->"		== SubStr( aOpcoes[ nFor ] , nTam      , 3 ) ) .and. ;
						    		   !( "<=>"		== SubStr( aOpcoes[ nFor ] , nTam	   , 3 ) ) .and. ;
						    		   !( " - "		== SubStr( aOpcoes[ nFor ] , nTam	   , 3 ) ) .and. ;
						    		   !( " = "		== SubStr( aOpcoes[ nFor ] , nTam	   , 3 ) )
						    			IF !( "-"	== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 1 ) ) .and. ;
						    			   !( "="	== SubStr( aOpcoes[ nFor ] , nTamPlus1 , 1 ) ) .and. ;
						    			   !( "-"	== SubStr( aOpcoes[ nFor ] , nTam	   , 1 ) ) .and. ;
						    			   !( "="	== SubStr( aOpcoes[ nFor ] , nTam      , 1 ) )
						    				nInitDesc	:= 1
						    				lExistCod	:= .F.
						    			Else
					    					nInitDesc	:= nTamPlus1 /* 1 */
						    				lExistCod	:= .T.
						    			EndIF
						    		Else
						    			IF (;
						    					lSepInCod := (;
																( "<->" $ cCodOpc ) .or. ;
						    									( "<=>" $ cCodOpc ) .or. ;
						    									( " - " $ cCodOpc ) .or. ;
						    									( " = " $ cCodOpc )		 ;
						    							   	  );
											)			    							   	  		
						    				nInitDesc	:= nTamPlus1
						    			Else
						    				nInitDesc	:= ( nTamPlus1 + 2 ) /* 123 */
						    			EndIF	
						    			lExistCod	:= .T.
						    		EndIF	
						    	Else
					    			IF (;
					    					lSepInCod := (;
					    									( " <-> " $ cCodOpc ) .or. ;
					    									( " <=> " $ cCodOpc )	   ;
					    							   );
										)		    							   
					    				nInitDesc	:= nTamPlus1
					    			Else
						    			nInitDesc	:= ( nTamPlus1 + 4 ) /* 12345 */
						    		EndIF	
						    		lExistCod	:= .T.
						    	EndIF
							    cDesOpc		:= SubStr( aOpcoes[ nFor ] , nInitDesc )
							    cCodDes		:= IF( lExistCod , aOpcoes[ nFor ] , cCodOpc + " - " + cDesOpc )
							    aAdd( aListBox , { .F. , cCodDes , cCodOpc , cDesOpc } )
								nAuxFor := ( ( nFor * nTam ) + 1 )
							Else
								aAdd( aListBox , { .F. , aOpcoes[ nFor ] , aOpcoes[ nFor ] , aOpcoes[ nFor ] } )
							EndIF	
							IF (;
							   		( cTypeVarRet == "C" );
							   		.and.;
							   		( aListBox[ nFor , 03 ] $ uVarRet );
							   	)	
								aListBox[ nFor , 01 ] := .T.
							EndIF
		        		Else
						    aAdd( aListBox , { .F. , aOpcoes[ nFor,1 ] , aOpcoes[ nFor,2 ] } )
	
						Endif
	
					Next nFor
				Else
					MsgInfo( OemToAnsi( "Não existem dados para consulta" ) , IF( Empty( cTitulo ) , OemToAnsi( "Escolha Padrões" ) , cTitulo ) )
					Break
				EndIF	
			Else
				DEFAULT nTam	:= ( TamSx3( cCampo )[1] )
				aListBox := MontaCombo( cCampo , @cTitulo )
				IF ( ( nOpcoes := Len( aListBox ) ) > 0 )
					For nFor := 1 To nOpcoes
				    	IF (;
				    			( cTypeVarRet == "C" );
				    			.and.;
				    			( aListBox[ nFor , 03 ] $ uVarRet );
				    		)	
			    	    	aListBox[ nFor , 01 ] := .T.
			    		EndIF
					Next nFor
				Else
					MsgInfo( OemToAnsi( "Não existem dados para consulta" ) , IF( Empty( cTitulo ) , OemToAnsi( "" ) , cTitulo ) )
				EndIF
			EndIF
	
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Define o DEFAULT do Maximo de Elementos que Podem ser Retorna³
			³ dos														   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			DEFAULT nElemRet := ( Len( &( ReadVar() ) ) / nTam )
	
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Define os numeros de Elementos que serao Mostrados		   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			nOpcoes		:= Len( aListbox )
			nElemRet    := Min( nElemRet , nOpcoes )
			nElemRet	:= IF( !( lMultSelect ) , 01 , nElemRet )
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Verifica os Elementos ja Selecionados          			   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			aEval( aListBox , { |x| IF( x[1] , ++nElemSel , NIL ) } )
	    
			
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Define o Bloco para a CaPexTroca()						   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		bCapTrc := { |cTipo,lMultSelect| ;
											aListBox := CBexTroca(;
																	oListBox:nAt,;
																	@aListBox,;
																	l1Elem,;
																	nOpcoes,;
																	nElemRet,;
																	@nElemSel,;
																	lMultSelect,;
																	cTipo;
																),;
											oListBox:nColPos := 1,;
											oListBox:Refresh(),;
											oElemSel:Refresh();
					}
	
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Seta a consulta F3                						   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		IF !Empty( cCampo )
			IF !Empty( cF3 )
				bSetF3	:= { || AdmPesqF3( cF3 , cCampo , oListBox ) , SetKey( VK_F3 , bSetF3 ) }
			Else
				aX3Box	:= Sx3Box2Arr( cCampo )
			EndIF	
		EndIF	
	
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Disponibiliza Dialog para Selecao 						   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		DEFINE FONT oFontNum NAME "Arial" SIZE 000,-014 BOLD
		DEFINE FONT oFontTit NAME "Arial" SIZE 000,-011 BOLD
		
		DEFINE MSDIALOG oDlg FROM 000,000 TO 390,500 TITLE "Escolha os Grupos" OF oMainWnd PIXEL 
	
		//Faz o calculo automatico de dimensoes de objetos
		oSize := FwDefSize():New(.T.,,,oDlg)
		
		oSize:lLateral := .F.
		oSize:lProp	:= .T. // Proporcional
		
		oSize:AddObject( "1STROW" ,  100, 070, .T., .T. ) // Totalmente dimensionavel
		oSize:AddObject( "2NDROW" ,  100, 010, .T., .T. ) // Totalmente dimensionavel
		oSize:AddObject( "3RDROW" ,  100, 020, .T., .T. ) // Totalmente dimensionavel
			
		oSize:aMargins := { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
		
		oSize:Process() // Dispara os calculos		
		
		
		a1stRow :=	{oSize:GetDimension("1STROW","LININI"),;
					oSize:GetDimension("1STROW","COLINI"),;
					oSize:GetDimension("1STROW","XSIZE"),;
					oSize:GetDimension("1STROW","YSIZE")}
		
		a2ndRow :=	{oSize:GetDimension("2NDROW","LININI"),;
					oSize:GetDimension("2NDROW","COLINI"),;
					oSize:GetDimension("2NDROW","XSIZE"),;
					oSize:GetDimension("2NDROW","YSIZE")}
		
		a3rdRow :=	{oSize:GetDimension("3RDROW","LININI"),;
					oSize:GetDimension("3RDROW","COLINI"),;
					oSize:GetDimension("3RDROW","LINEND"),;
					oSize:GetDimension("3RDROW","COLEND")}
		
			
			If lColunada
				@ a1stRow[1],a1stRow[2]	LISTBOX oListBox VAR cVarQ FIELDS HEADER "" , "Grupo", "Descrição do Grupo"SIZE a1stRow[3],a1stRow[4] ON	DBLCLICK Eval( bCapTrc ) NOSCROLL OF oDlg PIXEL 
	        Else
				@ a1stRow[1],a1stRow[2]	LISTBOX oListBox VAR cVarQ FIELDS HEADER "" , OemToAnsi(cTitulo)  SIZE a1stRow[3],a1stRow[4] ON	DBLCLICK Eval( bCapTrc ) NOSCROLL OF oDlg PIXEL
			Endif
	
			oListBox:SetArray( aListBox )
			oListBox:bLine := { || LineLstBox( oListBox , .T. ) }
			oListBox:bWhen := { || !lVisual }
	
			IF ( lMultSelect ) .AND. !lVisual
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Define Bloco e o Botao para Marcar Todos    				   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				bSetF4		:= { || Eval( bCapTrc , "M" , lMultSelect ) , SetKey( VK_F4 , bSetF4 ) }
				@ a2ndRow[1] + 002 ,a2ndRow[2] + 000  BUTTON oBtnMarcTod	PROMPT OemToAnsi( "Marca Todos - <F4>" )		SIZE 75,13.50 OF oDlg	PIXEL ACTION Eval( bSetF4 ) //
		
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Define Bloco e o Botao para Desmarcar Todos    			   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				bSetF5		:= { || Eval( bCapTrc , "D" , lMultSelect ) , SetKey( VK_F5 , bSetF5 ) }
				@ a2ndRow[1] + 002,a2ndRow[2] + 080 BUTTON oBtnDesmTod	PROMPT OemToAnsi( "Desmarca Todos - <F5>" )		SIZE 75,13.50 OF oDlg	PIXEL ACTION Eval( bSetF5 ) //
		
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Define Bloco e o Botao para Inversao da Selecao			   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				bSetF6		:= { || Eval( bCapTrc , "I" , lMultSelect ) , SetKey( VK_F6 , bSetF6 ) }
				@ a2ndRow[1] + 002,a2ndRow[2] + 160 BUTTON oBtnInverte	PROMPT OemToAnsi( "Inverte Seleção - <F6>" ) 	SIZE 75,13.50 OF oDlg	PIXEL ACTION Eval( bSetF6 ) //
			EndIF
	
			If !lVisual
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Numero de Elementos para Selecao							   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				@ a3rdRow[1] + 000,a3rdRow[2] + 000 GROUP oGrpOpc TO a3rdRow[3]-5,074.50	OF oDlg LABEL OemtoAnsi("Nro. Elementos") PIXEL	//
				oGrpOpc:oFont := oFontTit
				@ a3rdRow[1] + 010,a3rdRow[2] + 010 SAY oOpcoes VAR Transform( nOpcoes	, cPict )	OF oDlg PIXEL	FONT oFontNum
			
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Maximo de Elementos que poderm Ser Selecionados			   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				@ a3rdRow[1] + 000,a3rdRow[2] + 080 GROUP oGrpRet TO a3rdRow[3]-5,152.50	OF oDlg LABEL OemtoAnsi("M x. Elem. p/ Seleção") PIXEL	//
				oGrpRet:oFont := oFontTit
				@ a3rdRow[1] + 010,a3rdRow[2] + 090 SAY oElemRet	VAR Transform( nElemRet	, cPict )	OF oDlg PIXEL	FONT oFontNum
			
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Numero de Elementos Selecionados                		   	   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				@ a3rdRow[1] + 000,a3rdRow[2] + 160 GROUP oGrpSel	TO a3rdRow[3]-5,230	OF oDlg LABEL OemtoAnsi("Elem. Selecionados") PIXEL	//
				oGrpSel:oFont := oFontTit
				@ a3rdRow[1] + 010,a3rdRow[2] + 170 SAY oElemSel	VAR Transform( nElemSel	, cPict )	OF oDlg PIXEL	FONT oFontNum
			EndIf
	
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Define Bloco para a Tecla <CTRL-O>              		   	   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		  	bSet15 := { || nOpcA := 1 , GetKeys() , SetKey( VK_F3 , NIL ) , oDlg:End() }
		
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Define Bloco para a Tecla <CTRL-X>              		   	   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			bSet24 := { || nOpcA := 0 , GetKeys() , SetKey( VK_F3 , NIL ) , oDlg:End() }
		
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Define Bloco para o Init do Dialog              		   	   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			bDlgInit := { || EnchoiceBar( oDlg , bSet15 , bSet24 , NIL , aButtons ),NIL,NIL,NIL}
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval( bDlgInit )
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Retorna as Opcoes Selecionadas                  		   	   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		IF ( nOpcA == 1 )
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Coloca o Ponteiro do Cursor em Estado de Espera			   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			//CursorWait()
		    IF ( cTypeRet == "C" )
			    uRet		:= ""
				cReplicate	:= Replicate( "*" , nTam )
			    nListBox := Len( aListBox )
			    For nFor := 1 To nListBox
					IF ( aListBox[ nFor , 01 ] )
						uRet += aListBox[ nFor , IIf(lColunada, 02, 03) ]
			    	ElseIF ( lMultSelect )
			    		uRet += cReplicate
			    	EndIF
			    Next nFor
			ElseIF ( cTypeRet == "A" )
			    uRet	 	:= {}
			    nListBox	:= 0
			    While ( ( nFor := aScan( aListBox , { |x| x[1] } , ++nListBox ) ) > 0 )
			    	nListBox := nFor
					aAdd( uRet , aListBox[ nFor , 03 ] )
			    End While
			EndIF
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Restaura o Ponteiro do Cursor                  			   ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			//CursorArrow()
		EndIF
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega Variavel com retorno por Referencia     		   	   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		uVarRet := uRet
	
	End Sequence
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Restaura o Estado das Teclas de Atalho          		   	   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	RestKeys( aSvKeys , .T. )
	SetKey( VK_F3 , bSvF3 )
	
Return( ( nOpca == 1 ) )


/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³CaPexTroca	    ³Autor³Marinaldo de Jesus ³ Data ³11/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Efetua a Troca da Selecao no ListBox da AdmOpcoes()   		³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³AdmOpcoes()                                                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³Array (Listbox) Com a(s) opcao(oes) Selecionadas			³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais 									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Static Function CBexTroca(nAt,aArray,l1Elem,nOpcoes,nElemRet,nElemSel,lMultSelect,cTipo)

Local nOpcao		:= 0

DEFAULT nAt			:= 1
DEFAULT aArray		:= {}
DEFAULT l1Elem		:= .F.
DEFAULT nOpcoes		:= 0
DEFAULT nElemRet	:= 0
DEFAULT nElemSel	:= 0
DEFAULT lMultSelect := .F.
DEFAULT cTipo		:= "I"

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Coloca o Ponteiro do Cursor em Estado de Espera			   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
CursorWait()
	IF !Empty( aArray )
		IF !( l1Elem )
			IF !( lMultSelect )
				aArray[nAt,1] := !aArray[nAt,1]
				IF !( aArray[nAt,1] )
					--nElemSel
				Else
					++nElemSel
				EndIF	
			ElseIF ( lMultSelect )
				IF ( cTipo == "M" )
					nElemSel := 0
					aEval( aArray , { |x,y| aArray[y,1] := IF( ( y <= nElemRet ) , ( ++nElemSel , .T. ) , .F. ) } )
				ElseIF ( cTipo == "D" )
					aEval( aArray , { |x,y| aArray[y,1] := .F. , --nElemSel } )
				ElseIF ( cTipo == "I" )
					nElemSel := 0
					aEval( aArray , { |x,y| IF( aArray[y,1] , aArray[y,1] := .F. , IF( ( ( ++nElemSel ) <= nElemRet ) , aArray[y,1] := .T. , NIL ) ) } )
					nElemSel := Min( nElemSel , nElemRet )
				EndIF
			EndIF
		Else
			For nOpcao := 1 To nOpcoes
				IF ( nOpcao == nAt )
					aArray[ nOpcao , 1 ]	:= .T.
				Else
					aArray[ nOpcao , 1 ]	:= .F.
				EndIF
			Next nOpcao
			nElemSel := 01
		EndIF
	EndIF
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Restaura o Ponteiro do Cursor                  			   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
CursorArrow()
	
IF ( nElemSel > nElemRet )
	aArray[nAt,1] := .F.
	nElemSel := nElemRet
	MsgInfo(;
				OemToAnsi( "Excedeu o número de elementos permitidos para seleção" ) ,;
				OemToAnsi( "Atenção" )  ;
		    )
ElseIF ( nElemSel < 0 )
	nElemSel := 0
EndIF

Return( aArray )

/*/{Protheus.doc} _BuscaForn
//			Função que Retorna dados de fornecedor
@author 	iVan de Oliveira  
@since 		03/12/2018
@version 	1.0

@type 		Static function                                 
/*/
Static Function _BuscaForn( _cFilTab, _nRegistro, _cArqEmp ) 

Local _aAreas := {SF1->(GetArea()), SD1->(GetArea()), ("cArqTmp")->(GetArea()) }   
Local _cEmp := Right(_cArqEmp,3)   
Local _aRet := { ' - ', ' - ', 'Não existe PEDIDO para este documento', '' } 

// Se idenficado a empresa que esta sendo gerado.
if !empty(_cArqEmp) .and. len(_cEmp) == 3    

	_cAlias := GetNextAlias()

	cQuery	:= " SELECT "
	cQuery	+= 			" CV3_TABORI, CV3_RECORI, CV3_TABORI "
	cQuery	+= " FROM   CV3" + _cEmp + " A "  
	cQuery	+= " WHERE "
	cQuery	+= " 		A.D_E_L_E_T_   = ' '"
	cQuery	+= " 		AND CV3_FILIAL =   '" + _cFilTab   			   + "'"   
	cQuery	+= "   		AND CV3_RECDES =   '" + cValToChar(_nRegistro) + "'" 
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.F.)  
	
	(_cAlias)->( DbGoTop() )	 
	if !(_cAlias)->( Eof() )  
	 
		_cRegOrig := Alltrim((_cAlias)->CV3_RECORI)
	 	_cAliasTmp:= GetNextAlias() 
	 	cQuery    := ''
	
		if Alltrim((_cAlias)->CV3_TABORI) $ '|SF1|SD1|'
		
	 		cQuery	:= " SELECT "
			cQuery	+= 			" TOP 1 F1_DOC AS DOC, F1_SERIE AS SERIE, F1_FORNECE AS CLIFOR, F1_LOJA AS LJCF, A2_NOME AS RAZAO, D1_PEDIDO AS PEDIDO, 
			cQuery	+= 	   		" C7_XIDMOV AS IDVOO "   
		 
			cQuery	+= " FROM   SF1" + _cEmp + " A "  
			
			cQuery	+= " INNER JOIN SD1" + _cEmp   + " B ON D1_FILIAL = F1_FILIAL AND D1_DOC    = F1_DOC "
			cQuery	+= 								 " AND D1_SERIE   = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND B.D_E_L_E_T_ = ' ' "
			
			cQuery	+= " LEFT JOIN SC7"  + _cEmp   + " C ON C7_FILIAL = D1_FILIAL AND C7_NUM    = D1_PEDIDO  AND C.D_E_L_E_T_ = ' ' "
		 
			cQuery	+= " INNER JOIN    " +_cTabFor + " D ON A2_FILIAL = '" + FwXFilial("SA2") + "' AND A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA AND D.D_E_L_E_T_ = ' '
			
			cQuery	+= " WHERE "
			cQuery	+= " 		A.D_E_L_E_T_   = ' '"
			cQuery	+= " 		AND F1_FILIAL <> '**'
			
			if Alltrim((_cAlias)->CV3_TABORI) == 'SF1'
			
				cQuery	+= " 	AND ( A.R_E_C_N_O_ = '"  + _cRegOrig + "' )"
			
			Else
			
				cQuery	+= " 	AND ( B.R_E_C_N_O_ = '"  + _cRegOrig + "' )"
			
			Endif   
			
		ElseIf Alltrim((_cAlias)->CV3_TABORI) $ '|SF2|SD2|'
		
			cQuery	:= " SELECT "
			cQuery	+= 			" TOP 1 F2_DOC AS DOC, F2_SERIE AS SERIE, F2_CLIENTE AS CLIFOR, F2_LOJA AS LJCF, A1_NOME AS RAZAO, D2_PEDIDO AS PEDIDO, 
			cQuery	+= 			"	    C6_XIDMOV AS IDVOO "
			cQuery	+= " FROM   SF2" + _cEmp + " A "  
			
			cQuery	+= " INNER JOIN SD2" + _cEmp   + " B ON D2_FILIAL  = F2_FILIAL AND D2_DOC    = F2_DOC "
			cQuery	+= 								 " AND D2_SERIE    = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA AND B.D_E_L_E_T_ = ' ' "
			
			cQuery	+= " LEFT JOIN  SC6" + _cEmp   + " C ON C6_FILIAL  = D2_FILIAL AND C6_NUM    = D2_PEDIDO  AND C.D_E_L_E_T_ = ' ' "
			
			cQuery	+= " INNER JOIN    " +_cTabCli + " D ON A1_FILIAL  = '" + FwXFilial("SA1") + "' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D.D_E_L_E_T_ = ' '
			
			cQuery	+= " WHERE "
			cQuery	+= " 		A.D_E_L_E_T_   = ' '"
			cQuery	+= " 		AND F2_FILIAL <> '**'
			
			if Alltrim((_cAlias)->CV3_TABORI) == 'SF2'
			
				cQuery	+= " 	AND ( A.R_E_C_N_O_ = '"  + _cRegOrig + "' )"
			
			Else
			
				cQuery	+= " 	AND ( B.R_E_C_N_O_ = '"  + _cRegOrig + "' )"
			
			Endif
			
		Endif 
		  
		// Se retornou Querie.
		if !empty(cQuery)
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAliasTmp,.T.,.F.)  
			
			(_cAliasTmp)->( DbGoTop() )	   
			if !(_cAliasTmp)->( Eof() ) 
				
				_aRet[01] := Alltrim((_cAliasTmp)->CLIFOR)  + '-' + Alltrim((_cAliasTmp)->LJCF)
				_aRet[02] := Alltrim((_cAliasTmp)->RAZAO)
				_aRet[03] := Alltrim((_cAliasTmp)->PEDIDO) 
				_aRet[04] := Alltrim((_cAliasTmp)->IDVOO)   
		   	   		
		  	Endif 
				
			// Fecha arquivo temporário.
			(_cAliasTmp)->(DbClosearea()) 
			
		Endif
			
 	Endif 
	 
	// Fecha arquivo temporário.
	(_cAlias)->(DbClosearea())
 
Endif   
    
// Retorna posicionamento das areas.
aEval(_aAreas, {|x| RestArea(x) })

Return _aRet

User Function xValUser(aSelGp)

Local lRet       := .F.
Local aUsuarios  := AllUsers()
Local aUsrAux    := {}
Local nLinEnc    := 0
Local nPosFil    := 0
Local cCodUsr    := RetCodUsr()
Local cCodEmp    := cEmpAnt
Local cCodFil    := cFilAnt
Local cRetornoIn := ""
Local nFor       := 0
Local nCont      := 0
Local cFilIn     := ""
Local aGrupos    := UsrRetGrp(cCodUsr)
Local aInfGrp    := {}//FWGrpAcess()
Local nX         := 0
Local nY         := 0
Local lCont      := .T.

//Encontra o usuário
nLinEnc:= aScan(aUsuarios, {|x| x[1][1] == cCodUsr })
 
//Caso encontre o usuário
If nLinEnc > 0
    aUsrAux := aClone(aUsuarios[nLinEnc][2][6])
     
    //Agora procura pela empresa + filial nos acessos 
    nPosFil := aScan(aUsrAux, {|x| x == cCodEmp + cCodFil })
EndIf

For nX := 1 To Len(aGrupos)
	
	If lCont 
		aInfGrp := FwGrpEmp(aGrupos[nX])
		
		If "@" $ aInfGrp[1]
			lCont := .F.
		EndIf
		If lCont
			For nY := 1 To Len(aInfGrp)
				aADD(aUsrAux,aInfGrp[nY])
			Next
		EndIf
	Else
		Exit
	EndIf
Next

For nCont := 1 To Len(aUsrAux)
	cFilIn := SubStr( aUsrAux[nCont], 3 )
	If SubStr( aUsrAux[nCont], 1, 2 ) == aSelGp
		cRetornoIn += cFilIn + '|' 
	EndIf
Next nCont

If "@" $ cFilIn //Se o usuário tiver acesso Full não será necessário filtrar por filial
	Return cFilIn
EndIf

Return " IN " + FormatIn( SubStr( cRetornoIn , 1 , Len( cRetornoIn ) -1 ) , '|' )
