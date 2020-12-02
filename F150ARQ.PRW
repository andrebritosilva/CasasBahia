#Include "PROTHEUS.Ch"

/*
Ponto de Entrada que permite alterar o nome e extensão do arquivo de saída, gerado a partir da rotina Arquivos de Cobranças (FINA150).
*/

User Function F150ARQ()

	Local aArea      := GetArea()
	Local cTeste     := paramixb
	Local cMes       := StrZero( MONTH(DATE()), 2)
	Local cDia       := StrZero( DAY( DATE() ),2)
	Local lContinua  := SuperGetMv("MV_XNOMAUT",.F.,"")
	Local cDir       := Alltrim(SuperGetMv("MV_XCAMVAN",.F.,""))
	
	If lContinua
		cTeste := cDir + "REC" + Alltrim(mv_par05) + Alltrim(mv_par06) + Alltrim(Str(YEAR(DATE()))) + cMes + cDia
	Else
		Return
	EndIf
	
	RestArea(aArea)

Return cTeste