/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHEST102 �Autor �Jo�o Felipe da Rosa � Data �  12/09/2007  ���
�������������������������������������������������������������������������͹��
���Desc.     � RELAT�RIO DE �TENS EM PONTO DE PEDIDO                      ���
�������������������������������������������������������������������������͹��
���Uso       � Manutencao / compras                                       ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#INCLUDE "FIVEWIN.CH"  
#INCLUDE "TOPCONN.CH"
User Function NHEST102()   

cString   := "SB1"
cDesc1    := OemToAnsi("Este relat�rio tem por objetivo")
cDesc2    := OemToAnsi("Imprimir os produtos que est�o")
cDesc3    := OemToAnsi("em ponto de Pedido")
tamanho   := "M"
limite    := 232
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST102"
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("RELAT�RIO DE �TENS EM PONTO DE PEDIDO")                
cabec1    := OemToAnsi("Produto         Descri��o                       Estoque   P. Pedido  S.C.   Pedido    Valor �tem     Quant.Receber    Data Entrega")
cabec2    := ""                 
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina 
M_PAG     := 1  
wnrel     := "NHEST102"
_cPerg    := "EST102" 
_AOrd	  := {}    


SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,_AOrd,,tamanho)

Pergunte(_cPerg,.T.) 

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
Processa( {|| RptDetail() },"Imprimindo...")


set filter to 
//set device to screen
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
TRA1->(DbCloseArea())

Return

Static Function Gerando() 

		//-----------------------------------------------------------------------
		//  monta a query para o SB1, SB2, SC1 E SC7
		//-----------------------------------------------------------------------		
		cQuery := "SELECT B1.B1_COD, B1.B1_DESC, B2.B2_QATU, B1.B1_EMIN, C1.C1_NUM, C1.C1_ITEM "
		cQuery += "FROM " + RetSqlName ('SB1') + " B1, " + RetSqlName ('SB2') + " B2, " + RetSqlName('SC1') +" C1 " 
		cQuery += "WHERE B1.B1_COD = B2.B2_COD "
		cQuery += "AND B1.B1_COD = C1.C1_PRODUTO "
		cQuery += "AND B1.B1_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " 
        cQuery += "AND B1.D_E_L_E_T_ = ' ' AND B2.D_E_L_E_T_ = ' ' AND C1.D_E_L_E_T_ = ' ' "
//		MemoWrit('C:\TEMP\TRA1.SQL',cQuery)
		TCQUERY cQuery NEW ALIAS 'TRA1'
		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf

Return
Static Function RptDetail()  

Cabec(Titulo, Cabec1,Cabec2,NomeProg, tamanho, nTipo)                                    

DbSelectArea('TRA1') 
SC7->(DbSetOrder(22))//C7_FILIAL+C7_NUMSC+C7_ITEMSC
While TRA1->( ! Eof() )        

     	@ Prow ()+1,001 Psay TRA1->B1_COD
        @ Prow ()  ,016 Psay TRA1->B1_DESC
     	@ Prow ()  ,051 Psay TRA1->B2_QATU
     	@ Prow ()  ,062 Psay TRA1->B1_EMIN
     	@ Prow ()  ,068 Psay TRA1->C1_NUM
	    If SC7->(DbSeek(xFilial("SC7")+ TRA1->C1_NUM+TRA1->C1_ITEM))
	    	@ Prow ()  ,076 Psay SC7->C7_NUM 	
  	    	@ Prow ()  ,084 Psay Transform(SC7->C7_PRECO,"@e 9,999,999.99")
	    	@ Prow ()  ,100 Psay Transform(SC7->C7_QUANT,"@e 9,999,999")
	    	@ Prow ()  ,122 Psay DtoC(SC7->C7_DATPRF)
	    EndIf
	    TRA1->(DbSkip())
    	if Prow() > 60
			Cabec(Titulo, Cabec1,Cabec2,NomeProg,tamanho, nTipo) 
	    Endif

   	ENDDO

	@ Prow()+2,000 PSAY __PrtThinLine()         
	
Return(nil)
  
