/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � NHEST107  � Autor � Jo�o Felipe da Rosa    Data �11/01/08  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lan�amento de Produ��o                                     ���
�������������������������������������������������������������������������Ĵ��                                                                               
���Sintaxe   � Rdmake                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Expedi��o/ PCP /                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function NHEST107()

SetPrvt("CCADASTRO,AROTINA,aHeader,aCols,nPar,_cNum")

cCadastro := OemToAnsi("Apontamento de Produ��o")
aRotina := {{ "Pesquisa"     ,'AxPesqui'        , 0 , 1},;
            { "Visualizar"   ,'U_fEST107(1)'    , 0 , 2},;
            { "Incluir"      ,'U_fEST107(2)'    , 0 , 3},;
            { "Alterar"      ,'U_fEST107(3)'    , 0 , 4},;
            { "Complementar" ,'U_fEST107(5)'    , 0 , 3},;
            { "Excluir"      ,'U_fEST107(4)'    , 0 , 5},;
            { "Relat�rio"    ,'U_EST107Rel()'   , 0 , 2}}

mBrowse( 6, 1,22,75,"ZAU",,,,,,)

Return 

/*������������������������������Ŀ
/� FUNCAO PRINCIPAL              �
/�������������������������������*/
User Function fEST107(nParam)
  
DEFINE FONT oFont NAME "Arial" SIZE 10, -12
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10

nPar      := nParam
aHeader   := {}        
aCols     := {}
_dDt	  := Date()-1
aItmCompl := {}

If nPar == 2//inclui
	_cNum := GetSXENum("ZAU","ZAU_NUM")			// Traz o novo numero dO ACOMPANHAMENTO DE PRODUCAO
EndIf

AaDD(aHeader,{"Item"         , "ZAG_ITEM"    ,"@!"	     ,04 ,0,".F.","","C","ZAG"})
Aadd(aHeader,{"Peca"         , "ZAG_PROD"    ,"@!"	     ,15 ,0,"U_EST107PRD()","","C","ZAG"})
Aadd(aHeader,{"Desc"         , "ZAG_DESC"    ,"@!"	     ,30 ,0,".F.","","C","ZAG"})
Aadd(aHeader,{"T1 Op 10"     , "ZAG_OP101"   ,"@E 9999"	 ,04 ,0,"U_EST107T(4)" ,"","N","ZAG"})
Aadd(aHeader,{"T1 Gargalo"   , "ZAG_GARG1"   ,"@E 9999"	 ,04 ,0,"U_EST107T(5)" ,"","N","ZAG"})
Aadd(aHeader,{"T1 Embalado"  , "ZAG_EMBAL1"  ,"@E 9999"	 ,04 ,0,"U_EST107T(6)" ,"","N","ZAG"})
Aadd(aHeader,{"T2 Op 10"     , "ZAG_OP102"   ,"@E 9999"	 ,04 ,0,"U_EST107T(7)" ,"","N","ZAG"})
Aadd(aHeader,{"T2 Gargalo"   , "ZAG_GARG2"   ,"@E 9999"	 ,04 ,0,"U_EST107T(8)" ,"","N","ZAG"})
Aadd(aHeader,{"T2 Embalado"  , "ZAG_EMBAL2"  ,"@E 9999"	 ,04 ,0,"U_EST107T(9)" ,"","N","ZAG"})
Aadd(aHeader,{"T3 Op 10"     , "ZAG_OP103"   ,"@E 9999"	 ,04 ,0,"U_EST107T(10)","","N","ZAG"})
Aadd(aHeader,{"T3 Gargalo"   , "ZAG_GARG3"   ,"@E 9999"	 ,04 ,0,"U_EST107T(11)","","N","ZAG"})
Aadd(aHeader,{"T3 Embalado"  , "ZAG_EMBAL3"  ,"@E 9999"	 ,04 ,0,"U_EST107T(12)","","N","ZAG"})
Aadd(aHeader,{"Total"        , "ZAG_OP101"   ,"@E 999999",06 ,0,".F.","","N","ZAG"})

If nPar == 3 .Or. nPar == 1 .Or. nPar == 4 .Or. nPar == 5 	//Altera, visualiza, complementa ou exclui

	_cNum   := ZAU->ZAU_NUM
	_dDt    := ZAU->ZAU_DATA
	      
	DbSelectArea("ZAG")
	DbSetOrder(1)				//filial + num
	If DbSeek(xFilial("ZAG")+ZAU->ZAU_NUM)
		While ZAG->ZAG_NUM == ZAU->ZAU_NUM
			aAdd(Acols,{ZAG->ZAG_ITEM,; 
			            ZAG->ZAG_PROD,; 
			            ZAG->ZAG_DESC,;
			            ZAG->ZAG_OP101,; 
			            ZAG->ZAG_GARG1,; 
			            ZAG->ZAG_EMBAL1,; 
			            ZAG->ZAG_OP102,; 
			            ZAG->ZAG_GARG2,; 
			            ZAG->ZAG_EMBAL2,;             
			            ZAG->ZAG_OP103,; 
			            ZAG->ZAG_GARG3,; 
			            ZAG->ZAG_EMBAL3,0,.F.})
			
			If nPar == 5 //complementa
				aAdd(aItmCompl,ZAG->ZAG_ITEM)
			Endif
			
			If nPar == 3 //altera
				
				aHeader[2][6] := "U_PEST107VA() .AND. U_EST107PRD()"
				
				For _x:=4 to 12
					aHeader[_x][6] := "U_EST107VA("+AllTrim(STR(_x))+")"
				Next
				   	
			EndIf

			ZAG->(DbSkip())
			
		EndDo

	EndIf

EndIf

/*******************/
/* Constr�i a tela */
/*******************/
Define MsDialog oDialog Title OemToAnsi("Lan�amento de Produ��o") From 010,030 To 395,735 Pixel

//@ 005 ,005 To 030,350
@ 015 ,010 Say OemToAnsi("Lan�amento: ") size 40,8 object olLanc
@ 015 ,045 Say _cNum size 40,8 object olanc
olanc:Setfont(oFont)

@ 015 ,200 Say "Data:" size 40,8 object olData
@ 015 ,230 Get _dDt Picture "99/99/99" When(nPar != 5) Size 40,8 object oData
                	
@ 035 ,005 To 170,350 Title OemToAnsi(" Produtos ")

DbSelectArea("ZAU")
@ 045 ,010 TO 165,345 MULTILINE MODIFY DELETE  OBJECT oMultiline


//If nPar == 2 .OR. nPar == 5
@ 175,010 BUTTON "Carrega" SIZE 30,12 ACTION fCarrega() Object oBtn
//EndIf

@ 175,290 BMPBUTTON TYPE 01 ACTION fGrvOrd()
@ 175,320 BMPBUTTON TYPE 02 ACTION fEnd()


If nPar <> 2 .And.  nPar <> 5    //Diferente de incluir ou Complementar
   oMultiline:nMax := Len(aCols) //n�o deixa o usuario adicionar mais uma linha no multiline
Endif   

Activate MsDialog oDialog Center// Valid fDialog()

Return

//������������������������������������������Ŀ
//� FUNCAO QUE ATUALIZA O TOTAL NO MULTILINE �
//��������������������������������������������
User Function EST107T(nPos)
Local _nTotal := 0
Local _cField  

	For _x:= 4 to 12
		IF(_x != nPos)
			_nTotal += aCols[n][_x]
		EndIf
	Next
	
	Do Case
		Case nPos == 4
			_cField := "M->ZAG_OP101"
		Case nPos == 5
			_cField := "M->ZAG_GARG1"
		Case nPos == 6 
			_cField := "M->ZAG_EMBAL1"
		Case nPos == 7
			_cField := "M->ZAG_OP102"
		Case nPos == 8
			_cField := "M->ZAG_GARG2"
		Case nPos == 9 
			_cField := "M->ZAG_EMBAL2"
		Case nPos == 10
			_cField := "M->ZAG_OP103"
		Case nPos == 11
			_cField := "M->ZAG_GARG3"
		Case nPos == 12 
			_cField := "M->ZAG_EMBAL3"

	End Case		

	_nTotal += &(_cField)
	
	aCols[n][13] := _nTotal
	oMultiline:Refresh()

Return .T.
 
/*������������������������������Ŀ
/� FUNCAO DE SAIDA               �
/�������������������������������*/
Static Function fEnd()
 
	RollBackSX8()	  
    Close(oDialog) 
                      
Return

/*������������������������������Ŀ
/� GRAVA OS DADOS                �
/�������������������������������*/
Static Function fGrvOrd()
Local _lGravou	
Local _nPos := 0
Local nItem := 0

	If nPar == 2 //inclui

		_lGravou := .F.

		If !fDialog() //verifica erros
	    	Return
		EndIf		
		
		RecLock('ZAU',.T.) 
			ZAU->ZAU_FILIAL := xFilial('ZAU')
			ZAU->ZAU_NUM    := _cNum
			ZAU->ZAU_DATA   := _dDt 	//data
			ZAU->ZAU_HORA   := Substr(Time(),1,5) // horario
		MsUnlock('ZAU')

		For x := 1 to len(Acols)

			If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][1])
				RecLock('ZAG',.T.)
		 			ZAG->ZAG_FILIAL  := xFilial('ZAG')  	
					ZAG->ZAG_NUM	 := _cNum
					ZAG->ZAG_ITEM    := Acols[x][1]
					ZAG->ZAG_PROD    := Acols[x][2]  //produto
					ZAG->ZAG_DESC	 := Acols[x][3]  //descricao DO CC
					ZAG->ZAG_OP101   := Acols[x][4]  //operacao 10 TURNO 1
					ZAG->ZAG_GARG1   := Acols[x][5]  //gargalo TURNO 1
					ZAG->ZAG_EMBAL1	 := Acols[x][6]  //embalado TURNO 1
					ZAG->ZAG_OP102   := Acols[x][7]  //operacao 10 TURNO 2
					ZAG->ZAG_GARG2   := Acols[x][8]  //gargalo TURNO 2
					ZAG->ZAG_EMBAL2	 := Acols[x][9]  //embalado TURNO 2
					ZAG->ZAG_OP103   := Acols[x][10] //operacao 10 TURNO 3
					ZAG->ZAG_GARG3   := Acols[x][11] //gargalo TURNO 3
					ZAG->ZAG_EMBAL3  := Acols[x][12] //embalado TURNO 3 
					ZAG->ZAG_HORA    := Substr(Time(),1,5) // horario
					ZAG->ZAG_USER    := alltrim(upper(cUserName)) // horario
			  	MsUnLock('ZAG')   
		  	EndIf
			 
		Next x
		_lGravou := .T.
	EndIf

	If nPar == 3 //altera
	
		_lGravou := .F.

		If !fDialog() //verifica erros
	    	Return
		EndIf		

		DbSelectArea('ZAG')
		DbSetOrder(1) // filial + num  + item
		For x:= 1 to Len(Acols)

			If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][1])
//				ALERT(xFilial('ZAG')+ZAU->ZAU_NUM+Acols[x][1])
				DbSeek(xFilial('ZAG')+ZAU->ZAU_NUM+Acols[x][1])

				If ZAG->(Found())
					RecLock('ZAG',.F.)			

						ZAG->ZAG_PROD    := Acols[x][2]  //produto
						ZAG->ZAG_DESC	 := Acols[x][3]  //descricao DO CC
						ZAG->ZAG_OP101   := Acols[x][4]  //operacao 10 TURNO 1
						ZAG->ZAG_GARG1   := Acols[x][5]  //gargalo TURNO 1
						ZAG->ZAG_EMBAL1	 := Acols[x][6]  //embalado TURNO 1
						ZAG->ZAG_OP102   := Acols[x][7]  //operacao 10 TURNO 2
						ZAG->ZAG_GARG2   := Acols[x][8]  //gargalo TURNO 2
						ZAG->ZAG_EMBAL2	 := Acols[x][9]  //embalado TURNO 2
						ZAG->ZAG_OP103   := Acols[x][10] //operacao 10 TURNO 3
						ZAG->ZAG_GARG3   := Acols[x][11] //gargalo TURNO 3
						ZAG->ZAG_EMBAL3  := Acols[x][12] //embalado TURNO 3
						ZAG->ZAG_HORA    := Substr(Time(),1,5) // horario
						ZAG->ZAG_USER    := alltrim(upper(cUserName))	
				  	MsUnLock('ZAG')
				Else

					RecLock("ZAG",.T.)
		 				ZAG->ZAG_FILIAL  := xFilial("ZAG")  	
						ZAG->ZAG_NUM	 := _cNum
						ZAG->ZAG_ITEM    := Acols[x][1]
						ZAG->ZAG_PROD    := Acols[x][2]   //produto
						ZAG->ZAG_DESC	 := Acols[x][3]   //descricao DO CC
						ZAG->ZAG_OP101   := Acols[x][4]  //operacao 10 TURNO 1
						ZAG->ZAG_GARG1   := Acols[x][5]  //gargalo TURNO 1
						ZAG->ZAG_EMBAL1	 := Acols[x][6]  //embalado TURNO 1
						ZAG->ZAG_OP102   := Acols[x][7]  //operacao 10 TURNO 2
						ZAG->ZAG_GARG2   := Acols[x][8]  //gargalo TURNO 2
						ZAG->ZAG_EMBAL2	 := Acols[x][9]  //embalado TURNO 2
						ZAG->ZAG_OP103   := Acols[x][10] //operacao 10 TURNO 3
						ZAG->ZAG_GARG3   := Acols[x][11] //gargalo TURNO 3
						ZAG->ZAG_EMBAL3  := Acols[x][12] //embalado TURNO 3
						ZAG->ZAG_HORA    := Substr(Time(),1,5) // horario
						ZAG->ZAG_USER    := alltrim(upper(cUserName))	
				  	MsUnLock("ZAG")   
				EndIf

			Else
				If DbSeek(xFilial('ZAG')+ZAU->ZAU_NUM+Acols[x][1])
					RecLock("ZAG",.F.)
						ZAG->(DbDelete())
					MsUnLock("ZAG")
				EndIf
			EndIf

		 	ZAG->(DbSkip())
		Next
    EndIf
    
	If nPar == 5 //complementa
	
		_lGravou := .F.

		If !fDialog() //verifica erros
	    	Return
		EndIf		

		DbSelectArea('ZAG')
		DbSetOrder(1) // filial + num  + item
		For x:= 1 to Len(Acols)

			_nPos := aScan(aItmCompl,Acols[x][1])
			                                                             //S� adiciona os que n�o existem inicialmente
			If !Acols[x][len(aHeader)+1] .And. !Empty(Acols[x][1]) .AND. _nPos==0
				                       
				_lAdd := .T.
				
				If DbSeek(xFilial('ZAG')+ZAU->ZAU_NUM)
					While !EOF() .AND. ZAG->ZAG_NUM == ZAU->ZAU_NUM
				 		
				 		If ZAG->ZAG_PROD == Acols[x][2]
				 			Alert("O produto "+AllTrim(Acols[x][2])+" j� foi lan�ado nesta data e n�o ser� lan�ado novamente!")
				 			_lAdd := .F.
				 	 	EndIf
				 	 		
				 		nItem := Val(ZAG->ZAG_ITEM) + 1
						ZAG->(DBSKIP())
					EndDo
				EndIf
				
				If _lAdd
				
					ACols[x][1] := StrZero(nItem,4)

					RecLock("ZAG",.T.)
	 					ZAG->ZAG_FILIAL  := xFilial("ZAG")  	
						ZAG->ZAG_NUM	 := _cNum
						ZAG->ZAG_ITEM    := Acols[x][1]
						ZAG->ZAG_PROD    := Acols[x][2]   //produto
						ZAG->ZAG_DESC	 := Acols[x][3]   //descricao DO CC
						ZAG->ZAG_OP101   := Acols[x][4]  //operacao 10 TURNO 1
						ZAG->ZAG_GARG1   := Acols[x][5]  //gargalo TURNO 1
						ZAG->ZAG_EMBAL1	 := Acols[x][6]  //embalado TURNO 1
						ZAG->ZAG_OP102   := Acols[x][7]  //operacao 10 TURNO 2
						ZAG->ZAG_GARG2   := Acols[x][8]  //gargalo TURNO 2
						ZAG->ZAG_EMBAL2	 := Acols[x][9]  //embalado TURNO 2
						ZAG->ZAG_OP103   := Acols[x][10] //operacao 10 TURNO 3
						ZAG->ZAG_GARG3   := Acols[x][11] //gargalo TURNO 3
						ZAG->ZAG_EMBAL3  := Acols[x][12] //embalado TURNO 3
						ZAG->ZAG_HORA    := Substr(Time(),1,5) // horario
						ZAG->ZAG_USER    := alltrim(upper(cUserName))	
				  	MsUnLock("ZAG")   
    			EndIf
			EndIf
	
		 	ZAG->(DbSkip())
		Next

		_lGravou := .T.
	
	EndIf
	
	If nPar == 4 //exclui
	    If MsgYesNo("Tem certeza que deseja excluir a programa��o?")
			RecLock("ZAU",.F.)
				ZAU->(DbDelete())
			MsUnLock("ZAU")
			ZAG->(DbSetOrder(1))//filial + num + item
			ZAG->(DbSeek(xFilial('ZAG')+_cNum))
			While ZAG->ZAG_NUM == _cNum
				RecLock("ZAG",.F.)
					ZAG->(DbDelete())
				MsUnLock("ZAG")
				ZAG->(DbSkip())
			EndDo
		EndIf			
		Close(oDialog)		
	EndIf 
			
	If _lGravou
	  	ConfirmSX8()
  		Close(oDialog)
	EndIf  		
	Close(oDialog)	
	
Return

/*��������������������Ŀ
/� VALIDA O FORMULARIO �
/���������������������*/
Static Function fDialog() //verifica��o
	
	SB1->(DbSetOrder(1)) //FILIAL + CODIGO
	ZAU->(DbSetOrder(2)) //FILIAL + DATA        
	
	For x := 1 to len(Acols)
		If !Acols[x][len(aHeader)+1]  //nao pega quando a linha esta deletada
		  	//Verifica se a pe�a � valida
			SB1->(DbSeek(xFilial('SB1')+Acols[x][2]))
			If SB1->(!Found())
				MsgBox(OemToAnsi("Pe�a inexistente. "+Acols[x][2]+" Verifique!!!"),"Atencao","ALERT" )
				Return .F.
			EndIf
	
			//Verifica se os campos n�o est�o vazios
			If Empty(Acols[x][2])
				MsgBox(OemToAnsi("Campo pe�a deve ser preenchido. Verifique!!!"),"Atencao","ALERT" ) 
				Return .F. 
			EndIf

			If nPar != 3 .AND. nPar != 5//diferente de altera e diferente de �complementar
				//Verifica j� n�o foi lan�ada produ��o nesta data
				IF ZAU->(DbSeek(xFilial("ZAU")+DTOS(_dDt)))
					Alert("Lan�amento j� efetuado nesta data!")
					Return .F.
				EndIf
			EndIf

		EndIf
	Next
	
Return(.T.)

/*������������������������������Ŀ
/� TRAZ A DESCRICAO DO PRODUTO   �
/�������������������������������*/
User Function EST107PRD()
Local _nDescri	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZAG_DESC"}) 
Local _nPrd 	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "ZAG_PROD"}) 
	
	If ddatabase >= Ctod('22/04/2013')
		If alltrim(M->ZAG_PROD)$'SCA31.3.0096.03'
			Alert('Favor utilizar o c�digo SCA31.3.0280.00!')
			Return .f.
		Endif
	
		If alltrim(M->ZAG_PROD)$'SCA31.3.0097.03'
			Alert('Favor utilizar o c�digo SCA31.3.0281.00!')
			Return .f.
		Endif
	Endif
	
	If alltrim(M->ZAG_PROD)$'VWB08.4.0278.00'
		Alert('Favor utilizar o c�digo VWB08.4.0278.01!')
		Return .f.
	Endif
			
   	For _x := 1 to Len(aCols)
   		If !aCols[_x][len(aHeader)+1]  //nao pega quando a linha esta deletada
   			If aCols[_x][_nPrd] == M->ZAG_PROD
   				Alert("Pe�a j� digitada!")
   				Return .F.
   			EndIf
		EndIf   	
	Next

   	SB1->(DbSetOrder(1))
   	If SB1->(DbSeek(xFilial("SB1")+M->ZAG_PROD))
      	Acols[n][_nDescri] := SB1->B1_DESC
      	oMultiline:Refresh()  
   	Else
   		Msgbox("Pe�a Nao Encontrada, Verifique !!!" ,"Atencao","ALERT") 
   		RETURN .F.
   	Endif

Return .T.

//���������������������������������������������������Ŀ
//� VERIFICA SE PERMITE ALTERA��O NO CAMPO DOS TURNOS �
//�����������������������������������������������������
User Function EST107VA(nPos)

	If Alltrim(UPPER(cUserName))$"TIAGOMS/CASSIANOS/ADMINISTRADOR"
		Return .T.
	EndIf

	If U_PEST107VA()
		Return .T.
	Else
		If Empty(aCols[n][nPos])
			Return .T.
		Else
			Alert("Valor n�o pode ser alterado!")
			Return .F.
		EndIf
	EndIF

Return .T.   

//���������������������������������������������������������������������������Ŀ
//� VERIFICA SE A PECA ESTA SENDO INCLUIDA OU SE JA FOI GRAVADA ANTERIORMENTE �
//�����������������������������������������������������������������������������
User Function PEST107VA()

	ZAG->(DBSETORDER(1)) //FILIAL + NUM + ITEM
	IF ZAG->(DBSEEK(XFILIAL("ZAG")+_cNum))
		WHILE ZAG->(!EOF()) .AND. ZAG->ZAG_NUM == _cNum
		
			IF ZAG->ZAG_PROD == ACOLS[n][2]
			
				Return .F.
			ENDIF
			
		    ZAG->(DBSKIP())
		ENDDO
	ENDIF

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EST107Rel  �Autor �Jo�o Felipe da Rosa � Data �  20/02/2009� ��
�������������������������������������������������������������������������͹��
���Desc.     � RELAT�RIO DE APONTAMENTO DE PRODU��O                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / PCP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function EST107Rel()

cString   := "ZAG"
cDesc1    := OemToAnsi("Apresenta o controle das pe�as produzidas")
cDesc2    := OemToAnsi("")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHEST107" //nome do arquivo
nLastKey  := 0
titulo    := OemToAnsi("ACOMPANHAMENTO DA PRODU��O - OCORR�NCIAS POR TURNO") //t�tulo
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cabec1    := "PRODUTO                                                       OPERA��O INICIAL                             OPERA��O GARGALO                             OPERA��O FINAL"
cabec2    := "                                                        1� TURNO  2� TURNO  3� TURNO       TOTAL     1� TURNO  2� TURNO  3� TURNO       TOTAL     1� TURNO  2� TURNO  3� TURNO       TOTAL"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1 
M_PAG     := 1 //Variavel que acumula numero da pagina
wnrel     := nomeprog
_cPerg    := "EST107"

If !Pergunte(_cPerg,.T.)
   Return(nil)
Endif 

titulo += " - "+DTOC(MV_PAR01)

SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

if nlastKey ==27
    Set Filter to
    Return
Endif

SetDefault(aReturn,cString)

nTipo := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))

//������������������������Ŀ
//�CHAMADAS PARA AS FUN��ES�
//��������������������������

Processa(  {|| Gerando()   },"Gerando Dados para a Impressao") 
RptStatus( {|| Imprime()   },"Imprimindo...")

set filter to //remove o filtro da tabela

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif                                          

MS_FLUSH() //Libera fila de relatorios em spool

Return

//���������������������������������������Ŀ
//�FUNCAO QUE GERA OS DADOS PARA IMPRESSAO�
//�����������������������������������������
Static Function Gerando()
Local cQuery

	//�������������Ŀ
	//�MONTA A QUERY�
	//���������������
	cQuery := "SELECT ZAG.ZAG_PROD, "
	cQuery += " SUM(ZAG.ZAG_OP101)  AS ZAG_OP101 , SUM(ZAG.ZAG_OP102)  AS ZAG_OP102 , SUM(ZAG.ZAG_OP103)  AS ZAG_OP103, "
	cQuery += " SUM(ZAG.ZAG_GARG1)  AS ZAG_GARG1 , SUM(ZAG.ZAG_GARG2)  AS ZAG_GARG2 , SUM(ZAG.ZAG_GARG3)  AS ZAG_GARG3, "
	cQuery += " SUM(ZAG.ZAG_EMBAL1) AS ZAG_EMBAL1, SUM(ZAG.ZAG_EMBAL2) AS ZAG_EMBAL2, SUM(ZAG.ZAG_EMBAL3) AS ZAG_EMBAL3 "
	cQuery += " FROM "+RetSqlName("ZAU")+" ZAU, "+RetSqlName("ZAG")+" ZAG"
	cQuery += " WHERE ZAU.ZAU_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	cQuery += " AND ZAG.ZAG_NUM = ZAU.ZAU_NUM"
	cQuery += " AND ZAG.ZAG_FILIAL = '"+XFILIAL("ZAG")+"' AND ZAG.D_E_L_E_T_ = ''"
	cQuery += " AND ZAU.ZAU_FILIAL = '"+XFILIAL("ZAU")+"' AND ZAU.D_E_L_E_T_ = ''"
	cQuery += " GROUP BY ZAG.ZAG_PROD"
//	cQuery += " ORDER BY ZAG.ZAG_DESC"	
	
//	MemoWrit('C:\TEMP\'+nomeprog+'.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1" 
        
	TCSETFIELD("TRA1","ZAU_DATA","D") //MUDA DE STRING PARA DATE
	
	TRA1->(DbGotop())     

Return                                             		

//����������������������������������Ŀ
//�FUNCAO PARA IMPRESSAO DO RELAT�RIO�
//������������������������������������
Static Function Imprime()

Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)

SETREGUA(TRA1->(RECCOUNT()))

//Percorre os registros
WHILE TRA1->(!EOF())

	If Prow() > 65
		_nPag  := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
  	Endif

	IncRegua()

 	@Prow()+1, 001 psay TRA1->ZAG_PROD
 	
 	SB1->(DBSETORDER(1))
 	SB1->(DBSEEK(XFILIAL("SB1")+TRA1->ZAG_PROD))
 	
 	@Prow()  , 018 psay SB1->B1_DESC

 	@Prow()  , 060 psay TRA1->ZAG_OP101  PICTURE "@E 99999"
 	@Prow()  , 070 psay TRA1->ZAG_OP102  PICTURE "@E 99999"
 	@Prow()  , 080 psay TRA1->ZAG_OP103  PICTURE "@E 99999"
	@Prow()  , 090 psay (TRA1->ZAG_OP101+TRA1->ZAG_OP102+TRA1->ZAG_OP103) PICTURE "@E 999999"
 	
 	@Prow()  , 105 psay TRA1->ZAG_GARG1  PICTURE "@E 99999"
 	@Prow()  , 115 psay TRA1->ZAG_GARG2  PICTURE "@E 99999"
 	@Prow()  , 125 psay TRA1->ZAG_GARG3  PICTURE "@E 99999" 	
	@Prow()  , 135 psay (TRA1->ZAG_GARG1+TRA1->ZAG_GARG2+TRA1->ZAG_GARG3) PICTURE "@E 999999"

	@Prow()  , 150 psay TRA1->ZAG_EMBAL1 PICTURE "@E 99999"
 	@Prow()  , 160 psay TRA1->ZAG_EMBAL2 PICTURE "@E 99999" 	    
 	@Prow()  , 170 psay TRA1->ZAG_EMBAL3 PICTURE "@E 99999"
	@Prow()  , 180 psay (TRA1->ZAG_EMBAL1+TRA1->ZAG_EMBAL2+TRA1->ZAG_EMBAL3) PICTURE "@E 999999"

	TRA1->(DbSkip())

ENDDO

@ prow()+1,000 PSAY __PrtThinLine()        

//��������������������Ŀ
//� GERA O ARQUIVO TXT �
//����������������������
If mv_par03==1 //Gera txt ? Sim

	_nOutFile:= Fcreate("C:\apontamento\APONTAMENTO.txt",0)
	
	If !File("C:\APONTAMENTO\APONTAMENTO.txt")
		Alert("Arquivo txt n�o pode ser criado. Verifique se est� criada a pasta 'apontamento' no C: do seu computador. Ou verifique a permiss�o para grava��o no disco C:")
		TRA1->(DbCloseArea())
		Return
	EndIf

//	Fwrite(_nOutFile,cabec1+CHR(13)+CHR(10))
//	Fwrite(_nOutFile,cabec2+CHR(13)+CHR(10))

	TRA1->(DbGoTop())
	WHILE TRA1->(!EOF())
	 	SB1->(DBSETORDER(1))
 		SB1->(DBSEEK(XFILIAL("SB1")+TRA1->ZAG_PROD))

		Fwrite(_nOutFile,AllTrim(TRA1->ZAG_PROD)+"	")
		Fwrite(_nOutFile,Substr(SB1->B1_DESC,1,50)+"	")

		Fwrite(_nOutFile,Transform(TRA1->ZAG_OP101,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_OP102,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_OP103,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_OP101+TRA1->ZAG_OP102+TRA1->ZAG_OP103,"@E 999999")+"	",15)
		
		Fwrite(_nOutFile,Transform(TRA1->ZAG_GARG1,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_GARG2,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_GARG3,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_GARG1+TRA1->ZAG_GARG2+TRA1->ZAG_GARG3,"@E 999999")+"	",15)

		Fwrite(_nOutFile,Transform(TRA1->ZAG_EMBAL1,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_EMBAL2,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_EMBAL3,"@E 99999")+"	",10)
		Fwrite(_nOutFile,Transform(TRA1->ZAG_EMBAL1+TRA1->ZAG_EMBAL2+TRA1->ZAG_EMBAL3,"@E 999999")+"	",15)

		Fwrite(_nOutFile,CHR(13)+CHR(10),10)
		
		TRA1->(DbSkip())
		
	ENDDO
	Fclose(_nOutFile)
	   
    Alert("Arquivo txt gerado em C:\APONTAMENTO\APONTAMENTO.txt")

EndIf

TRA1->(DbCloseArea())

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST107  �Autor  �FELIPE CICONINI     � Data �  25/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �CARREGA OS ITENS DA ULTIMA INCLUSAO                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function fCarrega()
Local cQuery

	cQuery := "SELECT MAX(ZAG_NUM) NUM FROM "+RetSqlName("ZAG")+" ZAG "
	cQuery += " WHERE ZAG.D_E_L_E_T_ = ''"
	cQuery += " AND ZAG.ZAG_FILIAL = '"+xFilial("ZAG")+"'"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	ZAG->(DbSetOrder(1))		//filial+num
	ZAG->(DbSeek(xFilial("ZAG")+TRA1->NUM))
	
	SB1->(DbSetOrder(1))        //filial+cod
	
	nItem := 0
	aCols := {}
	
	While ZAG->ZAG_NUM == TRA1->NUM .AND. ZAG->(!EoF())
	
	nItem++
	
	SB1->(DbSeek(xFilial("ZAG")+ZAG->ZAG_PROD))
	
	aAdd(aCols,{StrZero(nItem,4),;
				ZAG->ZAG_PROD,;
				SB1->B1_DESC,;
				0,0,0,0,0,0,0,0,0,0,.F.})
				
	ZAG->(DbSkip())
	
	EndDo
	
	oMultiline:Refresh()
	
	TRA1->(DbCloseArea())
	

Return

