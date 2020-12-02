/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MARK  ºAutor  ³Andre - Ethosx      º Data ³  11/09/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto-de-Entrada: M460MARK - Validação de pedidos marcados º±±
±±º          ³                                                            º±±
±±º          ³ O ponto de entrada M460MARK e utilizado para validar os pe-º±± 
±±º          ³didos marcados e esta localizado na funcao a460Nota         º±±
±±º          ³(endereca rotinas para a geracao dos arquivos SD2/SF2).Sera º±±
±±º          ³informado no terceiro parametro a serie selecionada na gera-º±±
±±º          ³cao da nota e o numero da nota fiscal podera ser verificado º±±
±±º          ³pela variavel private cNumero.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Utilizado para validar as datas de vencimento do PV        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460MARK()

Local lRet  := .T.
Local aArea := GetArea()

SC5->(DbSetorder(1)) //C5_FILIAL + C5_NUM

If SC5->(DbSeek(xFilial("SC5") + SC9->C9_PEDIDO))

	If !Empty(SC5->C5_DATA1) .And. SC5->C5_EMISSAO > SC5->C5_DATA1

		MsgAlert( "Data de vencimento anterior a data de emissão, pedido: " + Alltrim (SC9->C9_PEDIDO) , "Data Vencimento 1" )
		lRet  := .F.
	
	ElseIf !Empty(SC5->C5_DATA2) .And. SC5->C5_EMISSAO > SC5->C5_DATA2
	
		MsgAlert( "Data de vencimento anterior a data de emissão, pedido: " + Alltrim (SC9->C9_PEDIDO) , "Data Vencimento 2" )
		lRet  := .F.
	
	ElseIf !Empty(SC5->C5_DATA3) .And. SC5->C5_EMISSAO > SC5->C5_DATA3
	
		MsgAlert( "Data de vencimento anterior a data de emissão, pedido: " + Alltrim (SC9->C9_PEDIDO) , "Data Vencimento 3" )
		lRet  := .F.
	
	ElseIf !Empty(SC5->C5_DATA4) .And. SC5->C5_EMISSAO > SC5->C5_DATA4
	
		MsgAlert( "Data de vencimento anterior a data de emissão, pedido: " + Alltrim (SC9->C9_PEDIDO) , "Data Vencimento 4" )
		lRet  := .F.
	
	EndIf

EndIf

RestArea(aArea)

Return lRet