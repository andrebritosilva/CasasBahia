#Include "PROTHEUS.Ch"

User Function FA080CHK ()

Local lRet := .F.

If Alltrim(SE2->E2_ORIGEM) == 'FISA001' .And. (Empty(SE2->E2_XAUTORI) .Or. SE2->E2_XAUTORI == 'N')

	If MsgYesNo( "Título oriundo de apuração de impostos, deseja solicitar autorização para baixa?", "Autorização Baixa")
	
		lRet := U_WCTPAGAR()
		
	EndIf
EndIf

Return lRet
