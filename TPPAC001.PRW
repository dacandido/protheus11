#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TPPAC001 � Autor � HANDERSON DUARTE   � Data �  11/12/08   ���
�������������������������������������������������������������������������͹��
���Descricao � CADASTRO DAS DEFINI��ES DE EMBALAGEM.                      ���
���          � TABELA ZC3 MSSQL                                           ���
�������������������������������������������������������������������������͹��
���Uso       � MP10 - WHB s                                                ���
�������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������͹��
���Obs       �                                                            ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TPPAC001()
Local aCores := {}
AADD(aCores, {"	!ZC3_STAREV"						      						,"BR_PRETO" })   //Revis�o obsoleta
AADD(aCores, {"	ZC3_STATUS=='A'"       					  						,"BR_VERDE"})    //Aprovado
AADD(aCores, {"	ZC3_STATUS=='R'"						  					    ,"DISABLE" })   //Reprovado
AADD(aCores, {"	ZC3_STAREV	.AND. (Empty(ZC3_APROV) .OR. ZC3_APROV=='2')"       ,"BR_AMARELO" }) //Pendente, Aguardando revis�o ou aprovacao

/*    Alterado 20090812 a pedido da Debora para que o campo que controla a aprova��o seja

Local aCores := {{"	ZC3_STAREV	.AND. (Empty(ZC3_APROV) .OR. ZC3_APROV=='2')"       ,"BR_AMARELO" },;           //Pendente, Aguardando revis�o ou aprovacao
{"	!ZC3_STAREV"						      						,"BR_PRETO" },;                //Revis�o obsoleta
{"ZC3_APROV=='1'"       					  						,"BR_VERDE"},;                //Aprovado
{"ZC3_APROV=='3'" 						  						    ,"DISABLE" }}                //Reprovado
*/

Private cCadastro := "Descritivo de Embalagem"

Private cCargo:="{"+Getmv("WHB_CARGO")+"}"
Private cDepart:="{"+Getmv("WHB_DPTO")+"}"
Private aCargo:=&cCargo   //Cagos autorizados a aprovar e geras revis�es
Private aDepart:=&cDepart//Departamentos autorizados a aprovar e geras revis�es

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar"	,"AxPesqui"			,0,1} ,;
{"Visualizar"	,"AxVisual"			,0,2} ,;
{"Incluir"		,"U_PPAC001A (3)"	,0,3} ,;
{"Alterar"		,"U_PPAC001B (4)"	,0,4} ,;
{"Excluir"		,"U_PPAC001E (5)"	,0,5} ,;
{"Gerar Revisao","U_PPAC001C (6)"	,0,6} ,;
{"Aprovar/Reprovar","U_PPAC001D (7)"	,0,7},;
{"Imprimir"	,"U_TPPAR001 ()"	,0,8},;
{"Legenda		","U_PPAC001H"	,0,9}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZC3"

dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString,,,,,,aCores)

Return
//===========================Funcao que Monta a Legenda=============================================
User Function PPAC001H()
BrwLegenda( cCadastro , "Legenda" ,{{"BR_AMARELO"    	,"Pendente" },;
{"BR_VERDE"    		,"Aprovado"	},;
{"DISABLE"    		,"Reprovado"},;
{"BR_PRETO"   		,"Obsoleto" }})

Return .T.
//================================================================================================
//===============================Incluir Registros================================================
User Function PPAC001A (nOpc)

AxInclui( cString,,,,,,"U_PPAC001F  ("+AllTrim(Str(nOpc))+")",,,)


Return ()
//==========================Fim da Incluis�o de Registros==========================================
//===============================Alterar Registros=================================================
User Function PPAC001B (nOpc)
local lRet := ''
If Empty(DtoS(ZC3->ZC3_DATAF)) .AND. ZC3->ZC3_STAREV
//If ZC3->ZC3_STAREV	.AND. (!Empty(ZC3->ZC3_DTENG) .OR. !Empty(ZC3->ZC3_DTQUA) .OR. !Empty(ZC3->ZC3_DTPROD) .OR. !Empty(ZC3->ZC3_DTAPR))
	lRet :=  (AxAltera(cString,,nOpc,,,,,"U_PPAC001F  ("+AllTrim(Str(nOpc))+")",,,))
Else
	MsgAlert("O registro n�o pode ser alterado, pois j� existe uma data fim ou � uma revis�o obsoleta","TPPAC001->PPAC001B("+AllTrim(Str(nOpc))+") Altera��o")
EndIf  

Return (lRet)
//==========================Fim da Altera��o de Registros==========================================
//===============================Gerar Vers�o     =================================================
User Function PPAC001C (nOpc)
Local 	lRet		:=	.F.
Local 	cTexto		:=	""
Local 	cTitulo		:=	""
Local 	nRecNo		:=	ZC3->(RecNo())
Local	nRecNoAtu	:=	0
Local 	aAreaZC3	:=	ZC3->(GetArea())
Local 	bCampo   	:= 	{ |nCPO| Field(nCPO) }
Private	aStru		:=	ZC3->(DbStruct())
Private	cNomArq 	:=	""
cNomArq 			:=	CriaTrab(aStru,.T.)

If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
dbUseArea(.T.,,cNomArq,"TRB",.F.,.F.)
dbClearIndex()

//If !Empty (DtoS(ZC3->ZC3_DATAF)) .AND. ZC3->ZC3_STAREV //S� poder� gerar revis�o se tiver data fim e com a revis�o atual
If ZC3->ZC3_STAREV .AND. (!Empty(ZC3->ZC3_DTENG) .OR. !Empty(ZC3->ZC3_DTQUA) .OR. !Empty(ZC3->ZC3_DTPROD) .OR. !Empty(ZC3->ZC3_DTAPR))
	dbSelectArea("ZC3")
	ZC3->(DBGoTo(nRecNo))
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	For nCont:=1 to Len(aStru)
		TRB->&(aStru[nCont][1]) := ZC3->&(aStru[nCont][1])
	Next nCont
	TRB->ZC3_REV	:=	sfRevisao (ZC3->ZC3_NUMEMB)//Nova Revis�o
	TRB->ZC3_DATAF	:=  StoD(" / / ")
	TRB->ZC3_APROV	:=	""
	TRB->ZC3_STAREV	:=	.T.
	TRB->ZC3_APRFIM	:=	""
	TRB->ZC3_MOTIVO	:=	""
	TRB->ZC3_DTREV	:=	dDataBase
	TRB->ZC3_STATUS	:=	""
	TRB->ZC3_DTENG	:=	StoD(" / / ")
	TRB->ZC3_DTQUA	:=	StoD(" / / ")
	TRB->ZC3_DTPROD	:=	StoD(" / / ")
	TRB->ZC3_DTAPR	:=	StoD(" / / ")
	TRB->(MsUnLock())
	
	BEGIN TRANSACTION
	TRB->(DBGotop())
	dbSelectArea("ZC3")
	ZC3->(dbSetOrder(3))//ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV+ZC3_APROV
	If !ZC3->(DBSeek(xFilial("ZC3")+TRB->(ZC3_NUMEMB+ZC3_REV)))
		lRet:=RecLock("ZC3",.T.)
		If lRet
			For nCont := 1 TO FCount()
				FieldPut(nCont,TRB->&(EVAL(bCampo,nCont)))
			Next nCont
			ZC3->ZC3_FILIAL := TRB->ZC3_FILIAL
		EndIf
		nRecNoAtu:=ZC3->(RecNo())
		ZC3->(MsUnLock())
		
		dbSelectArea("ZC3") //Atualiza o registro como ves�o n�o atual
		ZC3->(DBGoTo(nRecNo))
		lRet:=RecLock("ZC3",.F.)
		If lRet
			ZC3->ZC3_STAREV	:=	.F.
		EndIf
		ZC3->(MsUnLock())
		
	Else
		lRet:=.F.
	EndIf
	If !lRet
		DisarmTransaction()
		RollBackSX8()
		cTitulo:="TPPAC001->PPAC001C("+AllTrim(Str(nOpc))+") Revis�o"
		cTexto:="Erro ao gerar a revis�o, verifique se h� algum usu�rio realizado altera��es no registro"
	Else
		cTitulo:="TPPAC001->PPAC001C("+AllTrim(Str(nOpc))+") Revis�o"
		cTexto:="Revis�o gerada com sucesso"
	EndIf
	END TRANSACTION
	
	If ! lRet
		MsgAlert(cTexto,cTitulo)
	Else
		ZC3->(DBGoTo(nRecNoAtu))
		//		MsgAlert(cTexto,cTitulo)
		If U_PPAC001B(6) == 3		//CHAMA A ROTINA DE ALTERA��O PARA REVIS�ES
			RecLock("ZC3",.F.) 
				DbDelete()
			ZC3->(MsUnLock()) 
			
			ZC3->(DBGoTo(nRecNo))    
			RecLock("ZC3",.F.) 
				ZC3->ZC3_STAREV := .T.
			ZC3->(MsUnLock())
		EndIf 
	EndIf
Else
//	MsgAlert("S� poder� ser gerada a revis�o caso o registro tenha data fim ou n�o seja uma revis�o obsoleta ","TPPAC001->PPAC001C("+AllTrim(Str(nOpc))+") Revis�o")
	MsgAlert("S� poder� ser gerada a revis�o caso n�o seja uma revis�o obsoleta ","TPPAC001->PPAC001C("+AllTrim(Str(nOpc))+") Revis�o")
EndIf

If(Select("TRB")<>0)
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
FeRase(cNomArq+GetdbExtension())
RestArea(aAreaZC3)

Return ()
//==========================Fim da Gera��o de Vers�o     ==========================================
//===============================Aprova��o de Registros ===========================================
User Function PPAC001D (nOpc)//7
Local nRecNo	:=	ZC3->(RecNo())
Local aUser	 	:= {}
Local aAreaQAA	:=	QAA->(GetArea())
Local lFlag		:=	.T.

If (Empty(ZC3->ZC3_APROV) .OR. AllTrim(ZC3->ZC3_APROV)=="2" .OR. AllTrim(ZC3->ZC3_APROV)=="3" ) .AND. ZC3->ZC3_STAREV .AND. ZC3->ZC3_STATUS <> 'R' 
//S� poder� ser aprovado caso o pedido que ainda n�o esteja aprovado
	PswOrder(1)
	If PswSeek( __cuserid, .T. )
		aUser := PswRet() // Retorna vetor com informa��es do usu�rio
	EndIf

	DBSelectArea("QAA")
	DBSetOrder(6)//QAA_LOGIN
	If QAA->(DBSeek(aUser[1][2]))

		Do While QAA->(!EoF()) .AND. ALLTRIM(QAA->QAA_LOGIN)==AllTrim(aUser[1][2]) .AND. lFlag
			If !Empty(AScan(aDepart,ALLTRIM(QAA->QAA_CC))) .AND. !Empty(AScan(aCargo,ALLTRIM(QAA->QAA_CODFUN)))		
				lFlag:=.F.
				U_PPAC001G(nRecNo,sfOpcao (),QAA->QAA_MAT,QAA->QAA_EMAIL) //Reprovar
			EndIf
			QAA->(DBSkip())
		EndDo
	Else
		MsgStop("Usu�rio sem permiss�o para aprovar o documento.","TPPAC001->PPAC001D("+AllTrim(Str(nOpc))+") Aprova��o")
	EndIf
Else
	MsgAlert("S� poder� ser alterado caso o Descritivo ainda n�o esteja aprovado ou que seja uma revis�o atualizada",;
	"TPPAC001->PPAC001D("+AllTrim(Str(nOpc))+") Descritivo Aprovado")
EndIf

RestArea(aAreaQAA)

Return ()
//==========================Fim da Aprova��o de Registros==========================================
//=================================================================================================
Static Function sfOpcao ()

/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/
Private nRMenu :=1

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlg","oRMenu","oBtn")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlg       := MSDialog():New( 088,232,240,536,"Defini��o para o Documento",,,.F.,,,,,,.T.,,,.T. )
GoRMenu    := TGroup():New( 004,004,056,144,"Op��es",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oRMenu     := TRadMenu():New( 008,010,{"Aprovacao","Aprovado Temporariamente","Reprovado"},{|u| If(PCount()>0,nRMenu:=u,nRMenu)},oDlg,,,CLR_BLACK,CLR_WHITE,"",,,120,17,,.F.,.F.,.T. )
oRMenu     := TRadMenu():New( 018,010,{"Aprovar","Reprovar"},{|u| If(PCount()>0,nRMenu:=u,nRMenu)},oDlg,,,CLR_BLACK,CLR_WHITE,"",,,120,17,,.F.,.F.,.T. )
oBtn       := TButton():New( 060,004,"OK",oDlg,{|| oDlg:End()},037,012,,,,.T.,,"",,,,.F. )

oDlg:Activate(,,,.T.)

Return (nRMenu)
//=================================================================================================
//===============================Exlcus�o de Registros=============================================
User Function PPAC001E (nOpc)
/*
Local nRecNo	:=	ZC3->(RecNo())
Local lRet		:=	U_PPAC001F  (nOpc)
If lRet
AxDeleta(cString,nRecNo,nOpc,,,,,)
EndIf
*/

MsgStop("N�o � permitito excluir os registros","TPPAC001->PPAC001E("+AllTrim(Str(nOpc))+")")
Return ()
//==========================Fim da Exclus�o de Registros ==========================================
//================================APROVA��O OU REPROVA��O DO PEDIDO================================
User Function PPAC001G (nRecNo,nOpc,cMatr,cEMailRem)
Local aAreaZC3	:= 	ZC3->(GetArea())
Local cMensagem	:=	""
Local cEMail	:=	""

Local lFlag		:=	.T.
Local cNUMQUA	:=	""
Local cREVQUA	:=	""
Local nSeq		:=	1//Sequ�ncia das perguntas
Local cTexto	:=	""
Local cTitulo	:=	""
dbSelectArea("ZC3")
ZC3->(DBSetOrder(3))
ZC3->(DBGoTo(nRecNo))
cNUMEMB	:=	ZC3->ZC3_NUMEMB
cREVEMB	:=	ZC3->ZC3_REV

//BEGIN TRANSACTION
//Do Case
If ZC3->ZC3_APENG==cMatr
	nSeq:=1
	If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB+cREVEMB))
		If Empty(DtoS(ZC3->ZC3_DTENG))
			//Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB+StrZero(nSeq,2)) .AND. lFlag
			Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC3",.F.)
				ZC3->ZC3_DTENG	:= dDataBase
				ZC3->(MsUnLock())
				ZC3->(DBSkip())
			EndDo
		Else
			lFlag:=.F.
			cTexto:="O Registro j� foi aprovada pela Produ��o e n�o poder� ser alterada a data da mesma"
			cTitulo:="Aprova��o"
		EndIf
	Else
		lFlag:=.F.
		cTexto:="Falha na persist�ncia dos dados, Verificar se h� outro usu�rio utilizando o mesmo registro"
		cTitulo:="Aprova��o"
	EndIf
EndIf

dbSelectArea("ZC3")
ZC3->(DBSetOrder(3))
ZC3->(DBGoTo(nRecNo))

If ZC3->ZC3_APQUA==cMatr
	nSeq:=1
	If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB+cREVEMB))
		If Empty(DtoS(ZC3->ZC3_DTQUA))
			//Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB+StrZero(nSeq,2)) .AND. lFlag
			Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC3",.F.)
				ZC3->ZC3_DTQUA	:=dDataBase
				ZC3->(MsUnLock())
				ZC3->(DBSkip())
			EndDo
		Else
			lFlag:=.F.
			cTexto:="O Registro j� foi aprovada pela Produ��o e n�o poder� ser alterada a data da mesma"
			cTitulo:="Aprova��o"
		EndIf
	Else
		lFlag:=.F.
		cTexto:="Falha na persist�ncia dos dados, Verificar se h� outro usu�rio utilizando o mesmo registro"
		cTitulo:="Aprova��o"
	EndIf
EndIf

dbSelectArea("ZC3")
ZC3->(DBSetOrder(3))
ZC3->(DBGoTo(nRecNo))

If ZC3->ZC3_APPROD==cMatr
	nSeq:=1
	If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB+cREVEMB))
		If Empty(DtoS(ZC3->ZC3_DTPROD))
			//Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB+StrZero(nSeq,2)) .AND. lFlag
			Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC3",.F.)
				ZC3->ZC3_DTPROD	:=dDataBase
				ZC3->(MsUnLock())
				ZC3->(DBSkip())
			EndDo
		Else
			lFlag:=.F.
			cTexto:="O Registro j� foi aprovada pela Produ��o e n�o poder� ser alterada a data da mesma"
			cTitulo:="Aprova��o"
		EndIf
	Else
		lFlag:=.F.
		cTexto:="Falha na persist�ncia dos dados, Verificar se h� outro usu�rio utilizando o mesmo registro"
		cTitulo:="Aprova��o"
	EndIf
EndIf

dbSelectArea("ZC3")
ZC3->(DBSetOrder(3))
ZC3->(DBGoTo(nRecNo))

If ZC3->ZC3_APLOG==cMatr
	nSeq:=1
	If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB+cREVEMB))
		If Empty(DtoS(ZC3->ZC3_DTAPR))
			//Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB+StrZero(nSeq,2)) .AND. lFlag
			Do While ZC3->(!EoF()) .AND. ZC3->(ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV) == (xFilial("ZC3")+cNUMEMB+cREVEMB) .AND. lFlag
				nSeq++
				lFlag:=RecLock("ZC3",.F.)
				ZC3->ZC3_DTAPR	:=dDataBase
				ZC3->(MsUnLock())
				ZC3->(DBSkip())
			EndDo
		Else
			lFlag:=.F.
			cTexto:="O Registro j� foi aprovada pela Produ��o e n�o poder� ser alterada a data da mesma"
			cTitulo:="Aprova��o"
		EndIf
	Else
		lFlag:=.F.
		cTexto:="Falha na persist�ncia dos dados, Verificar se h� outro usu�rio utilizando o mesmo registro"
		cTitulo:="Aprova��o"
	EndIf
EndIf

/*
OtherWise
lFlag:=.F.
cTexto:="Usu�rio n�o faz parte do documento. A opera��o n�o proder� ser gravada."
cTitulo:="Aprova��o"

EndCase
*/
Do Case
	Case nOpc==1//Aprova��o
		dbSelectArea("ZC3")
		ZC3->(DBGoTo(nRecNo))
		RecLock("ZC3",.F.)
		//ZC3->ZC3_DATAF 		:=dDataBase
		//ZC3->ZC3_APROV		:="1"
		If !Empty(ZC3->ZC3_DTENG) .AND. !Empty(ZC3->ZC3_DTQUA) .AND. !Empty(ZC3->ZC3_DTPROD) .AND. !Empty(ZC3->ZC3_DTAPR)
			ZC3->ZC3_STATUS := 'A'
		EndIf
		ZC3->(MsUnLock())
		/*
		Case nOpc==2//Aproca��o Tempor�ria
		dbSelectArea("ZC3")
		ZC3->(DBGoTo(nRecNo))
		RecLock("ZC3",.F.)
		//ZC3->ZC3_DATAF 		:=dDataBase
		//ZC3->ZC3_APROV		:="2"
		ZC3->(MsUnLock())
		*/
	Case nOpc==2//Reprova��o
		dbSelectArea("ZC3")
		ZC3->(DBGoTo(nRecNo))
		RecLock("ZC3",.F.)
			ZC3->ZC3_STATUS := 'R'
		ZC3->(MsUnLock())
		While Empty(cMensagem)	 
			Alert('O preenchimento da Justificativa de Reprova��o � obrigatorio!')	
			cMensagem:=sfJustif ( )	//chamada da tela de justificativa
		EndDo
		//Grava na tabela de justificativas
		dbSelectArea("ZC3")
		ZC3->(DBGoTo(nRecNo))
		RecLock("ZCC",.T.)
		ZCC->ZCC_FILIAL	:=	xFilial("ZCC")
		ZCC->ZCC_CODDOC	:=	ZC3->ZC3_NUMEMB
		ZCC->ZCC_REV	:=	ZC3->ZC3_REV
		ZCC->ZCC_TABELA	:=	"ZC3"
		ZCC->ZCC_TEXTO	:=	cMensagem
		ZCC->ZCC_DATA	:=	dDataBase
		ZCC->ZCC_USUAR	:=	ZC3->ZC3_APRFIM
		ZCC->(MsUnLock())
		
		cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APRFIM,"QAA_EMAIL")
		//Chamada da func�o do e-mail
		//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
		cMensagem:=sfTexto("Reprova��o Descritivo de Embalagem",ZC3->ZC3_NUMEMB,ZC3->ZC3_REV,cMatr,cMensagem)//Para HTML
		If !Empty(cEMail)
			U_TWHBX001 (cMensagem,"Reprova��o Descritivo de Embalagem"+ZC3->ZC3_NUMEMB ,cEMail,cEMailRem,)
		EndIf
		
		
EndCase
//END TRANSACTION
RestArea(aAreaZC3)
Return( )
//========================FIM DA  APROVA��O OU REPROVA��O DO PEDIDO================================
//=================================================================================================
/*------------------------------------------------------------\
| Valida��o para Inclus�o, Altera��o, Excluir dos Registros	  |
\------------------------------------------------------------*/
User Function PPAC001F (nOpc)
Local lRet		:=	.T.
Local nRecNo	:=	IIF((nOpc==4 .OR. nOpc==6),ZC3->(RECNO()),0) //S� para altera��o de registro ou Altera��o para nova revis�o.
Local aAreaZC3	:= 	ZC3->(GetArea())
Local nContReg	:=	0//Contador de Registros
Local cEMail	:=	""
Local aUser		:=	{}

PswOrder(1)
If PswSeek( __cuserid, .T. )
	aUser := PswRet() // Retorna vetor com informa��es do usu�rio
EndIf

Do Case
	Case nOpc==3//Inclus�o
		DBSelectArea("ZC3")
		ZC3->(DBGoTop())
		DBSetOrder(1)//ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV
		If ZC3->(DBSeek(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)))
			lRet:=.F.
			MsgAlert("J� Existe registro para o cliente com o respectivo produto. Embalagem: "+ZC3->ZC3_NUMEMB,;
			"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Embalagem j� cadastrada")
		Else
			lRet:=.T.
		EndIf
		
	Case nOpc==4//Altera��o
		If Empty(M->ZC3_APROV) .OR. AllTrim(M->ZC3_APROV)=="2" .OR. AllTrim(M->ZC3_APROV)=="3"//S� poder� ser alterado caso o pedido que ainda n�o esteja aprovado
			DBSelectArea("ZC3")
			ZC3->(DBGoTop())
			DBSetOrder(1)//ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV
			If ZC3->(DBSeek(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)))
				Do While ZC3->(!EoF()) .AND. (ZC3->(ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)) == ;
					(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)) .AND. lRet
					
					If	nRecNo <> ZC3->(RECNO())
						lRet:=.F.
						MsgAlert("J� Existe registro para o cliente com o respectivo produto. Embalagem: "+ZC3->ZC3_NUMEMB,;
						"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Embalagem j� cadastrada")
					Else
						lRet:=.T.
					EndIF
					ZC3->(DBSkip())
				EndDo
			Else
				lRet:=.T.
			EndIf//Fim do DBSeek
		Else
			lRet:=.F.
			MsgAlert("S� poder� ser alterado caso a embalagem ainda n�o esteja aprovada.",;
			"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Embalagem aprovada")
		EndIf
		If lRet//Enviar um e-mail ao respons�vel
			cEMail	:=	Posicione("QAA",1,xFilial("QAA")+ZC3->ZC3_APRFIM,"QAA_EMAIL")
			cMensagem:=sfTexto("Altera��o Descritivo de Embalagem",ZC3->ZC3_NUMEMB,ZC3->ZC3_REV,Posicione("QAA",6,aUser[1][2],"QAA_MAT"),"Altera��o Descritivo de Embalagem")//Para HTML
			If !Empty(cEMail)
				//Chamada da func�o do e-mail
				//		TWHBX001 (cMensagem,cTitulo,cDestinat,cRemetente,cArquivos)
				U_TWHBX001 (cMensagem,"Altera��o Descritivo de Embalagem"+ZC3->ZC3_NUMEMB ,cEMail,,)
			EndIf
		EndIf
		
	Case nOpc==5//Excluir
		If Empty(ZC3->ZC3_APRFIM) .AND. ZC3->ZC3_REV=="00"
			lRet:=.T.
		Else
			lRet:=.F.
			MsgAlert("O Descritivo em quest�o n�o pode ser exclu�do, pois h� assinatura ou/e a revis�o � maior que '00'.",;
			"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Descritivo n�o pode ser exclu�do")
		EndIf
		
	Case nOpc==6// Gerar Revis�o
		If !Empty(M->ZC3_MOTIVO) //Para novas revis�o � obrigat�rio preencher o motivo da revis�o
			If Empty(M->ZC3_APROV)//S� gera revis�o se o descritivo esteja aprovado ou aprovado temporariamente
				DBSelectArea("ZC3")
				ZC3->(DBGoTop())
				DBSetOrder(1)//ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV
				If ZC3->(DBSeek(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)))
					Do While ZC3->(!EoF()) .AND. (ZC3->(ZC3_FILIAL+ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)) == ;
						(xFilial("ZC3")+M->(ZC3_CODCLI+ZC3_LOJACL+ZC3_CODWHB+ZC3_REV)) .AND. lRet
						
						If	nRecNo <> ZC3->(RECNO())
							lRet:=.F.
							MsgAlert("J� Existe registro para o cliente com o respectivo produto. Embalagem: "+ZC3->ZC3_NUMEMB,;
							"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Revis�o")
						Else
							lRet:=.T.
						EndIF
						ZC3->(DBSkip())
					EndDo
				Else
					lRet:=.T.
				EndIf//Fim do DBSeek
			Else
				lRet:=.F.
				MsgAlert("S� poder� ser alterado caso o descritivo ainda n�o tenha aprova��o.",;
				"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Revis�o")
			EndIf
		Else
			lRet:=.F.
			MsgAlert("O Campo Motivo da Revis�o � obrigat�rio.",;
			"TPPAC001->PPAC001F("+AllTrim(Str(nOpc))+") Revis�o")
		EndIf
		
EndCase

RestArea(aAreaZC3)
Return(lRet)
//=================================================================================================
//================================REVIS�O =========================================================
Static Function sfRevisao (cNUMEMB)
Local cRet		:=	""
Local aAreaZC3	:=	ZC3->(GetArea())
DBSelectArea("ZC3")
ZC3->(DBGoTop())
DBSetOrder(3)//ZC3_FILIAL+ZC3_NUMEMB+ZC3_REV+ZC3_APROV
If ZC3->(DBSeek(xFilial("ZC3")+cNUMEMB))
	Do While ZC3->(!EoF()) .AND. (ZC3->(ZC3_FILIAL+ZC3_NUMEMB)) == (xFilial("ZC3")+(cNUMEMB))
		cRet:=ZC3->ZC3_REV
		ZC3->(DBSkip())
	EndDo
EndIf//Fim do DBSeek
cRet:=StrZero(Val(cRet)+1,2)//Nova Revis�o
RestArea(aAreaZC3)
Return (cRet)
//================================FIM DA REVIS�O ==================================================
//================================JUSTIFICATIVA DA REPROVA��O======================================
Static Function sfJustif ( )

/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/
Private cGetTexto  := ""

/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlgEmail","oGetTexto","oBtnEnviar","oGetMemo")

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlgEmail  := MSDialog():New( 168,253,451,948,"Justificativa da Reprova��o",,,.F.,,,,,,.T.,,,.T. )
//oGetTexto  := TGet():New( 020,004,{|u| If(PCount()>0,cGetTexto:=u,cGetTexto)},oDlgEmail,336,114,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGetTexto",,)
@ 020,004 GET cGetTexto MEMO SIZE 336,114 OF oDlgEmail PIXEL HSCROLL
oBtnEnviar := TButton():New( 004,292,"Enviar",oDlgEmail,{||oDlgEmail:End()},037,012,,,,.T.,,"",,,,.F. )

oDlgEmail:Activate(,,,.T.)
Return (cGetTexto)
//================================FIM DA REPROVA��O================================================
//================================TEXTO JUSTIFICATIVA =============================================
Static Function sfTexto(cTitulo,cNum,cRev,cMatr,cTexto)
Local cHTML		:=	""
Local nCont		:=	0
Local cLinhaObs	:=	""
cHTML	+='<html >'
cHTML	+='<head>'
cHTML	+='<style type="text/css">'
cHTML	+='<!--'
cHTML	+='.style1 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 24px;'
cHTML	+='}'
cHTML	+='.style2 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 14px;'
cHTML	+='}'
cHTML	+='.style3 {font-family: Arial, Helvetica, sans-serif}'
cHTML	+='.style5 {'
cHTML	+='	font-family: Arial, Helvetica, sans-serif;'
cHTML	+='	font-size: 12px;'
cHTML	+='}'
cHTML	+='.style8 {font-family: Arial, Helvetica, sans-serif; font-size: 10px; }'
cHTML	+='-->'
cHTML	+='</style></head>'

cHTML	+='<body>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><div align="center"><strong><span class="style1">'+cTitulo+' '+cNum+'-'+cRev+'</span></strong></div></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td width="497"><strong><span class="style2">Justificativa:</span></strong></td>'
cHTML	+='  </tr>'
cHTML	+='  <tr>'
cHTML	+='    <td height="142"><div align="left">'
For nCont := 1 to MLCount( cTexto , 90 )
	cLinhaObs	:=Memoline( cTexto ,90, nCont )
	cHTML	+='      <p class="style3">'+cLinhaObs+'</p>'
Next nCont
cHTML	+='      <p class="style3">&nbsp;</p>'
cHTML	+='    </div></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="508" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td width="115" class="style5">Respons�vel</td>'
cHTML	+='    <td width="377"><span class="style5">'+Posicione("QAA",1,xFilial("QAA")+cMatr,"QAA_NOME")+' </span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<table width="507" border="1">'
cHTML	+='  <tr>'
cHTML	+='    <td><span class="style8">Mensagem autom�tica do sistema Protheus. Favor n�o responder</span></td>'
cHTML	+='  </tr>'
cHTML	+='</table>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='<p>&nbsp;</p>'
cHTML	+='</body>'
cHTML	+='</html>'
Return(cHTML)

//================================FIM DO TEXTO JUSTIFICATIVA =============================================

