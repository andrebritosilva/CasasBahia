#Include "Rwmake.Ch"
#Include "Protheus.Ch"
#Include "TopConn.Ch"

#Define CRLF 		CHR(13)+CHR(10)
#Define STR_PULA    Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CBFIN01A บAutor  ณ Rodrigo Tomaz      บ Data ณ  01/07/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Workflow Financeiro - Transferencia Bancaria Emp/Fil       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo CB                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBFIN01A()

	Local aCores 		:= U_CBFINLG()
	Local cFiltro       := ""
	Local cUser1        := ""
	
	Private cLogin		:= alltrim(substr(cUsuario,7,15))
	Private cCadastro	:= "Transferencia bancแria Emp/Fil - Grupo CB"
	Private aRotina		:= {}
	Private	cString		:= "ZZ1"
	Private aIndZZ1		:= {}
	Private lTipo		:= Space(20)
	Private cUserAtu    := __CUSERID
	Private cGruApro	:= SuperGetmv("FS_APRTRAN",,"000030")
	Private cAprovad	:= ""
	
	lTipo += "123"
	
	U_fStatCh()
	
	AAdd( aRotina, { "Pesquisar"        , "AxPesqui"	 	, 0, 1})
	AAdd( aRotina, { "Visualizar"       , "U_CBFIN01I('V')" , 0, 2})
	AAdd( aRotina, { "Incluir"    		, "U_CBFIN01I('I')" , 0, 3})
	AAdd( aRotina, { "Legenda"          , "U_CBFIN01G"   	, 0, 3})

//	Dbselectarea("SAL")
//	Dbsetorder(4)
//	Dbgotop()
//	If Dbseek(xFilial("SAL")+cGruApro+cUserAtu)
		
		AAdd( aRotina, { "Aprovar"    		, "U_CBFIN01I('A')" , 0, 4})
		
//		cFiltro 	:= "Alltrim(ZZ1_STATUS) $ '"+Alltrim(lTipo)+"' .And. Alltrim(ZZ1_APROV) == '"+cUserAtu+"' "
//		cAprovad    := cUserAtu
//	Else
//		Dbselectarea("SAL")
//		Dbsetorder(1)
//		Dbgotop()
//		Dbseek(xFilial("SAL")+cGruApro)
//		Do While !Eof() .and. cGruApro == SAL->AL_COD
//			cAprovad    := SAL->AL_USER 
//			Dbselectarea("SAL")
//			Dbskip()
//		EndDo

//		cFiltro 	:= "Alltrim(ZZ1_STATUS) $ '"+Alltrim(lTipo)+"' .And. Alltrim(ZZ1_USER) == '"+cUserAtu+"' "
//	EndIf	
	                                                                                                          
	cFiltro 	:= "Alltrim(ZZ1_STATUS) $ '"+Alltrim(lTipo)+"' "	
	
	DbSelectArea(cString)
	DbSetOrder(1)
	Dbgotop()
	
	bFilBrw := {|| FilBrowse(cString, @aIndZZ1, @cFiltro) }
	
	LjMsgRun("Aguarde, Filtrando Dados...",,{|| Eval(bFilBrw)})
	
	mBrowse( 6,1,22,75,cString,,,,,,aCores)
	
	aEval( aIndZZ1,{|x| Ferase(x[1]+OrdBagExt())})
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CBFINLG  บAutor  ณ Rodrigo Tomaz      บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Controla as Legendas da Tela                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBFINLG()

	Local aCores 	:= {}
	Local aArea		:= GetArea()
	
	Aadd( aCores, { "ZZ1->ZZ1_STATUS == '1'", "BR_AMARELO"  })
	Aadd( aCores, { "ZZ1->ZZ1_STATUS == '2'", "BR_VERDE"  	})
	Aadd( aCores, { "ZZ1->ZZ1_STATUS == '3'", "BR_VERMELHO" })
	
	RestArea(aArea)
	
Return(aCores)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CBFIN01G บAutor  ณ Rodrigo Tomaz      บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem tela de Legenda                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBFIN01G()

	Local aLegenda	:= U_RetLeg()
	
	BrwLegenda( OemToAnsi("Transf. Bancaria - Grupo CB"), OemToAnsi("Legenda"), aLegenda )
	
Return( .T. )   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfStatCh  บAutor   ณRodrigo T. Silva    บ Data ณ  07/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Tela de Filtro                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fStatCh(l1Elem,lTipoRet)

	Local cTitulo	:= "Status"
	Local Mvpar
	Local MvParDef  := ""
	
	Private aSit	:= {}
	Private nLot    := 0
	
	l1Elem	:= If(l1Elem = Nil, .F.,.T.)
	
	DEFAULT lTipoRet := .T.
	
	cAlias	:= Alias()
	
	If lTipoRet
		MvPar	:= lTipo
		MvRet	:= "lTipo"
	EndIf
	
	CursorWait()
	
	// Solicitado
	Aadd( aSit, "1 - Transfer๊cia Enviada para aprova็ใo" )
	mvpardef += "1"
	nLot     += 1
    // Aprovado
	Aadd( aSit, "2 - Transfer๊ncia Aprovada" )
	mvpardef += "2"
	nLot     += 1
    //Recusado
	Aadd( aSit, "3 - Transfer๊ncia Reprovada" )
	mvpardef += "3"
	nLot     += 1

	CursorArrow()
	
	If lTipoRet
		If f_Opcoes(@MvPar, cTitulo, aSit, mvParDef, 12, 49, l1Elem,,nLot)
			&MvRet	:= mvpar
		EndIf
	EndIf
	
	Dbselectarea(cAlias)
	
Return( If(	lTipoRet, .T., MvParDef) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RetLeg   บAutor  ณ Rodrigo T. Silva   บ Data ณ  03/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna Legenda                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetLeg()

	Local aRet :=	{}
	Local aArea		:= GetArea()
	Local nXa		:= 0
	
	Aadd( aRet, { "BR_AMARELO"	, OemToansi("Transf. Enviada para aprova็ใo")  })
	Aadd( aRet, { "BR_VERDE"	, OemToansi("Transfer๊ncia Aprovado") })
	Aadd( aRet, { "BR_VERMELHO"	, OemToansi("Transfer๊ncia Reprovada") })
	
	RestArea(aArea)
	
Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBFIN01I  บAutor  ณRodrigo T. Silva    บ Data ณ  07/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusใo/Visualiza็ใo/Aprova็ใo manual da Transfer๊ncia    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBFIN01I(cProc)

	Local oPanel1
	Local oPanel2
	Local oButton1
	Local oButton2
	Local N1 := 600
	Local cAliasNF		:= GetNextAlias()
	Local lWhen			:= If(cProc == "I",.T.,.F.)
	Local cTitulo		:= "Transfer๊ncia Bancแria entre Empresa/Filial - "+If(cProc == "I","Inclusใo","Visualiza็ใo")

	Private cVar	   := Nil
	Private _oDlg      := Nil
	Private oOk        := LoadBitmap( GetResources(), "LBOK" )
	Private oNo        := LoadBitmap( GetResources(), "LBNO" )
	Private lMark      := .F.
	Private oLbx       := Nil
	Private aVetor     := {}
	Private lCheckBox  := .F.
	Private oCheckBox  := Nil

	Private _cEmpori	:= SM0->M0_CODIGO
	Private _cFilori	:= SM0->M0_CODFIL
	Private _cBanori	:= Space(TamSX3("ZZ1_BANORI")[1])
	Private _cAgeori	:= Space(TamSX3("ZZ1_AGEORI")[1])
	Private _cConOri	:= Space(TamSX3("ZZ1_CONORI")[1])
	Private _cNatOri	:= Space(TamSX3("ZZ1_NATORI")[1])
	Private _cBNomOr	:= Space(TamSX3("ZZ1_BNOMOR")[1])
	
	Private _cEmpDes	:= Space(TamSX3("ZZ1_EMPDES")[1])
	Private _cFilDes	:= Space(TamSX3("ZZ1_FILDES")[1])
	Private _cBanDes	:= Space(TamSX3("ZZ1_BANDES")[1])
	Private _cAgeDes	:= Space(TamSX3("ZZ1_AGEDES")[1])
	Private _cConDes	:= Space(TamSX3("ZZ1_CONDES")[1])
	Private _cNatDes	:= Space(TamSX3("ZZ1_NATDES")[1])
	Private _cBNomDe	:= Space(TamSX3("ZZ1_BNOMDE")[1])


	Private _nValor		:= 0
	Private _cTipo		:= Space(TamSX3("ZZ1_TIPO")[1])
	Private _cDoc		:= Space(TamSX3("ZZ1_DOCUM")[1])
	
	Private _cHist		:= Space(10)
	Private _cMotv		:= Space(10)

	Private cAliasDes	:= GetNextAlias()
	Private cIndA 		:= CriaTrab(NIL,.F.)

	Public _cCbarqSa6	:= ""
	Public _cCbarqSeD	:= ""

    DEFINE FONT oBold    NAME "Arial" SIZE 0, -12 BOLD	

	STATIC oDlg

	If cProc == "A" .and. ZZ1->ZZ1_STATUS != "1"
		MsgAlert("<b>Transfer๊ncia jแ passou pelo processo de Aprova็ใo/Reprova็ใo</b>.", "Aten็ใo")
		Return()
	EndIf
	
	If cProc == "A"
		cTitulo		:= "Aprova็ใo Manual de Transfer๊ncia, Usuแrio : "+cUserAtu
	EndIf

	If cProc != "I"
	
		_cEmpOri	:= ZZ1->ZZ1_EMPORI
		_cFilOri	:= ZZ1->ZZ1_FILORI
		_cBanOri	:= ZZ1->ZZ1_BANORI
		_cAgeOri	:= ZZ1->ZZ1_AGEORI
		_cConOri	:= ZZ1->ZZ1_CONORI
		_cEmpDes	:= ZZ1->ZZ1_EMPDES
		_cFilDes	:= ZZ1->ZZ1_FILDES
		_cBanDes	:= ZZ1->ZZ1_BANDES
		_cAgeDes	:= ZZ1->ZZ1_AGEDES
		_cConDes	:= ZZ1->ZZ1_CONDES
		_nValor		:= ZZ1->ZZ1_VALOR
		_cHist		:= ZZ1->ZZ1_OBSERV
		_cNatOri	:= ZZ1->ZZ1_NATORI
		_cNatDes	:= ZZ1->ZZ1_NATDES
		_cDoc		:= ZZ1->ZZ1_DOCUM
		_cTipo		:= ZZ1->ZZ1_TIPO
		_cMotv		:= ZZ1->ZZ1_MOTREC
		
    EndIf
    
	CriaSxb1()
	CriaSxb2()
	CriaSxb3()
	CriaSxb4()	
	
	DEFINE MSDIALOG _oDlg TITLE cTitulo FROM 000,000 TO 300,1000 PIXEL

	@ 000, 000 MSPANEL oPanel1 SIZE 200, 148 OF _oDlg COLORS 0, 16777215 LOWERED
	
	@ 006, 012 Say "Transfer๊ncia Origem"	SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	
	@ 025, 015 Say "Empresa"	SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 025, 045 Say "Filial"		SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 025, 075 Say "Banco"		SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 025, 115 Say "Agencia"	SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 025, 165 Say "Conta"		SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 025, 235 Say "Natureza"	SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	
	@ 61, 012 Say "Transfer๊ncia Destino"	SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE

	@ 080, 015 Say "Empresa"	SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 080, 045 Say "Filial"		SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 080, 075 Say "Banco"		SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 080, 115 Say "Agencia"	SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 080, 165 Say "Conta"		SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 080, 235 Say "Natureza"	SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	
	
	@ 127, 015 Say "Tipo Mov." 	SIZE 150,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 127, 080 Say "Documento" 	SIZE 150,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	@ 127, 196 Say "Valor" 		SIZE 150,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
                                        
	@ 001, 001 to 04, 37.5 of oPanel1
	@ 005, 001 to 08, 37.5 of oPanel1
	@ 008.5, 001 to 10.2, 37.5 of oPanel1
	
	@ 035, 015 MsGet _cEmpOri																					 	 		SIZE 025,010 When .F.   OF oPanel1 PIXEL
	@ 035, 045 MsGet _cFilOri																					 	 		SIZE 025,010 When .F.   OF oPanel1 PIXEL
	@ 035, 075 MsGet _cBanOri				F3 "CBBORI" Picture "@S3"	Valid CbOSa6("1",_cBanOri) 					 	 		SIZE 030,010 When lWhen OF oPanel1 PIXEL
	@ 035, 115 MsGet _cAgeOri						 	Picture "@S5"	Valid CbOSa6("2",_cBanOri,_cAgeOri) 		 	 		SIZE 040,010 When lWhen OF oPanel1 PIXEL
	@ 035, 165 MsGet _cConOri						 	Picture "@S10"	Valid CbOSa6("3",_cBanOri,_cAgeOri,_cConOri) 	 		SIZE 060,010 When lWhen OF oPanel1 PIXEL
	@ 035, 235 MsGet _cNatOri				F3 "SED" 	Valid FinVldNat( .F., _cNatOri, 2 )	 					 	 		SIZE 060,010 When lWhen OF oPanel1 PIXEL

	@ 090, 015 MsGet _cEmpDes				F3 "CBEMP" 															 	 		SIZE 025,010 When lWhen OF oPanel1 PIXEL
	@ 090, 045 MsGet _cFilDes				Valid CbValEmp(_cEmpDes,_cFilDes) 										 		SIZE 025,010 When lWhen OF oPanel1 PIXEL
	@ 090, 075 MsGet _cBanDes				F3 "CBBAN" 	Picture "@S3"	Valid CbDSa6("1",_cBanDes) 					 		SIZE 030,010 When lWhen OF oPanel1 PIXEL
	@ 090, 115 MsGet _cAgeDes						   	Picture "@S5"	Valid CbDSa6("2",_cBanDes,_cAgeDes) 		 		SIZE 040,010 When lWhen OF oPanel1 PIXEL
	@ 090, 165 MsGet _cConDes						   	Picture "@S10"	Valid CbDSa6("3",_cBanDes,_cAgeDes,_cConDes) 		SIZE 060,010 When lWhen OF oPanel1 PIXEL
	@ 090, 235 MsGet _cNatDes				F3 "CBNAT" 	Valid CbVNat( _cNatDes ) 									 		SIZE 060,010 When lWhen OF oPanel1 PIXEL

  	@ 125, 048 MsGet _cTipo					F3 "14" 																 		Size 025,010 When lWhen OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
  	@ 125, 122 MsGet _cDoc					Picture "@!" Valid CbDocV(_cDoc)																		 		Size 070,010 When lWhen OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
//  	@ 125, 220 MsGet _nValor				Picture "@e 999,999,999.99" Valid CbSald(_cBanOri,_cAgeOri,_cConOri,_nValor) 	Size 070,010 When lWhen OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
  	@ 125, 220 MsGet _nValor				Picture "@e 999,999,999.99"  													Size 070,010 When lWhen OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	If cProc == "I"
		@ 006, 313 Say "Observa็๕es"			SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
	  	@ 014.5, 310 GET oDesc VAR _cHist MEMO  SIZE 184,098 When lWhen OF oPanel1 PIXEL
	Else
		If cProc == "A"
			@ 006, 313 Say "Observa็๕es"				 SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
		  	@ 014.5, 310 GET oDesc VAR _cHist MEMO  	 SIZE 184,042 When lWhen OF oPanel1 PIXEL
			@ 061, 313 Say "Motivo Aprova็ใo/Reprova็ใo" SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
		  	@ 069.5, 310 GET oMotv VAR _cMotv MEMO  	 SIZE 184,042 When .T.   OF oPanel1 PIXEL
		Else
			If ZZ1->ZZ1_STATUS == "1"
				@ 006, 313 Say "Observa็๕es"			 SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
			  	@ 014.5, 310 GET oDesc VAR _cHist MEMO   SIZE 184,098 When lWhen OF oPanel1 PIXEL
			Else
				@ 006, 313 Say "Observa็๕es"			 SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
			  	@ 014.5, 310 GET oDesc VAR _cHist MEMO   SIZE 184,042 When lWhen OF oPanel1 PIXEL
				@ 061, 313 Say "Motivo"+If(ZZ1->ZZ1_STATUS == "2"," Aprova็ใo",If(ZZ1->ZZ1_STATUS == "3"," Reprova็ใo",""))		SIZE 110,010 OF oPanel1 PIXEL Font oBold COLOR CLR_HBLUE
			  	@ 069.5, 310 GET oMotv VAR _cMotv MEMO   SIZE 184,042 When lWhen OF oPanel1 PIXEL
			EndIf				
		EndIf
	EndIf
	  	
	If cProc == "I"
		@ 120, 382 BUTTON oButton1 PROMPT "Transferir"  SIZE 052, 020 OF oPanel1 ACTION(CBCONF01A()) PIXEL
    EndIf
	If cProc == "A"
		@ 120, 320 BUTTON oButton1 PROMPT "Aprovar"   SIZE 052, 020 OF oPanel1 ACTION(U_CBAPRO01A(_cMotv,__CUSERID)) PIXEL
		@ 120, 382 BUTTON oButton1 PROMPT "Reprovar"  SIZE 052, 020 OF oPanel1 ACTION(U_CBREPR01A(_cMotv,__CUSERID)) PIXEL
    EndIf
    
	@ 120, 442 BUTTON oButton2 PROMPT "Fechar" 		SIZE 052, 020 OF oPanel1 ACTION(_oDlg:End()) PIXEL
	
	oPanel1:Align := CONTROL_ALIGN_TOP
	
	ACTIVATE MSDIALOG _oDlg CENTERED

	If Select(cAliasDes) > 0
		(cAliasDes)->(Dbclosearea())
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBFIN01A  บAutor  ณMicrosiga           บ Data ณ  07/19/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbDocV(_cDoc)

	Local lRet		:= .T.
	Local aAreaV	:= GetArea()

	Dbselectarea("ZZ1")
	Dbsetorder(4)
	If Dbseek(xFilial("ZZ1")+_cDoc)
		MsgAlert("<b>Documento : "+_cDoc+", nใo cadastrado.</b>", "Aten็ใo")	
		lRet	:= .F.
	EndIf
	
	RestArea(aAreaV)
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CbOSa6   บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo dos Campos Banco/Agencia/Conta Origem            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbOSa6(_cTp,_cBanOri,_cAgeOri,_cConOri,_cBNomOr)

	Local lRet			:= .T.
	
	Default _cBanOri	:= ""
	Default _cAgeOri	:= ""
	Default _cConOri	:= ""
	Default	_cBNomOr	:= ""
	
	If !Empty(Alltrim(_cBanOri+_cAgeOri+_cConOri))
		Dbselectarea("SA6")
		Dbsetorder(1) 
		Dbgotop()
		If !Dbseek(xFilial("SA6")+_cBanOri+_cAgeOri+_cConOri)
			If _cTp == "1"
		        MsgAlert("<b>Banco : "+_cBanOri+", nใo cadastrado.</b>", "Aten็ใo")
			ElseIf _cTp == "2"	
		        MsgAlert("<b>Banco/Ag๊ncia : "+_cBanOri+"/"+_cAgeOri+", nใo cadastrado.</b>", "Aten็ใo")
			ElseIf _cTp == "3"	
		        MsgAlert("<b>Banco/Ag๊ncia/Conta : "+_cBanOri+"/"+_cAgeOri+"/"+_cConOri+", nใo cadastrado.</b>", "Aten็ใo")
			EndIf
			lRet	:= .F.
		Else
			If _cTp == "4"
				_cBNomOr	:= SA6->A6_NOME
			Endif	
		EndIf
	EndIf
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CbDSa6   บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo Campos banco/Agencia/Conta Destino               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbDSa6(_cTp,_cBanDes,_cAgeDes,_cConDes,_cBNomDe)

	Local lRet			:= .T.
	Local cQuery		:= ""
	Local cTabDes		:= ""
	Local cAlias		:= GetNextAlias()

	Default _cBanDes	:= ""
	Default _cAgeDes	:= ""
	Default _cConDes	:= ""
	Default _cBNomDe	:= ""
	
	If !Empty(Alltrim(_cBanDes+_cAgeDes+_cConDes))

		Dbselectarea(cAliasDes)
		Dbgotop()
		If Dbseek("SA6")
			cTabDes		:= Alltrim((cAliasDes)->X2_ARQUIVO)
		EndIf
		
	 	cQuery	:= " SELECT A6_COD, A6_AGENCIA, A6_NUMCON, A6_NOME "
	  	cQuery	+= " FROM "+cTabDes+" SA6 "
	 	cQuery	+= " WHERE SA6.D_E_L_E_T_ = ' ' "
	 	If _cTp == "1"
		 	cQuery	+= " AND A6_COD = '"+_cBanDes+"' "
	 	ElseIf _cTp == "2"
		 	cQuery	+= " AND A6_COD = '"+_cBanDes+"' AND A6_AGENCIA = '"+_cAgeDes+"' "
	 	ElseIf _cTp == "3"
		 	cQuery	+= " AND A6_COD = '"+_cBanDes+"' AND A6_AGENCIA = '"+_cAgeDes+"' AND A6_NUMCON = '"+_cConDes+"' "
	    EndIf
	    
		TCQUERY cQuery New ALIAS &cAlias
		
		(cAlias)->(dbGoTop())
		If (cAlias)->(Eof())
			If _cTp == "1"
		        MsgAlert("<b>Banco : "+_cBanDes+", nใo cadastrado no destino.</b>", "Aten็ใo")
			ElseIf _cTp == "2"	
		        MsgAlert("<b>Banco/Ag๊ncia : "+_cBanDes+"/"+_cAgeDes+", nใo cadastrado no destino.</b>", "Aten็ใo")
			ElseIf _cTp == "3"	
		        MsgAlert("<b>Banco/Ag๊ncia/Conta : "+_cBanDes+"/"+_cAgeDes+"/"+_cConDes+", nใo cadastrado no destino.</b>", "Aten็ใo")
			EndIf
	    	lRet	:= .F.
		Else
			If _cTp == "4"
				_cBNomDe	:= (cAlias)->A6_NOME
			Endif	
		EndIf
		
		If Select(cAlias) > 0
			(cAlias)->(Dbclosearea())
		EndIf
	
	EndIf
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CbValEmp บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida campo empresa/Filial Destino                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbValEmp(_cEmp,_cFil)

	Local lRet		:= .F.
	Local aAreaSM0	:= SM0->(GetArea())
	Local lEntrou	:= .F.
	
	Default _cEmp	:= SM0->M0_CODIGO
	Default _cFil	:= SM0->M0_CODFIL
	
	If _cEmp+_cFil == cEmpAnt+cFilant
      	MsgAlert("<b>Aten็ใo opera็๕es dentro da mesma empresa/filial utilizar a rotina padrใo.</b>", "Aten็ใo")
		Return(lRet)
	EndIf
	
	Dbselectarea("SM0")
	Dbgotop()
	Do While !Eof()
		If Empty(_cFil)
			If SM0->M0_CODIGO == _cEmp
				lEntrou	:= .T.
				Exit
			EndIf	
		Else
			If SM0->M0_CODIGO == _cEmp .And. SM0->M0_CODFIL == _cFil
				lEntrou	:= .T.
				Exit
			EndIf	
		EndIf
		Dbselectarea("SM0")
		Dbskip()
	EndDo
	
	If lEntrou 
		lRet	:= .T.

		If Select(cAliasDes) > 0
			(cAliasDes)->(Dbclosearea())
		EndIf
	
		dbUseArea(.T.,"CTREECDX", "\SYSTEM\SX2"+_cEmp+"0.DTC",cAliasDes,.T.)
		IndRegua(cAliasDes,cIndA,"X2_CHAVE",,,"Selecionando Registros...")
		
		_cBanDes	:= ""
		_cAgeDes	:= ""
		_cConDes	:= ""
		_cNatDes	:= ""

		Dbselectarea(cAliasDes)
		Dbgotop()
		If Dbseek("SA6")
			_cCbarqSa6	:= Alltrim((cAliasDes)->X2_ARQUIVO)
		EndIf

		Dbselectarea(cAliasDes)
		Dbgotop()
		If Dbseek("SED")
			_cCbarqSeD	:= Alltrim((cAliasDes)->X2_ARQUIVO)
		EndIf

	Else
      	MsgAlert("<b>Empresa/Filial nใo existem.</b>", "Aten็ใo")
	EndIf	
	
	RestArea(aAreaSM0)
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CbVNat   บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbVNat( _cNatDes )

	Local cQuery		:= ""
	Local cTabDes		:= ""
	Local cAlias		:= GetNextAlias()

	Default _cNatOri	:= ""
	
	Dbselectarea(cAliasDes)
	Dbgotop()
	If Dbseek("SED")
		cTabDes		:= Alltrim((cAliasDes)->X2_ARQUIVO)
	EndIf
	
 	cQuery	:= " SELECT ED_CODIGO, ED_DESCRIC "
  	cQuery	+= " FROM "+cTabDes+" SED "
 	cQuery	+= " WHERE SED.D_E_L_E_T_ = ' ' "
 	cQuery	+= " AND ED_CODIGO = '"+_cNatDes+"' AND ED_MSBLQL = '1' AND ED_TIPO = '2' "
    
	TCQUERY cQuery New ALIAS &cAlias
	
	(cAlias)->(dbGoTop())
	If (cAlias)->(Eof())
      	MsgAlert("<b>Natureza invalida : "+_cNatDes+", no destino.</b>", "Aten็ใo")
    	lRet	:= .F.
	EndIf
	
	If Select(cAlias) > 0
		(cAlias)->(Dbclosearea())
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CriaSxb1 บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria consulta padrใo Empresa/Filial                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaSxb1()

	nXX      := 0
	cCons    := "CBEMP"
	aCons    := {}
	
	aAdd(aCons,{ "1" , "01" , "DB" , "Empresas/Filiais" , "SM0"        		})
	aAdd(aCons,{ "2" , "01" , "01" , "Empresa" 			, ""  				})
	aAdd(aCons,{ "4" , "01" , "01" , "Cod Empresa" 		, "M0_CODIGO"  		})
	aAdd(aCons,{ "4" , "01" , "02" , "Cod Filial" 		, "M0_CODFIL"  		})
	aAdd(aCons,{ "4" , "01" , "03" , "Empresa" 			, "M0_NOME"  		})
	aAdd(aCons,{ "4" , "01" , "04" , "Filial" 			, "M0_FILIAL"  		})
	aAdd(aCons,{ "4" , "01" , "05" , "Municipio" 		, "M0_CIDENT"  		})
	aAdd(aCons,{ "5" , "01" , ""   , "" 				, "SM0->M0_CODIGO" 	})
	aAdd(aCons,{ "5" , "02" , ""   , "" 				, "SM0->M0_CODFIL" 	})
	
	If !SXB->( DbSeek( cCons  ) )
		For nXX := 1 to Len( aCons )
			RecLock( "SXB" , .T. )
			SXB->XB_ALIAS     := cCons
			SXB->XB_TIPO      := aCons[ nXX , 01 ]
			SXB->XB_SEQ       := aCons[ nXX , 02 ]
			SXB->XB_COLUNA    := aCons[ nXX , 03 ]
			SXB->XB_DESCRI    := aCons[ nXX , 04 ]
			SXB->XB_DESCSPA   := aCons[ nXX , 04 ]
			SXB->XB_DESCENG   := aCons[ nXX , 04 ]
			SXB->XB_CONTEM    := aCons[ nXX , 05 ]
			SXB->( MsUnlock() )
		Next nXX
	EndIF
	
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณ CriaSxb2     ณ Autor ณ Rodrigo T. Silva  ณ Data ณ 31/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cria Consulta Banco Destino                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaSxb2()

	nXX      := 0
	cCons    := "CBBAN"
	aCons    := {}
	
	aAdd(aCons,{ "1" , "01" , "RE" , "Banco" , "SA6"          })
	aAdd(aCons,{ "2" , "01" , "01" , "Banco" , "U_CBCONSA6(_cCbarqSa6)"  })
	aAdd(aCons,{ "5" , "  " , "  " , "     " , "&(ReadVar())" })
	
	If !SXB->( DbSeek( cCons  ) )
		For nXX := 1 to Len( aCons )
			RecLock( "SXB" , .T. )
			SXB->XB_ALIAS     := cCons
			SXB->XB_TIPO      := aCons[ nXX , 01 ]
			SXB->XB_SEQ       := aCons[ nXX , 02 ]
			SXB->XB_COLUNA    := aCons[ nXX , 03 ]
			SXB->XB_DESCRI    := aCons[ nXX , 04 ]
			SXB->XB_DESCSPA   := aCons[ nXX , 04 ]
			SXB->XB_DESCENG   := aCons[ nXX , 04 ]
			SXB->XB_CONTEM    := aCons[ nXX , 05 ]
			SXB->( MsUnlock() )
		Next nXX
	EndIF
	
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณ CriaSxb3     ณ Autor ณ Rodrigo T. Silva  ณ Data ณ 31/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cria Consulta Natureza Destino                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaSxb3()

	nXX      := 0
	cCons    := "CBNAT"
	aCons    := {}
	
	aAdd(aCons,{ "1" , "01" , "RE" , "Banco" , "SED"          })
	aAdd(aCons,{ "2" , "01" , "01" , "Banco" , "U_CBCONSED(_cCbarqSeD)"  })
	aAdd(aCons,{ "5" , "  " , "  " , "     " , "&(ReadVar())" })
	
	If !SXB->( DbSeek( cCons  ) )
		For nXX := 1 to Len( aCons )
			RecLock( "SXB" , .T. )
			SXB->XB_ALIAS     := cCons
			SXB->XB_TIPO      := aCons[ nXX , 01 ]
			SXB->XB_SEQ       := aCons[ nXX , 02 ]
			SXB->XB_COLUNA    := aCons[ nXX , 03 ]
			SXB->XB_DESCRI    := aCons[ nXX , 04 ]
			SXB->XB_DESCSPA   := aCons[ nXX , 04 ]
			SXB->XB_DESCENG   := aCons[ nXX , 04 ]
			SXB->XB_CONTEM    := aCons[ nXX , 05 ]
			SXB->( MsUnlock() )
		Next nXX
	EndIF
	
Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณ CriaSxb3     ณ Autor ณ Rodrigo T. Silva  ณ Data ณ 31/10/06 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cria Consulta Natureza Destino                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaSxb4()

	nXX      := 0
	cCons    := "CBBORI"
	aCons    := {}
	
	aAdd(aCons,{ "1" , "01" , "DB" , "BancoAg๊nciaConta" , "SA6"        			})
	aAdd(aCons,{ "2" , "01" , "01" , "C๓digo" 			 , ""  						})
	aAdd(aCons,{ "2" , "02" , "02" , "Nome" 			 , ""  						})
	aAdd(aCons,{ "4" , "01" , "01" , "Conta" 			 , "A6_NUMCON"  			})	
	aAdd(aCons,{ "4" , "01" , "02" , "Nome" 			 , "A6_NOME"  				})	
	aAdd(aCons,{ "4" , "01" , "03" , "C๓digo" 			 , "A6_COD"  				})	
	aAdd(aCons,{ "4" , "01" , "04" , "Ag๊ncia" 			 , "A6_AGENCIA" 			})	
	aAdd(aCons,{ "4" , "02" , "05" , "Conta" 			 , "A6_NUMCON"  			})	
	aAdd(aCons,{ "4" , "02" , "06" , "Nome" 			 , "A6_NOME"  				})	
	aAdd(aCons,{ "4" , "02" , "07" , "C๓digo" 			 , "A6_COD"  				})	
	aAdd(aCons,{ "4" , "02" , "08" , "Ag๊ncia" 			 , "A6_AGENCIA" 			})	
	aAdd(aCons,{ "5" , "01" , "  " , "" 				 , "SA6->A6_COD" 			})
	aAdd(aCons,{ "5" , "02" , "  " , "" 				 , "SA6->A6_AGENCIA" 		})
	aAdd(aCons,{ "5" , "03" , "  " , "" 				 , "SA6->A6_NUMCON" 		})
	aAdd(aCons,{ "6" , "01" , "  " , "" 				 , "SA6->A6_BLOCKED != '1'" })
	
	If !SXB->( DbSeek( cCons  ) )
		For nXX := 1 to Len( aCons )
			RecLock( "SXB" , .T. )
			SXB->XB_ALIAS     := cCons
			SXB->XB_TIPO      := aCons[ nXX , 01 ]
			SXB->XB_SEQ       := aCons[ nXX , 02 ]
			SXB->XB_COLUNA    := aCons[ nXX , 03 ]
			SXB->XB_DESCRI    := aCons[ nXX , 04 ]
			SXB->XB_DESCSPA   := aCons[ nXX , 04 ]
			SXB->XB_DESCENG   := aCons[ nXX , 04 ]
			SXB->XB_CONTEM    := aCons[ nXX , 05 ]
			SXB->( MsUnlock() )
		Next nXX
	EndIF
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CBCONSA6 บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega Dados Consulta Banco Destino                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBCONSA6(_cCbarqSa6)

    Local lOk 		:= .F.
    Local aDados 	:= {}
	Local cAlias	:= GetNextAlias()
    Local cQuery	:= "" 

	Local nBanDes	:= TamSX3("ZZ1_BANORI")[1]
	Local nAgeDes	:= TamSX3("ZZ1_AGEORI")[1]
	local nConDes	:= TamSX3("ZZ1_CONORI")[1]
    
 	cQuery	:= " SELECT A6_COD, A6_AGENCIA, A6_NUMCON, A6_NOME "
  	cQuery	+= " FROM "+_cCbarqSa6+" SA6 "
 	cQuery	+= " WHERE SA6.D_E_L_E_T_ = ' ' AND A6_BLOCKED <> '1' "
 	cQuery	+= " ORDER BY A6_COD, A6_AGENCIA, A6_NUMCON "
    
	TCQUERY cQuery New ALIAS &cAlias
	
	(cAlias)->(dbGoTop())
	Do While (cAlias)->(!Eof())

	    aAdd(aDados, {(cAlias)->A6_COD, (cAlias)->A6_AGENCIA, (cAlias)->A6_NUMCON, (cAlias)->A6_NOME})
	    
    	(cAlias)->(Dbskip())
	EndDo     

	(cAlias)->(Dbclosearea())
	
    //Chamando a consulta
    lOk := u_zConsArr(aDados, 1, 4, {"Banco","Agencia","Conta","Descri็ใo"}, {03,05,10,40},"1")
     
    //Se foi confirmado, mostra mensagem
    If lOk
		_cBanDes	:= Substr(__cCBReton,1,nBanDes)
		_cAgeDes	:= Substr(__cCBReton,nBanDes+1,nAgeDes)
		_cConDes	:= Substr(__cCBReton,nBanDes+nAgeDes+1,nConDes)
    EndIf

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CBCONSED บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega Dados Consulta Natureza Destino                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBCONSED(_cCbarqSeD)

    Local lOk 		:= .F.
    Local aDados 	:= {}
	Local cAlias	:= GetNextAlias()
    Local cQuery	:= "" 

	Local nTamNat	:= TamSX3("ED_CODIGO")[1]
	Local nTamDes	:= TamSX3("ED_DESCRIC")[1]

    
 	cQuery	:= " SELECT ED_CODIGO, ED_DESCRIC "
  	cQuery	+= " FROM "+_cCbarqSeD+" SED "
 	cQuery	+= " WHERE SED.D_E_L_E_T_ = ' ' "
 	cQuery	+= " AND ED_MSBLQL = '1' AND ED_TIPO = '2' "
 	cQuery	+= " ORDER BY ED_CODIGO "
    
	TCQUERY cQuery New ALIAS &cAlias
	
	(cAlias)->(dbGoTop())
	Do While (cAlias)->(!Eof())

	    aAdd(aDados, {(cAlias)->ED_CODIGO, (cAlias)->ED_DESCRIC})
	    
    	(cAlias)->(Dbskip())
	EndDo     

	(cAlias)->(Dbclosearea())
	
    //Chamando a consulta
    lOk := u_zConsArr(aDados, 1, 2, {"Codigo","Descri็ใo"}, {nTamNat,nTamDes},"2")
     
    //Se foi confirmado, mostra mensagem
    If lOk
		_cNatDes	:= __cCBReton
    EndIf

Return lOk
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ zConsArr บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Tela de Consulta                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function zConsArr(aDadosM, nPosRetM, nColsM, aTitulosM, aTamanM, cCons )

    Local aArea 		:= GetArea()
    Local nTamBtn 		:= 50
    
    Default aDadosM 	:= {}
    Default nPosRetM 	:= 0
    Default nColsM 		:= 0
    Default aTitulosM 	:= {}
    Default aTamanM 	:= {}
    Default cCons		:= "1"
    Private aCampos 	:= aDadosM
    Private nPosRet 	:= nPosRetM
    Private cConsulta	:= cCons
    Private nCols    	:= nColsM
    Private aTitulos 	:= aTitulosM
    Private aTaman 		:= aTamanM
    Private oMsNew
    Private aHeadAux 	:= {}
    Private aColsAux 	:= {}
    Private nJanLarg 	:= 0800
    Private nJanAltu 	:= 0500
    Private oDlgEspe
    Private oGetPesq
    Private cGetPesq 	:= Space(100)
    Private lRetorn 	:= .F.
    Private nTamanRet 	:= Iif(Len(aDadosM) >= 1, Len(aDadosM[1][nPosRet]), 18)

    Public  __cCBReton 	:= ""
     
    DEFINE FONT oBold2    NAME "Arial" SIZE 0, -12 BOLD	

    //Se tiver o alias em branco ou nใo tiver campos
    If Len(aDadosM) <= 0 .Or. (nPosRetM == 0) .Or. (nColsM == 0)
        MsgStop("Sem campos!", "Aten็ใo")
        Return lRetorn
    EndIf
     
    //Criando a estrutura para a MsNewGetDados
    fCriaMsNew()
     
    //Criando a janela
    DEFINE MSDIALOG oDlgEspe TITLE "Consulta de Dados" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL Font oBold2
        //Pesquisar
        @ 003, 003 GROUP oGrpPesqui TO 025, (nJanLarg/2)-3 PROMPT "Pesquisar: "    OF oDlgEspe COLOR 0, 16777215 PIXEL
        @ 010, 006 MSGET oGetPesq VAR cGetPesq SIZE (nJanLarg/2)-12, 010 OF oDlgEspe COLORS 0, 16777215  VALID (fVldPesq()) PIXEL Font oBold2
         
        //Dados
        @ 028, 003 GROUP oGrpDados TO (nJanAltu/2)-28, (nJanLarg/2)-3 PROMPT "Dados: "    OF oDlgEspe COLOR 0, 16777215 PIXEL
            oMsNew := MsNewGetDados():New(    035,;                                        //nTop
                                                006,;                                        //nLeft
                                                (nJanAltu/2)-31,;                            //nBottom
                                                (nJanLarg/2)-6,;                            //nRight
                                                GD_INSERT+GD_DELETE+GD_UPDATE,;            //nStyle
                                                "AllwaysTrue()",;                            //cLinhaOk
                                                ,;                                            //cTudoOk
                                                "",;                                        //cIniCpos
                                                ,;                                            //aAlter
                                                ,;                                            //nFreeze
                                                999,;                                        //nMax
                                                ,;                                            //cFieldOK
                                                ,;                                            //cSuperDel
                                                ,;                                            //cDelOk
                                                oDlgEspe,;                                    //oWnd
                                                aHeadAux,;                                    //aHeader
                                                aColsAux)                                    //aCols                                   
            oMsNew:lActive := .F.
            oMsNew:oBrowse:blDblClick := {|| fConfirm()}
         
            //Populando os dados da MsNewGetDados
            fPopula()
         
        //A็๕es
        @ (nJanAltu/2)-25, 003 GROUP oGrpAcoes TO (nJanAltu/2)-3, (nJanLarg/2)-3 PROMPT "A็๕es: "    OF oDlgEspe COLOR 0, 16777215 	PIXEL
        
        @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06) BUTTON oBtnConf PROMPT "Confirmar" SIZE nTamBtn, 013 OF oDlgEspe ACTION(fConfirm())    PIXEL
        @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09) BUTTON oBtnLimp PROMPT "Limpar" 	SIZE nTamBtn, 013 OF oDlgEspe ACTION(fLimpar())     PIXEL
        @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*3)+12) BUTTON oBtnCanc PROMPT "Cancelar" 	SIZE nTamBtn, 013 OF oDlgEspe ACTION(fCancela())	PIXEL
       
        oMsNew:oBrowse:SetFocus()
    //Ativando a janela
    ACTIVATE MSDIALOG oDlgEspe CENTERED
     
    RestArea(aArea)

Return lRetorn
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCriaMsNewบAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta estrutura dos campos da Tela                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCriaMsNew()


    Local cCampoAtu := "XX_CAMP000"
    Local nTamanAtu := 0
     
    //Percorrendo os campos
    For nAtual := 1 To nCols
        cCampoAtu := Soma1(cCampoAtu)
        nTamanAtu := 10
         
        //Se tiver tํtulo
        If ! (nAtual > Len(aTitulos))
            cTituloAux := aTitulos[nAtual]
        Else
            cTituloAux := Capital(StrTran(cCampoAtu, "XX_", ""))
        EndIf
 
        //Se tiver tamanho
        If nAtual >= Len(aTaman)
            nTamanAtu := aTaman[nAtual]
        EndIf
         
        //Cabe็alho ...    Titulo            Campo            Mask        Tamanho    Dec        Valid    Usado    Tip        F3    CBOX
        aAdd(aHeadAux,{    cTituloAux,    cCampoAtu,        "",            nTamanAtu,            0,        ".F.",    ".F.",    "C",    "",    ""})
    Next

Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fPopula  บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza Grid                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fPopula()

    Local xAux := ""
    aColsAux :={}
     
    //Percorrendo linhas
    For nLinha := 1 To Len(aCampos)
        lFiltro := .F.
         
        //Se tiver filtro, verifica um a um se tem a expressใo
        If !Empty(cGetPesq)
            //percorrendo colunas
            For nColuna := 1 To nCols
                xAux := aCampos[nLinha][nColuna]
                If ValType(xAux) != 'C'
                    xAux := cValToChar(xAux)
                EndIf
                 
                //Se tiver na pesquisa
                If Alltrim(Lower(cGetPesq)) $ Lower(xAux)
                    lFiltro := .T.
                EndIf
            Next
         
        //Se nใo tiver filtro, traz tudo
        Else
            lFiltro := .T.
        EndIf
         
         
        //Se tiver filtrado ok
        If lFiltro
            aAux := {}
            //percorrendo colunas
            For nColuna := 1 To nCols
                aAdd(aAux, aCampos[nLinha][nColuna])
            Next
            aAdd(aAux, .F.)
            aAdd(aColsAux, aClone(aAux))
        EndIf
    Next
     
    //Se nใo tiver dados, adiciona linha em branco
    If Len(aColsAux) == 0
        aAux := {}
        //Percorrendo os campos e adicionando no acols (junto com o recno e com o delet
        For nAtual := 1 To nCols
            aAdd(aAux, '')
        Next
        aAdd(aAux, .F.)
     
        aAdd(aColsAux, aClone(aAux))
    EndIf
     
    //Posiciona no topo e atualiza grid
    oMsNew:SetArray(aColsAux)
    oMsNew:oBrowse:Refresh()

Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fConfirm บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorno dos campos da consulta                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fConfirm()

    Local cAux := ""
    Local aColsNov := oMsNew:aCols
    Local nLinAtu  := oMsNew:nAt
    lRetorn := .T.
                        
    If cConsulta == "1"
	    __cCBReton := aColsNov[nLinAtu][1]+aColsNov[nLinAtu][2]+aColsNov[nLinAtu][3]
    Else
	    __cCBReton := aColsNov[nLinAtu][nPosRet]
    EndIf
     
    oDlgEspe:End()
    
Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLimpar  บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Limpa Filtro                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLimpar()

    //Zerando gets
    cGetPesq := Space(100)
    oGetPesq:Refresh()
 
    //Atualiza grid
    fPopula()
     
    //Setando o foco na pesquisa
    oGetPesq:SetFocus()

Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCancela บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancela Consulta                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCancela()

    //Setando o retorno em branco e finalizando a tela
    lRetorn := .F.
    __cCBReton := Space(nTamanRet)
    oDlgEspe:End()

Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldPesq  บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida Pesquisa                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fVldPesq()

    Local lRet := .T.
     
    //Se tiver ap๓strofo ou porcentagem, a pesquisa nใo pode prosseguir
    If "'" $ cGetPesq .Or. "%" $ cGetPesq
        lRet := .F.
        MsgAlert("<b>Pesquisa invแlida!</b><br>A pesquisa nใo pode ter <b>'</b> ou <b>%</b>.", "Aten็ใo")
    EndIf
     
    //Se houver retorno, atualiza grid
    If lRet
        fPopula()
    EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBCONF01A บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Confirma็ใo da inclusใo da Transfer๊ncia                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CBCONF01A()

	Local lContinua		:= .F.
	Local aDadosWf		:= {}
	Local _cBNomOr		:= CbONAM(_cBanOri,_cAgeOri,_cConOri) 
	Local _cBNomDe		:= CbdNAM(_cBanDes,_cAgeDes,_cConDes) 
	Local _lProcesso 	:= .F.
	Local _cWFId		:= ""
	Local aWFId			:= {}

		    
	// Valida Banco/Agencia/Conta de origem
	If CbOSa6("3",_cBanOri,_cAgeOri,_cConOri)
		lContinua		:= .T.
	Else
		lContinua		:= .F.
	EndIf
	// Valida Banco/Agencia/Conta de Destino
	If CbDSa6("3",_cBanDes,_cAgeDes,_cConDes)
		lContinua		:= .T.
	Else
		lContinua		:= .F.
	EndIf

	If !Empty(_cTipo) .And. _nValor > 0 .And. !Empty(_cDoc) .And. !Empty(_cHist) .And. !Empty(_cNatOri) .And. !Empty(_cNatDes) .And.;
		!Empty(_cBanori) .And. !Empty(_cBanDes) .And. !Empty(_cAgeOri) .And. !Empty(_cAgeDes) .And. !Empty(_cConOri) .And. !Empty(_cConDes)
		lContinua		:= .T.
	Else
		MsgAlert("<b>Existem campos obrigat๓rios nใo preenchidos</b>.", "Aten็ใo")
		lContinua		:= .F.
	EndIf
	
	If !lContinua
		Return()
	EndIf

	Aadd( aDadosWf, { 	_cEmpOri, _cFilOri,	_cEmpDes, _cFilDes,	_cDoc, dDataBase, cUserAtu,;
						_nValor, _cHist, _cBanOri, _cAgeOri, _cConOri, _cBNomOr,_cBanDes,;
						_cAgeDes, _cConDes,	_cBNomDe })
	
	aWFId		:= CBWFIN01(aDadosWf)
	_cWFId		:= aWFId[1]
	cCRXTASKID	:= aWFId[2]
	_lProcesso 	:= .T.

	Reclock("ZZ1",.T.)
	ZZ1->ZZ1_FILIAL		:= xFilial("ZZ1")
	ZZ1->ZZ1_EMPORI		:= _cEmpOri
	ZZ1->ZZ1_FILORI		:= _cFilOri
	ZZ1->ZZ1_BANORI		:= _cBanOri
	ZZ1->ZZ1_AGEORI		:= _cAgeOri
	ZZ1->ZZ1_CONORI		:= _cConOri
	ZZ1->ZZ1_EMPDES		:= _cEmpDes
	ZZ1->ZZ1_FILDES		:= _cFilDes
	ZZ1->ZZ1_BANDES		:= _cBanDes
	ZZ1->ZZ1_AGEDES		:= _cAgeDes
	ZZ1->ZZ1_CONDES		:= _cConDes
	ZZ1->ZZ1_VALOR		:= _nValor
	ZZ1->ZZ1_ITEM		:= "01"
	ZZ1->ZZ1_OBSERV		:= _cHist
	ZZ1->ZZ1_USER		:= cUserAtu
	ZZ1->ZZ1_DTTRAN		:= dDataBase
	ZZ1->ZZ1_APROV		:= ""
	ZZ1->ZZ1_STATUS		:= "1"
	ZZ1->ZZ1_NATORI		:= _cNatOri
	ZZ1->ZZ1_NATDES		:= _cNatDes
	ZZ1->ZZ1_DOCUM		:= _cDoc
	ZZ1->ZZ1_TIPO		:= _cTipo
	ZZ1->ZZ1_BNOMOR		:= _cBNomOr
	ZZ1->ZZ1_BNOMDE		:= _cBNomDe
	ZZ1->ZZ1_WFID		:= _cWFId
	ZZ1->ZZ1_TASKID		:= cCRXTASKID
    ZZ1->(MsUnlock())
    
	MsgAlert("<b>Transfer๊ncia encaminhada para aprova็ใo</b>.", "Aten็ใo")

	_cCbarqSa6	:= ""
	_cCbarqSeD	:= ""
    __cCBReton 	:= ""
    
	If Select(cAliasDes) > 0 
		(cAliasDes)->(Dbclosearea())
	Endif
	
	_oDlg:End()    
	
Return()	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBREPR01A บAutor  ณRodrigo T. Silva    บ Data ณ  07/13/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Reprova Transferencia                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBREPR01A(_cMotv,cAprov)

	If Empty(_cMotv)
		MsgAlert("<b>Favor informar o motivo da rejei็ใo</b>.", "Aten็ใo")
		Return()
	EndIf
	
	Dbselectarea("ZZ1")
	Reclock("ZZ1",.F.)
	ZZ1->ZZ1_STATUS		:= "3"
	ZZ1->ZZ1_MOTREC		:= _cMotv
	ZZ1->ZZ1_APROV		:= cAprov
	ZZ1->(Msunlock())
	
	_oDlg:End()    

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CbSald   บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/17/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida Saldo bancแrio x Valor solicitado                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbSald(_cBanOri,_cAgeOri,_cConOri,_nValor)
        
	Local lRet		:= .T.
	Local nSalBan	:= 0
	
	If Empty(Alltrim(_cBanOri+_cAgeOri+_cConOri))
		MsgAlert("<b>Favor digitar banco/ag๊ncia/conta de origem</b>.", "Aten็ใo")
		_nValor	:= 0
		Return(lRet)
	EndIf	
	
	nSalban	:= SldBco(_cBanOri,_cAgeOri,_cConOri,dDataBase)
	
	If _nValor > nSalban
		If Aviso("Aten็ใo", "Saldo Bancแrio insuficiente R$ "+Transform(nSalban,"@e 999,999,999.99")+", Deseja Continuar?",{'Sim','Nใo'}) == 2
			lRet	:= .F.
			_nValor	:= 0
		EndIf
	Endif	

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBAPRO01A บAutor  ณ Rodrigo T. Silva   บ Data ณ  07/17/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aprova Transfer๊ncia e gera movimento                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBAPRO01A(_cMotv,cAprov)

	Local aCabP			:= {}
	Local aCabR			:= {}
	Local lMsErroAuto	:= .F.
	Local _cEmpOri		:= ZZ1->ZZ1_EMPORI
	Local _cFilOri		:= ZZ1->ZZ1_FILORI
	Local _cEmpDes		:= ZZ1->ZZ1_EMPDES
	Local _cFilDes		:= ZZ1->ZZ1_FILDES
	Local _aAreaSM0 	:= {}
	Local _oAppBk 		:= oApp
	Local lRet			:= .T.
	Local cIdSE5		:= ""
		
	// Carrega Vetor origem
	Aadd( aCabP, { "E5_FILIAL" 	, ZZ1->ZZ1_FILORI	, Nil } )
	Aadd( aCabP, { "E5_DATA" 	, ZZ1->ZZ1_DTTRAN	, Nil } )
	Aadd( aCabP, { "E5_MOEDA" 	, "R$"				, Nil } )
	Aadd( aCabP, { "E5_VALOR" 	, ZZ1->ZZ1_VALOR	, Nil } )
	Aadd( aCabP, { "E5_RECPAG" 	, "P"				, Nil } )
	Aadd( aCabP, { "E5_NATUREZ" , ZZ1->ZZ1_NATORI	, Nil } )
	Aadd( aCabP, { "E5_BANCO"	, ZZ1->ZZ1_BANORI	, Nil } )
	Aadd( aCabP, { "E5_AGENCIA"	, ZZ1->ZZ1_AGEORI	, Nil } )
	Aadd( aCabP, { "E5_CONTA"	, ZZ1->ZZ1_CONORI	, Nil } )
	Aadd( aCabP, { "E5_DOCUMEN" , ZZ1->ZZ1_DOCUM	, Nil } )
	Aadd( aCabP, { "E5_HISTOR" 	, ZZ1->ZZ1_OBSERV	, Nil } )
	Aadd( aCabP, { "E5_DTDIGIT" , dDataBase			, Nil } )
	Aadd( aCabP, { "E5_DTDISPO" , ZZ1->ZZ1_DTTRAN	, Nil } )
	Aadd( aCabP, { "E5_FILORIG" , ZZ1->ZZ1_FILORI	, Nil } )
	Aadd( aCabP, { "E5_TIPODOC" , ZZ1->ZZ1_TIPO		, Nil } )

	_aAreaSM0 	:= SM0->(GetArea())
	_cEmpBkp 	:= SM0->M0_CODIGO 				//Guardo a empresa atual
	_cFilBkp 	:= SM0->M0_CODFIL 				//Guardo a filial atual
	
	MSExecAuto({|x,y,z,w| Fina100(x,y,z,w),},,aCabP,3)

	If lMsErroAuto
   		MostraErro()
	Else
		Reclock("ZZ1",.F.)
		ZZ1->ZZ1_IDORIG		:= SE5->E5_IDORIG
		ZZ1->(Msunlock())
		
		cIdSE5		:= SE5->E5_IDORIG
		
	    // Carrega Vetor destino
		Aadd( aCabR, { "E5_FILIAL" 	, ZZ1->ZZ1_FILDES	, Nil } )
		Aadd( aCabR, { "E5_DATA" 	, ZZ1->ZZ1_DTTRAN	, Nil } )
		Aadd( aCabR, { "E5_MOEDA" 	, "R$"				, Nil } )
		Aadd( aCabR, { "E5_VALOR" 	, ZZ1->ZZ1_VALOR	, Nil } )
		Aadd( aCabR, { "E5_RECPAG" 	, "R"				, Nil } )
		Aadd( aCabR, { "E5_NATUREZ" , ZZ1->ZZ1_NATDES	, Nil } )
		Aadd( aCabR, { "E5_BANCO"	, ZZ1->ZZ1_BANDES	, Nil } )
		Aadd( aCabR, { "E5_AGENCIA"	, ZZ1->ZZ1_AGEDES	, Nil } )
		Aadd( aCabR, { "E5_CONTA"	, ZZ1->ZZ1_CONDES	, Nil } )
		Aadd( aCabR, { "E5_DOCUMEN" , ZZ1->ZZ1_DOCUM	, Nil } )
		Aadd( aCabR, { "E5_HISTOR" 	, ZZ1->ZZ1_OBSERV	, Nil } )
		Aadd( aCabR, { "E5_DTDIGIT" , dDataBase			, Nil } )
		Aadd( aCabR, { "E5_DTDISPO" , ZZ1->ZZ1_DTTRAN	, Nil } )
		Aadd( aCabR, { "E5_FILORIG" , ZZ1->ZZ1_FILDES	, Nil } )
		Aadd( aCabR, { "E5_TIPODOC" , ZZ1->ZZ1_TIPO		, Nil } )
	
		//troco de empresa
		dbCloseAll() 								//Fecho todos os arquivos abertos
		OpenSM0() 									//Abrir Tabela SM0 (Empresa/Filial)
		
		dbSelectArea("SM0")
		SM0->(dbSetOrder(1))
		SM0->(dbSeek(_cEmpDes + _cFilDes,.T.)) 		//Posiciona Empresa
		cEmpAnt := SM0->M0_CODIGO 					//Seto as variaveis de ambiente
		cFilAnt := SM0->M0_CODFIL
		OpenFile(cEmpAnt + cFilAnt) 				//Abro a empresa que eu desejo trabalhar
		
		If U_CBprcRec(aCabR)						// Cria Movimenta็ใo no destino
			lRet	:= .T.		
		Else
			lRet	:= .F.		
        EndIf
		
		//Para finalizar volto as variaveis de sistema para seus valores antes da execu็ใo
		dbCloseAll() //Fecho todos os arquivos abertos
		OpenSM0() //Abrir Tabela SM0 (Empresa/Filial)
		dbSelectArea("SM0")
		SM0->(dbSetOrder(1))
		SM0->(RestArea(_aAreaSM0)) //Restaura Tabela
		cFilAnt := SM0->M0_CODFIL //Restaura variaveis de ambiente
		cEmpAnt := SM0->M0_CODIGO
		OpenFile(cEmpAnt + cFilAnt) //Abertura das tabelas
	
		oApp := _oAppBk //Backup do componente visual

		If !lRet

			Dbselectarea("SE5")
			DbSetOrder(21)
			If DSeek(xFilial("SE5")+ZZ1->ZZ1_IDORIG )
                              
				lMsErroAuto	:= .F.
				aFINA100 := { 	{ "E5_DATA" 	,SE5->E5_DATA 		,Nil},;
								{ "E5_MOEDA" 	,SE5->E5_MOEDA 		,Nil},;
								{ "E5_VALOR" 	,SE5->E5_VALOR 		,Nil},;
								{ "E5_NATUREZ" 	,SE5->E5_NATUREZ 	,Nil},;
								{ "E5_BANCO" 	,SE5->E5_BANCO 		,Nil},;
								{ "E5_AGENCIA" 	,SE5->E5_AGENCIA 	,Nil},;
								{ "E5_CONTA" 	,SE5->E5_CONTA 		,Nil},;
								{ "E5_HISTOR" 	,SE5->E5_HISTOR 	,Nil},;
								{ "E5_IDORIG" 	,SE5->E5_IDORIG 	,Nil},;
								{ "E5_DOCUMEN" 	,SE5->E5_DOCUMEN 	,Nil},;
								{ "E5_TIPOLAN" 	,SE5->E5_TIPOLAN 	,Nil} }

				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,5)		

				If lMsErroAuto
			   		MostraErro()
				Else
		        	Dbselectarea("ZZ1")
		        	Dbsetorder(3)
		        	If Dbseek(cIdSE5)
		
						Reclock("ZZ1",.F.)
						ZZ1->ZZ1_IDORIG		:= SE5->E5_IDORIG
						ZZ1->(Msunlock())
				
					EndIf
									
				EndIf				
		    EndIf
        Else
        	
        	Dbselectarea("ZZ1")
        	Dbsetorder(3)
        	If Dbseek(cIdSE5)

				Reclock("ZZ1",.F.)
				ZZ1->ZZ1_APROV		:= cAprov
				ZZ1->ZZ1_DTAPRO		:= dDatabase
				ZZ1->ZZ1_STATUS		:= "2"
				ZZ1->ZZ1_MOTREC		:= _cMotv
				ZZ1->(Msunlock())
		
			EndIf
        
        EndIf

	EndIf
	    
	_oDlg:End()    

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBFIN01A  บAutor  ณMicrosiga           บ Data ณ  07/17/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBprcRec(aCabR)  // Cria Movimenta็ใo na Origem

	Local lRet			:= .T.
	Local lMsErroAuto	:= .F.

	MSExecAuto({|x,y,z,w| Fina100(x,y,z,w),},,aCabR,4)

	If lMsErroAuto
   		MostraErro()
		lRet	:= .F.
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBFIN01A  บAutor  ณMicrosiga           บ Data ณ  07/24/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbONAM(_cBanOri,_cAgeOri,_cConOri)

	Local cRetName	:= ""

	Dbselectarea("SA6")
	Dbsetorder(1) 
	Dbgotop()
	If Dbseek(xFilial("SA6")+_cBanOri+_cAgeOri+_cConOri)
		cRetName	:= SA6->A6_NOME
	EndIf
	
Return(cRetName)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBFIN01A  บAutor  ณMicrosiga           บ Data ณ  07/24/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbDNAM(_cBanDes,_cAgeDes,_cConDes)

	Local cRetName		:= ""
	Local cQuery		:= ""
	Local cTabDes		:= ""
	Local cAlias		:= GetNextAlias()
	
	Dbselectarea(cAliasDes)
	Dbgotop()
	If Dbseek("SA6")
		cTabDes		:= Alltrim((cAliasDes)->X2_ARQUIVO)
	EndIf
		
 	cQuery	:= " SELECT A6_COD, A6_AGENCIA, A6_NUMCON, A6_NOME "
  	cQuery	+= " FROM "+cTabDes+" SA6 "
 	cQuery	+= " WHERE SA6.D_E_L_E_T_ = ' ' "
 	cQuery	+= " AND A6_COD = '"+_cBanDes+"' AND A6_AGENCIA = '"+_cAgeDes+"' AND A6_NUMCON = '"+_cConDes+"' "
	    
	TCQUERY cQuery New ALIAS &cAlias
		
	(cAlias)->(dbGoTop())
	If (cAlias)->(!Eof())
		cRetName	:= (cAlias)->A6_NOME
	EndIf	
	
	If Select(cAlias) > 0
		(cAlias)->(Dbclosearea())
	EndIf
	
Return(cRetName)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBFIN01A  บAutor  ณMicrosiga           บ Data ณ  07/24/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CBWFIN01(aDadosWf)

	Local oProcess, oHtml
	Local cPasta			:= "TRANSFBAN"
	Local cUrl      		:= GetMv("MV_WFURL") + cEmpAnt + "/" + cPasta
	Local cSubject			:= ""  
	Local _cWFID			:= ""
	Local cCRXTASKID		:= ""
	Local cNomEOri  		:= ""
	Local cNomFOri			:= ""
	Local cNomEDes  		:= ""
	Local cNomFDes			:= ""

	Private cAttachFile 	:= ""	    

	ChkFile("ZZ1")
	ChkFile("SED")
	ChkFile("SA6")

	cNomEOri	:= CbuscSm0( 1, aDadosWf[1,1], aDadosWf[1,2] )
	cNomFOri	:= CbuscSm0( 2, aDadosWf[1,1], aDadosWf[1,2] )
	cNomEDes	:= CbuscSm0( 1, aDadosWf[1,3], aDadosWf[1,4] )
	cNomFDes	:= CbuscSm0( 2, aDadosWf[1,3], aDadosWf[1,4] )

	PswOrder(1) // Ordem de nome

	If PswSeek(ALLTRIM(__cUserID),.T.)
		_aRetUser := PswRet(1)
	EndIf

	
	dbSelectArea("SM0")
	dbSetOrder(1)
	SM0->(dbSeek(cEmpAnt+cFilAnt))

	cSubject := "Aprova็ใo Transfer๊ncia Bancaria "  + cEmpAnt + "-" + cFilAnt + " / " + _aRetUser[1][4]

	oProcess			:=TWFProcess():New("00001","WORKFLOW APROVACAO TRANSFERENCIA BANCARIA")
	clArqHtml			:= "\WORKFLOW\HTML\Cbwftrans.html"
	oProcess:NewTask("WFGrupoCB",clArqHtml)
	oProcess:cSubject 	:= cSubject
	oProcess:bReturn  	:= "U_CBWFIN1A()" 
	oProcess:cTo      	:= cPasta 
	oProcess:UserSiga	:= __cUserID
	oProcess:NewVersion(.T.)
	oProcess:attachfile(cAttachFile)

	oHtml    := oProcess:oHTML

	oHtml:ValByName( "WF"   		, Trim(_cWF))
	oHtml:ValByName( "WFID"			, oProcess:fProcessId)

	oHtml:ValByName("cNUM"			, aDadosWf[1,5] )
	oHtml:ValByName("cEMISSAO"		, DTOC(aDadosWf[1,6]) )
	oHtml:ValByName("cSOLICIT"		, aDadosWf[1,7]+" - "+_aRetUser[1][4] )
	oHtml:ValByName("cCODUSR"		, aDadosWf[1,7] )
	oHtml:ValByName("cAPROV"		, "" )
	oHtml:ValByName("cMOTIVO"		, "" )
	oHtml:ValByName("nValor"		, Transform(aDadosWf[1,8],"@E 999,999,999.99") )
	oHtml:ValByName("cObserv"		, aDadosWf[1,9] )
	//Banco Origem
	oHtml:ValByName("cEmpOri"		, aDadosWf[1,1]+"-"+cNomEOri )
	oHtml:ValByName("cFilOri"		, aDadosWf[1,2]+"-"+cNomFOri )
	oHtml:ValByName("cBanOri"		, aDadosWf[1,10] )
	oHtml:ValByName("cAgeOri"		, aDadosWf[1,11] )
	oHtml:ValByName("cConOri"		, aDadosWf[1,12] )
	oHtml:ValByName("cNomOri"		, aDadosWf[1,13] )
	//Banco Destino
	oHtml:ValByName("cEmpDes"		, aDadosWf[1,3]+"-"+cNomEDes )
	oHtml:ValByName("cFilDes"		, aDadosWf[1,4]+"-"+cNomFDes )
	oHtml:ValByName("cBanDes"		, aDadosWf[1,14] )
	oHtml:ValByName("cAgeDes"		, aDadosWf[1,15] )
	oHtml:ValByName("cConDes"		, aDadosWf[1,16] )
	oHtml:ValByName("cNomDes"		, aDadosWf[1,17] )

	_cWFID 		:= oProcess:fProcessId
	cCRXTASKID	:= oProcess:FTaskID

	_cWFID 		:= oProcess:Start() 
	cCRXTASKID	:= oProcess:FTaskID

	oProcess := TWFProcess():New( "APROVADORES", "Envio de email para os aprovadores" )
	oProcess:NewTask( "Envio de email Link", "\workflow\html\link.htm" )
	oProcess:cTo := "rodrigosilvat@hotmail.com"
	oProcess:cSubject := cSubject
	
	oProcess:oHtml:ValByName("cNomAprov", AllTrim( UsrFullName(__cUserID) ) )
	oProcess:oHtml:ValByName("cLinkWF", cUrl + "/" + _cWFID + ".htm")
	oProcess:oHtml:ValByName("cNomeProcesso", cSubject )

	_cWFID := Left(_cWFID,8)

	oProcess:Start()

	DbCommitAll()	

Return( {_cWFID, cCRXTASKID } )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBWFIN01  บAutor  ณMicrosiga           บ Data ณ  07/19/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CbuscSm0(nTipo, cEmp, cFil)

	Local cRet		:= ""
	Local aAreaSm0	:=  SM0->(GetArea())
	Local aArea		:=  GetArea()
	
	Default	cEmp	:= ""
	Default	cFil	:= ""
                     
 	Dbselectarea("SM0")
 	Dbgotop()
 	Do While SM0->(!Eof())
 		If nTipo == 1 .and. cEmp == SM0->M0_CODIGO
 			cRet	:= SM0->M0_NOME
 			Exit
 		EndIf
 		If nTipo == 2 .and. cFil == SM0->M0_CODFIL
 			cRet	:= SM0->M0_FILIAL 		
 			Exit
 		EndIf
 		SM0->(Dbskip())
 	EndDo

	RestArea(aAreaSm0)
	RestArea(aArea)
             
Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBFIN01A  บAutor  ณMicrosiga           บ Data ณ  07/24/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/	

User Function CBWFIN1A(oProcess)


	If oProcess <> Nil

		cNum		:= oProcess:oHtml:RetByName("cNUM")
		cSolicit	:= oProcess:oHtml:RetByName("cSOLICIT")
		cAprov		:= oProcess:oHtml:RetByName("cAPROV")
		cMotivo		:= oProcess:oHtml:RetByName("cMOTIVO")
		cCodSol		:= oProcess:oHtml:RetByName("cCODUSR")
		cEmpOri		:= oProcess:oHtml:RetByName("cEmpOri")
		cFilOri		:= oProcess:oHtml:RetByName("cFilOri")
		cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
		cWF       	:= alltrim(oProcess:oHtml:RetByName("WF"))


		oProcess:Finish()
		
		Dbselectarea("ZZ1")
		Dbsetorder(3)
		Dbgotop()
		If Dbseek(cWFID)

			If cAprov == "L"
				U_CBAPRO01A(cMotivo,cAprov)        
	        Else
	        	U_CBREPR01A(cMotivo,cAprov)
			EndIf
		EndIf
	
	EndIf

Return(.T.)