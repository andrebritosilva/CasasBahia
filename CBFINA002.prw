#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch" 
#include 'fwbrowse.ch'

#DEFINE  _CFILIAL      	001
#DEFINE  _CPREFIXO     	002
#DEFINE  _CTITULO      	003
#DEFINE  _CPARCELA      004
#DEFINE  _CTIPO    		005
#DEFINE  _CCODFOR     	006
#DEFINE  _CLJFOR     	007

 /*/
{Protheus.doc} CBFINA02
 				Gerar registros de WF de pagamentos
@author 		iVan Oliveira - EthosX
@since 			12/12/2018
@version 		1.0
@return 		${nulo}, ${nulo}

@type function 	user function
/*/
User Function CBFINA02(_lExcl,_aUnit, _aLote)

Local _nIt 	   := 0

Default _aUnit := {}
Default _aLote := {}

// baixa Manual
for _nIt := 1 to len(_aUnit)

	// Processando Registro
	ProcReg(_lExcl, _aUnit[_CFILIAL] ,_aUnit[_CPREFIXO],_aUnit[_CTITULO],;
					_aUnit[_CPARCELA],_aUnit[_CTIPO]   ,_aUnit[_CCODFOR],_aUnit[_CLJFOR])

Next

// Se for baixa automática
for _nIt := 1 to len(_aLote)

 	dbSelectArea("SE5")
	DbSetOrder(1)
		
	SE5->(dbGoto(_aLote[_nIt]))
	if Upper(Alltrim(SE5->E5_TIPO))  == 'NF'
	
		// Processando Registro
		ProcReg(_lExcl, SE5->E5_FILIAL ,SE5->E5_PREFIXO,SE5->E5_NUMERO ,;
						SE5->E5_PARCELA,SE5->E5_TIPO   ,SE5->E5_CLIFOR ,SE5->E5_LOJA )
						
	Endif

Next

Return

/*/
{Protheus.doc} ProcReg
 				Processar registros WF de pagamentos
@author 		iVan Oliveira - EthosX
@since 			12/12/2018
@version 		1.0
@return 		${nulo}, ${nulo}

@type function 	Static function
/*/
Static Function ProcReg(_lExcl, _cFilReg,_cPrefix,_cNumTit,_cParcel,_cTipo,_cForn,_cLjForn)

Local _cChave := _cFilReg + _cPrefix + _cNumTit + _cParcel + _cTipo + _cForn + _cLjForn

DbSelectArea("ZFC")
ZFC->(DbSetOrder(1))

// Verificando se exclusão ou inclusão
if !_lExcl   

	if !ZFC->( DbSeek(_cChave) )  

		if RecLock( "ZFC", !_lExcl )
	
			ZFC->ZFC_FILIAL := _cFilReg 
			ZFC->ZFC_PREFIX := _cPrefix
			ZFC->ZFC_NUM  	:= _cNumTit 
			ZFC->ZFC_PARCEL	:= _cParcel
			ZFC->ZFC_TIPO  	:= _cTipo
			ZFC->ZFC_FORNEC := _cForn
			ZFC->ZFC_LOJA	:= _cLjForn
			
			MsUnlock()
			
		Endif  
		
	Endif

Else 

	if ZFC->( DbSeek(_cChave) ) 

		// Se for exclusão
		RecLock("ZFC",.F.)				
			ZFC->(dbDelete())
		ZFC->(MsUnlock())

	Endif
			 
Endif
 
Return
