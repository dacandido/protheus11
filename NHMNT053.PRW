/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHMNT053  �Autor  �Jo�o Felipe da Rosa � Data �  08/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Substitui a funcao OCORMOSTRA da NGI                       ���
���          � Utilizada para validar os campos da tabela STN no SX3      ���
�������������������������������������������������������������������������͹��
���Uso       � manutencao                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHMNT053(cCOD)
Local nDDefe := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "TN_CODOCOR"})
Local nDCaus := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "TN_CAUSA"})
Local nDSolu := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "TN_SOLUCAO"})

Local cMens := "Codigo invalido para "
Local cCabT := "NAO CONFORMIDADE"
Local cTipo := "problema"
lret := .T.

IF !ST8->(DbSeek(XFILIAL("ST8") + cCOD))
   lRet := .F.
Elseif readvar() == 'M->TN_CODOCOR'
   If ST8->T8_TIPO <> "P"
      MsgInfo(cMens+cTipo,cCabT)
      lRet := .F.
   Else    
      aCols[n][nDDefe+1] := SubStr(ST8->T8_NOME,1,20)
   EndIf   
Elseif readvar() == 'M->TN_CAUSA'
   If ST8->T8_TIPO <> "C" 
      cTipo := "causa"
      MsgInfo(cMens+cTipo,cCabT)
      lRet := .F.
   Else   
      aCols[n][nDCaus+1] := SubStr(ST8->T8_NOME,1,20)
   EndIf   
Elseif readvar() == 'M->TN_SOLUCAO'
   If ST8->T8_TIPO <> "S" 
      cTipo := "solucao"
      MsgInfo(cMens+cTipo,cCabT)
      lRet := .F.
   Else
      aCols[n][nDSolu+1] := SubStr(ST8->T8_NOME,1,20)
   EndIf
EndIf

Return lRET