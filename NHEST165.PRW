/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST165  � Jo�o Felipe da Rosa        � Data �  14/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � VALIDA O C.CUSTO E A CTA CONTABIL NOS PONTOS DE ENTRADA    ���
���          � MT100LOK, MT110LOK, MT120LOK                               ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS - COMPRAS                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//-- Chamado 007916 do helpdesk
//-- Chamado 008962 do helpdesk
User Function NHEST165(cCC,cConta,cProd)

Local nB1Rec := SB1->(Recno()) //-- Guarda a posicao da tabela SB1
    
   	SB1->(Dbseek(xFilial("SB1")+cProd))

    If SM0->M0_CODIGO=="FN" //Fundicao
                     
    	//-- chamado 019266 do portal
    	//If AllTrim(cConta)$"307030010005" // Treinamento inova��o tecnol�gica
		If Substr(cCC,2,1)$"7" .and. !substr(AllTrim(cConta),1,3)$"307"
			Alert("Para C.Custo com 2� d�gito 7 a Conta deve iniciar com 307!") // de Treinamento e Inova��o Tecnol�gica s� pode ser usado C.Custo com 2� d�gito igual a 7!")
//			Return .F.
		Else
	    	//-- contas de exce��o
	    	If !AllTrim(cConta)$"101030040001/101030040002/101030040003/101030040004/101030040007/101030020003/101030020007" .AND. ;
	    	   !Substr(cConta,1,5)$"10302/10303/10401/10402/10104" .AND. ;
	    	   !AllTrim(SB1->B1_TIPO)$"IM/BN/PA/PW"
	    
		    	//-- se o 2� digito do C.Custo for 3 ou 4 a C.Contabil deve ser do grupo 4
	   	 		If Substr(cCC,2,1)$"3/4" .AND. Substr(cConta,1,1)<>"4"
	   	 			Alert("Para este C.Custo a Conta Cont�bil deve ser do Grupo 4!")
		    		Return .F.
	    		EndIf
	
		    	//-- se o 2� digito do C.Custo for 1, 2 ou 5 a C.Contabil deve ser do grupo 3
	    		If ( Substr(cCC,2,1)$"1/2/5" .and. !alltrim(cCC)$'11003005' ).AND. Substr(cConta,1,1)<>"3"
	    			Alert("Para este C.Custo a Conta Cont�bil deve ser do Grupo 3!")
	     			Return .F.
		    	EndIf
	
	    	EndIf
		EndIf
	    	
    ElseIf SM0->M0_CODIGO=="NH" //Usinagem
    	
    	//-- contas de exce��o
    	If !AllTrim(cConta)$"101030040001/101030040002/101030040003/101030040004/101030040006/101030040006/101030040007/101030040005" .AND. ;
    	   !Substr(cConta,1,5)$"10302/10303/10401/10402/10104" .AND. ;
    	   !AllTrim(SB1->B1_TIPO)$"IM/BN/PA/PW"

	    	//-- se o 1� digito do C.Custo for 3 ou 4 a C.Contabil deve ser do grupo 4
	    	If Substr(cCC,1,1)$"3/4" .AND. Substr(cConta,1,1)<>"4"
	    		Alert("Para este C.Custo a Conta Cont�bil deve ser do Grupo 4!")
	    		Return .F.
	    	EndIf
	    	
	    	//-- se o 1� digito do C.Custo for 1, 2 ou 5 a C.Contabil deve ser do grupo 3
	    	If Substr(cCC,1,1)$"1/2/5" .AND. Substr(cConta,1,1)<>"3"
	    		Alert("Para este C.Custo a Conta Cont�bil deve ser do Grupo 3!")
	    		Return .F.
	    	EndIf

		EndIf
	    
    EndIf

	SB1->(dbGoTo(nB1Rec)) //--retorna a posicao da tabela SB1

Return .T.