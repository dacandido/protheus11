
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MT100TOK � Autor �  Alexandre R. Bento  � Data � 11/03/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Na inclus�o da nota fiscal de entrada do tipo FE/MM        ���
���          � Verificar saldo disponivel do orcamento do mesmo           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Compras                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "AP5MAIL.CH"
//***********************************************************************************************************
//
//***********************************************************************************************************
User Function SD1100E()

     ZAK->(DbSetOrder(1))//filial + mesano + tipo
     SF4->(DbSeek(xFilial("SF4")+ SD1->D1_TES)) 
     If SF4->F4_DUPLIC$"S" 
	    If Subs(Alltrim(SD1->D1_CONTA),1,6) <> "104020"  //nao pega conta de novos projetos       		   
	       If Subs(Alltrim(SD1->D1_CONTA),1,8) <> "10104006"  //nao pega conta de novos projetos       		   	    
		      If ZAK->(Dbseek(xFilial("ZAK")+Strzero(Month(SD1->D1_DTDIGIT),2) + "/"+Strzero(Year(SD1->D1_DTDIGIT),4)+ SD1->D1_TP ))  
			     Reclock("ZAK",.F.)
			 	   ZAK->ZAK_SLD   += SD1->D1_TOTAL
			     MsUnlock("ZAK")     
			  Endif   
	       Endif
		Endif
     Endif
Return(.T.) 
                       
