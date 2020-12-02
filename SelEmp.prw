#Include 'Protheus.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} SelEmp
Wizard para sele��o GRUPO/Filial/Evento
@type 		User function
@author 	iVan Oliveira
@since 		21/09/2018
@version 	1.0
@return 	_aRet,Array, Array unidimensional com c�digos dos grupos e filiais selecionadas.
@example
			u_SelEmp()
/*/
User Function SelEmp(_cPerg, _cTexto)

Local _cTit01  := "Essa ferramenta ir� auxiliar na gera��o do relat�rio: "  + _cTexto + Space(50)
Local _cTit02  := "Nas pr�ximas telas voc� dever� informar as Grupos/filiais utilizado como filtro para o relat�rio."
local _aStruEmp:= {}
Local _cEmpLOG := _cFilLOG := ''

Private cAliasSM0	:= GetNextAlias()
Private cMark     	:= GetMark()
Private oMsSelect
Private oTmpTbl 	 
Private _aRet  		:= {}
Private _cIndSM0
Private _lParam	    := .F.

DeFault _cPerg     := ''

    
//Sele��o as GRUPOs       
dbSelectArea( "SM0" )
nRecSM0 := SM0->( Recno() )
SM0->( dbGoTop() )

aAdd( _aStruEmp, { "CODGRUPO" , "C", Len( SM0->M0_CODIGO) , 0 } )	
aAdd( _aStruEmp, { "GRUPO" 	  , "C", 50 , 0 } )
aAdd( _aStruEmp, { "CODFIL"	  , "C", Len( SM0->M0_CODFIL ) , 0 } )
aAdd( _aStruEmp, { "FILIAL"   , "C", Len( SM0->M0_FILIAL ) , 0 } )
aAdd( _aStruEmp, { "MARK"     , "C", 02 	               , 0 } )

if SELECT ("cAliasSM0")>0
alert('pvez')
	cAliasSM0->(dbCloseArea())

Endif

// Criando tabelas tempor�rias.
oTmpTbl:=Criatrab(_aStruEmp,.T.) 
DbUseArea(.T.,,oTmpTbl,"cAliasSM0",.F.,.F.) 

_cIndSM0 := Criatrab(NIL,.F.)
_cIndKSM0:= "GRUPO+CODFIL"

IndRegua("cAliasSM0", _cIndSM0, _cIndKSM0,,,"Aguarde, selecionando registros...")

// Selecionando Grupos/Filiais 
DbSelectArea("cAliasSM0")
cAliasSM0->(dbgotop())
If cAliasSM0->( Eof() )

if Empty(_cEmpLOG  + _cFilLOG) 

_cEmpLOG := SM0->M0_CODIGO  
_cFilLOG := SM0->M0_CODFIL

Endif

	While SM0->( !Eof() )
		If .T. // AllTrim( SM0->M0_CODIGO ) == cEmpAnt .And. AllTrim( SM0->M0_CODFIL ) $ cValidFil
			RecLock( "cAliasSM0", .T. )
			cAliasSM0->CODGRUPO:= SM0->M0_CODIGO 
			cAliasSM0->GRUPO   := SM0->M0_CODIGO + '- ' + FWGrpName(SM0->M0_CODIGO)
			cAliasSM0->CODFIL  := SM0->M0_CODFIL
			cAliasSM0->FILIAL  := SM0->M0_FILIAL
			cAliasSM0->MARK    := ' '
			cAliasSM0->( MsUnLock() )
		EndIf
		
		SM0->( dbSkip() )
	EndDo
		
	SM0->( dbGoTo( nRecSM0 ) )
	
EndIf

// Seta no primeiro ambiente
RpcSetType( 3 )
RpcSetEnv( _cEmpLOG, _cFilLOG)

//�����������������������������������������������������Ŀ
//� Painel 1 - Tela inicial do Wizard 		            � 	
//�������������������������������������������������������
//<chTitle > , < chMsg > , < cTitle > , < cText > , < bNext > , < bFinish > , < lPanel > , < cResHead > , < bExecute > , < lNoFirst > , < aCoord > ) --> NIL
oWizard := APWizard():New( OemToAnsi( '.' ), ' ', OemToAnsi( '.' ), OemToAnsi( '.' ) + CRLF + OemToAnsi( _cTit01 ) + CRLF + OemToAnsi( _cTit02 ) + CRLF + ;
 						   OemToAnsi( '.' ), {|| .T.}, {|| .T.}, .F., Nil, {|| .T.}, Nil, {00,00,450,600} )
 
//�����������������������������������������������������Ŀ
//� Painel 2 - Selecao de Filiais		                �
//�������������������������������������������������������
oWizard:NewPanel(	"Filtros"						,; //"Parametriza��o"
					"Selecione Grupos/filiais"		,; //"Selecione os par�emtros que ser�o utilizados durante a convers�o"
						{|| .T.}					,; //<bBack>
						{|| _ValEmp()} 				,; //<bNext>
						{|| Finaliza(1) }		    ,; //<bFinish>
						.T.							,; //<.lPanel.>
						{|| GetFilConv(_cPerg) } )     //<bExecute>
 
oWizard:Activate( .T., { || Finaliza(0) }, { || .T. }, { || .T. } )

Return _aRet

/*
��������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������
����������������������������������������������������������������������������������ͻ��
���Programa  � GetFilConv �Autor� Ivan - Ethosx            � Data � 21/09/18       ���
����������������������������������������������������������������������������������͹��
���Descri��o � Monta tela para sele��o das filiais.		                           ���
����������������������������������������������������������������������������������͹��
���Sintaxe   � GetFilConv()                                                        ���
����������������������������������������������������������������������������������͹��
���Par�metros�                                                                     ���
����������������������������������������������������������������������������������͹��
���Uso       � GPECONV                                                             ���
����������������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������
*/
Static Function GetFilConv(_cPerg)

Local aColumns		:= {}
Local cMarkAll		:= cMark
Local oPanel 		:= oWizard:oMPanel[oWizard:nPanel]
 
If oMsSelect == Nil

	bMarkAll := { || RhMkAll( "cAliasSM0" , .F., .T. , 'MARK', @cMarkAll ,cMark ) }
	cMarkAll := cMark

	aAdd( aColumns, { "MARK"    , ,''         , "@!" } )
	aAdd( aColumns, { "GRUPO"   , ,"Grupo"    , "@!" } )
	aAdd( aColumns, { "CODFIL"  , ,"Filial"   , "@!" } )
	aAdd( aColumns, { "FILIAL"  , ,"Descri��o", "@!" } )
	
	cAliasSM0->(DbGoTop())
	
	oMsSelect := MsSelect():New(;
									"cAliasSM0"			,;	//Alias	do Arquivo de Filtro
									"MARK"				,;	//Campo para controle do mark
									NIL					,;	//Condicao para o Mark
									aColumns			,;	//Array com os Campos para o Browse
									NIL					,;	//
									cMark				,;	//Conteudo a Ser Gravado no campo de controle do Mark
									{c(20),c(00),c(125),c(232)},;//Coordenadas do Objeto
									NIL					,;  //
									NIL					,;	//
									oPanel				 ;	//Objeto Dialog
								)
	oMsSelect:oBrowse:lAllMark := .T.
	oMsSelect:oBrowse:bAllMark := bMarkAll
	
	_oTButton := TButton():New( c(007), c(192), "Par�metros",oPanel,{|| if(pergunte(_cPerg,.T.),_lParam:=.T.,_lParam:=.F.) }, 50,15,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	
Endif

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RhMkAll     � Autor � Ivan - Ethosx	    � Data � 21/09/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Marca/Desmarca todos os elementos do browse                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPECONV                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Static Function RhMkAll( cAlias, lInverte, lTodos, cCpoCtrl, cMark, cMarkAux ) 
  
Local nRecno		:= (cAlias)->(Recno())

(cAlias)->( dbGotop() )

While (cAlias)->( !Eof() )  
	
	RhMkMrk( cAlias , lInverte , lTodos, cCpoCtrl, cMark, {})
	
	(cAlias)->( dbSkip() )
End While

(cAlias)->( MsGoto( nRecno ) )

If cMark == cMarkAux
	cMark := ""
Else
	cMark := cMarkAux
EndIf

Return

/*/{Protheus.doc} _ValEmp
Wizard para sele��o GRUPO/filial
@type 		Static function
@author 	iVan Oliveira
@since 		21/09/2018
@version 	1.0
@return 	_lRet, l�gico, Verifica se foi selecionado algum grupo/filial.
@example
			_ValEmp()
/*/
Static Function _ValEmp

Local _lRet := .f.

// Array de retorno - GRUPOs/Filiais
cAliasSM0->(Dbgotop())
While !cAliasSM0->(Eof())

	if !empty(cAliasSM0->MARK)
	
		_lRet := .T.
		Exit
	
	Endif
	
	cAliasSM0->(DbSkip())

Enddo
 

if !_lRet
 
 	cAliasSM0->(Dbgotop())
	MsgAlert ('Selecione pelo menos uma GRUPO/Filial !', 'Aten��o' )

Endif
	
Return _lRet

/*/{Protheus.doc} Finaliza
Wizard para sele��o GRUPO/filial
@type 		Static function
@author 	iVan Oliveira
@since 		21/09/2018
@version 	1.0
@return 	_lRet, l�gico, Verifica se foi selecionado algum grupo/filial e encerra o processo. 
@example
			Finaliza()
/*/
Static Function Finaliza(_nOpc)

Local _lRet := .T.
 
if _nOpc == 1

	// Array de retorno - GRUPOs/Filiais
	cAliasSM0->(Dbgotop())
	While !cAliasSM0->(Eof())
	
		if !empty(cAliasSM0->MARK)
 
			aadd(_aRet, { Alltrim(cAliasSM0->CODGRUPO), Alltrim(cAliasSM0->CODFIL) } )
			
		Endif
		
		cAliasSM0->(DbSkip())
	
	Enddo
	
	// Se n�o foi alterado os par�metros.
	if !_lParam .and. !empty(_aRet)
	
		_lRet := MsgYesNo ('N�o foi verificado/preenchido os par�metros para o relat�rio. Continuar?', 'Aten��o')
	
	Endif
	
 Endif

// Fechando o tempor�rio
if _lRet .and. Select ("cAliasSM0")>0
 
	cAliasSM0->(dbCloseArea())
	FErase(_cIndSM0 + GetDbExtension())  // Deletando o arquivo
	FErase(_cIndSM0 + OrdBagExt())       // Deletando �ndice
	
Endif

Return _lRet
 