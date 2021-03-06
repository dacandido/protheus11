
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCOM059  �Autor  �Jo�o Felipe da Rosa � Data �  13/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho: Atualiza Conta Cont�bil a partir do campo         ���
���          � C1_NUMOS                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHCOM059()
Local nProd  := 0
Local nNumOs := 0
Local cConta := ''

	If alltrim(upper(funname()))$"MATA110"
		nProd  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_PRODUTO"})  
		nNumOs := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C1_NUMOS"})     
	ElseIf alltrim(upper(funname()))$"MATA120/MATA121"
		nProd  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_PRODUTO"})  
		nNumOs := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "C7_NUMOS"})     
	Else
		return ''
	ENDIF
      
	//-- OS Portal N�: 025933
	If ReadVar()$'M->C1_NUMOS/M->C7_NUMOS'
		cNumOs := &(ReadVar())
	Else
		cNumOs := aCols[n][nNumOs]
	Endif

	If SUBSTR(cNumOs,1,2)$'MM'

		aOldSB1 := SB1->(GetArea())
		
		SB1->(dbsetorder(1))
		SB1->(dbseek(xFilial("SB1")+aCols[n][nProd]))
		If Substr(SB1->B1_GRUPO,1,2)$"SA"
			cConta := '401030010010'
		ElseIf Substr(SB1->B1_GRUPO,1,2)$"MM/IC"
			cConta := '401020020003'
		Endif
		
		SB1->(RestArea(aOldSB1))
	Else
		cConta := Posicione("ZA1",1,xFilial("ZA1")+Substr(cNumOs,1,6),"ZA1_CONTA")
	EndIf
	//-- fim os 025933

Return cConta