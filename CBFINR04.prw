#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch' 
#include 'fwbrowse.ch'
#include 'fwmvcdef.ch' 
#include 'fileio.ch'                           				
#include 'totvs.ch'
#include "matr550.ch" 
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} CBFINR04
//	Relatório customizado tendo como base MATR550 ( não atende Empresa + Filial)
@author 	iVan de Oliveira - EthosX
@since 		22/01/2019
@version 	1.0
@return 	nulo 

@type 		User function
/*/
User Function CBFINR04()

Local _nIt 		:= 0
Local _lRet     := .F.
Local oReport

Private _oTempTable
Private _cPerg 	:= 'MTR550P9R1'//'MTR550'

// Tela para selecionar a Empresa/Filial.
_aParam := u_SelEmp(_cPerg, 'Faturamento Multi-Empresas')
 
// Se foi selecionado algum grupo/empresa, criar tabela temporária.
if !Empty(_aParam)
 
 	//Criando Tabela Temporária
	Processa( {|| _lRet := _CriaTab() }, "Criando Tabela Temporária", "Processando aguarde...", .f.)
 	
	// Tabela Temporária criada com sucesso.
	if _lRet
	
		_cEmpresa := _aParam[01][01]
		_cFilDe   := _aParam[01][02]
		_cFilAte  := _aParam[01][02]
	
		//Adicionando itens das NF por Grupo/Empresa selecionados.
		for _nIt = 1 to len (_aParam)
		
			if _aParam[_nIt][01] == _cEmpresa 
			
				_cFilAte  := _aParam[_nIt][02]
			
			Endif
			
			// Se diferente ou for o último item
			if _cEmpresa # _aParam[_nIt][01] .or. _nIt == Len(_aParam)
			
				// Carrega os dados na temporária
				Processa( {|| _CarDados(_cPerg, _cEmpresa, _cFilDe, _cFilAte)},;
							"Efetuando carga de dados. Grp/Fil:", "Processando aguarde...", .f.)
			 
				_cEmpresa := _aParam[_nIt][01]
				_cFilDe   := _aParam[_nIt][02]
				_cFilAte  := _aParam[_nIt][02]
				
			Endif
		
		Next
		
		// Chamada do relatório
		If FindFunction("TRepInUse") .And. TRepInUse()
		
			//-- Interface de impressao
			oReport := ReportDef()
			oReport:PrintDialog()
			
		Endif
		
		//Exclui a Tabela Termporaria do Bando de Dados
		_oTempTable:Delete()
		
	Endif
	
Endif

Return

/*/{Protheus.doc} _CriaTab
//			Criação da tabela temporária para acumulo de NF 
@author 	iVan de Oliveira - EthosX
@since 		29/01/2019
@version 	1.0
@return 	Lógico, _lRet, Se conseguiu criar a tabela. 

@type 		Static function
/*/
Static Function _CriaTab()

Local _lRet 	 := .F.
Local _aFields   := {}
Local _cQuery    := ""
  
//Cria o objeto da Tabela Temporaria
_oTempTable := FWTemporaryTable():New( "TRBMFAT" )
  
//Montagem da estrutura dos campos da Tabela Temporaria
aAdd( _aFields, {"EMPRESA"	 , "C"						, Len(cEmpAnt)				,  0})
aAdd( _aFields, {"F2_FILIAL" , TamSX3("F2_FILIAL")[03]	, TamSX3("F2_FILIAL")[01]	,  TamSX3("F2_FILIAL")[02]})
aAdd( _aFields, {"F2_DOC"	 , TamSX3("F2_DOC")[03]		, TamSX3("F2_DOC")[01]		,  TamSX3("F2_DOC")[02]})
aAdd( _aFields, {"F2_SERIE"  , TamSX3("F2_SERIE")[03]	, TamSX3("F2_SERIE")[01]	,  TamSX3("F2_SERIE")[02]})
aAdd( _aFields, {"F2_EMISSAO", "C"						, 10						,  0					 })
aAdd( _aFields, {"F2_TIPO"	 , TamSX3("F2_TIPO")[03]	, TamSX3("F2_TIPO")[01]		,  TamSX3("F2_TIPO")[02]})
aAdd( _aFields, {"F2_ICMSRET", TamSX3("F2_ICMSRET")[03]	, TamSX3("F2_ICMSRET")[01]	,  TamSX3("F2_ICMSRET")[02]})
aAdd( _aFields, {"F2_CLIENTE", TamSX3("F2_CLIENTE")[03] , TamSX3("F2_CLIENTE")[01]	,  TamSX3("F2_CLIENTE")[02]})
aAdd( _aFields, {"F2_LOJA"	 , TamSX3("F2_LOJA")[03]	, TamSX3("F2_LOJA")[01]		,  TamSX3("F2_LOJA")[02]})
aAdd( _aFields, {"F2_FRETE"	 , TamSX3("F2_FRETE")[03]	, TamSX3("F2_FRETE")[01]	,  TamSX3("F2_FRETE")[02]})
aAdd( _aFields, {"F2_FRETAUT", TamSX3("F2_FRETAUT")[03]	, TamSX3("F2_FRETAUT")[01]	,  TamSX3("F2_FRETAUT")[02]})
aAdd( _aFields, {"F2_ICMAUTO", TamSX3("F2_ICMAUTO")[03]	, TamSX3("F2_ICMAUTO")[01]	,  TamSX3("F2_ICMAUTO")[02]})
aAdd( _aFields, {"F2_VALBRUT", TamSX3("F2_VALBRUT")[03]	, TamSX3("F2_VALBRUT")[01]	,  TamSX3("F2_VALBRUT")[02]})
aAdd( _aFields, {"F2_VALIPI" , TamSX3("F2_VALIPI")[03]	, TamSX3("F2_VALIPI")[01]	,  TamSX3("F2_VALIPI")[02]})
aAdd( _aFields, {"F2_VALICM" , TamSX3("F2_VALICM")[03]	, TamSX3("F2_VALICM")[01]	,  TamSX3("F2_VALICM")[02]})
aAdd( _aFields, {"F2_VALISS" , TamSX3("F2_VALISS")[03]	, TamSX3("F2_VALISS")[01]	,  TamSX3("F2_VALISS")[02]})
aAdd( _aFields, {"D2_DOC"	 , TamSX3("D2_DOC")[03]		, TamSX3("D2_DOC")[01]		,  TamSX3("D2_DOC")[02]})
aAdd( _aFields, {"D2_SERIE"	 , TamSX3("D2_SERIE")[03]	, TamSX3("D2_SERIE")[01]	,  TamSX3("D2_SERIE")[02]})
aAdd( _aFields, {"D2_COD"	 , TamSX3("D2_COD")[03]		, TamSX3("D2_COD")[01]		,  TamSX3("D2_COD")[02]})
aAdd( _aFields, {"D2_GRUPO"	 , TamSX3("D2_GRUPO")[03]	, TamSX3("D2_GRUPO")[01]	,  TamSX3("D2_GRUPO")[02]})
aAdd( _aFields, {"D2_TP"	 , TamSX3("D2_TP")[03]		, TamSX3("D2_TP")[01]		,  TamSX3("D2_TP")[02]})
aAdd( _aFields, {"D2_TIPO"	 , TamSX3("D2_TIPO")[03]	, TamSX3("D2_TIPO")[01]		,  TamSX3("D2_TIPO")[02]})
aAdd( _aFields, {"D2_CLIENTE", TamSX3("D2_CLIENTE")[03]	, TamSX3("D2_CLIENTE")[01]	,  TamSX3("D2_CLIENTE")[02]})
aAdd( _aFields, {"D2_LOJA"	 , TamSX3("D2_LOJA")[03]	, TamSX3("D2_LOJA")[01]		,  TamSX3("D2_LOJA")[02]})
aAdd( _aFields, {"D2_GRADE"	 , TamSX3("D2_GRADE")[03]	, TamSX3("D2_GRADE")[01]	,  TamSX3("D2_GRADE")[02]})
aAdd( _aFields, {"D2_CF"	 , TamSX3("D2_CF")[03]		, TamSX3("D2_CF")[01]		,  TamSX3("D2_CF")[02]})
aAdd( _aFields, {"D2_TES"	 , TamSX3("D2_TES")[03]		, TamSX3("D2_TES")[01]		,  TamSX3("D2_TES")[02]})
aAdd( _aFields, {"D2_LOCAL"	 , TamSX3("D2_LOCAL")[03]	, TamSX3("D2_LOCAL")[01]	,  TamSX3("D2_LOCAL")[02]})
aAdd( _aFields, {"D2_PRCVEN" , TamSX3("D2_PRCVEN")[03]	, TamSX3("D2_PRCVEN")[01]	,  TamSX3("D2_PRCVEN")[02]})
aAdd( _aFields, {"D2_ICMSRET", TamSX3("D2_ICMSRET")[03]	, TamSX3("D2_ICMSRET")[01]	,  TamSX3("D2_ICMSRET")[02]})
aAdd( _aFields, {"D2_QUANT"	 , TamSX3("D2_QUANT")[03]	, TamSX3("D2_QUANT")[01]	,  TamSX3("D2_QUANT")[02]})
aAdd( _aFields, {"D2_TOTAL"	 , TamSX3("D2_TOTAL")[03]	, TamSX3("D2_TOTAL")[01]	,  TamSX3("D2_TOTAL")[02]})
aAdd( _aFields, {"D2_EMISSAO", "C"						, 10						,  0					 })
aAdd( _aFields, {"D2_VALIPI" , TamSX3("D2_VALIPI")[03]	, TamSX3("D2_VALIPI")[01]	,  TamSX3("D2_VALIPI")[02]})
aAdd( _aFields, {"D2_CODISS" , TamSX3("D2_CODISS")[03]	, TamSX3("D2_CODISS")[01]	,  TamSX3("D2_CODISS")[02]})
aAdd( _aFields, {"D2_VALISS" , TamSX3("D2_VALISS")[03]	, TamSX3("D2_VALISS")[01]	,  TamSX3("D2_VALISS")[02]})
aAdd( _aFields, {"D2_VALICM" , TamSX3("D2_VALICM")[03]	, TamSX3("D2_VALICM")[01]	,  TamSX3("D2_VALICM")[02]})
aAdd( _aFields, {"D2_ITEM"	 , TamSX3("D2_ITEM")[03]	, TamSX3("D2_ITEM")[01]		,  TamSX3("D2_ITEM")[02]})
aAdd( _aFields, {"F2_SEGURO" , TamSX3("F2_SEGURO")[03]	, TamSX3("F2_SEGURO")[01]	,  TamSX3("F2_SEGURO")[02]})
aAdd( _aFields, {"F2_DESPESA", TamSX3("F2_DESPESA")[03]	, TamSX3("F2_DESPESA")[01]	,  TamSX3("F2_DESPESA")[02]}) 
aAdd( _aFields, {"D2_PEDIDO" , TamSX3("D2_PEDIDO")[03]	, TamSX3("D2_PEDIDO")[01]	,  TamSX3("D2_PEDIDO")[02]}) 
aAdd( _aFields, {"D2_ITEMPV" , TamSX3("D2_ITEMPV")[03]	, TamSX3("D2_ITEMPV")[01]	,  TamSX3("D2_ITEMPV")[02]})
aAdd( _aFields, {"B1_DESC"	 , TamSX3("B1_DESC")[03]	, TamSX3("B1_DESC")[01]		,  TamSX3("B1_DESC")[02]})
aAdd( _aFields, {"A1_NOME"	 , TamSX3("A1_NOME")[03]	, TamSX3("A1_NOME")[01]		,  TamSX3("A1_NOME")[02]})
aAdd( _aFields, {"A1_COD"	 , TamSX3("A1_COD")[03]		, TamSX3("A1_COD")[01]		,  TamSX3("A1_COD")[02]}) 
aAdd( _aFields, {"A1_LOJA"	 , TamSX3("A1_LOJA")[03]	, TamSX3("A1_LOJA")[01]		,  TamSX3("A1_LOJA")[02]}) 
aAdd( _aFields, {"F4_INCSOL" , TamSX3("F4_INCSOL")[03]	, TamSX3("F4_INCSOL")[01]	,  TamSX3("F4_INCSOL")[02]})
aAdd( _aFields, {"F4_AGREG"	 , TamSX3("F4_AGREG")[03]	, TamSX3("F4_AGREG")[01]	,  TamSX3("F4_AGREG")[02]}) 
aAdd( _aFields, {"F4_ICM"	 , TamSX3("F4_ICM")[03]		, TamSX3("F4_ICM")[01]		,  TamSX3("F4_ICM")[02]}) 
aAdd( _aFields, {"F4_ISS"	 , TamSX3("F4_ISS")[03]		, TamSX3("F4_ISS")[01]		,  TamSX3("F4_ISS")[02]})

if SerieNfId("SF2",3,"F2_SERIE")<>"F2_SERIE"
	aAdd( _aFields, {"F2_SDOC"	 , TamSX3("F2_SDOC")[03], TamSX3("F2_SDOC")[01],  TamSX3("F2_SDOC")[02]})
	aAdd( _aFields, {"D2_SDOC"	 , TamSX3("D2_SDOC")[03], TamSX3("D2_SDOC")[01],  TamSX3("D2_SDOC")[02]})
Endif

//Input dos campos na Tabela Temporaria
_oTempTable:SetFields( _aFields )
  
//Adiciona indice na Tabela Temporaria
_oTempTable:AddIndex( "01", {"EMPRESA","F2_FILIAL", "F2_EMISSAO","F2_DOC","F2_SERIE","D2_COD","D2_ITEM"} )
  
//Criacao da Tabela no Banco de Dados
_oTempTable:Create()
 
 // Retorno de criação tabela temporária.
_lRet := _oTempTable:GetRealName()#""

Return _lRet

/*/{Protheus.doc} _CarDados
//			Carrega dados por Grupo/Filial na tabela temporária para acumulo de NF 
@author 	iVan de Oliveira - EthosX
@since 		29/01/2019
@version 	1.0
@return 	Lógico, _lRet, Se conseguiu criar a tabela. 

@type 		Static function
/*/
Static Function _CarDados( _cPergunta, _cEmpSel, _cFilDe, _cFilAte )

Local _lRet    := .F.
Local _cFilSa1 := FWxFilial('SA1',  , _cEmpSel)
Local _cFilSb1 := FWxFilial('SB1',  , _cEmpSel)
Local _cFilSf4 := FWxFilial('SF4',  , _cEmpSel)
Local _nFP     := 0

// Carrega pergunta off-line
Pergunte(_cPergunta,.f.) 

dbUseArea(.T.,"CTREECDX", "\SYSTEM\SX2"+_cEmpSel+"0.DTC","SX2TMP",.T.)
_cIndSX2 := CriaTrab(NIL,.F.)
IndRegua("SX2TMP",_cIndSX2,"X2_CHAVE",,,"Selecionando Registros...")

Dbselectarea("SX2TMP")
Dbgotop()

If Dbseek("SA1")
	_cTabCli := Alltrim(SX2TMP->X2_ARQUIVO)	
EndIf   

If Dbseek("SB1")
	_cTabPro:= Alltrim(SX2TMP->X2_ARQUIVO)	
EndIf  

If Dbseek("SF4")
	_cTabTes:= Alltrim(SX2TMP->X2_ARQUIVO)	
EndIf  

SX2TMP->(DbClosearea())   
 
cWhere		:= ''  
If MV_PAR15 == 2
	cWhere	+= "AND F2_TIPO<>'D'"
EndIf
cWhere		+= " AND NOT (" + IsRemito(2,"F2_TIPODOC") + ")"
 
//cSelect	:= "%"
cSelect	:= IIf(SerieNfId("SF2",3,"F2_SERIE")<>"F2_SERIE", ", F2_SDOC,D2_SDOC ", "")
//cSelect	+= "%"

//cIDWhere	:= "%"
cIDWhere	:= SerieNfId("SF2",3,"F2_SERIE") + " >= '" + mv_par06 + "'"
cIDWhere	+= "AND " + SerieNfId("SF2",3,"F2_SERIE") + " <= '" + mv_par07 + "'"
 
//Criacao da Query que ira alimentar a Tabela Temporaria
_cQuery := " SELECT F2_FILIAL, F2_DOC,F2_SERIE,F2_EMISSAO,F2_TIPO,F2_ICMSRET,F2_CLIENTE,F2_LOJA, " 
_cQuery += "	    F2_FRETE,F2_FRETAUT,F2_ICMAUTO,F2_VALBRUT,F2_VALIPI,F2_VALICM,F2_VALISS, "
_cQuery += "	    D2_DOC,D2_SERIE,D2_COD,D2_GRUPO,D2_TP,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_GRADE, "
_cQuery += "        D2_CF,D2_TES,D2_LOCAL,D2_PRCVEN,D2_ICMSRET,D2_QUANT,D2_TOTAL,D2_EMISSAO, "
_cQuery += "	    D2_VALIPI,D2_CODISS,D2_VALISS,D2_VALICM,D2_ITEM,F2_SEGURO,F2_DESPESA, D2_PEDIDO, D2_ITEMPV, "
_cQuery += "	    B1_DESC, A1_NOME, A1_COD, A1_LOJA, F4_INCSOL, F4_AGREG, F4_ICM, F4_ISS " + cSelect 

_cQuery += "  FROM  	SF2" + _cEmpSel + "0 SF2   "

_cQuery += " INNER JOIN SD2" + _cEmpSel + "0 SD2   "
_cQuery += "			 ON D2_FILIAL      		= F2_FILIAL "  
_cQuery += "	  			AND D2_CLIENTE 		= F2_CLIENTE"
_cQuery += "	  			AND D2_LOJA    		= F2_LOJA"
_cQuery += "	  			AND D2_DOC     		= F2_DOC"
_cQuery += "	  			AND D2_SERIE   		= F2_SERIE"
_cQuery += "				AND SD2.D_E_L_E_T_ 	= ' '"

_cQuery += " INNER JOIN "  + _cTabCli    + " SA1 "
_cQuery += "		ON A1_FILIAL ='"  + _cFilSa1 + "' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SA1.D_E_L_E_T_ = ' ' "

_cQuery += " INNER JOIN " + _cTabPro    + " SB1 "
_cQuery += "		ON B1_FILIAL ='"  + _cFilSb1 +  "' AND B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "


_cQuery += " INNER JOIN " + _cTabTes    + " SF4 "
_cQuery += "		ON A1_FILIAL ='"  + _cFilSf4 + "'  AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "


_cQuery += " WHERE " 
_cQuery += "	  SF2.D_E_L_E_T_ = ' '
_cQuery += "	  AND F2_FILIAL BETWEEN '" + _cFilDe        + "' AND '" + _cFilAte + "'"
_cQuery += "	  AND F2_DOC     		>= '" + mv_par01       + "'"
_cQuery += "	  AND F2_DOC     		<= '" + mv_par02       + "'"
_cQuery += "	  AND F2_EMISSAO 		>= '" + DtoS(mv_par03) + "'" 
_cQuery += "	  AND F2_EMISSAO 		<= '" + DtoS(mv_par04) + "' AND " + cIdWhere

// Filtros.
if !empty(mv_par05)

	_cFilPro:= FormatIn(Alltrim(mv_par05),';')
	_cQuery += " AND D2_COD IN " + _cFilPro 
	
endif

if !empty(mv_par10)

	_cQuery +=" AND D2_GRUPO='" + mv_par10 + "'"

Endif

if !empty(mv_par11)

	_cQuery +=" AND D2_TP ='" + mv_par11 + "'"

Endif

_cQuery += cWhere 	  
_cQuery += " ORDER BY F2_FILIAL, SF2.F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE,SD2.D2_COD,SD2.D2_ITEM "

// eecview(_cQuery)
 
//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros  EECVIEW(_cQuery)
IF Select("TMPMFAT") > 0
	DbSelectArea("TMPMFAT")
	DbCloseArea()
ENDIF
 
//crio o novo alias
TCQUERY _cQuery NEW ALIAS "TMPMFAT"	
TcSetfield( "TMPMFAT",'F2_EMISSAO'  ,"D", 10 )
TcSetfield( "TMPMFAT",'D2_EMISSAO'  ,"D", 10 )
	
dbSelectArea("TMPMFAT")
Count To _nRecCount
// Cria a régua com a quantidade de registros contatos
ProcRegua(_nRecCount)  
TMPMFAT->(dbGoTop())  
 
//Le todos os registro da Query e armazena na Tabela Temporaria
While !(TMPMFAT->(EOF()))

	IncProc("Grupo: " + FWFilialName(_cEmpSel,TMPMFAT->F2_FILIAL, 2) ) 
 
	RecLock("TRBMFAT", .T.)
    
		TRBMFAT->EMPRESA   := _cEmpSel
		TRBMFAT->F2_FILIAL := TMPMFAT->F2_FILIAL   
		TRBMFAT->F2_DOC    := TMPMFAT->F2_DOC      
		TRBMFAT->F2_SERIE  := TMPMFAT->F2_SERIE    
		TRBMFAT->F2_EMISSAO:= DTOS(TMPMFAT->F2_EMISSAO)
		TRBMFAT->F2_TIPO   := TMPMFAT->F2_TIPO     
		TRBMFAT->F2_ICMSRET:= TMPMFAT->F2_ICMSRET  
		TRBMFAT->F2_CLIENTE:= TMPMFAT->F2_CLIENTE  
		TRBMFAT->F2_LOJA   := TMPMFAT->F2_LOJA     
		TRBMFAT->F2_FRETE  := TMPMFAT->F2_FRETE    
		TRBMFAT->F2_FRETAUT:= TMPMFAT->F2_FRETAUT  
		TRBMFAT->F2_ICMAUTO:= TMPMFAT->F2_ICMAUTO  
		TRBMFAT->F2_VALBRUT:= TMPMFAT->F2_VALBRUT  
		TRBMFAT->F2_VALIPI := TMPMFAT->F2_VALIPI   
		TRBMFAT->F2_VALICM := TMPMFAT->F2_VALICM   
		TRBMFAT->F2_VALISS := TMPMFAT->F2_VALISS   
		TRBMFAT->D2_DOC    := TMPMFAT->D2_DOC      
		TRBMFAT->D2_SERIE  := TMPMFAT->D2_SERIE    
		TRBMFAT->D2_COD    := TMPMFAT->D2_COD      
		TRBMFAT->D2_GRUPO  := TMPMFAT->D2_GRUPO    
		TRBMFAT->D2_TP     := TMPMFAT->D2_TP       
		TRBMFAT->D2_TIPO   := TMPMFAT->D2_TIPO     
		TRBMFAT->D2_CLIENTE:= TMPMFAT->D2_CLIENTE  
		TRBMFAT->D2_LOJA   := TMPMFAT->D2_LOJA     
		TRBMFAT->D2_GRADE  := TMPMFAT->D2_GRADE    
		TRBMFAT->D2_CF     := TMPMFAT->D2_CF       
		TRBMFAT->D2_TES    := TMPMFAT->D2_TES      
		TRBMFAT->D2_LOCAL  := TMPMFAT->D2_LOCAL    
		TRBMFAT->D2_PRCVEN := TMPMFAT->D2_PRCVEN   
		TRBMFAT->D2_ICMSRET:= TMPMFAT->D2_ICMSRET  
		TRBMFAT->D2_QUANT  := TMPMFAT->D2_QUANT    
		TRBMFAT->D2_TOTAL  := TMPMFAT->D2_TOTAL    
		TRBMFAT->D2_EMISSAO:= DTOS(TMPMFAT->D2_EMISSAO)  
		TRBMFAT->D2_VALIPI := TMPMFAT->D2_VALIPI   
		TRBMFAT->D2_CODISS := TMPMFAT->D2_CODISS   
		TRBMFAT->D2_VALISS := TMPMFAT->D2_VALISS   
		TRBMFAT->D2_VALICM := TMPMFAT->D2_VALICM   
		TRBMFAT->D2_ITEM   := TMPMFAT->D2_ITEM     
		TRBMFAT->F2_SEGURO := TMPMFAT->F2_SEGURO   
		TRBMFAT->F2_DESPESA:= TMPMFAT->F2_DESPESA  
		TRBMFAT->D2_PEDIDO := TMPMFAT->D2_PEDIDO   
		TRBMFAT->D2_ITEMPV := TMPMFAT->D2_ITEMPV   
		TRBMFAT->B1_DESC   := TMPMFAT->B1_DESC     
		TRBMFAT->A1_NOME   := TMPMFAT->A1_NOME     
		TRBMFAT->A1_COD    := TMPMFAT->A1_COD      
		TRBMFAT->A1_LOJA   := TMPMFAT->A1_LOJA     
		TRBMFAT->F4_INCSOL := TMPMFAT->F4_INCSOL   
		TRBMFAT->F4_AGREG  := TMPMFAT->F4_AGREG    
		TRBMFAT->F4_ICM    := TMPMFAT->F4_ICM      
		TRBMFAT->F4_ISS    := TMPMFAT->F4_ISS
 
		if SerieNfId("SF2",3,"F2_SERIE")<>"F2_SERIE"
		
			TRBMFAT->F2_SDOC := TMPMFAT->F2_SDOC
			TRBMFAT->D2_SDOC := TMPMFAT->D2_SDOC
		
		Endif
    
	TRBMFAT->(MsUnLock())
    TMPMFAT->(DBSkip())
    
Enddo

TMPMFAT->(DbCloseArea())
dbSelectArea("TRBMFAT")

Return _lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³05/06/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport,oSintetico,oItens,oItensD1,oItensD2,oCabec,oCabecF1,oCabecF2,oTotDia,oSecFil
//Local cAliasQry := GetNextAlias()
Local cNota 	:= ""
Local cSerie 	:= ""
Local cGrpfil   := ''
Local cSerieView 	:= ""
Local nAcN1  	:= nAcN2 :=  nAcN3 :=   nAcN4 :=   nAcN5 :=   nAcN6 :=   nVlrISS :=   nFretAut := 0
Local cCod		:= ""
Local cDesc		:= ""
Local cPedido	:= ""
Local cItem		:= ""
Local cRemito	:= ""
Local cItemrem	:= ""

Local nQuant	:= 0
Local nPrcVen	:= 0
Local nValadi	:= 0
Local cLocal	:= ""
Local cCF		:= ""
Local cTes		:= ""

Local cItemPV	:= ""
Local nValIPI	:= 0
Local nValIcm	:= 0
Local nValISS	:= 0
Local nDesAces	:= 0

// Variaveis Base Localizacao
Local cCliente 		:= ""
Local cLoja			:= ""
Local cNome			:= ""
Local dEmissao 		:= CTOD("  /  /  ")
Local cTipo    		:= ""
Local nAcD1			:= 0
Local nAcD2			:= 0
Local nAcDImpInc	:= 0
Local nAcDImpNoInc	:= 0
Local nAcD3			:= 0
Local nAcD4       	:= 0
Local nAcD5       	:= 0
Local nAcD6       	:= 0
Local nAcD7       	:= 0
Local nAcDAdi		:= 0
Local nTotal 		:= nTotfil := 0
Local nImpInc 		:= 0
Local nImpnoInc 	:= 0
Local nTotcImp  	:= 0

Local nAcG1			:= 0
Local nAcG2			:= 0
Local nAcGAdi		:= 0
Local nAcGImpInc	:= 0
Local nAcGImpNoInc	:= 0
Local nAcG3			:= 0
Local nTotNeto		:= 0
Local nTotNetGer	:= 0
Local nIPIDesp 		:= 0
Local nICMDesp 		:= 0

Local nAcImpInc  	:= 0
Local nAcImpNoInc	:= 0

Local nTotDia		:= 0


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
oReport := TReport():New("MATR550",STR0030,_cPerg, {|oReport| ReportPrint(oReport,oSintetico,oItens,oItensD1,oItensD2,oCabec,oCabecF1,oCabecF2,oTotDia,oSecFil)},STR0031)  // "Relacao de Notas Fiscais"###"Este programa ira emitir a relacao de notas fiscais."
oReport:SetLandscape(.T.) 

Pergunte(oReport:uParam,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc == "BRA"

	// Filial
	if  mv_par17 == 1
	
		oSecFil:= TRSection():New(oReport, "Grupo/Filial", {"SF2"}, , .F., .T.)
		TRCell():New(oSecFil,"GRPFIL"		,"TRBMFAT","Grupo/Filial" ,"@!",100)
	
	Endif
	
	//TRCell():New(oSecFil,"FILTOTAL"		,"TRBMFAT"," ",PesqPict("SD2","D2_TOTAL"),TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nTotFil },,,"RIGHT")
		 
	// Sintetico
	oSintetico := TRSection():New(oReport,STR0055,{"SF2","SD2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oSintetico:SetTotalInLine(.F.)
	TRCell():New(oSintetico,"CNOTA"		,/*Tabela*/,RetTitle("D2_DOC")		,PesqPict("SD2","D2_DOC")		,TamSX3("D2_DOC")[1]	,/*lPixel*/,{|| cNota })
	TRCell():New(oSintetico,"CSERIEVIEW",/*Tabela*/,SerieNfId("SD2",7,"D2_SERIE"),PesqPict("SD2","D2_SERIE"),SerieNfId("SD2",6,"D2_SERIE")	,/*lPixel*/,{|| cSerieView })
	TRCell():New(oSintetico,"NACN1"		,/*Tabela*/,RetTitle("D2_QUANT")	,PesqPict("SD2","D2_QUANT")		,TamSX3("D2_QUANT")[1]	,/*lPixel*/,{|| nAcN1 },,,"RIGHT")
	TRCell():New(oSintetico,"NACN2"		,/*Tabela*/,STR0039					,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")[1]	,/*lPixel*/,{|| nAcN2 },,,"RIGHT")
	TRCell():New(oSintetico,"NACN5"		,/*Tabela*/,RetTitle("D2_VALIPI")	,PesqPict("SD2","D2_VALIPI")	,TamSX3("D2_VALIPI")[1]	,/*lPixel*/,{|| nAcN5 },,,"RIGHT")
	TRCell():New(oSintetico,"NACN4"		,/*Tabela*/,RetTitle("D2_VALICM")	,PesqPict("SD2","D2_VALICM")	,TamSX3("D2_VALICM")[1]	,/*lPixel*/,{|| nAcN4 },,,"RIGHT")
	TRCell():New(oSintetico,"NVLRISS"	,/*Tabela*/,RetTitle("D2_VALISS")	,PesqPict("SD2","D2_VALISS")	,TamSX3("D2_VALISS")[1]	,/*lPixel*/,{|| nVlrISS },,,"RIGHT")
	TRCell():New(oSintetico,"NDESPACES",/*Tabela*/,STR0032					,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")[1]	,/*lPixel*/,{|| nAcN3+nFretAut },,,"RIGHT")
	TRCell():New(oSintetico,"NACN6"		,/*Tabela*/,STR0033					,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")[1]	,/*lPixel*/,{|| nAcN6 },,,"RIGHT")

	// Analitico
	oCabec := TRSection():New(oReport,STR0056,{"SF2","SD2","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oCabec:SetTotalInLine(.F.)
	
	if  mv_par17 == 2
 
		TRCell():New(oCabec,"EMPRESA"	,/*Tabela*/, "Empresa" ,/*Picture*/,100,/*lPixel*/,{|| CGRPFIL })
	
	Endif
	
	TRCell():New(oCabec,"F2_CLIENTE"	,/*Tabela*/,RetTitle("F2_CLIENTE")	,/*Picture*/,TamSX3("F2_CLIENTE")[1]+ 5,/*lPixel*/,{|| cCliente })
	TRCell():New(oCabec,"F2_LOJA"		,/*Tabela*/,RetTitle("F2_LOJA")		,/*Picture*/,/*Tamanho*/,/*lPixel*/,{||  cLoja})
	TRCell():New(oCabec,"A1_NOME"		,/*Tabela*/,RetTitle("A1_NOME")		,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cNome})
	TRCell():New(oCabec,"F2_EMISSAO"	,/*Tabela*/,RetTitle("F2_EMISSAO")	,/*Picture*/,TamSX3("F2_EMISSAO")[1]+ 5,/*lPixel*/,{||  dEmissao})
	TRCell():New(oCabec,"F2_TIPO"		,/*Tabela*/,RetTitle("F2_TIPO")		,/*Picture*/,/*Tamanho*/,/*lPixel*/,{||  cTipo })

	oItens := TRSection():New(oCabec,STR0057,{"SF2","SD2","SB1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oItens:SetTotalInLine(.F.)
	TRCell():New(oItens,"CCOD"			,/*Tabela*/,STR0035,/*Picture*/					,TamSX3("D2_COD"	)[1]	,/*lPixel*/,{|| cCod			})
	TRCell():New(oItens,"CDESC"			,/*Tabela*/,STR0036,/*Picture*/					,TamSX3("B1_DESC"	)[1]	,/*lPixel*/,{|| cDesc			})
	TRCell():New(oItens,"NQUANT"		,/*Tabela*/,STR0037,PesqPict("SD2","D2_QUANT")	,TamSX3("D2_QUANT"	)[1]	,/*lPixel*/,{|| nQuant			},,,"RIGHT")
	TRCell():New(oItens,"NPRCVEN"		,/*Tabela*/,STR0038,PesqPict("SD2","D2_PRCVEN")	,TamSX3("D2_PRCVEN"	)[1]	,/*lPixel*/,{|| nPrcVen			},,,"RIGHT")
	TRCell():New(oItens,"NTOTAL"		,/*Tabela*/,STR0039,PesqPict("SD2","D2_TOTAL")	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nTotal			},,,"RIGHT")
	TRCell():New(oItens,"CLOCAL"		,/*Tabela*/,STR0040,PesqPict("SD2","D2_LOCAL") ,TamSX3("D2_LOCAL"  )[1]	,/*lPixel*/,{|| cLocal			})
	TRCell():New(oItens,"CCF"			,/*Tabela*/,STR0041,PesqPict("SD2","D2_CF")    ,TamSX3("D2_CF" 	)[1]	,/*lPixel*/,{|| cCF				})
	TRCell():New(oItens,"CTES"	  		,/*Tabela*/,STR0042,PesqPict("SD2","D2_TES")   ,TamSX3("D2_TES"    )[1]	,/*lPixel*/,{|| cTes			})
	TRCell():New(oItens,"CPEDIDO"		,/*Tabela*/,STR0043,PesqPict("SD2","D2_PEDIDO"),TamSX3("D2_PEDIDO" )[1]	,/*lPixel*/,{|| cPedido			})
	TRCell():New(oItens,"CITEMPV"		,/*Tabela*/,STR0044,PesqPict("SD2","D2_ITEMPV"),TamSX3("D2_ITEMPV"	)[1]	,/*lPixel*/,{|| cItemPV			})
	TRCell():New(oItens,"NVALIPI"		,/*Tabela*/,STR0045,PesqPict("SD2","D2_VALIPI")	,TamSX3("D2_VALIPI"	)[1]	,/*lPixel*/,{|| nValIpi			},,,"RIGHT")
	TRCell():New(oItens,"NVALICM"		,/*Tabela*/,STR0046,PesqPict("SD2","D2_VALICM")	,TamSX3("D2_VALICM"	)[1]	,/*lPixel*/,{|| nValIcm			},,,"RIGHT")
	TRCell():New(oItens,"NVALISS"		,/*Tabela*/,STR0047,PesqPict("SD2","D2_VALISS")	,TamSX3("D2_VALISS"	)[1]	,/*lPixel*/,{|| nVlrISS			},,,"RIGHT")
	TRCell():New(oItens,"NDESACES"		,/*Tabela*/,STR0032,PesqPict("SD2","D2_TOTAL")	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nAcN3			},,,"RIGHT")
	TRCell():New(oItens,"NACN6"			,/*Tabela*/,STR0033,PesqPict("SD2","D2_TOTAL")	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nAcN6			},,,"RIGHT")


	// Totalizador por dia
	oTotDia := TRSection():New(oReport,STR0058,{"SF2","SD2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oTotDia:SetTotalInLine(.F.)
	TRCell():New(oTotDia,"CCOD"			,/*Tabela*/,STR0035,/*Picture*/						,TamSX3("D2_COD"	)[1]		,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"CDESC"		,/*Tabela*/,STR0036,/*Picture*/						,TamSX3("B1_DESC"	)[1]		,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"NACD1"		,/*Tabela*/,STR0037,PesqPict("SD2","D2_QUANT")		,TamSX3("D2_QUANT"	)[1]		,/*lPixel*/,{|| nAcD1 },,,"RIGHT"							)
	TRCell():New(oTotDia,"NPRCVEN"		,/*Tabela*/,STR0038,/*Picture*/						,TamSX3("D2_PRCVEN"	)[1]			  		,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT"	)
	TRCell():New(oTotDia,"NACD2"		,/*Tabela*/,STR0039,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL"	)[1]		,/*lPixel*/,{|| nAcD2 },,,"RIGHT"							)
	TRCell():New(oTotDia,"CLOCAL"		,/*Tabela*/,STR0040,/*Picture*/						,TamSX3("D2_LOCAL"  )[1]					,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"CCF"			,/*Tabela*/,STR0041,/*Picture*/						,TamSX3("D2_CF"  )[1]					,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"CTES"	  		,/*Tabela*/,STR0042,/*Picture*/						,TamSX3("D2_TES"  )[1]					,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"CPEDIDO"		,/*Tabela*/,STR0043,/*Picture*/						,TamSX3("D2_PEDIDO"  )[1]					,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"CITEMPV"		,/*Tabela*/,STR0044,/*Picture*/						,TamSX3("D2_ITEMPV"  )[1]					,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"NACD5"		,/*Tabela*/,STR0045,PesqPict("SD2","D2_VALIPI")		,TamSX3("D2_VALIPI"	)[1]		,/*lPixel*/,{|| nAcD5 },,,"RIGHT"				)
	TRCell():New(oTotDia,"NACD4"		,/*Tabela*/,STR0046,PesqPict("SD2","D2_VALICM")		,TamSX3("D2_VALICM"	)[1]		,/*lPixel*/,{|| nAcD4 },,,"RIGHT"				)
	TRCell():New(oTotDia,"NACD7"		,/*Tabela*/,STR0047,PesqPict("SD2","D2_VALISS")		,TamSX3("D2_VALISS"	)[1]		,/*lPixel*/,{|| nAcD7 },,,"RIGHT"				)	
	TRCell():New(oTotDia,"NACD3"		,/*Tabela*/,STR0032,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL"	)[1]		,/*lPixel*/,{|| nAcD3 },,,"RIGHT"				)	
	TRCell():New(oTotDia,"NACD6"		,/*Tabela*/,STR0033,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL"	)[1]		,/*lPixel*/,{|| nAcD6 },,,"RIGHT"				)


	// Totalizador das Despesas Acessorias (IPI, ICMS e Outros Gastos)
	oTotDesp := TRSection():New(oReport,STR0059,{"SF2","SD2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oTotDesp:SetTotalInLine(.F.)
	TRCell():New(oTotDesp,"CNOTA"		,/*Tabela*/,RetTitle("D2_DOC")		,PesqPict("SD2","D2_DOC"	),TamSX3("D2_DOC"		)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)	
	TRCell():New(oTotDesp,"CSERIEVIEW"	,/*Tabela*/,SerieNfId("SD2",7,"D2_SERIE")	,PesqPict("SD2","D2_SERIE"),SerieNfId("SD2",6,"D2_SERIE")	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDesp,"NACN1"		,/*Tabela*/,RetTitle("D2_QUANT")	,PesqPict("SD2","D2_QUANT"	),TamSX3("D2_QUANT"		)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT"	)
	TRCell():New(oTotDesp,"NACN2"		,/*Tabela*/,RetTitle("D2_TOTAL")	,PesqPict("SD2","D2_TOTAL"	),TamSX3("D2_TOTAL"		)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT"	)
	TRCell():New(oTotDesp,"NACN5"		,/*Tabela*/,RetTitle("D2_VALIPI")	,PesqPict("SD2","D2_VALIPI"	),TamSX3("D2_VALIPI"	)[1]	,/*lPixel*/,{|| nIPIDesp },,,"RIGHT"						)
	TRCell():New(oTotDesp,"NACN4"		,/*Tabela*/,RetTitle("D2_VALICM")	,PesqPict("SD2","D2_VALICM"	),TamSX3("D2_VALICM"	)[1]	,/*lPixel*/,{|| nICMDesp },,,"RIGHT"						)
	TRCell():New(oTotDesp,"NVLRISS"		,/*Tabela*/,RetTitle("D2_VALISS")	,PesqPict("SD2","D2_VALISS"	),TamSX3("D2_VALISS"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT"	)
	TRCell():New(oTotDesp,"NDESPACES"	,/*Tabela*/,STR0032					,PesqPict("SD2","D2_TOTAL"	),TamSX3("D2_TOTAL"		)[1]	,/*lPixel*/,{|| nAcN3+nFretAut },,,"RIGHT"				)
	TRCell():New(oTotDesp,"NACN6"		,/*Tabela*/,STR0033					,PesqPict("SD2","D2_TOTAL"	),TamSX3("D2_TOTAL"		)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT"	)
	
	if  mv_par17 == 2
	
		oReport:Section(3):SetEdit(.F.)
		oReport:Section(4):SetEdit(.F.)
		oReport:Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query    
		oReport:Section(2):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
		oReport:Section(2):Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
	else
		
		oReport:Section(4):SetEdit(.F.)
		oReport:Section(5):SetEdit(.F.)
		oReport:Section(2):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query    
		oReport:Section(3):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
		oReport:Section(3):Section(1):SetUseQuery(.F.) // Novo compomente tReport para adcionar campos de usuario no relatorio qdo utiliza query
		
	EndIf
	
Else

	oCabecF1 := TRSection():New(oReport,STR0061,{"SF1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oCabecF1:SetTotalInLine(.F.)
	TRCell():New(oCabecF1,"CCLIENTE"	,/*Tabela*/,RetTitle("F2_CLIENTE"	),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| Substr(cCliente,1,TamSx3("F2_CLIENTE")[01])})
	TRCell():New(oCabecF1,"CLOJA"		,/*Tabela*/,RetTitle("F2_LOJA"		),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cLoja 		})
	TRCell():New(oCabecF1,"CNOME"		,/*Tabela*/,RetTitle("A1_NOME"		),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cNome 		})
 	TRCell():New(oCabecF1,"CEMISSAO"	,/*Tabela*/,RetTitle("F2_EMISSAO"	),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| dEmissao 	})
	TRCell():New(oCabecF1,"CTIPO"		,/*Tabela*/,RetTitle("F2_TIPO"		),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cTipo 		})


	oCabecF2 := TRSection():New(oReport,STR0062,{"SF2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oCabecF2:SetTotalInLine(.F.)
	TRCell():New(oCabecF2,"CCLIENTE"	,/*Tabela*/,RetTitle("F2_CLIENTE"	),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| Substr(cCliente,1,TamSx3("F2_CLIENTE")[01])})
	TRCell():New(oCabecF2,"CLOJA"		,/*Tabela*/,RetTitle("F2_LOJA"		),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cLoja 		})
	TRCell():New(oCabecF2,"CNOME"		,/*Tabela*/,RetTitle("A1_NOME"		),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cNome 		})
 	TRCell():New(oCabecF2,"CEMISSAO"	,/*Tabela*/,RetTitle("F2_EMISSAO"	),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| dEmissao 	})
	TRCell():New(oCabecF2,"CTIPO"		,/*Tabela*/,RetTitle("F2_TIPO"		),/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cTipo 		})


    // Analitico SD1
	oItensD1 := TRSection():New(oReport,STR0063,{"SD1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oItensD1:SetTotalInLine(.F.)
	TRCell():New(oItensD1,"CCOD"		,/*Tabela*/,RetTitle("D2_COD" 		)	,/*Picture*/					,TamSX3("D2_COD"	)[1]	,/*lPixel*/,{|| cCod		})
	TRCell():New(oItensD1,"CDESC"		,/*Tabela*/,RetTitle("B1_DESC"		)	,/*Picture*/					,TamSX3("B1_DESC"	)[1]	,/*lPixel*/,{|| cDesc		})
	TRCell():New(oItensD1,"ALMOX"		,/*Tabela*/,RetTitle("D2_LOCAL"		)	,/*Picture*/					,TamSX3("D2_LOCAL"	)[1]	,/*lPixel*/,{|| cLocal		})
	TRCell():New(oItensD1,"PEDIDO"		,/*Tabela*/,RetTitle("D2_PEDIDO"	)	,/*Picture*/					,TamSX3("D2_PEDIDO"	)[1]	,/*lPixel*/,{|| cPedido		})
	TRCell():New(oItensD1,"ITEM"		,/*Tabela*/,RetTitle("D2_ITEM"		)	,/*Picture*/					,TamSX3("D2_ITEM"	)[1]	,/*lPixel*/,{|| cItemPV		})
	TRCell():New(oItensD1,"REMITO"		,/*Tabela*/,RetTitle("D2_REMITO"	)	,/*Picture*/					,TamSX3("D2_REMITO"	)[1]	,/*lPixel*/,{|| cRemito		})
	TRCell():New(oItensD1,"ITEMREM"		,/*Tabela*/,RetTitle("D2_ITEMREM"	)	,/*Picture*/					,TamSX3("D2_ITEMREM")[1]	,/*lPixel*/,{|| cItemrem	})
	TRCell():New(oItensD1,"NQUANT"		,/*Tabela*/,RetTitle("D2_QUANT"		)	,PesqPict("SD2","D2_QUANT"	)	,TamSX3("D2_QUANT"	)[1]	,/*lPixel*/,{|| nQuant		},,,"RIGHT")
	TRCell():New(oItensD1,"NPRCVEN"		,/*Tabela*/,RetTitle("D2_PRCVEN"	)	,PesqPict("SD2","D2_PRCVEN"	)	,TamSX3("D2_PRCVEN"	)[1]	,/*lPixel*/,{|| nPrcVen		},,,"RIGHT")
	TRCell():New(oItensD1,"NTOTAL"		,/*Tabela*/,STR0039						,PesqPict("SD2","D2_TOTAL"	)	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nTotal		},,,"RIGHT")
	TRCell():New(oItensD1,"NIMPINC"		,/*Tabela*/,STR0049						,PesqPict("SD2","D2_TOTAL"	)	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nImpInc 	},,,"RIGHT")
	TRCell():New(oItensD1,"NIMPNOINC"	,/*Tabela*/,STR0050						,PesqPict("SD2","D2_TOTAL"	)	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nImpnoInc 	},,,"RIGHT")
	TRCell():New(oItensD1,"NTOTCIMP"	,/*Tabela*/,RetTitle("D2_TOTAL"		)	,PesqPict("SD2","D2_TOTAL"	)	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nTotcImp 	},,,"RIGHT")


    // Analitico SD2
	oItensD2 := TRSection():New(oReport,STR0064,{"SD2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oItensD2:SetTotalInLine(.F.)
	TRCell():New(oItensD2,"CCOD"		,/*Tabela*/,RetTitle("D2_COD"		)	,/*Picture*/					,TamSX3("D2_COD"	)[1]	,/*lPixel*/,{|| cCod		})
	TRCell():New(oItensD2,"CDESC"		,/*Tabela*/,RetTitle("B1_DESC"		)	,/*Picture*/					,TamSX3("B1_DESC"	)[1]	,/*lPixel*/,{|| cDesc		})
	TRCell():New(oItensD2,"ALMOX"		,/*Tabela*/,RetTitle("D2_LOCAL"		)	,/*Picture*/					,TamSX3("D2_LOCAL"	)[1]	,/*lPixel*/,{|| cLocal		})
	TRCell():New(oItensD2,"PEDIDO"		,/*Tabela*/,RetTitle("D2_PEDIDO"	)	,/*Picture*/					,TamSX3("D2_PEDIDO"	)[1]	,/*lPixel*/,{|| cPedido		})
	TRCell():New(oItensD2,"ITEM"		,/*Tabela*/,RetTitle("D2_ITEM"		)	,/*Picture*/					,TamSX3("D2_ITEM"	)[1]	,/*lPixel*/,{|| cItemPV		})
	TRCell():New(oItensD2,"REMITO"		,/*Tabela*/,RetTitle("D2_REMITO"	)	,/*Picture*/					,TamSX3("D2_REMITO"	)[1]	,/*lPixel*/,{|| cRemito		})
	TRCell():New(oItensD2,"ITEMREM"		,/*Tabela*/,RetTitle("D2_ITEMREM"	)	,/*Picture*/					,TamSX3("D2_ITEMREM")[1]	,/*lPixel*/,{|| cItemrem	})
	TRCell():New(oItensD2,"NQUANT"		,/*Tabela*/,RetTitle("D2_QUANT"		)	,PesqPict("SD2","D2_QUANT"	)	,TamSX3("D2_QUANT"	)[1]	,/*lPixel*/,{|| nQuant		},,,"RIGHT")
	TRCell():New(oItensD2,"NPRCVEN"		,/*Tabela*/,RetTitle("D2_PRCVEN"	)	,PesqPict("SD2","D2_PRCVEN"	)	,TamSX3("D2_PRCVEN"	)[1]	,/*lPixel*/,{|| nPrcVen		},,,"RIGHT")
	If cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0
		TRCell():New(oItensD2,"NVALADI"	,/*Tabela*/,RetTitle("D2_VALADI"	)	,PesqPict("SD2","D2_VALADI"	)	,TamSX3("D2_VALADI"	)[1]	,/*lPixel*/,{|| nValadi		},,,"RIGHT")
	EndIf
	TRCell():New(oItensD2,"NTOTAL"		,/*Tabela*/,STR0039						,PesqPict("SD2","D2_TOTAL"	)	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nTotal		},,,"RIGHT")
	TRCell():New(oItensD2,"NIMPINC"		,/*Tabela*/,STR0049						,PesqPict("SD2","D2_TOTAL"	)	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nImpInc 	},,,"RIGHT")
	TRCell():New(oItensD2,"NIMPNOINC"	,/*Tabela*/,STR0050						,PesqPict("SD2","D2_TOTAL"	)	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nImpnoInc 	},,,"RIGHT")
	TRCell():New(oItensD2,"NTOTCIMP"	,/*Tabela*/,RetTitle("D2_TOTAL"		)	,PesqPict("SD2","D2_TOTAL"	)	,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nTotcImp 	},,,"RIGHT")

         
    // Total Geral
   	oTotGer := TRSection():New(oReport,STR0060,{"SF2","SD2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oTotGer:SetTotalInLine(.F.)
	oTotGer:SetEdit(.F.)

	TRCell():New(oTotGer,"CCOD"			,/*Tabela*/,RetTitle("D2_COD"		)	,/*Picture*/					,TamSX3("D2_COD"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"CDESC"		,/*Tabela*/,RetTitle("B1_DESC"		)	,/*Picture*/					,TamSX3("B1_DESC"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"ALMOX"		,/*Tabela*/,RetTitle("D2_LOCAL"		)	,/*Picture*/					,TamSX3("D2_LOCAL"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"PEDIDO"		,/*Tabela*/,RetTitle("D2_PEDIDO"	)	,/*Picture*/					,TamSX3("D2_PEDIDO"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"ITEM"			,/*Tabela*/,RetTitle("D2_ITEM"		)	,/*Picture*/					,TamSX3("D2_ITEM"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"REMITO"		,/*Tabela*/,RetTitle("D2_REMITO"	)	,/*Picture*/					,TamSX3("D2_REMITO"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"ITEMREM"		,/*Tabela*/,RetTitle("D2_ITEMREM"	)	,/*Picture*/					,TamSX3("D2_ITEMREM")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"NACG1"		,/*Tabela*/,RetTitle("D2_QUANT"	)	,PesqPict("SD2","D2_QUANT"	)		,TamSX3("D2_QUANT"	)[1]	,/*lPixel*/,{|| nACG1},,,"RIGHT"				)
	TRCell():New(oTotGer,"NPRCVEN"		,/*Tabela*/,RetTitle("D2_PRCVEN")	,PesqPict("SD2","D2_PRCVEN"	)		,TamSX3("D2_PRCVEN"	)[1]	,/*lPixel*/,/*{|| code-block de impressao}*/	)

	If cPaisLoc == "MEX"
		TRCell():New(oTotGer,"NACGADI"	,/*Tabela*/,RetTitle("D2_VALADI")	,PesqPict("SD2","D2_VALADI"	)		,TamSX3("D2_VALADI"	)[1]	,/*lPixel*/,{|| nAcGAdi}	)
	EndIf	

	TRCell():New(oTotGer,"NACG2"		,/*Tabela*/,STR0039					,PesqPict("SD2","D2_TOTAL"	)		,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nACG2},,,"RIGHT"				)
	TRCell():New(oTotGer,"NACGIMPINC"	,/*Tabela*/,STR0049					,PesqPict("SD2","D2_TOTAL"	)		,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"NACGIMPNOINC",/*Tabela*/,STR0050					,PesqPict("SD2","D2_TOTAL"	)		,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotGer,"NTOTNETGER"	,/*Tabela*/,STR0054					,PesqPict("SD2","D2_TOTAL"	)		,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nTotNetGer},,,"RIGHT"			)	


    // Total por dia
   	oTotDia := TRSection():New(oReport,STR0034,{"SF2","SD2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oTotDia:SetTotalInLine(.F.)
	oTotDia:SetEdit(.F.)

	TRCell():New(oTotDia,"CCOD"			,/*Tabela*/,RetTitle("D2_COD"		)	,/*Picture*/					,TamSX3("D2_COD"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"CDESC"		,/*Tabela*/,RetTitle("B1_DESC"		)	,/*Picture*/					,TamSX3("B1_DESC"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"ALMOX"		,/*Tabela*/,RetTitle("D2_LOCAL"		)	,/*Picture*/					,TamSX3("D2_LOCAL"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"PEDIDO"		,/*Tabela*/,RetTitle("D2_PEDIDO"	)	,/*Picture*/					,TamSX3("D2_PEDIDO"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"ITEM"			,/*Tabela*/,RetTitle("D2_ITEM"		)	,/*Picture*/					,TamSX3("D2_ITEM"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"REMITO"		,/*Tabela*/,RetTitle("D2_REMITO"	)	,/*Picture*/					,TamSX3("D2_REMITO"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"ITEMREM"		,/*Tabela*/,RetTitle("D2_ITEMREM"	)	,/*Picture*/					,TamSX3("D2_ITEMREM")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"NACD1"		,/*Tabela*/,RetTitle("D2_QUANT"	)	,PesqPict("SD2","D2_QUANT"	)		,TamSX3("D2_QUANT"	)[1]	,/*lPixel*/,{|| nACD1},,,"RIGHT"				)
	TRCell():New(oTotDia,"NPRCVEN"		,/*Tabela*/,RetTitle("D2_PRCVEN")	,PesqPict("SD2","D2_PRCVEN"	)		,TamSX3("D2_PRCVEN"	)[1]	,/*lPixel*/,/*{|| code-block de impressao}*/	)

	If cPaisLoc == "MEX"
		TRCell():New(oTotDia,"NACDADI"	,/*Tabela*/,RetTitle("D2_VALADI")	,PesqPict("SD2","D2_VALADI"	)		,TamSX3("D2_VALADI"	)[1]	,/*lPixel*/,{|| nAcDAdi})	
	EndIf

	TRCell():New(oTotDia,"NACD2"		,/*Tabela*/,STR0039					,PesqPict("SD2","D2_TOTAL"	)		,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nACD2},,,"RIGHT"				)
	TRCell():New(oTotDia,"NACGIMPINC"	,/*Tabela*/,STR0049					,PesqPict("SD2","D2_TOTAL"	)		,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"NACGIMPNOINC",/*Tabela*/,STR0050					,PesqPict("SD2","D2_TOTAL"	)		,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,/*{|| code-block de impressao }*/	)
	TRCell():New(oTotDia,"NTOTDIA"		,/*Tabela*/,STR0054					,PesqPict("SD2","D2_TOTAL"	)		,TamSX3("D2_TOTAL"	)[1]	,/*lPixel*/,{|| nTotDia},,,"RIGHT"				)	

EndIf

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Marco Bianchi          ³ Data ³05/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport, oSintetico,oItens,oItensD1,oItensD2,oCabec,oCabecF1,oCabecF2,oTotDia,oSecFil)


If ( cPaisLoc#"BRA" )

	TRFunction():New(oItensD1:Cell("NQUANT"),    /* cID */,"SUM",/*oBreak*/,STR0037,PesqPict("SD2","D2_QUANT"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
	TRFunction():New(oItensD1:Cell("NTOTAL"),    /* cID */,"SUM",/*oBreak*/,STR0039,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
	TRFunction():New(oItensD1:Cell("NIMPINC"),   /* cID */,"SUM",/*oBreak*/,STR0045,PesqPict("SD2","D2_VALIPI"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
	TRFunction():New(oItensD1:Cell("NIMPNOINC"), /* cID */,"SUM",/*oBreak*/,STR0046,PesqPict("SD2","D2_VALICM"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
	TRFunction():New(oItensD1:Cell("NTOTCIMP"),  /* cID */,"SUM",/*oBreak*/,STR0047,PesqPict("SD2","D2_VALISS"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  

	TRFunction():New(oItensD2:Cell("NQUANT"),    /* cID */,"SUM",/*oBreak*/,STR0037,PesqPict("SD2","D2_QUANT"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	If cPaisLoc == "MEX" 
		TRFunction():New(oItensD2:Cell("NVALADI"),/* cID */,"SUM",/*oBreak*/,RetTitle("D2_VALADI"),PesqPict("SD2","D2_VALADI"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
	EndIf
	TRFunction():New(oItensD2:Cell("NTOTAL"),    /* cID */,"SUM",/*oBreak*/,STR0039,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
	TRFunction():New(oItensD2:Cell("NIMPINC"),   /* cID */,"SUM",/*oBreak*/,STR0045,PesqPict("SD2","D2_VALIPI"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
	TRFunction():New(oItensD2:Cell("NIMPNOINC"), /* cID */,"SUM",/*oBreak*/,STR0046,PesqPict("SD2","D2_VALICM"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
	TRFunction():New(oItensD2:Cell("NTOTCIMP"),  /* cID */,"SUM",/*oBreak*/,STR0047,PesqPict("SD2","D2_VALISS"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  


	oReport:SetTotalInLine(.F.)

	TRImpLocTop(oReport,cAliasQry)

Else

	// Sintético
	If mv_par17 == 2
		TRFunction():New(oSintetico:Cell("NACN1"),     /* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)  
		TRFunction():New(oSintetico:Cell("NACN2"),     /* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,{||IIF(SF2->F2_TIPO $ "IP",0,nAcN2)},.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)  
		TRFunction():New(oSintetico:Cell("NACN5"),     /* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)  
		TRFunction():New(oSintetico:Cell("NACN4"),     /* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)  
		TRFunction():New(oSintetico:Cell("NVLRISS"),   /* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)  
		TRFunction():New(oSintetico:Cell("NDESPACES"), /* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)  
		TRFunction():New(oSintetico:Cell("NACN6"),     /* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,{||IIF(SF2->F2_TIPO $ "IP",0,nAcN6)},.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)   
	    
		oReport:SetTotalInLine(.F.)
		TRImpSint(oReport)
 
	Else
		TRFunction():New(oTotDia:Cell("NACD1"),   /* cID */,"SUM",/*oBreak*/,STR0037,PesqPict("SD2","D2_QUANT"	),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oTotDia:Cell("NACD2"),   /* cID */,"SUM",/*oBreak*/,STR0039,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oTotDia:Cell("NACD5"),   /* cID */,"SUM",/*oBreak*/,STR0045,PesqPict("SD2","D2_VALIPI"	),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oTotDia:Cell("NACD4"),   /* cID */,"SUM",/*oBreak*/,STR0046,PesqPict("SD2","D2_VALICM"	),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oTotDia:Cell("NACD7"),   /* cID */,"SUM",/*oBreak*/,STR0047,PesqPict("SD2","D2_VALISS"	),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oTotDia:Cell("NACD3"),   /* cID */,"SUM",/*oBreak*/,STR0032,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oTotDia:Cell("NACD6"),   /* cID */,"SUM",/*oBreak*/,STR0033,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,.F./*lEndPage*/)  
		
		TRFunction():New(oItens:Cell("NQUANT"),   /* cID */,"SUM",/*oBreak*/,STR0037,PesqPict("SD2","D2_QUANT"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oItens:Cell("NTOTAL"),   /* cID */,"SUM",/*oBreak*/,STR0039,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oItens:Cell("NVALIPI"),  /* cID */,"SUM",/*oBreak*/,STR0045,PesqPict("SD2","D2_VALIPI"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oItens:Cell("NVALICM"),  /* cID */,"SUM",/*oBreak*/,STR0046,PesqPict("SD2","D2_VALICM"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oItens:Cell("NVALISS"),  /* cID */,"SUM",/*oBreak*/,STR0047,PesqPict("SD2","D2_VALISS"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oItens:Cell("NDESACES"), /* cID */,"SUM",/*oBreak*/,STR0032,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
		TRFunction():New(oItens:Cell("NACN6"),    /* cID */,"SUM",/*oBreak*/,STR0033,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
		
		//TRFunction():New(oSecFil:Cell('FILTOTAL'),NIL,"SUM",/*oBreak*/,NIL,PesqPict("SD2","D2_TOTAL"),/*uFormula*/,.F.,.F.)  
	 	
		oReport:SetTotalInLine(.F.)
		TRImpAna(oReport, oItens,oCabec,oTotDia)   
	EndIf   
EndIf   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRImpAna ³ Autor ³ Marco Bianchi         ³ Data ³ 07/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Relatorio Analitico (Base Brasil).                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR550 - R4		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TRImpAna(oReport, oItens,oCabec,oTotDia)

Local nAcD1		:= 0
Local nAcD2		:= 0
Local nAcD3		:= 0
Local nAcD4		:= 0
Local nAcD5		:= 0
Local nAcD6		:= 0
Local nAcD7		:= 0
Local lContinua	:= .T.
Local dEmisAnt	:= CtoD(Space(08))
Local nReg     	:= 0
Local nTotQuant	:= 0
Local nTotal   	:= nTotFil := 0
Local nTotIcm  	:= 0
Local nTotIPI  	:= 0
Local nTotRet		:= 0
Local nTotRetIt	:= 0
Local cNumPed  	:= ""
Local cMascara 	:= GetMv("MV_MASCGRD")
Local nTamRef  	:= Val(Substr(cMascara,1,2))
Local dEmiDia 	:= dDataBase
Local nFrete  	:= 0
Local nIcmAuto	:= 0
Local nSeguro 	:= 0
Local nDespesa	:= 0
Local nValIPI 	:= 0
Local nValICM 	:= 0
Local nAcN3     := 0
Local nValISS 	:= 0
Local nVlrISS	:= 0
Local cTipoNF 	:= 0
Local lFretAut	:= GetNewPar("MV_FRETAUT",.T.)
Local cKey    	:= ""
Local cExpr		:= ""
Local cExprGrade	:= ""
Local lFirst		:= .F.
Local cSelect		:= ""
Local cIdWhere	:= ""
Local cFilSA1 	:= xFilial("SA1")
Local cFilSA2 	:= xFilial("SA2")
Local cFilSF2 	:= xFilial("SF2")
Local cFilSD2 	:= xFilial("SD2")
Local cFilSB1 	:= xFilial("SB1")
Local nTamD2_TOTAL  := TAMSX3("D2_TOTAL")[2]
Local nTamD2_PRCVEN := TAMSX3("D2_PRCVEN")[2]
LOCAL oSecFil	:= oReport:Section(1)
 
// Seção total por filial
//oSecFil:Cell("FILTOTAL"):SetBlock({|| nTotFil })

oReport:Section(3):Cell("F2_CLIENTE"):SetBlock({|| cCliente})
oReport:Section(3):Cell("F2_LOJA"):SetBlock({|| cLoja})
oReport:Section(3):Cell("A1_NOME"):SetBlock({|| cNome})
oReport:Section(3):Cell("F2_EMISSAO"):SetBlock({|| dEmissao})
oReport:Section(3):Cell("F2_TIPO"):SetBlock({|| cTipo})

oReport:Section(3):Section(1):Cell("CCOD"):SetBlock({|| cCod})
oReport:Section(3):Section(1):Cell("CDESC"):SetBlock({|| cDesc})
oReport:Section(3):Section(1):Cell("NQUANT"):SetBlock({|| nQuant})
oReport:Section(3):Section(1):Cell("NPRCVEN"):SetBlock({|| nPrcVen})
oReport:Section(3):Section(1):Cell("NTOTAL"):SetBlock({|| xMoeda(TRBMFAT->D2_TOTAL, 1, MV_PAR13, TRBMFAT->D2_EMISSAO, nTamD2_TOTAL)})
oReport:Section(3):Section(1):Cell("CLOCAL"):SetBlock({|| cLocal})
oReport:Section(3):Section(1):Cell("CCF"):SetBlock({|| cCF})
oReport:Section(3):Section(1):Cell("CTES"):SetBlock({|| cTes})
oReport:Section(3):Section(1):Cell("CPEDIDO"):SetBlock({|| cPedido})
oReport:Section(3):Section(1):Cell("CITEMPV"):SetBlock({|| cItemPV})
oReport:Section(3):Section(1):Cell("NVALIPI"):SetBlock({|| nValIPI})
oReport:Section(3):Section(1):Cell("NVALICM"):SetBlock({|| nValIcm})
oReport:Section(3):Section(1):Cell("NVALISS"):SetBlock({|| nVlrISS})
oReport:Section(3):Section(1):Cell("NDESACES"):SetBlock({|| nAcN3})
oReport:Section(3):Section(1):Cell("NACN6"):SetBlock({|| IIf(TRBMFAT->D2_TIPO $ "P", xMoeda(TRBMFAT->D2_VALIPI, 1, MV_PAR13, TRBMFAT->D2_EMISSAO), xMoeda(TRBMFAT->D2_TOTAL + TRBMFAT->D2_VALIPI + nTotRetIt, 1, MV_PAR13, TRBMFAT->D2_EMISSAO, nTamD2_TOTAL))})     
        
oReport:Section(4):Cell("CCOD")
oReport:Section(4):Cell("CDESC")
oReport:Section(4):Cell("NACD1"):SetBlock({|| nAcD1})
oReport:Section(4):Cell("NPRCVEN")
oReport:Section(4):Cell("NACD2"):SetBlock({|| nAcD2})
oReport:Section(4):Cell("CLOCAL")
oReport:Section(4):Cell("CCF")
oReport:Section(4):Cell("CTES")
oReport:Section(4):Cell("CPEDIDO")
oReport:Section(4):Cell("CITEMPV")
oReport:Section(4):Cell("NACD5"):SetBlock({|| nAcD5})
oReport:Section(4):Cell("NACD4"):SetBlock({|| nAcD4})
oReport:Section(4):Cell("NACD7"):SetBlock({|| nAcD7})
oReport:Section(4):Cell("NACD3"):SetBlock({|| nAcD3})
oReport:Section(4):Cell("NACD6"):SetBlock({|| nAcD6})

oBreak1 := TRBreak():New(oSecFil,oSecFil:Cell('GRPFIL')," ",.F.) 
//oFSomFil:= TRFunction():New(oSecFil:Cell('FILTOTAL'),NIL,"SUM",oBreak1,NIL,PesqPict("SD2","D2_TOTAL"),/*uFormula*/,.F.,.F.)

oFSomFil01 := TRFunction():New(oReport:Section(3):Section(1):Cell("NQUANT")  ,NIL, "SUM",oBreak1,NIL, PesqPict("SD2","D2_QUANT") ,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
oFSomFil02 := TRFunction():New(oReport:Section(3):Section(1):Cell("NTOTAL")  ,NIL, "SUM",oBreak1,NIL, PesqPict("SD2","D2_TOTAL") ,/*uFormula*/,.F.,.F.)  
oFSomFil03 := TRFunction():New(oReport:Section(3):Section(1):Cell("NVALIPI") ,NIL, "SUM",oBreak1,NIL, PesqPict("SD2","D2_VALIPI"),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
oFSomFil04 := TRFunction():New(oReport:Section(3):Section(1):Cell("NVALICM") ,NIL, "SUM",oBreak1,NIL, PesqPict("SD2","D2_VALICM"),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
oFSomFil05 := TRFunction():New(oReport:Section(3):Section(1):Cell("NVALISS") ,NIL, "SUM",oBreak1,NIL, PesqPict("SD2","D2_VALISS"),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
oFSomFil06 := TRFunction():New(oReport:Section(3):Section(1):Cell("NDESACES"),NIL, "SUM",oBreak1,NIL, PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)  
oFSomFil07 := TRFunction():New(oReport:Section(3):Section(1):Cell("NACN6")   ,NIL, "SUM",oBreak1,NIL, PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)

/*		
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1 - SINTETICO                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAliasSD2	:= cAliasQry

cWhere		:= '' // "%"
If MV_PAR15 == 2
	cWhere	+= "AND F2_TIPO<>'D'"
EndIf
cWhere		+= " AND NOT (" + IsRemito(2,"F2_TIPODOC") + ")"
//cWhere		+="%"

//cSelect	:= "%"
cSelect	:= IIf(SerieNfId("SF2",3,"F2_SERIE")<>"F2_SERIE", ", F2_SDOC,D2_SDOC ", "")
//cSelect	+= "%"

//cIDWhere	:= "%"
cIDWhere	:=  SerieNfId("SF2",3,"F2_SERIE") + " >= '" + mv_par06 + "'"
cIDWhere	+= "AND " + SerieNfId("SF2",3,"F2_SERIE") + " <= '" + mv_par07 + "'"
//cIDWhere	+= "%"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//MakeSqlExpr(oReport:uParam)
/*
oReport:Section(3):BeginQuery()
BeginSql Alias cAliasQry
	SELECT F2_FILIAL, F2_DOC,F2_SERIE,F2_EMISSAO,F2_TIPO,F2_ICMSRET,F2_CLIENTE,F2_LOJA,
	       F2_FRETE,F2_FRETAUT,F2_ICMAUTO,F2_VALBRUT,F2_VALIPI,F2_VALICM,F2_VALISS,
	       D2_DOC,D2_SERIE,D2_COD,D2_GRUPO,D2_TP,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_GRADE,
	       D2_CF,D2_TES,D2_LOCAL,D2_PRCVEN,D2_ICMSRET,D2_QUANT,D2_TOTAL,D2_EMISSAO,
	       D2_VALIPI,D2_CODISS,D2_VALISS,D2_VALICM,D2_ITEM,F2_FRETE,F2_SEGURO,F2_DESPESA, D2_GRADE,D2_PEDIDO, D2_ITEMPV,
	       B1_DESC, A1_NOME, A1_COD, A1_LOJA, F4_INCSOL, F4_AGREG, F4_ICM, F4_ISS %Exp:cSelect%
	  FROM %Table:SD2% SD2, %Table:SB1% SB1, %Table:SF4% SF4, %Table:SF2% SF2
	       LEFT JOIN %Table:SA1% SA1 ON A1_FILIAL	= %xFilial:SA1%
	                                AND A1_COD = F2_CLIENTE
	                                AND A1_LOJA = F2_LOJA
	                                AND SA1.%notdel%
	 WHERE F2_FILIAL <> '**'
	   AND F2_DOC >= %Exp:mv_par01%
	   AND F2_DOC <= %Exp:mv_par02%
	   AND F2_EMISSAO >= %Exp:DtoS(mv_par03)%
	   AND F2_EMISSAO <= %Exp:DtoS(mv_par04)%
	   AND %Exp:cIdWhere%
	   AND SF2.%notdel%
	   AND D2_FILIAL = F2_FILIAL
	   AND D2_CLIENTE = F2_CLIENTE
	   AND D2_LOJA = F2_LOJA
	   AND D2_DOC = F2_DOC
	   AND D2_SERIE = F2_SERIE
	   AND SD2.%notdel%
	   AND B1_FILIAL = %xFilial:SB1%
	   AND B1_COD = D2_COD
	   AND SB1.%notdel%
	   AND F4_FILIAL = %xFilial:SF4%
	   AND F4_CODIGO = D2_TES
	   AND SF4.%notdel%
	   %Exp:cWhere%
	 ORDER BY F2_FILIAL, SF2.F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE,SD2.D2_COD,SD2.D2_ITEM
EndSql
oReport:Section(3):EndQuery({mv_par16,mv_par05,mv_par10,mv_par11})


	cQuery := "	SELECT F2_FILIAL, F2_DOC,F2_SERIE,F2_EMISSAO,F2_TIPO,F2_ICMSRET,F2_CLIENTE,F2_LOJA, " 
	cQuery += "	       F2_FRETE,F2_FRETAUT,F2_ICMAUTO,F2_VALBRUT,F2_VALIPI,F2_VALICM,F2_VALISS, "
	cQuery += "	       D2_DOC,D2_SERIE,D2_COD,D2_GRUPO,D2_TP,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_GRADE, "
	cQuery += "      D2_CF,D2_TES,D2_LOCAL,D2_PRCVEN,D2_ICMSRET,D2_QUANT,D2_TOTAL,D2_EMISSAO, "
	cQuery += "	       D2_VALIPI,D2_CODISS,D2_VALISS,D2_VALICM,D2_ITEM,F2_FRETE,F2_SEGURO,F2_DESPESA, D2_GRADE,D2_PEDIDO, D2_ITEMPV, "
	cQuery += "	       B1_DESC, A1_NOME, A1_COD, A1_LOJA, F4_INCSOL, F4_AGREG, F4_ICM, F4_ISS "  

	cQuery += "	FROM  SD2120 SD2, SB1120 SB1,  SF4120 SF4,  SF2120 SF2 "
	cQuery += "	INNER JOIN SA1120 SA1 ON A1_FILIAL	= ' ' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "	WHERE " 
	cQuery += "	  F2_FILIAL <> '**'"  
	cQuery += "	   AND F2_DOC >= ' ' "
	cQuery += "	   AND F2_DOC <= 'zzzzzzzzz'"
	cQuery += "	   AND F2_EMISSAO >= '20181201'"
	cQuery += "	   AND F2_EMISSAO <= '20181215' AND " + cIdWhere
	cQuery += "	   AND D2_FILIAL = F2_FILIAL"
	cQuery += "	   AND D2_CLIENTE = F2_CLIENTE"
	cQuery += "	   AND D2_LOJA = F2_LOJA"
	cQuery += "	   AND D2_DOC = F2_DOC"
	cQuery += "	   AND D2_SERIE = F2_SERIE"
	cQuery += "	   AND SD2.D_E_L_E_T_ = ' '"
	cQuery += "	   AND B1_FILIAL = ' '"
	 cQuery += "	  AND B1_COD = D2_COD"
	cQuery += "	   AND SB1.D_E_L_E_T_ = ' '"
	cQuery += "	   AND F4_FILIAL = ' '"
	 cQuery += "	  AND F4_CODIGO = D2_TES"
	 cQuery += "	  AND SF4.D_E_L_E_T_ = ' '" + cWhere 
	 cQuery += "	  ORDER BY F2_FILIAL, SF2.F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE,SD2.D2_COD,SD2.D2_ITEM" 
		
	//Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
	IF Select("TRBMFAT") > 0
		DbSelectArea("TRBMFAT")
		DbCloseArea()
	ENDIF
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBMFAT"	
	
	TcSetfield( "TRBMFAT",'F2_EMISSAO'  ,"D", 10 )
*/
// Posiciona tabela temporária criada anteriormente.	
dbSelectArea("TRBMFAT")
TRBMFAT->(dbGoTop())

TRPosition():New(oReport:Section(3),"SA1",1,{|| cFilSA1 + TRBMFAT->F2_CLIENTE + TRBMFAT->F2_LOJA})
TRPosition():New(oReport:Section(3),"SD2",3,{|| TRBMFAT->F2_FILIAL  + TRBMFAT->F2_DOC + TRBMFAT->F2_SERIE + TRBMFAT->F2_CLIENTE + TRBMFAT->F2_LOJA + TRBMFAT->D2_COD + TRBMFAT->D2_ITEM})		
TRPosition():New(oReport:Section(3),"SF2",1,{|| TRBMFAT->F2_FILIAL  + TRBMFAT->F2_DOC + TRBMFAT->F2_SERIE + TRBMFAT->F2_CLIENTE + TRBMFAT->F2_LOJA})		
TRPosition():New(oReport:Section(3):Section(1),"SB1",1,{|| cFilSB1 + TRBMFAT->D2_COD})
TRPosition():New(oReport:Section(3):Section(1),"SD2",3,{|| TRBMFAT->F2_FILIAL  + TRBMFAT->F2_DOC + TRBMFAT->F2_SERIE + TRBMFAT->F2_CLIENTE + TRBMFAT->F2_LOJA + TRBMFAT->D2_COD + TRBMFAT->D2_ITEM})		
TRPosition():New(oReport:Section(3):Section(1),"SF2",1,{|| TRBMFAT->F2_FILIAL  + TRBMFAT->F2_DOC + TRBMFAT->F2_SERIE + TRBMFAT->F2_CLIENTE + TRBMFAT->F2_LOJA})		
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('TRBMFAT')
Count To _nRecCount
oReport:SetMeter(_nRecCount)

TRBMFAT->(DbGotop())
While !oReport:Cancel() .And. !TRBMFAT->(Eof())

	nTotFil:= 0
	CGRPFIL := FWGrpName(TRBMFAT->EMPRESA) + '- ' + TRBMFAT->F2_FILIAL 
	cFilSF2 := cFilSD2 := TRBMFAT->F2_FILIAL 
	cEmprNF := TRBMFAT->EMPRESA 

	While   !(TRBMFAT->(Eof())).and.;
		FWGrpName(TRBMFAT->EMPRESA) + '- ' + TRBMFAT->F2_FILIAL  == CGRPFIL
		
		nAcN1	:= 0
		nAcN2	:= 0
		nAcN3	:= 0
		nAcN4	:= 0
		nAcN5	:= 0
		nAcN6	:= 0
 
		 // Impressao da secao Filial
		oSecFil:Cell('GRPFIL'):SetValue(CGRPFIL) 
		oSecFil:Init()
		oSecFil:PrintLine()
	 
		IF TRBMFAT->F2_TIPO $ "BD"
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(cFilSA2+TRBMFAT->F2_CLIENTE+TRBMFAT->F2_LOJA)		
			oCabec:Cell("F2_CLIENTE"):SetTitle("Fornecedor")
			cNome := SA2->A2_NOME
		else
			oCabec:Cell("F2_CLIENTE"):SetTitle("Cliente")
			cNome := TRBMFAT->A1_NOME		
		EndIf
		
		dbSelectArea('TRBMFAT')
	
		nTotRet	:= 0
		nTotRetIt	:= 0
		nCt			:= 1
		dEmisAnt	:= Stod(TRBMFAT->F2_EMISSAO)
		cNota		:= TRBMFAT->F2_DOC
		cSerie		:= TRBMFAT->F2_SERIE
		cSerieView	:= Alltrim(TRBMFAT->&(SerieNfId("SF2",3,"F2_SERIE")))
		nFrete		:= TRBMFAT->F2_FRETE
		nICMSRet	:= TRBMFAT->F2_ICMSRET
		nFretAut	:= TRBMFAT->F2_FRETAUT
		nIcmAuto	:= TRBMFAT->F2_ICMAUTO
		nSeguro	:= TRBMFAT->F2_SEGURO
		nDespesa	:= TRBMFAT->F2_DESPESA
		nValIPIF2	:= TRBMFAT->F2_VALIPI
		nValICMF2	:= TRBMFAT->F2_VALICM
		nValISSF2	:= TRBMFAT->F2_VALISS
		cTipoNF	:= TRBMFAT->F2_TIPO
		dEmissao	:= Stod(TRBMFAT->F2_EMISSAO)
		cTipo		:= TRBMFAT->F2_TIPO
		cCliente	:= TRBMFAT->F2_CLIENTE
		cLoja		:= TRBMFAT->F2_LOJA
		 
		oSecFil:Hide()
		oReport:Section(3):Init()
		oReport:Section(3):Section(1):Init()
      
		lFirst := .T.
	
		While TRBMFAT->(! Eof()) .AND. TRBMFAT->EMPRESA  == cEmprNF .and. TRBMFAT->F2_FILIAL == cFilSF2 .AND.;
		 							   TRBMFAT->D2_DOC   == cNota   .and. TRBMFAT->D2_SERIE  == cSerie
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Valida o produto conforme a mascara       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRet := ValidMasc(TRBMFAT->D2_COD,MV_PAR08)
			If !lRet
				TRBMFAT->(dBSkip())
				Loop
			Endif
	
			cNumPed  := TRBMFAT->D2_PEDIDO
			nTotQuant:= 0
			nTotal   := 0
			nTotICM  := 0
			nTotIPI  := 0
	
			If TRBMFAT->F4_INCSOL == "S"
				nTotRet	+= TRBMFAT->D2_ICMSRET
				nTotRetIt	:= TRBMFAT->D2_ICMSRET
			Endif
	
			nReg := 0
			dbSelectArea('TRBMFAT')
			If TRBMFAT->D2_GRADE == "S" .And. MV_PAR09 == 1
				cProdRef := Substr(TRBMFAT->D2_COD,1,nTamRef)
				While TRBMFAT->(! Eof()) .And. cProdRef == Substr(TRBMFAT->D2_COD,1,nTamRef) .And. TRBMFAT->D2_GRADE == "S" .And. cNumPed == TRBMFAT->D2_PEDIDO
					nTotQuant	+= TRBMFAT->D2_QUANT
					nTotal		+= TRBMFAT->D2_TOTAL
					nTotIPI	+= TRBMFAT->D2_VALIPI
	
					If Empty(TRBMFAT->D2_CODISS) .And. TRBMFAT->D2_VALISS == 0 // ISS
						nTotIcm	+= TRBMFAT->D2_VALICM
					EndIf
					nReg	:= TRBMFAT->(Recno())
					TRBMFAT->(dbSkip())
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Valida o produto conforme a mascara       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lRet := ValidMasc(TRBMFAT->D2_COD,MV_PAR08)
					If ! lRet
						TRBMFAT->(dbSkip())
					Endif
					
				EndDo
				
				nAcN1 += nTotQuant
	    		
				If TRBMFAT->F4_AGREG <> "N"  
					nAcN2 += xMoeda(nTotal,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO))
				   If TRBMFAT->F4_AGREG == "D"
						nAcN2 -= xMoeda(nTotICM,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO))
					EndIf
				EndIf
	
				nAcN4 += xMoeda(nTotICM,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO))
				nAcN5 += xMoeda(nTotIPI,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO))
	
				cCod	:= TRBMFAT->D2_COD
				If mv_par12 == 1
		    	    cDesc := TRBMFAT->B1_DESC
				Else
					SA7->(dBSetOrder(2))
					If SA7->(dBSeek(xFilial("SA7")+TRBMFAT->D2_COD+TRBMFAT->F2_CLIENTE+TRBMFAT->F2_LOJA))
						cDesc := SA7->A7_DESCCLI
					Else
		    	        cDesc := TRBMFAT->B1_DESC
					Endif
				Endif
				
				dbSelectArea('TRBMFAT')
				nQuant		:= TRBMFAT->D2_QUANT
				nPrcVen	:= xMoeda(TRBMFAT->D2_PRCVEN,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO))
				cLocal		:= TRBMFAT->D2_LOCAL
				nAcN2		:= xMoeda(TRBMFAT->D2_TOTAL,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO))
				cCF			:= TRBMFAT->D2_CF
				cTes		:= TRBMFAT->D2_TES
				cPedido	:= TRBMFAT->D2_PEDIDO
				cItemPV	:= TRBMFAT->D2_ITEMPV
				nVlrISS	:= xMoeda(nValISS,1,MV_PAR13,dEmiDia)
				
				If lRet .And. lFirst
					oReport:Section(3):PrintLine()
					lFirst := .F.
				Endif
				
				oReport:Section(3):Section(2):PrintLine()
				
			Else
	    	 
				cCod	:= TRBMFAT->D2_COD
				If mv_par12 == 1
		    	    cDesc := TRBMFAT->B1_DESC
				Else
					SA7->(dBSetOrder(2))
					If SA7->(dBSeek(xFilial("SA7")+TRBMFAT->D2_COD+TRBMFAT->F2_CLIENTE+TRBMFAT->F2_LOJA))
						cDesc := SA7->A7_DESCCLI
					Else
		    	        cDesc := TRBMFAT->B1_DESC
					Endif
				Endif
		
				nQuant		:= TRBMFAT->D2_QUANT
				nPrcVen	:= xMoeda(TRBMFAT->D2_PRCVEN,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO), nTamD2_PRCVEN)
				cLocal		:= TRBMFAT->D2_LOCAL
				nTotal		:= xMoeda(TRBMFAT->D2_TOTAL,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO), nTamD2_TOTAL)
				// Totais por Filial
				nTotFil += nTotal
				cCF			:= TRBMFAT->D2_CF
				cTes		:= TRBMFAT->D2_TES
				cPedido	:= TRBMFAT->D2_PEDIDO
				cItemPV	:= TRBMFAT->D2_ITEMPV
				nValIpi	:= xMoeda(TRBMFAT->D2_VALIPI,1,MV_PAR13,Stod(TRBMFAT->D2_EMISSAO))
				nValIcm	:= IIf(TRBMFAT->F4_ICM == "S", xMoeda(TRBMFAT->D2_VALICM, 1, MV_PAR13, Stod(TRBMFAT->D2_EMISSAO)), 0)
				nVlrISS	:= IIf(TRBMFAT->F4_ISS == "S", xMoeda(TRBMFAT->D2_VALISS, 1, MV_PAR13, dEmiDia),                 0)						
				
				If lRet .And. lFirst
					oReport:Section(3):PrintLine()
					lFirst := .F.
				Endif
				
				oReport:Section(3):Section(1):PrintLine()
				
				nAcN1 += TRBMFAT->D2_QUANT
	
				If TRBMFAT->F4_AGREG <> "N"   
	   			   nAcN2 += xMoeda(TRBMFAT->D2_TOTAL, 1, MV_PAR13, TRBMFAT->D2_EMISSAO, nTamD2_TOTAL)
					If TRBMFAT->F4_AGREG = "D"
						nAcN2 -= xMoeda(TRBMFAT->D2_VALICM, 1, MV_PAR13, Stod(TRBMFAT->D2_EMISSAO))
					EndIf
				Endif
			
				If Empty(TRBMFAT->D2_CODISS) .And. TRBMFAT->D2_VALISS == 0 // ISS
					nAcN4 += xMoeda(TRBMFAT->D2_VALICM, 1, MV_PAR13, Stod(TRBMFAT->D2_EMISSAO))
				EndIf
	
				nAcN5 += xMoeda(TRBMFAT->D2_VALIPI, 1, MV_PAR13, Stod(TRBMFAT->D2_EMISSAO))
	
			Endif
			dEmiDia := Stod(TRBMFAT->D2_EMISSAO)
			
			dbSelectArea('TRBMFAT')
			If nReg == 0
				TRBMFAT->(dBSkip())
			Endif

		EndDo
		 
		nAcN3 := 0
		If (nAcN2 + nAcN4 + nAcN5) # 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se nota tem ICMS Solidario, imprime.			             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nICMSRet > 0
				oReport:PrintText(STR0052 + " ------------> " + Str(nICMSRet,14,2))		// ICMS SOLIDARIO
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se nota tem ICMS Ref.Frete Autonomo, imprime.                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nICMAuto > 0
				oReport:PrintText(STR0053 + " ------------> " + Str(nICMAuto,14,2))		// ICMS REF.FRETE AUTONOMO
			EndIf
	
			nAcN3 := xMoeda(nFrete+nSeguro+nDespesa,1,MV_PAR13,dEmiDia)
			If nAcN3 != 0 .Or. nFretAut != 0
				nIPIDesp	:= xMoeda(nValIPI,1,MV_PAR13,dEmiDia) - nAcN5
				nICMDesp	:= xMoeda(nValICM,1,MV_PAR13,dEmiDia) - nAcN4
				nAcN5		:= xMoeda(nValIPIF2,1,MV_PAR13,dEmiDia)
				nAcN4		:= xMoeda(nValICMF2,1,MV_PAR13,dEmiDia)
				
				If nIPIDesp > 0
					oReport:PrintText(STR0032 + " ------------> IPI           : " + Str(nIPIDesp,14,2) )	// DESPESAS ACESSORIAS
				EndIf
				If 	nICMDesp > 0
					oReport:PrintText(STR0032 + " ------------> ICM            : " + Str(nICMDesp,14,2)  )	// DESPESAS ACESSORIAS
				EndIf
				If 	(nAcN3+nFretAut) > 0
					oReport:PrintText(STR0032 + " ------------> OUTRAS DESPESAS: " + Str(nAcN3+nFretAut,14,2)  )	// DESPESAS ACESSORIAS
				EndIf
				
			EndIf
			
			nAcN6		:= nAcN2 + nAcN3 + nAcN5 + xMoeda(nTotRet, 1, MV_PAR13, dEmiDia) + If(lFretAut, nIcmAuto, 0)
			nVlrISS	:= xMoeda(nValISSF2,1,MV_PAR13,dEmiDia)
			
			// Total da Nota
			oReport:Section(3):Section(1):SetTotalText(STR0048 + cNota + "/" + cSerieVIEW)
			oReport:Section(3):Section(1):Finish()
			oReport:Section(3):Finish()
		 
			nAcN3 += nFretAut
		
			If (nICMSRet > 0) .Or. (nICMAuto > 0) .Or. (nAcN3 != 0 .Or. nFretAut != 0)
				oReport:SkipLine(1)
			EndIf
			
		EndIf
		
		nAcD1 += nAcN1
		nAcD2 += IIF(cTipoNF $ "IP",0,nAcN2)
		nAcD3 += nAcN3
		nAcD4 += nAcN4
		nAcD5 += nAcN5
		nAcD6 += IIF(cTipoNF $ "IP",0,nAcN6)
		nAcD7 += nVlrISS
	
		nAcn1		:= 0
		nAcn2		:= 0
		nAcn3		:= 0
		nAcn4		:= 0
		nAcn5		:= 0
		nAcn6		:= 0
		nVlrISS	:= 0
		
		dbSelectArea('TRBMFAT')
		If (nAcd1 + nAcD4 + nAcD5) > 0 .And. ( dEmisAnt != stod(TRBMFAT->F2_EMISSAO) .Or. TRBMFAT->(Eof()) )
	                        
			oReport:Section(4):SetHeaderSection(.F.)
			oReport:PrintText(STR0034 + dtoc(dEmisAnt))
			oReport:FatLine()
			oReport:Section(4):Init()
			oReport:Section(4):PrintLine()
			oReport:Section(4):Finish()
			oReport:SkipLine(4)
			
			nAcD1 	:= 0
			nAcD2 	:= 0
			nAcD3 	:= 0
			nAcD4 	:= 0
			nAcD5 	:= 0
			nAcD6 	:= 0
			nAcD7 	:= 0
			
		EndIf
		
	Enddo
	
	oReport:SkipLine() 
	
		//oReport:Section(1):SetTotalText("Total Grupo/Filial: " + CGRPFIL)
	oBreak1:SetTitle("Total Grupo/Filial: " + CGRPFIL)		 
	 
	oReport:FatLine()	
	oSecFil:Finish()
	oReport:SkipLine()
	oSecFil:Show()
	oReport:EndPage()
	oReport:IncMeter()
	
	
EndDo

oReport:Section(3):SetPageBreak(.T.)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRImpSint³ Autor ³ Marco Bianchi         ³ Data ³ 07/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Relatorio Sintetico (Base Brasil).                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR550 - R4 	                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TRImpSint(oReport)

Local nAcD1		:= 0
Local nAcD2		:= 0
Local nAcD3		:= 0
Local nAcD4		:= 0
Local nAcD5		:= 0
Local nAcD6		:= 0
Local nAcD7		:= 0
Local lContinua	:= .T.
Local dEmisAnt	:= CtoD(Space(08))
Local nReg		:= 0
Local nTotQuant	:= 0
Local nTotal	:= 0
Local nTotIcm	:= 0
Local nTotIPI	:= 0
Local nTotRet	:= 0
Local cNumPed	:= ""
Local cMascara	:= GetMv("MV_MASCGRD")
Local nTamRef	:= Val(Substr(cMascara,1,2))
Local dEmiDia	:= dDataBase
Local nFrete	:= 0
Local nIcmAuto	:= 0
Local nSeguro	:= 0
Local nDespesa	:= 0
Local nValIPI	:= 0
Local nValICM	:= 0
Local nValISS	:= 0
Local nVlrISS	:= 0
Local cTipoNF	:= 0
Local lFretAut	:= GetNewPar("MV_FRETAUT",.T.)
Local cKey		:= ""
Local cExpr		:= ""
Local cExprGrade:= ""
Local cSelect	:= ""
Local cIdWhere	:= ""
Local lCompIPI	:= .F.
 
//oReport:Section(1):Disable()

oReport:Section(1):Cell("CNOTA"):SetBlock({|| cNota})
oReport:Section(1):Cell("CSERIEVIEW"):SetBlock({|| cSerieVIEW})
oReport:Section(1):Cell("NACN1"):SetBlock({|| nAcN1})
oReport:Section(1):Cell("NACN2"):SetBlock({|| nAcN2})
oReport:Section(1):Cell("NACN5"):SetBlock({|| nAcN5})
oReport:Section(1):Cell("NACN4"):SetBlock({|| nAcN4})
oReport:Section(1):Cell("NVLRISS"):SetBlock({|| nVlrISS})
oReport:Section(1):Cell("NDESPACES"):SetBlock({|| nAcN3 + nFretAut})
oReport:Section(1):Cell("NACN6"):SetBlock({|| nAcN6})
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query do relatório da secao 1 - SINTETICO                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
cIdWhere	:= "%"
cIdWhere	+= SerieNfId("SF2",3,"F2_SERIE")+" >= '"+mv_par06+"' "
cIdWhere	+= "AND "+SerieNfId("SF2",3,"F2_SERIE")+" <='"+mv_par07+"'"
cIdwhere	+= "%"
If Alltrim(SerieNfId("SF2",3,"F2_SERIE"))<> "F2_SERIE"
	cSelect	:= "%F2_DOC,"+SerieNfId("SF2",3,"F2_SERIE")+",F2_SERIE,F2_EMISSAO,F2_TIPO,F2_ICMSRET,F2_FRETE,F2_FRETAUT,F2_ICMAUTO,F2_VALBRUT"
	cSelect	+= ",F2_VALIPI,F2_VALICM,F2_VALISS,D2_DOC,"+SerieNfId("SD2",3,"D2_SERIE")+",D2_SERIE,D2_COD,D2_GRUPO,D2_TP,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_GRADE"
	cSelect	+= ",D2_CF,D2_TES,D2_LOCAL,D2_PRCVEN,D2_ICMSRET,D2_QUANT,D2_TOTAL,D2_EMISSAO"
	cSelect	+= ",D2_VALIPI,D2_CODISS,D2_VALISS,D2_VALICM,F2_FRETE,F2_SEGURO,F2_DESPESA, D2_GRADE,D2_PEDIDO, D2_ITEMPV%"
Else
	cSelect	:= "%F2_DOC,F2_SERIE,F2_EMISSAO,F2_TIPO,F2_ICMSRET,F2_FRETE,F2_FRETAUT,F2_ICMAUTO,F2_VALBRUT"
	cSelect	+= ",F2_VALIPI,F2_VALICM,F2_VALISS,D2_DOC,D2_SERIE,D2_COD,D2_GRUPO,D2_TP,D2_TIPO,D2_CLIENTE,D2_LOJA,D2_GRADE"
	cSelect	+= ",D2_CF,D2_TES,D2_LOCAL,D2_PRCVEN,D2_ICMSRET,D2_QUANT,D2_TOTAL,D2_EMISSAO"
	cSelect	+= ",D2_VALIPI,D2_CODISS,D2_VALISS,D2_VALICM,F2_FRETE,F2_SEGURO,F2_DESPESA, D2_GRADE,D2_PEDIDO, D2_ITEMPV%"
Endif

cAliasQry	:= GetNextAlias()
cAliasSD2	:= cAliasQry
cWhere		:="%"
If MV_PAR15 == 2
	cWhere	+= "AND F2_TIPO<>'D'"
EndIf
cWhere		+= " AND NOT ("+IsRemito(2,"F2_TIPODOC")+")"
cWhere		+= "%"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)
                                      
oReport:Section(2):BeginQuery()	
BeginSql Alias cAliasQry
	SELECT %Exp:cSelect%
	  FROM %Table:SF2% SF2, %Table:SD2% SD2
	 WHERE F2_FILIAL = %xFilial:SF2%
	   AND F2_DOC >= %Exp:mv_par01%
	   AND F2_DOC <= %Exp:mv_par02%
	   AND F2_EMISSAO >= %Exp:DtoS(mv_par03)%
	   AND F2_EMISSAO <= %Exp:DtoS(mv_par04)%
	   AND %Exp:cIdWhere%
	   AND SF2.%notdel%
	   AND D2_FILIAL = %xFilial:SD2%
	   AND D2_CLIENTE = F2_CLIENTE
	   AND D2_LOJA = F2_LOJA
	   AND D2_DOC = F2_DOC
	   AND D2_SERIE = F2_SERIE
	   AND SD2.%notdel%
	   %Exp:cWhere%
	 ORDER BY SF2.F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE,SD2.D2_COD,SD2.D2_ITEM
EndSql
      
oReport:Section(1):EndQuery({MV_PAR16,MV_PAR10,MV_PAR05,MV_PAR11})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(TRBMFAT->(LastRec()))

dbSelectArea(cAliasQry)
*/
// Posiciona tabela temporária criada anteriormente.
oReport:Section(2):BeginQuery()	
oReport:Section(1):EndQuery({MV_PAR16,MV_PAR10,MV_PAR05,MV_PAR11})
dbSelectArea("TRBMFAT")
Count To _nRecCount 
oReport:SetMeter(_nRecCount)

TRBMFAT->(dbGoTop())

oReport:Section(1):Init()

lFecha	:= .T.
nAcN1	:= 0
nAcN2	:= 0
nAcN3	:= 0
nAcN4	:= 0
nAcN5	:= 0
nAcN6	:= 0

While !oReport:Cancel() .And. !TRBMFAT->(Eof())

	CGRPFIL 	:= FWGrpName(TRBMFAT->EMPRESA) + '- ' + TRBMFAT->F2_FILIAL 
	nTotRet		:= 0
	dEmisAnt	:= Stod(TRBMFAT->F2_EMISSAO)   
	cNota		:= TRBMFAT->F2_DOC
	cSerieView	:= Alltrim(TRBMFAT->&(SerieNfId("SF2",3,"F2_SERIE")))
	nFrete		:= TRBMFAT->F2_FRETE
	nFretAut	:= TRBMFAT->F2_FRETAUT
	nIcmAuto	:= TRBMFAT->F2_ICMAUTO
	nSeguro		:= TRBMFAT->F2_SEGURO
	nDespesa	:= TRBMFAT->F2_DESPESA
	nValIPI		:= TRBMFAT->F2_VALIPI
	nValICM		:= TRBMFAT->F2_VALICM
	nValISS		:= TRBMFAT->F2_VALISS
	cTipoNF		:= TRBMFAT->F2_TIPO
	cSerie		:= TRBMFAT->F2_SERIE
	
	While TRBMFAT->(! Eof()) .and. FWGrpName(TRBMFAT->EMPRESA) + '- ' + TRBMFAT->F2_FILIAL  == CGRPFIL .and.;
		  TRBMFAT->D2_DOC == cNota .and. TRBMFAT->D2_SERIE == cSerie

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida o produto conforme a mascara       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet := ValidMasc(TRBMFAT->D2_COD,MV_PAR08)
		If ! lRet
			TRBMFAT->(dBSkip())
			Loop
		Endif
 
		cNumPed	:= TRBMFAT->D2_PEDIDO
		nTotQuant	:= 0
		nTotal		:= 0
		nTotICM	:= 0
		nTotIPI	:= 0

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + TRBMFAT->D2_TES)
		If SF4->F4_INCSOL == "S"
			nTotRet	+= TRBMFAT->D2_ICMSRET
		Endif

		nReg := 0
		dbSelectArea('TRBMFAT')
		
		If TRBMFAT->D2_GRADE == "S" .And. MV_PAR09 == 1
			cProdRef	:= Substr(TRBMFAT->D2_COD,1,nTamRef)
			While TRBMFAT->(! Eof()) .And. cProdRef == Substr(TRBMFAT->D2_COD,1,nTamRef) .And. TRBMFAT->D2_GRADE == "S" .And. cNumPed == TRBMFAT->D2_PEDIDO
				nTotQuant	+= TRBMFAT->D2_QUANT
				nTotal		+= TRBMFAT->D2_TOTAL
				nTotIPI	+= TRBMFAT->D2_VALIPI

				If Empty(TRBMFAT->D2_CODISS) .And. TRBMFAT->D2_VALISS == 0 // ISS
					nTotIcm	+= TRBMFAT->D2_VALICM
				EndIf
				nReg	:= TRBMFAT->(Recno())
				TRBMFAT->(dBSkip())
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida o produto conforme a mascara       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRet := ValidMasc(TRBMFAT->D2_COD,MV_PAR08)
				If ! lRet
					TRBMFAT->(dBSkip())
				Endif
				
			EndDo
			
			nAcN1	+= nTotQuant

			If SF4->F4_AGREG <> "N"
				nAcN2 += xMoeda(nTotal, 1, MV_PAR13, TRBMFAT->D2_EMISSAO)
				If SF4->F4_AGREG == "D"
					nAcN2 -= xMoeda(nTotICM, 1, MV_PAR13, TRBMFAT->D2_EMISSAO)
				EndIf
			EndIf

			nAcN4 += xMoeda(nTotICM, 1, MV_PAR13, TRBMFAT->D2_EMISSAO)
			nAcN5 += xMoeda(nTotIPI, 1, MV_PAR13, TRBMFAT->D2_EMISSAO)

		Else

			nAcN1 += TRBMFAT->D2_QUANT
			If SF4->F4_AGREG <> "N"
				nAcN2 += xMoeda(TRBMFAT->D2_TOTAL, 1, MV_PAR13, TRBMFAT->D2_EMISSAO)
				If SF4->F4_AGREG = "D"
					nAcN2 -= xMoeda(TRBMFAT->D2_VALICM, 1, MV_PAR13, TRBMFAT->D2_EMISSAO)
				EndIf
			Endif

			If Empty(TRBMFAT->D2_CODISS) .And. TRBMFAT->D2_VALISS == 0 // ISS
				nAcN4 += xMoeda(TRBMFAT->D2_VALICM, 1, MV_PAR13, TRBMFAT->D2_EMISSAO)
			EndIf

			nAcN5 += xMoeda(TRBMFAT->D2_VALIPI, 1, MV_PAR13, TRBMFAT->D2_EMISSAO)
			
			lCompIPI := If(TRBMFAT->D2_TIPO == "P",.T.,.F.)

		Endif
		dEmiDia := TRBMFAT->D2_EMISSAO

		dbSelectArea('TRBMFAT')
		If nReg == 0
			TRBMFAT->(dBSkip())
		Endif

	EndDo
    
	nAcN3 := 0
	If (nAcN2 + nAcN4 + nAcN5) # 0
		nAcN3 := xMoeda(nFrete + nSeguro + nDespesa, 1, MV_PAR13, dEmiDia)
		If nAcN3 != 0 .Or. nFretAut != 0
			nAcN5 := xMoeda(nValIPI, 1, MV_PAR13, dEmiDia)
			nAcN4 := xMoeda(nValICM, 1, MV_PAR13, dEmiDia)
		EndIf
		If !lCompIPI
			nAcN6 := nAcN2 + nAcN3 + nAcN5 + xMoeda(nTotRet, 1, MV_PAR13, dEmiDia) + If(lFretAut, nIcmAuto, 0)
		Else
			nAcN6 := nAcN5
		EndIf
		
		nVlrISS	:= xMoeda(nValISS, 1, MV_PAR13, dEmiDia)
		
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSeek(xFilial("SF2")+cNota+cSerie)
		
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

		oReport:Section(1):PrintLine()
		
	EndIf

	nAcD1 += nAcN1
	nAcD2 += nAcN2
	nAcD3 += nAcN3 + nFretAut
	nAcD4 += nAcN4
	nAcD5 += nAcN5
	nAcD6 += nAcN6
	nAcD7 += nVlrISS

	nAcn1		:= 0
	nAcn2		:= 0
	nAcn3		:= 0
	nAcn4		:= 0
	nAcn5		:= 0
	nAcn6		:= 0
	nVlrISS	:= 0

	dbSelectArea('TRBMFAT')
	If (nAcd1 + nAcD4 + nAcD5) > 0 .And. ( dEmisAnt != stod(TRBMFAT->F2_EMISSAO)  .Or. Eof() )
		oReport:Section(1):SetTotalText(STR0034 +  DtoC(dEmisAnt))
		oReport:Section(1):Finish()
		oReport:SkipLine(2)
		oReport:Section(1):Init()
		nAcD1 	:= 0
		nAcD2 	:= 0
		nAcD3 	:= 0
		nAcD4 	:= 0
		nAcD5 	:= 0
		nAcD6 	:= 0
		nAcD7 	:= 0
		lFecha := .F.
	EndIf

	oReport:IncMeter()
EndDo

If lFecha
	oReport:Section(1):Finish()
EndIf

oReport:Section(1):SetPageBreak(.T.)

 

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TRImpLocTop³ Autor ³ Marco Bianchi        ³ Data ³ 07/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatorio (Base Localizada - Top)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR550 - R4                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TRImpLocTop(oReport,cAliasQry)

Local nCt				:= 0
Local lContinua		:= .T.
Local dEmisAnt		:= CtoD(Space(08))
Local cExpTot			:= ""
Local cSelect			:= ""
Local cSelectUni		:= ""
Local cExp2			:= ""
Local cIdWhere		:= ""
Local cIdWhereU		:= ""
Local nY				:= 0

Private aImpostos		:= {}
Private cAliasSF2 	:= ""
Private cAliasSF1 	:= ""
Private cAliasSD1 	:= ""
Private cAliasSD2 	:= ""
Private nFrete   		:= 0
Private nFretAut 		:= 0
Private nSeguro  		:= 0
Private nDespesa 		:= 0
Private nMoeda   		:= 0
Private nTxMoeda 		:= 0
Private nDecs			:= MsDecimais(mv_par13)
Private nTamA1COD		:= TamSx3("A1_COD")[01]

oReport:Section(2):Cell("CCLIENTE"	):SetBlock({|| Substr(cCliente,1,nTamA1COD)})
oReport:Section(2):Cell("CLOJA"		):SetBlock({|| cLoja})
oReport:Section(2):Cell("CNOME"		):SetBlock({|| cNome})
oReport:Section(2):Cell("CEMISSAO"	):SetBlock({|| dEmissao})
oReport:Section(2):Cell("CTIPO"		):SetBlock({|| cTipo})

oReport:Section(3):Cell("CCLIENTE"	):SetBlock({|| Substr(cCliente,1,nTamA1COD)})
oReport:Section(3):Cell("CLOJA"		):SetBlock({|| cLoja})
oReport:Section(3):Cell("CNOME"		):SetBlock({|| cNome})
oReport:Section(3):Cell("CEMISSAO"	):SetBlock({|| dEmissao})
oReport:Section(3):Cell("CTIPO"		):SetBlock({|| cTipo})

oReport:Section(6):Cell("NACG1"		):SetBlock({|| nAcG1})
oReport:Section(6):Cell("NACG2"		):SetBlock({|| nAcG2})

If cPaisLoc == "MEX"
	oReport:Section(6):Cell("NACGADI"):SetBlock({|| nAcGADI})
EndIf

oReport:Section(6):Cell("NACGIMPINC"	):SetBlock({|| nAcGImpInc})
oReport:Section(6):Cell("NACGIMPNOINC"	):SetBlock({|| nAcGImpNoInc})
oReport:Section(6):Cell("NTOTNETGER"	):SetBlock({|| nTotNetGer})

oReport:Section(7):Cell("NACD1"		):SetBlock({|| nAcD1})
oReport:Section(7):Cell("NACD2"		):SetBlock({|| nAcD2})

If cPaisLoc == "MEX"
	oReport:Section(7):Cell("NACDADI"	):SetBlock({|| nAcDAdi})
EndIf

oReport:Section(7):Cell("NTOTDIA"	):SetBlock({|| nTotDia})

If mv_par17 == 2
	oReport:Section(4):SetHeaderSection(.F.)	// Desabilita Impressao Cabecalho no Topo da Pagina
	oReport:Section(5):SetHeaderSection(.T.)	// Desabilita Impressao Cabecalho no Topo da Pagina
	oReport:Section(4):Disable()
	oReport:Section(5):Hide()
	
	oReport:Section(5):Acell[1]:SetTitle(Space(Len(oReport:Section(5):Acell[1]:GETTEXT())))
	oReport:Section(5):Acell[2]:SetTitle(Space(Len(oReport:Section(5):Acell[2]:GETTEXT()))) 
	oReport:Section(5):Acell[3]:Disable()
	oReport:Section(5):Acell[4]:Disable()
	oReport:Section(5):Acell[5]:Disable()
	oReport:Section(5):Acell[6]:Disable()
	oReport:Section(5):Acell[7]:Disable()
	oReport:Section(5):Acell[9]:Disable() //PRCVEN
	
	oReport:Section(6):Acell[3]:Disable()
	oReport:Section(6):Acell[4]:Disable()
	oReport:Section(6):Acell[5]:Disable()
	oReport:Section(6):Acell[6]:Disable()
	oReport:Section(6):Acell[7]:Disable()
	oReport:Section(6):Acell[9]:Disable() //PRCVEN
	
	oReport:Section(7):Acell[3]:Disable()
	oReport:Section(7):Acell[4]:Disable()
	oReport:Section(7):Acell[5]:Disable()
	oReport:Section(7):Acell[6]:Disable()
	oReport:Section(7):Acell[7]:Disable()
	oReport:Section(7):Acell[9]:Disable() //PRCVEN
			
EndIf
 
cNota		:= ""
cSerie    := ""
cSerieView:= ""
nAcN1		:= 0
nAcN2		:= 0
nAcImpInc	:= 0
nAcImpnoInc	:= 0
nAcDImpInc  := 0
nAcDImpNoInc:= 0
nAcD1		:= 0
nAcD2		:= 0
nAcD3		:= 0
nAcDAdi		:= 0
nAcG1		:= 0
nAcG2		:= 0
nAcGADI		:= 0
nAcGImpInc	:= 0
nAcGImpNoInc:= 0
nAcG3		:= 0
nTotNeto	:= 0
nTotNetGer	:= 0
nTotDia		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice de Trabalho                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cWhereF2 := "%"
if mv_par14 == 2   //nao imprimir notas com moeda diferente da escolhida
	cWhereF2 += " AND F2_MOEDA=" + Alltrim(str(mv_par13))
endif
cWhereF2 += " AND NOT ("+IsRemito(2,"F2_TIPODOC")+")"

cWhereF1 := "%"
if mv_par14 == 2   //nao imprimir notas com moeda diferente da escolhida
	cWhereF1 += " AND F1_MOEDA=" + Alltrim(str(mv_par13))
endif
cWhereF1 += " AND NOT ("+IsRemito(2,"F1_TIPODOC")+")"

cSCpo:="1"
cCpo:="D2_VALIMP"+cSCpo
cCamposD2 := "%"
While SD2->(FieldPos(cCpo))>0
	cCamposD2 += ","+cCpo + " " + Substr(cCpo,4)
	cSCpo := Soma1(cSCpo)
	cCpo := "D2_VALIMP"+cSCpo
Enddo
cCamposD2 += "%"

cSCpo:="1"
cCpo:="D1_VALIMP"+cSCpo
cCamposD1 := "%"
While SD1->(FieldPos(cCpo))>0
	cCamposD1 += ","+cCpo + " " + Substr(cCpo,4)
	cSCpo := Soma1(cSCpo)
	cCpo := "D1_VALIMP"+cSCpo
Enddo
cCamposD1 += "%"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

If !( Empty(mv_par05) )
	cWhereF2 += " AND " + MV_PAR05
	cWhereF1 += " AND " + StrTran(MV_PAR05, "D2_", "D1_")
EndIf	
If !( Empty(mv_par10) )
	cWhereF2 += " AND " + MV_PAR10
	cWhereF1 += " AND " + StrTran(MV_PAR10, "D2_", "D1_")
EndIf	
If !( Empty(mv_par11) )
	cWhereF2 += " AND " + MV_PAR11
	cWhereF1 += " AND " + StrTran(MV_PAR11, "D2_", "D1_")
EndIf	
If !( Empty(mv_par16) )
	cWhereF2 += " AND " + MV_PAR16
	cWhereF1 += " AND " + StrTran(MV_PAR16, "F2_CLIENTE", "F1_FORNECE")
EndIf	
cWhereF2 +="%"
cWhereF1 +="%"

If cPaisLoc == "MEX"
	cExpTot := "% D2_TOTAL-D2_VALADI TOTAL, D2_VALADI VALADI%"
Else 
	cExpTot := "% D2_TOTAL TOTAL,0 VALADI %"
EndIf

cIDWhere:= "%"
cIDWhere+= SerieNfId("SF2",3,"F2_SERIE")+" >= '"+mv_par06+"'" 
cIDWhere+= "AND "+SerieNfId("SF2",3,"F2_SERIE")+" <= '"+mv_par07+"'"
cIDWhere+= "%"

cIDWhereU:= "%"
cIDWhereU+= SerieNfId("SF1",3,"F1_SERIE")+" >= '"+mv_par06+"'" 
cIDWhereU+= "AND "+SerieNfId("SF1",3,"F1_SERIE")+" <= '"+mv_par07+"'"
cIDWhereU+= "%"

cSelect:= "%"
cSelect+= Iif(SerieNfId("SF2",3,"F2_SERIE")<>"F2_SERIE",",F2_SDOC","")
cSelect+= "%"
	
cSelectUni:= "%"
cSelectUni+= Iif(SerieNfId("SF1",3,"F1_SERIE")<>"F1_SERIE",",F1_SDOC","")
cSelectUni+= "%"

cExp2:= "%D2_DESCON VALDESC,D2_ITEM ITEM%"


oReport:Section(2):BeginQuery()	

BeginSql Alias cAliasQry
SELECT F2_CLIENTE CLIFOR,F2_LOJA LOJA,F2_DOC DOC,F2_SERIE SERIE,F2_EMISSAO EMISSAO %Exp:cSelect%
		,F2_MOEDA MOEDA,F2_TXMOEDA TXMOEDA,F2_TIPO TIPO,F2_ESPECIE ESPECIE
		,F2_FRETE FRETE,F2_FRETAUT FRETAUT,F2_SEGURO SEGURO,F2_DESPESA DESPESA
		,SA1.A1_NOME NOME,D2_DOC DOCITEM,D2_SERIE SERIEITEM,D2_CLIENTE CLIFORITEM,D2_LOJA LOJAITEM,D2_TIPO TIPOITEM
		,D2_GRADE GRADE,D2_COD COD ,D2_QUANT QUANT
		,D2_CF CF,D2_TES TES,D2_LOCAL ALMOX,D2_ITEMPV ITEMPV,D2_PEDIDO PEDIDO,D2_REMITO REMITO,D2_ITEMREM ITEMREM
		,D2_PRCVEN PRCVEN,%Exp:cExpTot% ,D2_DESCON VALDESC,D2_ITEM ITEM, "2" TIPODOC %Exp:cCamposD2%
FROM %Table:SF2% SF2, %Table:SD2% SD2, %Table:SA1% SA1
WHERE	F2_FILIAL = %xFilial:SF2%
		AND F2_DOC >= %Exp:mv_par01% AND F2_DOC <= %Exp:mv_par02%
		AND F2_EMISSAO >= %Exp:DTOS(mv_par03)%  AND F2_EMISSAO <= %Exp:DTOS(mv_par04)%
		AND %Exp:cIDWhere%
		AND F2_TIPO <> 'D'
		AND SF2.%notdel%
		AND SA1.A1_FILIAL = %xFilial:SA1% AND SA1.A1_COD = F2_CLIENTE AND SA1.A1_LOJA = F2_LOJA
		AND SA1.%notdel%
		AND D2_FILIAL = %xFilial:SD2% AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA
		AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE
		AND SD2.%notdel%
		%Exp:cWhereF2%		
			
UNION ALL
	
SELECT	F1_FORNECE CLIFOR,F1_LOJA LOJA,F1_DOC DOC,F1_SERIE SERIE,F1_DTDIGIT EMISSAO %Exp:cSelectUni%
		,F1_MOEDA MOEDA,F1_TXMOEDA TXMOEDA,F1_TIPO TIPO,F1_ESPECIE ESPECIE
		,F1_FRETE,0 FRETAUT,F1_SEGURO SEGURO,F1_DESPESA DESPESA
		,SA1.A1_NOME NOME,D1_DOC DOCITEM,D1_SERIE SERIEITEM,D1_FORNECE CLIFORITEM,D1_LOJA LOJAITEM,D1_TIPO TIPOITEM
		," " GRADE,D1_COD COD,D1_QUANT QUANT
		,D1_CF CF,D1_TES TES,D1_LOCAL ALMOX,D1_ITEMPV ITEMPV,D1_NUMPV PEDIDO,D1_REMITO REMITO,D1_ITEMREM ITEMREM
		,D1_VUNIT PRCVEN,D1_TOTAL TOTAL,0 VALADI,D1_VALDESC VALDESC,D1_ITEM ITEM, "1" TIPODOC %Exp:cCamposD1%
FROM %Table:SF1% SF1, %Table:SD1% SD1, %Table:SA1% SA1
WHERE	F1_FILIAL = %xFilial:SF1%
		AND F1_DOC >= %Exp:mv_par01% AND F1_DOC <= %Exp:mv_par02%
		AND F1_DTDIGIT >= %Exp:DtoS(mv_par03)% AND F1_DTDIGIT <= %Exp:DtoS(mv_par04)%
		AND %Exp:cIDWhereU%
		AND F1_TIPO = 'D'
		AND SF1.%notdel%
		AND SA1.A1_FILIAL = %xFilial:SA1% AND SA1.A1_COD = F1_FORNECE AND SA1.A1_LOJA=F1_LOJA
		AND SA1.%notdel%
		AND D1_FILIAL = %xFilial:SD1% AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA
		AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE
		AND SD1.%notdel%
		%Exp:cWhereF1%		
ORDER BY EMISSAO,TIPODOC,DOC,SERIE,COD,ITEM
EndSql
oReport:Section(2):EndQuery()

TcSetField(cAliasQry, 'EMISSAO', 'D', 08, 0  )

oReport:SetMeter(TRBMFAT->(LastRec()))
dbSelectArea('TRBMFAT')
dbGoTop()
While !TRBMFAT->(Eof()) .And. lContinua

	oReport:IncMeter()
	
	dEmisAnt   := TRBMFAT->EMISSAO
	dEmissao   := TRBMFAT->EMISSAO
	cNota		:= TRBMFAT->DOC
	cTipo		:= TRBMFAT->TIPO
	cTipoDoc	:= TRBMFAT->TIPODOC
	cSerie		:= TRBMFAT->SERIE
	cSerieView	:= Alltrim(TRBMFAT->&(SerieNfId("SF2",3,"SERIE")))
	cCliente	:= TRBMFAT->CLIFOR + TRBMFAT->LOJA
	cNome	  	:= TRBMFAT->NOME
	cLoja		:= TRBMFAT->LOJA
	nFrete		:= TRBMFAT->FRETE
	nSeguro	:= TRBMFAT->SEGURO
	nDespesa	:= TRBMFAT->DESPESA
	nMoeda		:= TRBMFAT->MOEDA
	nTxMoeda	:= TRBMFAT->TXMOEDA
	nFretAut	:= TRBMFAT->FRETAUT
	nCt			:= 1
	
	If TRBMFAT->TIPODOC == "1"
		TRPrinD1Top(@nCt,oReport,cAliasQry)   
	Else	
		TRPrinD2Top(@nCt,oReport,cAliasQry)
	Endif

	nAcN3 := 0
	nTotNeto := 0
	If nAcN2 > 0
		nAcN3 := xmoeda(nFrete + nSeguro + nDespesa, nMoeda, mv_par13, dEmisAnt, nDecs+1, nTXMoeda)
		nTotNeto := nAcN2 + nAcN3 + nFretAut + nAcImpInc

		If nAcN3 != 0 .Or. nFretAut != 0
			oReport:PrintText(STR0032 + " ------------> " + Str(nAcN3+nFretAut,14,2))		// DESPESAS ACESSORIAS
			oReport:SkipLine(1)			
		EndIf

		If cTipoDoc == "2" 
			nAcGImpInc		+= nAcImpInc
			nAcGImpNoInc	+= nAcImpNoInc
			nAcG1			+= nAcN1
			nAcG2			+= nAcN2
			nAcG3			+= nAcN3 + nFretAut
			nTotNetGer		+= nAcN2 + nAcN3 + nAcImpInc
		Else
			nAcGImpInc		-= nAcImpInc
			nAcGImpNoInc	-= nAcImpNoInc
			nAcG1			-= nAcN1
			nAcG2			-= nAcN2
			nAcG3			-= nAcN3 + nFretAut
			nTotNetGer		-= nAcN2 + nAcN3 + nAcImpInc			
		Endif
	EndIf

	nTotDia += nAcN2 + nAcImpInc
	
	For nY := 1 to Len(aImpostos)
		If (aImpostos[nY][3] == "2") .And. cPaisLoc == "COL"
			nTotNeto	-= nAcImpNoInc
			nTotNetGer	-= nAcImpNoInc
			nTotDia	-= nAcImpNoInc
		EndIf
	Next
	
	nAcDImpInc		+= nAcImpInc
	nAcDImpNoInc	+= nAcImpNoInc
	nAcD1			+= nAcN1
	nAcD2			+= nAcN2
	nAcD3			+= nAcN3 + nFretAut
	
	nAcImpInc		:= 0
	nAcImpNoInc	:= 0
	nAcn1			:= 0
	nAcn2			:= 0
	nAcn3			:= 0

	If ( nAcd1 > 0 .And. ( dEmisAnt != TRBMFAT->EMISSAO .Or. Eof()))
		oReport:Section(7):SetHeaderSection(.F.)
		oReport:PrintText(STR0034 +  DtoC(dEmisAnt))
		oReport:FatLine() 
		oReport:Section(7):Init()
		oReport:Section(7):PrintLine()
		oReport:Section(7):Finish()
		oReport:SkipLine(2)		
		
		nAcDImpInc  := 0
		nAcDImpNoInc:= 0
		nAcD1 		:= 0
		nAcD2 		:= 0
		nAcD3 		:= 0
		nTotDia		:= 0
		nAcdAdi		:= 0
	Endif

End // Documento, Serie

oReport:Section(6):SetHeaderSection(.F.)
oReport:PrintText(STR0060)
oReport:Section(6):Init()

oReport:Section(6):Cell("CCOD"):Hide()
oReport:Section(6):Cell("CDESC"	):Hide()
oReport:Section(6):Cell("ALMOX"):Hide()
oReport:Section(6):Cell("PEDIDO"):Hide()
oReport:Section(6):Cell("ITEM"):Hide()
oReport:Section(6):Cell("REMITO"):Hide()
oReport:Section(6):Cell("ITEMREM"):Hide()
oReport:Section(6):Cell("NACGIMPINC"):Hide()
oReport:Section(6):Cell("NACGIMPNOINC"):Hide()

oReport:Section(6):PrintLine()
oReport:Section(6):Finish()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TRPrinD2Top³ Autor ³ Marco Bianchi        ³ Data ³ 08/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime itens do SD2 (Base Localizada Top).                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR550 - R4 	                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function TRPRIND2TOP(nCt,oReport,cAliasQry)

Local nTotImpInc		:= 0
Local nTotImpNoInc	:= 0
Local nImpInc			:= 0
Local nImpNoInc		:= 0
Local nQuant			:= 0
Local nPrcVen			:= 0
Local nValadi			:= 0
Local nTotal			:= 0
Local nTotcImp		:= 0
Local cNumPed		  	:= ""
Local nY				:= 0
Local cMascara		:= GetMv("MV_MASCGRD")
Local nTamRef			:= Val(Substr(cMascara,1,2))
Local nReg				:= 0
Local cFilSF2			:= ""
Local cFilSD2			:= ""
Local lValadi			:= cPaisLoc == "MEX"

oReport:Section(3):Cell("CCLIENTE"	):SetBlock({|| Substr(cCliente,1,nTamA1COD)})
oReport:Section(3):Cell("CLOJA"		):SetBlock({|| cLoja})
oReport:Section(3):Cell("CNOME"		):SetBlock({|| cNome})
oReport:Section(3):Cell("CEMISSAO"	):SetBlock({|| dEmissao})
oReport:Section(3):Cell("CTIPO"		):SetBlock({|| cTipo})

oReport:Section(5):Cell("CCOD"		):SetBlock({|| cCod})
oReport:Section(5):Cell("ALMOX"		):SetBlock({|| cLocal})
oReport:Section(5):Cell("CDESC"		):SetBlock({|| cDesc})
oReport:Section(5):Cell("NQUANT"	):SetBlock({|| nQuant})
oReport:Section(5):Cell("NPRCVEN"	):SetBlock({|| nPrcVen})

If lValadi
	oReport:Section(5):Cell("NVALADI"	):SetBlock({|| nValadi})
EndIf

oReport:Section(5):Cell("NTOTAL"	):SetBlock({|| nTotal})
oReport:Section(5):Cell("NIMPINC"	):SetBlock({|| nImpInc})
oReport:Section(5):Cell("NIMPNOINC"):SetBlock({|| nImpnoInc})
oReport:Section(5):Cell("NTOTCIMP"	):SetBlock({|| nTotcImp})
oReport:Section(5):Cell("PEDIDO"	):SetBlock({|| cPedido})
oReport:Section(5):Cell("ITEM"		):SetBlock({|| cItemPV})
oReport:Section(5):Cell("REMITO"	):SetBlock({|| cRemito})
oReport:Section(5):Cell("ITEMREM"	):SetBlock({|| cItemrem})

nAcN1			:= 0
nAcN2			:= 0
nAcImpInc		:= 0
nAcImpnoInc	:= 0

If len(oReport:Section(3):GetAdvplExp("SF2")) > 0
	cFilSF2	:= oReport:Section(3):GetAdvplExp("SF2")
EndIf
If len(oReport:Section(5):GetAdvplExp("SD2")) > 0
	cFilSD2	:= oReport:Section(5):GetAdvplExp("SD2")
EndIf

While TRBMFAT->(! Eof()) .and. TRBMFAT->DOC + TRBMFAT->SERIE + TRBMFAT->CLIFOR + TRBMFAT->LOJA == cNota + cSerie + cCliente

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbSeek( xFilial("SF2") + TRBMFAT->DOC + TRBMFAT->SERIE + TRBMFAT->CLIFOR + TRBMFAT->LOJA )
	// Verifica filtro do usuario
	If !( Empty(cFilSF2) ) .And. !(&cFilSF2)
		dbSelectArea('TRBMFAT')
		dbSkip()
		Loop
	EndIf
	        
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek( xFilial("SD2")+ TRBMFAT->DOCITEM +TRBMFAT->SERIEITEM +TRBMFAT->CLIFORITEM + TRBMFAT->LOJAITEM +TRBMFAT->COD + TRBMFAT->ITEM )
	// Verifica filtro do usuario
	If !( Empty(cFilSD2) ) .And. !(&cFilSD2)
		dbSelectArea('TRBMFAT')
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida o produto conforme a mascara         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('TRBMFAT')
	lRet	:= ValidMasc(TRBMFAT->COD, MV_PAR08)
	If ! lRet
		TRBMFAT->(dbSkip())
		Loop
	Endif

	If nCt == 1
		oReport:Section(3):Init()
		oReport:Section(3):PrintLine()
		oReport:Section(3):Finish()
		oReport:Section(5):Init()
		nCt++
	EndIf

	cCod	:= IIF(TRBMFAT->GRADE == "S".And. MV_PAR09 == 1, Substr(TRBMFAT->COD,1,nTamRef), TRBMFAT->COD)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Utiliza Descricao conforme mv_par12         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par12 == 1
		cDesc := Posicione("SB1",1,xFilial("SB1")+TRBMFAT->COD,"B1_DESC")
	Else
		dbSelectArea("SA7");dbSetOrder(2)
		If dbSeek(xFilial("SA7")+TRBMFAT->COD+TRBMFAT->CLIFOR+TRBMFAT->LOJA)
			cDesc := SA7->A7_DESCCLI
		Else
			cDesc := Posicione("SB1",1,xFilial("SB1")+TRBMFAT->COD,"B1_DESC")
		Endif
	Endif

	dbSelectArea('TRBMFAT')
	cCf				:= TRBMFAT->CF
	cTes			:= TRBMFAT->TES
	cNumPed		:= TRBMFAT->PEDIDO
	nTotQuant		:= 0
	nTotal			:= 0
	nTotcImp		:= 0
	nTotImpInc		:= 0
	nTotImpNoInc	:= 0
	nPrcVen		:= xmoeda(TRBMFAT->PRCVEN,TRBMFAT->MOEDA,mv_par13,,nDecs+1,TRBMFAT->TXMOEDA)
	If lValadi
		nValadi	:= xmoeda(TRBMFAT->VALADI,TRBMFAT->MOEDA,mv_par13,,nDecs+1,TRBMFAT->TXMOEDA)
	EndIf
	cLocal			:= TRBMFAT->ALMOX
	cPedido		:= TRBMFAT->PEDIDO
	cItemPV		:= TRBMFAT->ITEMPV
	cRemito		:= TRBMFAT->REMITO
	cItemRem		:= TRBMFAT->ITEMREM

	nReg := 0
	If TRBMFAT->GRADE == "S" .And. MV_PAR09 == 1
		cProdRef	:= Substr(TRBMFAT->COD,1,nTamRef)
		cCod		:= Substr(TRBMFAT->COD,1,nTamRef)
		While TRBMFAT->(! Eof()) .And. cProdRef == Substr(TRBMFAT->COD,1,nTamRef) .And. TRBMFAT->GRADE == "S" .And. cNumPed == TRBMFAT->PEDIDO
			nTotQuant	+= TRBMFAT->QUANT
			nTotal		+= IIF(!(TRBMFAT->TIPO $ "IP"), xmoeda(TRBMFAT->TOTAL, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA), 0)

			If TRBMFAT->TIPO == "I"
				nCompIcm	+= xmoeda(TRBMFAT->TOTAL, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
			EndIf

			nImpInc		:= 0
			nImpNoInc		:= 0

			aImpostos		:= TesImpInf(TRBMFAT->TES)

			For nY := 1 to Len(aImpostos)
				cCampImp	:= TRBMFAT+"->"+(Substr(aImpostos[nY][2],4))
				If ( aImpostos[nY][3]=="1" )
					nImpInc	+= xmoeda(&cCampImp, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
				Else
					nImpNoInc	+= xmoeda(&cCampImp, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
				EndIf
			Next

			nTotImpInc		+= nImpInc
			nTotImpNoInc	+= nImpNoInc

			nReg			:= TRBMFAT->(Recno())

			TRBMFAT->(dbSkip())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Valida o produto conforme a mascara       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRet			:= ValidMasc(TRBMFAT->COD,MV_PAR08)
			If ! lRet
				TRBMFAT->(dbSkip())
				Loop
			Endif
		End

		nTotcImp		:= (nTotal + nTotImpInc)
		nQuant			:= nTotQuant
		oReport:Section(5):PrintLine()

		nAcN1			+= nTotQuant
		nAcN2			+= nTotal
		nAcImpInc		+= nTotImpInc
		nAcImpNoInc	+= nTotImpNoInc

	Else
	
		nImpInc		:= 0
		nImpNoInc		:= 0

		aImpostos		:= TesImpInf(TRBMFAT->TES)

		For nY := 1 to Len(aImpostos)
			cCampImp	:= cAliasQry + "->" + (substr(aImpostos[nY][2],4))
			If ( aImpostos[nY][3] == "1" )
				nImpInc	+= xmoeda(&cCampImp, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
			Else
				nImpNoInc	+= xmoeda(&cCampImp, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
			EndIf
		Next

		cCod			:= TRBMFAT->COD
		nQuant			:= TRBMFAT->QUANT
		nPrcVen		:= xMoeda(TRBMFAT->PRCVEN, TRBMFAT->MOEDA, MV_PAR13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
		If lValadi
			nValadi	:= xMoeda(TRBMFAT->VALADI, TRBMFAT->MOEDA, MV_PAR13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
		EndIf
		nTotal			:=  xMoeda(TRBMFAT->TOTAL, TRBMFAT->MOEDA, MV_PAR13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
		
		For nY := 1 to Len(aImpostos)
			If (aImpostos[nY][3] == "2") .And. cPaisLoc == "COL"
				nTotcImp	:= (nImpInc + xMoeda(TRBMFAT->TOTAL, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)) - nImpNoInc
			Else
				nTotcImp	:=  nImpInc + xMoeda(TRBMFAT->TOTAL, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
			EndIf
		Next

		oReport:Section(5):PrintLine()

		nAcImpInc		+= nImpInc
		nAcImpNoInc	+= nImpNoInc

		nAcN1			+= TRBMFAT->QUANT
		nAcN2			+= xmoeda(TRBMFAT->TOTAL,TRBMFAT->MOEDA,mv_par13,TRBMFAT->EMISSAO,nDecs+1,TRBMFAT->TXMOEDA)

	Endif

	If lValadi
		nAcgAdi		+= nValadi
		nAcdAdi		+= nValadi
	EndIf
	
	dbSelectArea('TRBMFAT')
	If nReg == 0
		dbSkip()
	Endif
EndDo // Nota

If !(nQuant + nTotal + nImpInc + nImpNoInc + nTotcImp > 0)
	oReport:Section(5):AFunction	:= {}
	TRFunction():New(oReport:Section(5):Cell("NQUANT")		,/* cID */,"SUM",/*oBreak*/,STR0037,PesqPict("SD2","D2_QUANT"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oReport:Section(5):Cell("NTOTAL")		,/* cID */,"SUM",/*oBreak*/,STR0039,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oReport:Section(5):Cell("NIMPINC")	,/* cID */,"SUM",/*oBreak*/,STR0045,PesqPict("SD2","D2_VALIPI"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oReport:Section(5):Cell("NIMPNOINC")	,/* cID */,"SUM",/*oBreak*/,STR0046,PesqPict("SD2","D2_VALICM"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oReport:Section(5):Cell("NTOTCIMP")	,/* cID */,"SUM",/*oBreak*/,STR0047,PesqPict("SD2","D2_VALISS"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	oReport:SetTotalInLine(.F.)
Else
	oReport:Section(5):SetTotalText(STR0048 + " " +  cNota + "/" + cSerie)
	oReport:Section(5):Finish()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TRPrinD1Top³ Autor ³ Marco Bianchi        ³ Data ³ 07/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime itens do SD1 (Base Localizada - Top).              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR550 - R4		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function TRPRIND1TOP(nCt,oReport,cAliasQry)

Local nY			:= 0
Local cFilSF1		:= ""
Local cFilSD1		:= ""
Local nQuant		:= 0
Local nTotal		:= 0
Local nImpInc		:= 0
Local nImpNoInc	:= 0
Local nTotcImp	:= 0

oReport:Section(2):Cell("CCLIENTE"	):SetBlock({|| Substr(cCliente,1,nTamA1COD)})
oReport:Section(2):Cell("CLOJA"		):SetBlock({|| cLoja})
oReport:Section(2):Cell("CNOME"		):SetBlock({|| cNome})
oReport:Section(2):Cell("CEMISSAO"	):SetBlock({|| dEmissao})
oReport:Section(2):Cell("CTIPO"		):SetBlock({|| cTipo})

oReport:Section(4):Cell("CCOD"		):SetBlock({|| cCod})
oReport:Section(4):Cell("ALMOX"		):SetBlock({|| cLocal})
oReport:Section(4):Cell("CDESC"		):SetBlock({|| cDesc})
oReport:Section(4):Cell("NQUANT"	):SetBlock({|| nQuant})
oReport:Section(4):Cell("NPRCVEN"	):SetBlock({|| nPrcVen})
oReport:Section(4):Cell("NTOTAL"	):SetBlock({|| nTotal})
oReport:Section(4):Cell("NIMPINC"	):SetBlock({|| nImpInc})
oReport:Section(4):Cell("NIMPNOINC"):SetBlock({|| nImpnoInc})
oReport:Section(4):Cell("NTOTCIMP"	):SetBlock({|| nTotcImp})
oReport:Section(4):Cell("PEDIDO"	):SetBlock({|| cPedido})
oReport:Section(4):Cell("ITEM"		):SetBlock({|| cItemPV})
oReport:Section(4):Cell("REMITO"	):SetBlock({|| cRemito})
oReport:Section(4):Cell("ITEMREM"	):SetBlock({|| cItemrem})
    
nAcN1			:= 0
nAcN2			:= 0
nAcImpInc		:= 0
nAcImpnoInc	:= 0
cPedido		:= ""
cItemPV		:= ""
cRemito		:= ""
cItemrem		:= ""
cLocal			:= ""

If len(oReport:Section(2):GetAdvplExp("SF1")) > 0
	cFilSF1 := oReport:Section(2):GetAdvplExp("SF1")
EndIf
If len(oReport:Section(3):GetAdvplExp("SD1")) > 0
	cFilSD1 := oReport:Section(3):GetAdvplExp("SD1")
EndIf

While TRBMFAT->(! Eof()) .and. TRBMFAT->TIPODOC == "1" .And. TRBMFAT->DOC + TRBMFAT->SERIE + TRBMFAT->CLIFOR + TRBMFAT->LOJA == cNota + cSerie + cCliente
	
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek( xFilial("SF1") + TRBMFAT->DOC + TRBMFAT->SERIE + TRBMFAT->CLIFOR + TRBMFAT->LOJA )
	// Verifica filtro do usuario
	If !( Empty(cFilSF1) ) .And. !(&cFilSF1)
		dbSelectArea('TRBMFAT')
		dbSkip()
		Loop
	EndIf
	        
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek( xFilial("SD1") + TRBMFAT->DOCITEM + TRBMFAT->SERIEITEM + TRBMFAT->CLIFORITEM + TRBMFAT->LOJAITEM + TRBMFAT->COD + TRBMFAT->ITEM )
	// Verifica filtro do usuario
	If !( Empty(cFilSD1) ) .And. !(&cFilSD1)
		dbSelectArea('TRBMFAT')
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida o produto conforme a mascara         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('TRBMFAT')
	lRet := ValidMasc(TRBMFAT->COD,MV_PAR08)

	If !lRet
		dbSkip()
		Loop
	Endif

	If nCt == 1
		oReport:Section(2):Init()
		oReport:Section(2):PrintLine()
		oReport:Section(2):Finish()
		oReport:Section(3):Init()
		nCt++
	EndIf
	dbSelectArea('TRBMFAT')

	nTotQuant   := 0
	nTotcImp    := 0
	nTotal      := 0
	nImpInc  	:= 0
	nImpNoInc	:= 0

	aImpostos	:= TesImpInf(TRBMFAT->TES)
	For nY := 1 to Len(aImpostos)
		cCampImp	:= cAliasQry + "->" + (Substr(aImpostos[nY][2],4))
		If ( aImpostos[nY][3] == "1" )
			nImpInc	+= xmoeda(&cCampImp, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
		Else
			nImpNoInc	+= xmoeda(&cCampImp, TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
		EndIf
	Next

	If mv_par12 == 1
		cDesc := Posicione("SB1",1,xFilial("SB1")+TRBMFAT->COD,"B1_DESC")
	Else
		SA7->(dbSetOrder(2))
		If SA7->(dbSeek(xFilial("SA7") + TRBMFAT->COD + TRBMFAT->CLIFOR + TRBMFAT->LOJA))
			cDesc := SA7->A7_DESCCLI
		Else
			cDesc := Posicione("SB1",1,xFilial("SB1")+TRBMFAT->COD,"B1_DESC")
		Endif
	Endif
	
	dbSelectArea('TRBMFAT')
	cCod		:= TRBMFAT->COD
	nQuant		:= TRBMFAT->QUANT
	nPrcVen	:=           xMoeda((TRBMFAT->PRCVEN - (TRBMFAT->VALDESC/TRBMFAT->QUANT)) ,TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
	nTotal		:=           xMoeda((TRBMFAT->TOTAL -   TRBMFAT->VALDESC),                     TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
	nTotcImp	:= nImpInc + xmoeda((TRBMFAT->TOTAL -   TRBMFAT->VALDESC),                     TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
	cLocal		:= TRBMFAT->ALMOX
    
	oReport:Section(3):PrintLine()

	nAcImpInc		+= nImpInc
	nAcImpNoInc	+= nImpNoInc

	nAcN1		+= TRBMFAT->QUANT
	nAcN2		+= xmoeda((TRBMFAT->TOTAL - TRBMFAT->VALDESC), TRBMFAT->MOEDA, mv_par13, TRBMFAT->EMISSAO, nDecs+1, TRBMFAT->TXMOEDA)
	
	dbSelectArea('TRBMFAT')
	dbSkip()
EndDo

If !(nQuant + nTotal + nImpInc + nImpNoInc + nTotcImp > 0)
	oReport:Section(3):aFunction := {}		// Zera array de totais
	TRFunction():New(oReport:Section(3):Cell("NQUANT"),   /* cID */,"SUM",/*oBreak*/,STR0037,PesqPict("SD2","D2_QUANT"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oReport:Section(3):Cell("NTOTAL"),   /* cID */,"SUM",/*oBreak*/,STR0039,PesqPict("SD2","D2_TOTAL"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oReport:Section(3):Cell("NIMPINC"),  /* cID */,"SUM",/*oBreak*/,STR0045,PesqPict("SD2","D2_VALIPI"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oReport:Section(3):Cell("NIMPNOINC"),/* cID */,"SUM",/*oBreak*/,STR0046,PesqPict("SD2","D2_VALICM"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oReport:Section(3):Cell("NTOTCIMP"), /* cID */,"SUM",/*oBreak*/,STR0047,PesqPict("SD2","D2_VALISS"	),/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	oReport:SetTotalInLine(.F.)
Else
	oReport:Section(3):SetTotalText(STR0048 + " " +  cNota + "/" + cSerieView)
	oReport:Section(3):Finish()
EndIf

Return



	
Return Nil