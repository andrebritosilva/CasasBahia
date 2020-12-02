#Include "Protheus.ch"
#Include "restful.ch"
#Include "tbiconn.ch"
#Include "fwmvcdef.ch"

static cPrefDef := SuperGetMv("FS_TABWEB", .T., "PW")

/*/-----------------------------------------------------------------------------------------
{Protheus.doc} u_EnvStru
//TODO Envia estrutura de acordo com cadastro do usuário ou selecionado no ato do login
@author  André Brito
@since 15/10/2019
@version 1.0
@return ${return}, ${return_description}
@param cProduto, cLogin, cPass, cAlias, cIdUsuário
@type function
---------------------------------------------------------------------------------------------/*/
WSRESTFUL WSRESTWFRETURN DESCRIPTION "Aprovacao Titulo Pagar"

	WSMETHOD GET  DESCRIPTION "WSRESTWFRETURN" WSSYNTAX "Chave || Filial/Prefixo/Numero/Parcela"
                                                    
END WSRESTFUL

WSMETHOD GET WSSERVICE WSRESTWFRETURN

Local cFilSe2  := Alltrim(Self:aUrlParms[1])
Local cPrefixo := Alltrim(Self:aUrlParms[2])
Local cNumero  := Alltrim(Self:aUrlParms[3])
Local cParcela := Alltrim(Self:aUrlParms[4]) 
Local cMensagem:= "Aprovado"

Self:SetResponse(cMensagem)

Return .T.