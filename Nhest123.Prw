/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHEST123        � Jo�o Felipe da Rosa   � Data �23/07/2008���
������������������������������������������������������������������������Ĵ��
���Descricao � Verifica se usu�rio tem permiss�o para alterar o campo    ���
���          � B1_ESTSEG  no SX5 tabela ZF ->login(16)pastas "1/2"(10)   ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#INCLUDE "rwmake.ch"

User Function Nhest123()


//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local lOK       := .F.

IF M->B1_TIPO == "FE"

	SX5->(DbGotop())
	SX5->(DbSetOrder(1))
	SX5->(DbSeek(xFilial("SX5")+"ZF")) // Tabela de valida��o de Usuarios, para alterar o produto por FOLDER
	While !SX5->(Eof()) .And. SX5->X5_TABELA == "ZF"
	   If Alltrim(Substr(SX5->X5_DESCRI,1,16)) == Upper(Alltrim(cUserName)) //Verifica se o Usuario � o mesmo da tabela ZF no SX5
	      lOK := .T. //Flag de Controle          
	      Exit //achou for�a a saida
	   Endif
	   SX5->(DbSkip())
	Enddo

	Return(lOk)  // retorna
ENDIF

Return(.T.)