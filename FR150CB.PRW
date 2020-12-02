#INCLUDE "FINR150.CH"
#Include "PROTHEUS.Ch"
#INCLUDE "FWCOMMAND.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE QUEBR				1
#DEFINE FORNEC				2
#DEFINE TITUL				3
#DEFINE TIPO				4
#DEFINE NATUREZA			5
#DEFINE EMISSAO			    6
#DEFINE VENCTO				7
#DEFINE VENCREA			    8
#DEFINE VL_ORIG			    9
#DEFINE VL_NOMINAL		    10
#DEFINE VL_CORRIG			11
#DEFINE VL_VENCIDO		    12
#DEFINE PORTADOR			13
#DEFINE VL_JUROS			14
#DEFINE ATRASO				15
#DEFINE HISTORICO			16
#DEFINE VL_SOMA			    17
#DEFINE FILIA				18
#DEFINE PJSITA				19
#DEFINE CENT_CUSTO			20
#DEFINE BAIXA				21


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FR150CB    ³ Autor ³OSCAR PROX          ³ Data ³ 24/05/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³TITULOS A PAGAR            .                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß           
/*/
USER Function FR150CB()//U_FR150CB()

Local oReport  

Private cTitAux := ""    // Guarda o titulo do relatório para R3 e R4 
Private cPerg:= "XF150CB"

 
oReport := ReportDef()
oReport:PrintDialog()

Return
//_____________________________________________________________________

Static Function ReportDef()
Local oReport
Local oSection1
Local cPictTit
Local nTamVal, nTamCli, nTamQueb
Local aOrdem := {STR0012,"Prefixo"}	//"Número","Fornecedor"

oReport := TReport():New("FR150CB",STR0005,cPerg,{|oReport| ReportPrint(oReport)},STR0001+STR0002)

oReport:SetLandScape(.T.)
oReport:SetTotalInLine(.F.)		//Imprime o total em linha


//dbSelectArea("SX1")
pergunte(cPerg,.F.)

cPictTit := PesqPict("SE2","E2_VALOR")

nTamVal	 := TamSX3("E2_VALOR")[1]
nTamCli	 := TamSX3("E2_FORNECE")[1] + TamSX3("E2_LOJA")[1] + 25
nTamTit	 := TamSX3("E2_PREFIXO")[1] + TamSX3("E2_NUM")[1] + TamSX3("E2_PARCELA")[1] + 8
nTamQueb := nTamCli + nTamTit + TamSX3("E2_TIPO")[1] + TamSX3("E2_NATUREZ")[1] + TamSX3("E2_EMISSAO")[1] + TamSX3("E2_VENCTO")[1] + TamSX3("E2_VENCREA")[1] + 14
			
//________________
// Secao 1  
//________________
oSection1 := TRSection():New(oReport,STR0061,{"SE2","SA2"},aOrdem)

TRCell():New(oSection1,"M0_CODIGO","SM0","EMPRESA"/*Titulo*/,/*Picture*/,12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"M0_FILIAL","SM0","Filial"/*Titulo*/,/*Picture*/,12,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"FORNECEDOR"	,	  ,STR0038				,,nTamCli,.F.,)  		//"Codigo-Nome do Fornecedor"
TRCell():New(oSection1,"TITULO"		,	  ,STR0039+'-'+STR0040	,,nTamTit,.F.,)  		//"Prf-Numero" + "Parcela"
TRCell():New(oSection1,"E2_TIPO"	,"SE2",STR0041				,,,.F.,)  				//"TP"
TRCell():New(oSection1,"E2_NATUREZ"	,"SE2",STR0042				,,TamSX3("E2_NATUREZ")[1] + 5,.F.,)  				//"Natureza"
TRCell():New(oSection1,"E2_EMISSAO"	,"SE2",STR0043+CRLF+STR0044	,,,.F.,) 				//"Data de" + "Emissao"
TRCell():New(oSection1,"E2_VENCTO"	,"SE2",STR0043+CRLF+STR0045	,,,.F.,)  				//"Vencto" + "Titulo"
TRCell():New(oSection1,"E2_VENCREA"	,"SE2",STR0045+CRLF+STR0047	,,,.F.,)  				//"Vencto" + "Real"
TRCell():New(oSection1,"VAL_ORIG"	,	  ,STR0048				,cPictTit,nTamVal+3,.F.,) //"Valor Original"
TRCell():New(oSection1,"VAL_NOMI"	,	  ,STR0049+CRLF+STR0050	,cPictTit,nTamVal+3,.F.,) //"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection1,"VAL_CORR"	,	  ,STR0049+CRLF+STR0051	,cPictTit,nTamVal+3,.F.,) //"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection1,"VAL_VENC"	,	  ,STR0052+CRLF+STR0050	,cPictTit,nTamVal+3,.F.,) //"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection1,"E2_BAIXA"	,"SE2","BAIXA"	,,,.F.,)  				//"BAIXA"
TRCell():New(oSection1,"E2_PORTADO"	,"SE2",STR0053+CRLF+STR0054	,,,.F.,)  				//"Porta-" + "dor"
TRCell():New(oSection1,"JUROS"		,	  ,STR0055+CRLF+STR0056	,cPictTit,nTamVal+3,.F.,) //"Vlr.juros ou" + "permanencia"
TRCell():New(oSection1,"DIA_ATR"	,	  ,STR0057+CRLF+STR0058	,,4,.F.,)  				//"Dias" + "Atraso"
TRCell():New(oSection1,"E2_HIST"	,"SE2","HISTORICO" 			,,35,.F.,)  			//"Historico(Vencidos+Vencer)"
TRCell():New(oSection1,"VAL_SOMA"	,	  ,STR0060				,cPictTit,nTamVal+7,.F.,) 	//"(Vencidos+Vencer)"
TRCell():New(oSection1,"E2_PJSITA"	,"SE2","PJSITA"				,,,.F.,)  //PJSITA
TRCell():New(oSection1,"CENT_CUSTO"	,	  ,"CENTRO DE CUSTO"	,,,.F.,,,,,,,.T.) //CENTRO DE CUSTO


oSection1:Cell("VAL_ORIG")	:SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_NOMI")	:SetHeaderAlign("RIGHT")             
oSection1:Cell("VAL_CORR")	:SetHeaderAlign("RIGHT")
oSection1:Cell("VAL_VENC")	:SetHeaderAlign("RIGHT")
oSection1:Cell("JUROS")   	:SetHeaderAlign("RIGHT")  
oSection1:Cell("VAL_SOMA")	:SetHeaderAlign("RIGHT") 
oSection1:Cell("CENT_CUSTO"):SetHeaderAlign("CENTER")

oSection1:SetLineBreak(.f.)		//Quebra de linha automatica

oSection2 := TRSection():New(oReport,STR0061)//,{"SM0"},aOrdem)

//TRCell():New(oSection2,"FILIAL"		,,"TOTAL FILIAL"	,			,105) //"Total por Filial:"
//TRCell():New(oSection2,"FILLER1","","",,10,.F.,)
TRCell():New(oSection2,"VALORORIG"	,,STR0048				,cPictTit	,nTamVal+3)//"Valor Original"
TRCell():New(oSection2,"VALORNOMI"	,,STR0049+CRLF+STR0050	,cPictTit	,nTamVal+3)//"Tit Vencidos" + "Valor Nominal"
TRCell():New(oSection2,"VALORCORR"	,,STR0049+CRLF+STR0051	,cPictTit	,nTamVal+3)//"Tit Vencidos" + "Valor Corrigido"
TRCell():New(oSection2,"VALORVENC"	,,STR0052+CRLF+STR0050	,cPictTit	,nTamVal+3)//"Titulos a Vencer" + "Valor Nominal"
TRCell():New(oSection2,"JUROS"		,,STR0055+CRLF+STR0056	,cPictTit	,nTamVal+5)//"Vlr.juros ou" + "permanencia"
TRCell():New(oSection2,"VALORSOMA"	,,STR0060				,cPictTit	,nTamVal+20)//"(Vencidos+Vencer)"


oSection2:Cell("VALORORIG"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALORNOMI"):SetHeaderAlign("RIGHT")             
oSection2:Cell("VALORCORR"):SetHeaderAlign("RIGHT")
oSection2:Cell("VALORVENC"):SetHeaderAlign("RIGHT")
oSection2:Cell("JUROS")   :SetHeaderAlign("RIGHT")  
oSection2:Cell("VALORSOMA"):SetHeaderAlign("RIGHT")

oSection2:SetLineBreak(.F.)

Return oReport                                                                              

/*/
Impressão do Relatório
/*/

Static Function ReportPrint(oReport)
Local oSection1	:=	oReport:Section(1) 
Local oSection2	:=	oReport:Section(2)
Local nOrdem 	:=  oSection1:GetOrder()
Local oBreak
//Local oBreak2

Local aDados[21]
Local dOldDtBase := dDataBase
Local dOldData := dDataBase
Local nJuros  :=0
Local nQualIndice := 0
//Local lContinua := .T.
Local nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
Local nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
//LOcal nTotFil0:=0, nTotFil1:=0, nTotFil2:=0, nTotFil3:=0,nTotFil4:=0, nTotFilTit:=0, nTotFilJ:=0
//Local nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0
Local cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0
Local dDataReaj
Local dDataAnt := dDataBase , lQuebra
//Local nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
//Local cIndexSe2
Local cChaveSe2
//Local nIndexSE2
//Local cFilDe,cFilAte
Local nTotsRec := SE2->(RecCount())
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := 0


Local cMoeda := ""

Local cNomFor	:= ""
Local cNomNat	:= ""

Local cNumBco	:= 0
Local nTotVenc	:= 0
Local nTotGeral := 0
Local nTotTitMes:= 0
Local nTotFil	:= 0
Local dDtVenc
Local lTemCont := .F. 
//Local aSM0 := {}
Local cPictTit := ""
Local nGerTot := 0
Local nFilTot := 0
Local nAuxTotFil := 0
Local nRecnoSE2 := 0
Local aTotFil :={}
local lQryEmp := .F.
Local nI := 0
Local dUltBaixa	:= STOD("")
Local nCont	:= 0

Local cCampos := ""
Local cQueryP := ""
//Local aStru := SE2->(dbStruct())
Local nFilAtu		:= 0
Local nLenSelFil	:= 0
Local nTamUnNeg		:= 0
Local nTamEmp		:= 0
Local nTotEmp		:= 0
Local nTotEmpJ		:= 0
Local nTotEmp0		:= 0
Local nTotEmp1		:= 0
Local nTotEmp2		:= 0
Local nTotEmp3		:= 0
Local nTotEmp4		:= 0
Local nTotTitEmp	:= 0
Local cNomEmp		:= ""
Local cTmpFil		:= ""

Local lTotEmp		:= .F.
Local aTmpFil		:= {}
Local oBrkFil		:= Nil
Local oBrkEmp		:= Nil
Local oBrkNat		:= Nil
Local nBx			:= 0


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
Local cNomeEmp:="",cUnid:="",xDados:={}
Local j:=0
Local nOpc	:= 0


//Local aAreaSEs:=lj7GetArea({"SE2","SE5","SA2","SA6","SED"})
Local _aAreaSM0 := {}
Local _oAppBk := oApp //Guardo a variavel resposavel por componentes visuais
Local _cEmpAtu , _cFilAtu

Private dBaixa := dDataBase
Private cTitulo  := ""
Private cEmpNew:="",cNewEmp:="",cEmpbkp:="",cFilbkp:=""
Private cModo:=""

If mv_par05 == 0
	mv_par05 := 1
EndIf
nDecs  := Msdecimais(mv_par05)
cMoeda := Alltrim(Str(mv_par05,2))
cPictTit := PesqPict("SE2","E2_VALOR")

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
//SM0->(dbSeek('01'+'01'))//Posicionando o SIGAMAT no início

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
//cEmpbkp:=cEmpAnt
//cFilbkp:=cFilAnt

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

		cNewEmp:= aEmps3[j,1]
		cEmpNew:= aEmps3[j,3]

		oSection1:Cell("EMPRESA"    ):SetValue(cNomeEmp)
		oSection1:Cell("FILIAL"     ):SetBlock( { || aDados[FILIA]    			})
		oSection1:Cell("FORNECEDOR"	):SetBlock( { || aDados[FORNEC] 			})
		oSection1:Cell("TITULO"		):SetBlock( { || aDados[TITUL] 				})
		oSection1:Cell("E2_TIPO"	):SetBlock( { || aDados[TIPO] 				})
		oSection1:Cell("E2_NATUREZ"	):SetBlock( { || MascNat(aDados[NATUREZA])  })
		oSection1:Cell("E2_EMISSAO"	):SetBlock( { || aDados[EMISSAO] 			})
		oSection1:Cell("E2_VENCTO"	):SetBlock( { || aDados[VENCTO] 			})
		oSection1:Cell("E2_VENCREA"	):SetBlock( { || aDados[VENCREA] 			})
		oSection1:Cell("VAL_ORIG"	):SetBlock( { || aDados[VL_ORIG] 			})
		oSection1:Cell("VAL_NOMI"	):SetBlock( { || aDados[VL_NOMINAL] 		})
		oSection1:Cell("VAL_CORR"	):SetBlock( { || aDados[VL_CORRIG] 			})
		oSection1:Cell("VAL_VENC"	):SetBlock( { || aDados[VL_VENCIDO] 		})
		oSection1:Cell("E2_BAIXA"   ):SetBlock( { || aDados[BAIXA]				})
		oSection1:Cell("E2_PORTADO"	):SetBlock( { || aDados[PORTADOR] 			})
		oSection1:Cell("JUROS"		):SetBlock( { || aDados[VL_JUROS] 			})
		oSection1:Cell("DIA_ATR"	):SetBlock( { || aDados[ATRASO] 			})
		oSection1:Cell("E2_HIST"	):SetBlock( { || aDados[HISTORICO] 			})
		oSection1:Cell("VAL_SOMA"	):SetBlock( { || aDados[VL_SOMA] 			})
		oSection1:Cell("E2_PJSITA"  ):SetBlock( { || aDados[PJSITA] 			})
		oSection1:Cell("CENT_CUSTO" ):SetBlock( { || aDados[CENT_CUSTO]   		})
		
		oSection1:Cell("VAL_SOMA"):Disable()
		
		TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA })
		
		//????????????????????????????????
		//?Define as quebras da sessão, conforme a ordem escolhida.      ?
		//????????????????????????????????
		
		If nOrdem == 1	//Fornecedor
			oBreak := TRBreak():New(oSection1,{|| SE2->(E2_FORNECE+E2_LOJA) },{|| cNomFor })
		EndIf                                                                       
		
		
		If mv_par10 == 1	//1- Analitico  2-Sintetico
			//Altero o texto do Total Geral
			oReport:SetTotalText({|| STR0027 + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,"MOVIMENTACOES","TITULO")+")" })
			TRFunction():New(oSection1:Cell("VAL_ORIG"),"","SUM",oBreak,,,,.F.,.T.)
			TRFunction():New(oSection1:Cell("VAL_NOMI"),"","SUM",oBreak,,,,.F.,.T.)
			TRFunction():New(oSection1:Cell("VAL_CORR"),"","SUM",oBreak,,,,.F.,.T.)
			TRFunction():New(oSection1:Cell("VAL_VENC"),"","SUM",oBreak,,,,.F.,.T.)
			TRFunction():New(oSection1:Cell("JUROS"	  ),"","SUM",oBreak,,,,.F.,.T.)
			//nTotGeral nao estava imprimindo corretamente o totalizador por isso foi necessario o ajuste abaixo
			//portanto foi criado a variavel nGerTot que eh o acumulador geral da coluna
			TRFunction():New(oSection1:Cell("E2_HIST"),"","ONPRINT",oBreak,,Iif(cPaisLoc == "CHI",cPictTit, PesqPict("SE2","E2_VALOR")),{|lSection,lReport| If(lReport,Iif(nOrdem==2,nTotGeral,nGerTot), nTotVenc)},.F.,.T.)
		EndIf
		
		dbSelectArea ( "SE2" )
		//Set Softseek On
				
		//Acerta a database de acordo com o parametro
		If mv_par11 == 1    // Considera Data Base
			dDataBase := mv_par18
		Endif	
		oSection1:Init()
		//oSection2:Init()
		//Caso nao preencha o mv_par05 um erro ocorre ao procurar o parametro do sistema MV_MOEDA0.
		If Val(cMoeda) == 0
			cMoeda := "1"
		Endif
		
		cTitulo := oReport:title()
		cTitAux := cTitulo
		
		cTitulo += " " + STR0035 + GetMv("MV_MOEDA"+cMoeda)  //"Posicao dos Titulos a Pagar" + " em "
		
		dbSelectArea("SE2")
					
		cQueryP := ""
		cCampos := ""
		aEval(SE2->(DbStruct()),{|e| If(e[2]<> "M", cCampos += ",SE2."+AllTrim(e[1]),Nil)})
		cCampos += ",SE2.R_E_C_N_O_, SE2.R_E_C_D_E_L_, SE2.D_E_L_E_T_ " 
		cQuery := "SELECT " + SubStr(cCampos,2) "
		cQuery += "  FROM SE2"+cNewEmp+"0 SE2 "
		cQuery += " WHERE "//SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
		cQuery += " D_E_L_E_T_ = ' ' " 	
		
			
		IF nOrdem == 1
			cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
			cOrder := SqlOrder(cChaveSe2)
			//cCond1 := "SE2_->E2_FORNECE <= mv_par12"
			cCond2 := "SE2_->E2_FORNECE+SE2->E2_LOJA"
			cTitulo += STR0022 //" - Por Fornecedor"
			nQualIndice := IndexOrd()
		Else
			cChaveSe2 := "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"
			cOrder := SqlOrder(cChaveSe2)
			cCond2 := "SE2_->E2_PREFIXO"
			cTitulo += "Prefixo" //" - Por Prefixo"
			nQualIndice := IndexOrd()
		EndIF
			
		
		cTitulo += STR0023  //" - Analitico"
		
			
		oReport:SetTitle(cTitulo)
		cTitulo := cTitAux
	
		//dbSelectArea("SE2")
				
		//cQueryP += " AND SE2.E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
		//cQueryP += " AND SE2.E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
		//cQueryP += " AND (SE2.E2_MULTNAT = '1' OR (SE2.E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
		cQueryP += " AND SE2.E2_VENCREA BETWEEN '"+ DTOS(mv_par01)+ "' AND '"+ DTOS(mv_par02) + "'"
		//cQueryP += " AND SE2.E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
		//cQueryP += " AND SE2.E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
		cQueryP += " AND SE2.E2_EMISSAO BETWEEN '"+ DTOS(mv_par03)+ "' AND '"+ DTOS(mv_par04) + "'"
		cQueryP += " AND SE2.E2_EMIS1   BETWEEN '"+ DTOS(mv_par08)+ "' AND '"+ DTOS(mv_par09) + "'"		
		//cQueryP += " AND SE2.E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'"
				//Considerar titulos cuja emissao seja maior que a database do sistema
		If mv_par21 == 2
			cQueryP += " AND SE2.E2_EMISSAO <= '" + DTOS(dDataBase) +"'" 
		Endif
		
		//If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
		//	cQueryP += " AND SE2.E2_TIPO IN "+FormatIn(mv_par30,";") 
		//ElseIf !Empty(mv_par31) // Deseja excluir os tipos do parametro 31
		//	cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(mv_par31,";")
		//EndIf
		
		If mv_par17 == 1
			cQueryP += " AND SE2.E2_FLUXO != 'N'"
		Endif
		
				
		cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVABATIM,";")
		
				
		If mv_par06 == 2
			cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVPROVIS,";")			
		Endif
		
		If mv_par12 == 2
			cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MVPAGANT,";")			 
			cQueryP += " AND SE2.E2_TIPO NOT IN "+FormatIn(MV_CPNEG,";")			
		Endif		
		
		iF mv_par19 == 2 .And. !Empty(mv_par18)
			cQueryP += " AND SE2.E2_EMIS1 <= '" + DTOS(mv_par18) +"'"
		Endif
		
		//verifica moeda do campo=moeda parametro
		If mv_par14 == 2 // nao imprime
			cQueryP += " AND SE2.E2_MOEDA = " + cMoeda
		Endif  
		cQueryP +=" AND SE2.E2_SALDO<>0	"
		
		cQuery += cQueryP							
		
		cQuery += " ORDER BY "+ cOrder
		
		cQuery := ChangeQuery(cQuery)	
		//dbSelectArea("SE2")
		//dbCloseArea()

		MemoWrite("C:\microsiga\titulos_a_pagar"+cNewEmp +".sql",cQuery)
		
		If !Select( "SE2_" ) == 0
			SE2_->(dbCloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2_', .F., .T.)
		nTotsRec := SE2_->(RecCount())
		oReport:SetMeter(nTotsRec)	
		
		
		lQryEmp := Eof()
		
		_cFilAtu := SE2_->E2_FILIAL
		
		While !SE2_->(Eof())
		
			oReport:IncMeter()
	
			Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5
			
			IF _cFilAtu<>SE2_->E2_FILIAL
				_cFilAtu:=SE2_->E2_FILIAL
				cFilAnt:=_cFilAtu
			EndIF
			
			//?????????????????????
			//?Carrega data do registro para permitir ?
			//?posterior analise de quebra por mes.   ?
			//?????????????????????
			dDataAnt := Iif(nOrdem == 3, SE2_->E2_VENCREA, SE2_->E2_EMISSAO)
	
			cCarAnt := &cCond2
	        
			lTemCont := .F.

			dbSelectArea("SE2")
			SE2->(DBSetOrder(1))
			SE2->(MsSeek(SE2_->E2_FILIAL+SE2_->E2_PREFIXO+SE2_->E2_NUM+SE2_->E2_PARCELA+SE2_->E2_TIPO+SE2_->E2_FORNECE+SE2_->E2_LOJA,.T.))
			
			//????????????????????????????????
			//?Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ?
			//?n? no relat?io quando se considera database (mv_par11 = 1) ?
			//?ou caso n? se considere a database, se o titulo foi totalmen?
			//?te baixado.																  ?
			//????????????????????????????????
			IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par11 == 2 ,SE2->E2_SALDO == 0 ,SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase)						
				SE2_->(dbSkip())
				Loop
			EndIF

			dbSelectArea("SA2")
			SA2->(DBSetOrder(1)) 
			SA2->(dbSeek(xFilial("SA2")+SE2_->E2_FORNECE+SE2_->E2_LOJA)) //Posiciona o Fornecedor
			// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
			If SE2->E2_VENCREA < dDataBase
				If mv_par17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
					dDataReaj := SE2->E2_VENCREA
				Else
					dDataReaj := dDataBase
				EndIf	
			Else
				dDataReaj := dDataBase
			EndIf       
			DBSelectArea("SE5")
			If mv_par11 == 1
				nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par05,dDataReaj,,SE2->E2_LOJA,,If(mv_par20==1,SE2->E2_TXMOEDA,Nil),IIF(mv_par19 == 2,3,1)) // 1 = DT BAIXA    3 = DT DIGIT
				//Verifica se existem compensa?es em outras filiais para descontar do saldo, pois a SaldoTit() somente
				//verifica as movimenta?es da filial corrente. Nao deve processar quando existe somente uma filial.
				If !Empty(xFilial("SE2")) .And. !Empty(xFilial("SE5"))
					nSaldo -= FRVlCompFil("P",SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,IIF(mv_par19 == 2,3,1),,,,mv_par05,SE2->E2_MOEDA,If(mv_par20==1,SE2->E2_TXMOEDA,Nil),dDataReaj,.T.)
				EndIf
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
					nSAldo -= SE2->E2_DECRESC
				Endif	
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
					nSAldo += SE2->E2_ACRESC
				Endif				
			Else
				nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par05,dDataReaj,ndecs+1,If(mv_par20==1,SE2->E2_TXMOEDA,Nil))
			Endif
			
			IF AlLtrim(SE2_->E2_TIPO)=='NF'
				cQuery := "SELECT DISTINCT "
				cQuery += "D1_DOC,D1_SERIE,D1_CC  "
				cQuery += "FROM SD1"+cNewEmp+"0 SD1 "
				cQuery += "WHERE "
				cQuery += "SD1.D1_DOC =  '"+SE2_->E2_NUM+"' "
				cQuery += "AND SD1.D1_FORNECE = '"+SE2_->E2_FORNECE+"' "
				cQuery += "AND SD1.D1_LOJA = '"+SE2_->E2_LOJA+"' "
				cQuery += "AND SD1.D_E_L_E_T_ = ' ' "
				cQuery += "AND SD1.D1_CC <> ' ' "

				cQuery := ChangeQuery(cQuery)
				If !Select( "SD1_" ) == 0
					SD1_->(dbCloseArea())
				Endif
				//ITENS DA NF
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SD1_",.T.,.T.)

				SD1_->(dbGoTop())

				IF SD1_->D1_CC<>""
					aDados[CENT_CUSTO] := SD1_->D1_CC
				Else
					aDados[CENT_CUSTO] := ""
				Endif
			Else
				aDados[CENT_CUSTO] := ""
			EndIf

			IF aDados[CENT_CUSTO]<>""
				DBSelectArea("CTT")
				CTT->(DBSetOrder(1))
				aDados[CENT_CUSTO]:=Alltrim(aDados[CENT_CUSTO])+" - "+Posicione("CTT",1,xFilial("CTT")+SD1_->D1_CC,"CTT_DESC01")
			EndIF
			
			
			If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
			   ! ( mv_par11 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
	
				//Quando considerar Titulos com emissao futura, eh necessario
				//colocar-se a database para o futuro de forma que a Somaabat()
				//considere os titulos de abatimento
				If mv_par21 == 1
					dOldData := dDataBase
					dDataBase := CTOD("31/12/40")
				Endif
	
				nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par05,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)
	
				If mv_par21 == 1
					dDataBase := dOldData
				Endif
			EndIf
	
			nSaldo:=Round(NoRound(nSaldo,3),2)
			//????????????????????????????
			//?Desconsidera caso saldo seja menor ou igual a zero   ?
			//????????????????????????????
			If nSaldo <= 0
				SE2_->(dbSkip())
				Loop
			Endif  

			aDados[FILIA]:= SE2_->E2_FILIAL
			aDados[FORNEC] := SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+If(mv_par13 == 1, SA2->A2_NREDUZ, SA2->A2_NOME)
			aDados[TITUL]		:= SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
			aDados[TIPO]		:= SE2->E2_TIPO
			aDados[NATUREZA]	:= SE2->E2_NATUREZ
			aDados[EMISSAO]	:= SE2->E2_EMISSAO
			aDados[VENCTO]		:= SE2->E2_VENCTO
			aDados[VENCREA]	:= SE2->E2_VENCREA
			aDados[VL_ORIG]	:= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par05,SE2->E2_EMISSAO,ndecs+1,If(mv_par20==1,SE2->E2_TXMOEDA,Nil)) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
			aDados[PJSITA] := SE2_->E2_PJSITA
			aDados[VL_NOMINAL] :=0
			aDados[VL_CORRIG]:=0
			aDados[VL_VENCIDO]:=0
			

			If dDataBase > SE2->E2_VENCREA 		//vencidos
				aDados[VL_NOMINAL] := nSaldo * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
				nJuros := 0
				dBaixa := dDataBase
				
				// C?culo dos Juros retroativo.
				dUltBaixa := SE2->E2_BAIXA
				If mv_par11 == 1 // se compoem saldo retroativo verifico se houve baixas
					If !Empty(dUltBaixa) .And. dDataBase < dUltBaixa
						dUltBaixa := FR150DBX() // Ultima baixa at?DataBase
					EndIf
				EndIf
				
				dbSelectArea("SE2")
				nJuros := fa080Juros(mv_par05,nSaldo,"SE2",dUltBaixa)
			
				//dbSelectArea("SE2")
				aDados[VL_CORRIG] := (nSaldo+nJuros) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par05,SE2->E2_EMISSAO,ndecs+1,If(mv_par20==1,SE2->E2_TXMOEDA,Nil))
					nTit1 -= nSaldo
					nTit2 -= nSaldo+nJuros
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par05,SE2->E2_EMISSAO,ndecs+1,If(mv_par20==1,SE2->E2_TXMOEDA,Nil))
					nTit1 += nSaldo
					nTit2 += nSaldo+nJuros
				Endif
				nTotJur += (nJuros)
			Else				  //a vencer
				aDados[VL_VENCIDO] := nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) 
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par05,SE2->E2_EMISSAO,ndecs+1,If(mv_par20==1,SE2->E2_TXMOEDA,Nil))
					nTit3 -= nSaldo
					nTit4 -= nSaldo
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par05,SE2->E2_EMISSAO,ndecs+1,If(mv_par20==1,SE2->E2_TXMOEDA,Nil))
					nTit3 += nSaldo
					nTit4 += nSaldo
				Endif
			Endif
	
			aDados[PORTADOR] := SE2->E2_PORTADO
	
			If nJuros > 0
				aDados[VL_JUROS] := nJuros
				nJuros := 0
			Endif
	
			IF dDataBase > SE2->E2_VENCREA
				nAtraso:=dDataBase-SE2->E2_VENCTO
				IF Dow(SE2->E2_VENCTO) == 1 .Or. Dow(SE2->E2_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso:=0
					EndIF
				EndIF
				nAtraso := If(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					aDados[ATRASO] := nAtraso
				EndIF
			EndIF
			aDados[VL_SOMA]:= nTot2+nTot3
			aDados[BAIXA]:= SE2->E2_BAIXA
			If mv_par10 == 1	//1- Analitico  2-Sintetico					
				aDados[HISTORICO] := SUBSTR(SE2->E2_HIST,1,25)+If(SE2_->E2_TIPO $ MVPROVIS,"*"," ")
				//nRecnoSE2 := SE2_->R_E_C_N_O_

				oSection1:PrintLine()

			EndIf

			dDataAnt := SE2->E2_EMISSAO
	
			cNomFor := If(mv_par13 == 1,AllTrim(SA2->A2_NREDUZ),AllTrim(SA2->A2_NOME))+" "+Substr(SA2->A2_TEL,1,15)
			
			
			cNumBco	 := SE2->E2_PORTADO
			dDtVenc  := SE2->E2_EMISSAO
			nTotVenc := nTit2+nTit3
	
	
			SE2_->(dbSkip())
	
			nTotTit ++
			
			nTit5 ++						
					
		   	nTotGeral  := nTit2+nTit3 

			nGerTot  += nTit2+nTit3
	
	
			nTot0 += nTit0
			nTot1 += nTit1
			nTot2 += nTit2
			nTot3 += nTit3
			nTot4 += nTit4
			nTotJ += nTotJur
			
			Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
	
			
		Enddo					

		dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
		If Empty(xFilial("SE2"))
			Exit
		Endif

		oSection1:Finish()
	
	EndIf
	//nInc++
Next
	
oSection1:Init()

If mv_par10 == 1	//1- Analitico  2-Sintetico	

		ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)	

EndIf

	
oSection1:Finish()
//oSection2:Finish()

dDataBase := dOldDtBase

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


/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??un?o	 ?mpT150R  ?Autor ?Wagner Xavier 		  ?Data ?01.06.92 ??
???????????????????????????????????????
??escri?o ?MPRIMIR TOTAL DO RELATORIO 										  ??
???????????????????????????????????????
??intaxe e ?ImpT150R()	 															  ??
???????????????????????????????????????
??arametros?																			  ??
???????????????????????????????????????
??Uso		 ?Generico 																  ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/
STATIC Function ImpT150R(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nTotTit,oReport,oSection1)

HabiCel(oReport)

oSection1:Cell("FORNECEDOR"):SetBlock({|| STR0027 + "(" + ALLTRIM(STR(nTotTit))+" "+If(nTotTit > 1,"MOVIMENTACOES","TITULO")+")" })
oSection1:Cell("VAL_NOMI"  ):SetBlock({|| nTot1 })
oSection1:Cell("VAL_CORR"  ):SetBlock({|| nTot2 })
oSection1:Cell("VAL_VENC"  ):SetBlock({|| nTot3 })
oSection1:Cell("JUROS"     ):SetBlock({|| nTotJ })
oSection1:Cell("VAL_SOMA"  ):SetBlock({|| nTot2+nTot3 })

oSection1:PrintLine()

Return(.T.)


/*/
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??un?o	 ?abiCel	?Autor ?Daniel Tadashi Batori ?Data ?04/08/06 ??
???????????????????????????????????????
??escri?o ?abilita ou desabilita celulas para imprimir totais		  ??
???????????????????????????????????????
??intaxe e ?HabiCel()	 											  ??
???????????????????????????????????????
??arametros?															  ??
??		 ?oReport ->objeto TReport que possui as celulas 			  ??
???????????????????????????????????????
??Uso		 ?Generico 												  ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
/*/
STATIC Function HabiCel(oReport)

Local oSection1 := oReport:Section(1)

oSection1:Cell("FORNECEDOR"):SetSize(50)
oSection1:Cell("TITULO"    ):Hide()
oSection1:Cell("E2_TIPO"   ):Hide()
oSection1:Cell("E2_NATUREZ"):Hide()
oSection1:Cell("E2_EMISSAO"):Hide()
oSection1:Cell("E2_VENCTO" ):Hide()
oSection1:Cell("E2_VENCREA"):Hide()
oSection1:Cell("VAL_ORIG"  ):Hide()
oSection1:Cell("BAIXA" 	   ):Hide()
oSection1:Cell("E2_PORTADO"):Hide()
oSection1:Cell("DIA_ATR"   ):Hide()
oSection1:Cell("E2_HIST"   ):Hide()
oSection1:Cell("E2_PJSITA" ):Hide()
oSection1:Cell("CENT_CUSTO"  ):Hide()
oSection1:Cell("VAL_SOMA"  ):Enable()

oSection1:Cell("FORNECEDOR"):HideHeader()
oSection1:Cell("E2_TIPO"   ):HideHeader()
oSection1:Cell("E2_NATUREZ"):HideHeader()
oSection1:Cell("E2_EMISSAO"):HideHeader()
oSection1:Cell("E2_VENCTO" ):HideHeader()
oSection1:Cell("E2_VENCREA"):HideHeader()
oSection1:Cell("VAL_ORIG"  ):HideHeader()
oSection1:Cell("E2_PORTADO"):HideHeader()
oSection1:Cell("DIA_ATR"   ):HideHeader()	
oSection1:Cell("E2_PJSITA" ):HideHeader()

Return(.T.)


//-------------------------------------------------------------------
/*/{Protheus.doc} FR150DBX

Busca a data da ultima baixa realizada do titulo a pagar at?a
DataBase do sistema.

@author leonardo.casilva

@since 20/05/2016
@version P1180
 
@return
/*/
//-------------------------------------------------------------------
Static Function FR150DBX()

Local dDataRet := SE2_->E2_VENCREA
Local cQuery	 := "SELECT"

cQuery += " MAX(SE5.E5_DATA) DBAIXA"
cQuery += " FROM "+ RetSQLName( "SE5" ) + " SE5 "
cQuery += " WHERE SE5.E5_FILIAL IN ('" + xFilial("SE2")  + "') " 
cQuery += " AND SE5.E5_PREFIXO = '" + SE2_->E2_PREFIXO	 + "'"
cQuery += " AND SE5.E5_NUMERO = '"  + SE2_->E2_NUM		 + "'"
cQuery += " AND SE5.E5_PARCELA = '" + SE2_->E2_PARCELA	 + "'"
cQuery += " AND SE5.E5_TIPO = '"	+ SE2_->E2_TIPO	 	 + "'"
cQuery += " AND SE5.E5_CLIFOR = '"	+ SE2_->E2_FORNECE	 + "'"
cQuery += " AND SE5.E5_LOJA = '"	+ SE2_->E2_LOJA	 	 + "'"
cQuery += " AND SE5.E5_TIPODOC IN('BA','VL')"
cQuery += " AND SE5.E5_RECPAG  = 'P'"
cQuery += " AND SE5.E5_DATA <= '"	+ DTOS(dDataBase) + "'"
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
