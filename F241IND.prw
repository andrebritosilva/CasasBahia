#Include "PROTHEUS.Ch"

/*

Ponto de entrada que ordena os titulos que compoem o border� por valor

*/

User Function F241IND ()

SE2->(DbSetOrder(18))

aIndTemp := {CriaTrab(,.F.)}

IndRegua(cAliasSE2,aIndTemp[1],SE2->(IndexKey()),"D",,"Ordenando os t�tulos...") //"Indexando arquivo...."

Return aIndTemp
