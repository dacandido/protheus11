/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mt170grv  �Autor  �Fabio Nico          � Data �  12/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada apos gravacao da SC via ponto de pedido   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Mt170sc1()

   	DbSelectArea("SB5")
	DbSetOrder(1)
	DbSeek(xFilial("SB5") + SC1->C1_PRODUTO, .F.)

	RecLock("SC1")
	   SC1->C1_DESCRI := alltrim(SC1->C1_DESCRI) + " " + ALLTRIM (SB5->B5_CEME)
	MsUnLock("SC1")     
	    
	    SZU->(DbSetOrder(2))
	    SB1->(DbSetOrder(1))
	    SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
	    If SB1->(Found())
            // Verifica se o produto esta com o valor zerado e pega da ultima compra do mesmo
			If Empty(SC1->C1_VUNIT)
  			   RecLock("SC1",.F.)			
               SC1->C1_VUNIT := SB1->B1_UPRC  			   
  			   MsUnLock("SC1")     
			Endif               
	  		// Tabela de valida��o de Usuarios, Grupos e Local Padr�o  
			ZAA->(DbGotop()) // Tabela de valida��o de Usuarios, Grupos e Local Padr�o
			While !ZAA->(Eof())
				// Aprovacao  ZAA_GERA
				// 1 = solicitacao de compras
				// 2 = pedido em aberto
				// 3 = autorizacao de entrega

               If ZAA->ZAA_GERA == "1" // gera aprova�ao para solicitacao de compra
					If Substr(Alltrim(SC1->C1_CONTA),1,8) == "10104006" .AND. ZAA->ZAA_CONTA == "10104006"
						If !Empty(ZAA->ZAA_GRUPO)
							If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) 
								SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
		        	            If !SZU->(Found())
									RecLock("SZU",.T.)
									SZU->ZU_FILIAL := xFilial("SZU")
									SZU->ZU_NUM    := SC1->C1_NUM
									SZU->ZU_ITEM   := SC1->C1_ITEM
									SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
									SZU->ZU_ORIGEM := "SC1"
									MsUnlock("SZU")
								Endif
							Endif
						Endif
					
					Elseif Substr(Alltrim(SC1->C1_CONTA),1,8) <> "10104006" .AND. ZAA->ZAA_CONTA <> "10104006"
	
						If Alltrim(SB1->B1_TIPO) $ 'FC/FD'
	
							If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .AND. ZAA->ZAA_TIPO == Alltrim(SB1->B1_TIPO)
								SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
	    		   	            If !SZU->(Found())
									RecLock("SZU",.T.)
									SZU->ZU_FILIAL := xFilial("SZU")
									SZU->ZU_NUM    := SC1->C1_NUM
									SZU->ZU_ITEM   := SC1->C1_ITEM
									SZU->ZU_LOGIN  := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL  := ZAA->ZAA_ORDEM
  									SZU->ZU_ORIGEM := "SC1"								
									MsUnlock("SZU")   
								Endif                     
							Endif
	
						Else
	
							If ZAA->ZAA_GRUPO == Alltrim(SB1->B1_GRUPO) .And. Empty(ZAA->ZAA_TIPO)
	
								SZU->(DbSeek(xFilial("SZU")+SC1->C1_NUM + SC1->C1_ITEM + ZAA->ZAA_ORDEM)) // Pesquisa o Nivel
		    		   	        If !SZU->(Found())
									RecLock("SZU",.T.)
									SZU->ZU_FILIAL:= xFilial("SZU")
									SZU->ZU_NUM   := SC1->C1_NUM
									SZU->ZU_ITEM  := SC1->C1_ITEM
									SZU->ZU_LOGIN := ZAA->ZAA_LOGIN
									SZU->ZU_NIVEL := ZAA->ZAA_ORDEM
  									SZU->ZU_ORIGEM:= "SC1"
									MsUnlock("SZU")
								Endif
	
							Endif
	
						Endif					
	
					Endif	
               Endif
   			   ZAA->(DbSkip())
			Enddo
	    Endif
	    
Return(.T.)