
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA242V   �Autor  �Alexandre R. Bento  � Data � 01/02/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. chamado logo ap�s a confirma��o da digita��o da tela  ���
���          � de desmonte de produto  Deve retornar verdadeiro ou falso  ���
���          � para validar a data do desmonte.                           ���
�������������������������������������������������������������������������͹��
���Uso       � MTA242V - desmonte de produtos                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function MTA242V

Local _lRet := .T.
                       
If (DEMIS260 > Ddatabase)
   MSGBOX("A Data de Emissao esta Maior que a Data do Sistema Verifique !!!!!"+chr(13)+;
          " Este Documento nao Sera Incluido ", "Atencao Data Errada","STOP")
   _lRet := .F.
Endif

Return(_lRet)