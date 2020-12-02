/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460MARK  �Autor  �Andre - Ethosx      � Data �  11/09/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto-de-Entrada: M460MARK - Valida��o de pedidos marcados ���
���          �                                                            ���
���          � O ponto de entrada M460MARK e utilizado para validar os pe-��� 
���          �didos marcados e esta localizado na funcao a460Nota         ���
���          �(endereca rotinas para a geracao dos arquivos SD2/SF2).Sera ���
���          �informado no terceiro parametro a serie selecionada na gera-���
���          �cao da nota e o numero da nota fiscal podera ser verificado ���
���          �pela variavel private cNumero.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Utilizado para validar as datas de vencimento do PV        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M460MARK()

Local lRet  := .T.
Local aArea := GetArea()

SC5->(DbSetorder(1)) //C5_FILIAL + C5_NUM

If SC5->(DbSeek(xFilial("SC5") + SC9->C9_PEDIDO))

	If !Empty(SC5->C5_DATA1) .And. SC5->C5_EMISSAO > SC5->C5_DATA1

		MsgAlert( "Data de vencimento anterior a data de emiss�o, pedido: " + Alltrim (SC9->C9_PEDIDO) , "Data Vencimento 1" )
		lRet  := .F.
	
	ElseIf !Empty(SC5->C5_DATA2) .And. SC5->C5_EMISSAO > SC5->C5_DATA2
	
		MsgAlert( "Data de vencimento anterior a data de emiss�o, pedido: " + Alltrim (SC9->C9_PEDIDO) , "Data Vencimento 2" )
		lRet  := .F.
	
	ElseIf !Empty(SC5->C5_DATA3) .And. SC5->C5_EMISSAO > SC5->C5_DATA3
	
		MsgAlert( "Data de vencimento anterior a data de emiss�o, pedido: " + Alltrim (SC9->C9_PEDIDO) , "Data Vencimento 3" )
		lRet  := .F.
	
	ElseIf !Empty(SC5->C5_DATA4) .And. SC5->C5_EMISSAO > SC5->C5_DATA4
	
		MsgAlert( "Data de vencimento anterior a data de emiss�o, pedido: " + Alltrim (SC9->C9_PEDIDO) , "Data Vencimento 4" )
		lRet  := .F.
	
	EndIf

EndIf

RestArea(aArea)

Return lRet