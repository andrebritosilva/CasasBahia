#Include "PROTHEUS.Ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} XGERREC

Geração de títulos a receber

@since 14/10/2019
@version P12
/*/
//-------------------------------------------------------------------

User Function XGERREC()

Local aSaveArea	  := GetArea()
Local cPrefixo    := SE2->E2_PREFIXO
Local cNumero     := SE2->E2_NUM
Local cParcela    := SE2->E2_PARCELA
Local cTipo       := SE2->E2_TIPO
Local cLoja       := SE2->E2_LOJA
Local dVencimento := SE2->E2_VENCTO
Local dVencReal   := SE2->E2_VENCREA
Local dEmissao    := SE2->E2_EMISSAO
Local nValor      := SE2->E2_VALOR
Local nVlrCruz    := SE2->E2_VLCRUZ
Local cHist       := Alltrim(SE2->E2_HIST)
Local aArray      := {}
Local _aAreaSM0   := SM0->(GetArea())
Local aEmps       := {}
Local aEmps2      := {}
Local aEmps3      := {}
Local cEmpNew     := ""
Local cNewEmp     := ""
Local oDlg        := Nil
Local cTitul      := "Selecione a empresa desejada"
Local oOk         := LoadBitmap( GetResources(), "LBOK" )
Local oNo         := LoadBitmap( GetResources(), "LBNO" )
Local oChk        := Nil
Local lChk        := .F.
Local oLbx        := Nil
Local j           := 0
Local cEmps       := ""
Local cSM0        := ""
Local cNatureza   := ""
Local aSelGp      := {}
Local aSelFil     := {}
Local aPWiz       := {}
Local aRetWiz     := {}
Local cCliente    := ""
Local cNatureza   := "" 
Local lContinua   := .T.
Local nContEmp    := 0
Local cHistorico  := "ND " + Alltrim (SE2->E2_NOMFOR) + " " + Alltrim (SE2->E2_NUM)   
Local nOpc	      := 0

Private cEmpbkp     := ""
Private cFilbkp     := ""
Private _cEmpAtu    := SM0->M0_CODIGO //Guardo a empresa atual
Private _cFilAtu    := SM0->M0_CODFIL //Guardo a filial atual
Private _oAppBk     := oApp //Guardo a variavel resposavel por componentes visuais
Private nRegSA1     := SE2->( RECNO() )
Private nOrdSA1     := SE2->( INDEXORD() )

Private lMsErroAuto := .F.

//aSelGp := F050GETGP()

If Alltrim(cTipo) != "NF"
	MsgInfo("Função disponibilizada apenas para títulos do tipo NF!","Tipo Inválido")
	Return
EndIf

If SE2->E2_SALDO <= 0
	MsgInfo("Título já baixado, realize a operação em um título em aberto","Tit. Baixado")
	Return
EndIf

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
(Iif(AScan( aEmps, {|x| x[1]==.T.}) == 0 , MsgAlert("Precisa marcar no mínimo uma empresa.",cTitul),(nOpc:=1,oDlg:End()))) ENABLE OF oDlg

DEFINE SBUTTON FROM 174,286 TYPE 2 ACTION (nOpc:=0,oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER 

If nOpc == 1
	For j:=1 to len(aEmps)
		if aEmps[j,1]==.T.
			nContEmp ++
			AADD(aEmps2,{aEmps[j,2], aEmps[j,3]})
		ENDIF 
	Next
EndIF


If nContEmp > 1
	MsgAlert("Por favor selecione apenas uma empresa.")
	Return
EndIf

If nOpc == 0
	MsgAlert("Inclusão cancelada pois nenhuma empresa foi escolhida.")
	Return
EndIf

aEmps3:={}
For j:=1 to len(aEmps2)
	cEmps += aEmps2[j,1]+"/"
Next
cEmps := Substr(cEmps,1,len(cEmps)-1)

Do While !SM0->(Eof())	
	If !SM0->M0_CODIGO $ cEmps
		SM0->(dbSkip())
  		Loop
	EndIf
	AADD(aEmps3,{SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOMECOM, SM0->M0_NOME, SM0->M0_Filial})         
	SM0->(dbSkip())
EndDo
cEmpbkp := cEmpAnt
cFilbkp := cFilAnt

For j=1 to Len(aEmps3)  
	If aEmps3[j] [1]<>cSM0
		cSM0      := aEmps3[j] [1]
		cEmpAnt   := aEmps3[j] [1]
		cFilAnt   := aEmps3[j] [2]
		cNomeEmp  := aEmps3[j] [3]
		cUnid     := aEmps3[j] [4]
		
		If Empty(aSelFil)
			aSelFil := AdmGetFil(.F.,.F.,"SE5")
			If Empty(aSelFil)
			   Aadd(aSelFil,cFilAnt)
			Endif
		Endif

		If Len(aSelFil) >1 
			MsgAlert("Por favor selecione apenas uma filial.")
			Return
		EndIf
		
		dbCloseAll() //Fecho todos os arquivos abertos
		OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro a SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(aEmps3[j][1] + aSelFil[1],.T.)) //Posiciona Empresa
		cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
		cFilAnt := SM0->M0_CODFIL
		OpenFile(cEmpAnt + cFilAnt) //Abro a empresa que eu desejo trabalhar
		U_F750BROW()
	EndIf
Next

//Verificar com Henrique as informações a serem passadas

aAdd(aPWiz,{ 1,"Cliente: "             ,Space(TamSX3("A1_COD")[1])    ,"","","SA1AZ0","", ,.T.})
aAdd(aPWiz,{ 1,"Natureza: "            ,Space(TamSX3("ED_CODIGO")[1]) ,"","","SED","", ,.T.})
aAdd(aPWiz,{ 1,"Data Vencimento: "     ,Ctod("") ,"","",""   ,  ,60 ,.T.})

aAdd(aRetWiz,Space(TamSX3("A1_COD")[1]))
aAdd(aRetWiz,Space(TamSX3("ED_CODIGO")[1]))
aAdd(aRetWiz,Ctod(""))

lContinua := ParamBox(aPWiz,"Geração de título - GrupoCB",aRetWiz,,,,,,,,.T.,.T.)    

If lContinua
	cCliente    := Alltrim(aRetWiz[1])
	cNatureza   := Alltrim(aRetWiz[2])
	dVencimento := aRetWiz[3]
	dVencReal   := aRetWiz[3]
	 
	MsgRun("Gerando títulos a receber...",,{|| xCreaRec(cPrefixo,cNumero,cParcela,cTipo,cNatureza,cCliente,cLoja,dVencimento,dVencReal,nValor,_aAreaSM0,cFilAnt,cEmpAnt,oApp,_oAppBk,cHistorico, aSelFil[1])}) 
Else
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
	RestArea(aSaveArea)
	U_F750BROW()
EndIf

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

SE2->( DBSETORDER(1) )
SE2->( DBGOTO(1) )

RestArea(aSaveArea)

U_F750BROW()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} xCreaRec

Executa a chamada automática de inclusão de títulos a receber

@since 14/10/2019
@version P12
/*/
//-------------------------------------------------------------------

Static Function xCreaRec(cPrefixo,cNumero,cParcela,cTipo,cNatureza,cCliente,cLoja,dVencimento,dVencReal,nValor,_aAreaSM0,cFilAnt,cEmpAnt,oApp,_oAppBk,cHistorico, cFilDest)

Local aArea	  := GetArea()
Local lRet        := .T.

DbSelectArea("SE1")
DbSetOrder(1)

If(DbSeek(xFilial("SE1") + cPrefixo + cNumero + cParcela + cTipo))
	MsgInfo("Título já existente na base de dados","Tit. Existente")
	lRet := .F.
EndIf

If lRet
	aArray := { { "E1_FILIAL"    , cFilDest            , NIL },;
		        { "E1_PREFIXO"   , "ND"                , NIL },;//Sempre ND
	            { "E1_NUM"       , cNumero             , NIL },;
	            { "E1_PARCELA"   , cParcela            , NIL },;
	            { "E1_TIPO"      , cTipo               , NIL },;
	            { "E1_NATUREZ"   , cNatureza           , NIL },; //Criar tela para seleção de natureza
	            { "E1_CLIENTE"   , cCliente            , NIL },;
	            { "E1_LOJA"      , cLoja               , NIL },;
	            { "E1_EMISSAO"   , dDatabase           , NIL },;
	            { "E1_VENCTO"    , dVencimento         , NIL },;
	            { "E1_VENCREA"   , dVencReal           , NIL },;
	            { "E1_HIST"      , cHistorico          , NIL },;
	            { "E1_VALOR"     , nValor              , NIL }}
	
	MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
	If lMsErroAuto
	    MostraErro()
	    lRet := .F.
	Else
	    MsgInfo("Título incluído com sucesso!", "Inclusão Tit. Rec.")
	EndIf
EndIf

RestArea(aArea)  

Return 

//-------------------------------------------------------------------
/*/{Protheus.doc} F050GETGP

Montagem da tale de seleção de empresas e filiais

@since 14/10/2019
@version P12
/*/
//-------------------------------------------------------------------

Static Function F050GETGP(lTodasFil,lSohFilEmp,cAlias,lSohFilUn,lHlp)                                  

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
Local lGestao	 := AdmGetGest()
Local lFWCompany := FindFunction( "FWCompany" )
Local cEmpFil 	 := " "
Local cUnFil	 := " "
Local nTamEmp	 := 0
Local nTamUn	 := 0
Local lOk		 := .T.

Default lTodasFil 	:= .F.
Default lSohFilEmp 	:= .F.	//Somente filiais da empresa corrente (Gestao Corporativa)
Default lSohFilUn 	:= .F.	//Somente filiais da unidade de negocio corrente (Gestao Corporativa)
Default lHlp		:= .T.
Default cAlias		:= ""


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
	If F050CbOpcoes(@MvPar,cTitulo,aSit,MvParDef,,,.F.,nTamFil,nI,.T.,,,,,,,,.T.)
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

//-------------------------------------------------------------------
/*/{Protheus.doc} F050CbOpcoes

Complemento da montagem de tela referente a seleção de empresas e filiais

@since 14/10/2019
@version P12
/*/
//-------------------------------------------------------------------
	
Static Function F050CbOpcoes(	uVarRet,cTitulo,aOpcoes,cOpcoes,nLin1,nCol1,l1Elem,nTam,nElemRet,lMultSelect,lComboBox,cCampo,lNotOrdena,lNotPesq,lForceRetArr,cF3,lVisual,lColunada)
                    	
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
Local oListbox		    := NIL
Local oElemSel      	:= NIL
Local oElemRet		    := NIL
Local oOpcoes			:= NIL
Local oFontNum		    := NIL
Local oFontTit		    := NIL
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

		DEFAULT nElemRet := ( Len( &( ReadVar() ) ) / nTam )

		nOpcoes		:= Len( aListbox )
		nElemRet    := Min( nElemRet , nOpcoes )
		nElemRet	:= IF( !( lMultSelect ) , 01 , nElemRet )

		aEval( aListBox , { |x| IF( x[1] , ++nElemSel , NIL ) } )
    
	bCapTrc := { |cTipo,lMultSelect| ;
										aListBox := F050CBexTroca(;
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

	IF !Empty( cCampo )
		IF !Empty( cF3 )
			bSetF3	:= { || AdmPesqF3( cF3 , cCampo , oListBox ) , SetKey( VK_F3 , bSetF3 ) }
		Else
			aX3Box	:= Sx3Box2Arr( cCampo )
		EndIF	
	EndIF	

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

//-------------------------------------------------------------------
/*/{Protheus.doc} F050CBexTroca

Troca seleção

@since 14/10/2019
@version P12
/*/
//-------------------------------------------------------------------

Static Function F050CBexTroca(nAt,aArray,l1Elem,nOpcoes,nElemRet,nElemSel,lMultSelect,cTipo)

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