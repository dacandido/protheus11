/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHVLD002 � Autor � Alexandre R. Bento    � Data � 23/04/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validacao das linhas do Cadastro das EPI'S                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Execblock usado do programa NHEST023                       ���
�������������������������������������������������������������������������Ĵ��
��� Arquivos � SZ7                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


#include "rwmake.ch" 

User Function Nhvld002() 

SetPrvt("_LRET,_CNOME,_cAux")

_lRet := .t.     
 
_cAux := Alltrim(_cMatr)

If Len(_cAux) < 6 
	If Val(_cAux) > 7000
	   _cAux  := "9"+StrZero(Val(_cMatr),5)
   	_cMatr := _cAux
	Else
	   _cAux  := StrZero(Val(_cMatr),6)
   	_cMatr := _cAux
	Endif
Endif                                  

//QAA - ARQUIVOS DE USUARIOS
QAA->(DbSetOrder(1)) //filial matricula
QAA->(DbSeek(xFilial("QAA")+_cMatr))

IF ExistCpo("QAA")
   _cNome := QAA->QAA_NOME
ELSE
   _lRet := .f.
ENDIF   

Return(_lRet)
