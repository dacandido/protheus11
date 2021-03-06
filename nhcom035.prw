/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � NHCOM035        � Sergio L Tambosi      � Data � 10.04.03 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao da Previsao de Desembolso por Fornecedor        ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#include "rwmake.ch"      
#INCLUDE "TOPCONN.CH"

User Function Nhcom035()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,_dDataEnt,_nNfGe,_nqTotpe,_nqIpi,_nBase1,_nJaEnt")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,LEND,TITULO,CABEC1,_nTotAberto,nTotAtende,_nSubAberto,_nSubAtende,_nPosMes")
SetPrvt("CABEC2,CCANCEL,_NPAG,WNREL,_CPERG,ADRIVER,_nSemana, _aPed,_axPed,_n,_nSaldo,_anPed,_azPed,_c7NumPro")
SetPrvt("CCOMPAC,CNORMAL,CQUERY,nSubTot,nTotGer,nTotCC,nConta,dData1,dData2,dData3,dData4,dData5,dData6,cCentroC")
SetPrvt("_aGrupo,_cApelido,_cCodUsr,_lPri,_nTotItem,_nTotcIpi,nSubIpi,nTotIpi,_nTotPe,_nIpi,_c7Num,_z,_aMes,j")


_aGrupo   := pswret()
_cCodUsr  := _agrupo[1,1]
cString   := "SC7"
cDesc1    := OemToAnsi("Este relatorio tem como objetivo Imprimir a  ")
cDesc2    := OemToAnsi("Previsao de Desembolso por Fornecedor")
cDesc3    := OemToAnsi("")
tamanho   := "G"  // P - PEQUENO, M - MEDIO G - GRANDE
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHCOM035"
aLinha    := { }
nLastKey  := 0
nQtde     := 0
lEnd      := .F.                                                   
lDivPed   := .F.
titulo    := "PREVISAO DE DESEMBOLSO P/FORNECEDOR"
Cabec1    := " DT.EMIS.   PEDIDO  FORNECEDOR                                  VLR.TOTAL  DT.ENTR.    COND.PAGTO     1.o VCTO    2o. VCTO    3o. VCTO    4o. VCTO                  TOT.SEMANA                        Sigla  N.Fiscal"
Cabec2    := "It Produto   Descricao                                                                   Custo Total          Qtde Um         Vlr.Unit             Vlr.Ipi           Vlr.Total  Vlr.Total(c/Ipi)"
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1  //Variavel que acumula numero da pagina
M_PAG     := 1
wnrel     := "NHCOM035"       //Nome Default do relatorio em Disco
_cPerg    := "COM007"         //Grupo de Par�metros que ser�o utilizados (cadastrar novo grupo no SX3)
aMatriz   := {}
_aPed     := {}
_axPed    := {}
_nTotPe   := 0
_nIpi     := 0
_anPed    := {}
_azPed    := {}	
_aMes     := {}
_nPosMes  := 0


dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek(_cPerg))
If Sx1->(Found())
	RecLock('SX1')
	SX1->X1_CNT01 := _cCodUsr
	MsUnLock('SX1')
Endif

//Mv_par01 :=	Usuario
//Mv_par02 :=	Centro de Custo de   
//Mv_par03 :=	Centro de Custo Ate  
//Mv_par04 :=	Grupo de 
//Mv_par05 :=	Grupo Ate 
//Mv_par06 :=	Data de 
//Mv_par07 :=	Data Ate 
//Mv_par08 :=	Sigla de 
//Mv_par09 :=	Sigla Ate
//Mv_par12 :=   Obs SC (Sim/Nao)

If !Pergunte(_cPerg,.T.) //ativa os parametros
	Return(nil)
Endif
                                     
SetPrint(cString,wnrel,_cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"",,tamanho) 

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

nTipo   := IIF(aReturn[4]==1,GetMV("MV_COMP"), GetMV("MV_NORM"))
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

// inicio do processamento do relat�rio
Processa( {|| Gerando()   },"Gerando Dados para a Impressao")
                  
// verifica se existe dados para o relatorio atraves da valida��o de dados em um campo qualquer
TMP->(DbGoTop())

If Empty(TMP->D1_DOC)
   MsgBox("N�o existem dados para estes par�metros...verifique!","Atencao","STOP")
   DbSelectArea("TMP")
   DbCloseArea()
   Return
Endif

Processa( {|| fMatriz()   },"Gerando Dados para a Impressao")

If Len(_aPed) <=0
	MsgBox("Nao existe dados para impressao","Relatorios","ALERT")
    DbSelectArea("TMP")
    DbCloseArea()
	Return
Endif

Cabec1  := " DT.EMIS.   PEDIDO  FORNECEDOR                                    DT.PREV.    DT.ENTR.   COND.PGTO    1.o VCTO    2o. VCTO    3o. VCTO    4o. VCTO                  TOT.SEMANA                         Sigla  N.Fiscal"
Cabec2  := "It Produto   Descricao                                                                     Custo Total        Qtde Um         Vlr.Unit             Vlr.Ipi           Vlr.Total  Vlr.Total(c/Ipi)"
Processa( {|| RptDet1() },"Imprimindo...")

DbSelectArea("TMP")
DbCloseArea()

Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


Static Function Gerando()

   	IncProc("Processando..........") 
	cQuery := "SELECT DATEPART(WK, D1.D1_DTDIGIT) AS 'DIA', * FROM " + RetSqlName( 'SD1' ) + " D1 "
	cQuery += "WHERE D1.D1_DTDIGIT BETWEEN '"+ DTOS(Mv_par06) + "'  AND '"+ DTOS(Mv_par07) + "' "
	cQuery += "AND D1.D1_FILIAL = '" + xFilial("SD1")+ "' "
	cQuery += "AND D1.D1_PEDIDO <> ' ' " 
	cQuery += "AND D1.D_E_L_E_T_ = ' ' " 
	cQuery += "AND D1.D1_GRUPO BETWEEN '"+ Mv_par04 + "' AND '"+ Mv_par05 + "' "
	cQuery += "ORDER BY D1.D1_DTDIGIT,D1.D1_PEDIDO,D1.D1_ITEMPC "
	
	TCQUERY cQuery NEW ALIAS "TMP"
	TcSetField("TMP","D1_DTDIGIT","D")  // Muda a data de string para date

Return

Static Function fMatriz()
Local lMatriz   := .t.,;
      _n7Quant  := 0,;
      _n7Quje   := 0,;
      _nAbeUni  := 0,;
      _nAbeIpi  := 0,;
      _nAberto  := 0,;
      _cNomeFor := Space(30)
SA2->(DbsetOrder(1))
TMP->(DbGoTop())
While TMP->(!Eof())
   	IncProc("Processando.........." + TMP->D1_PEDIDO ) 
	SC7->(DbSeek(xFilial("SD1")+TMP->D1_PEDIDO + TMP->D1_ITEMPC))
	If SC7->(Found()) 
		If !Empty(Alltrim(mv_par01))
			If SC7->C7_USER == Mv_par01
				If SC7->C7_SIGLA >=  Mv_par08  .AND. SC7->C7_SIGLA <=  Mv_par09 //FILTRA POR SIGLA
				
					//-- FILTRO POR PEDIDO ABERTO / FECHADO (OS: 062409)
					IF (MV_PAR11==2 .AND. SC7->C7_RESIDUO<>'S' .AND. SC7->C7_QUANT > SC7->C7_QUJE) .OR. ; // SOMENTE ABERTOS
					   (MV_PAR11==1 .AND. (SC7->C7_RESIDUO=='S' .OR. SC7->C7_QUANT == SC7->C7_QUJE)) .OR. ; // SOMENTE ATENDIDOS
					    MV_PAR11==3  // AMBOS
				
						_cNomeFor := Space(30)
						SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
						IF SA2->(Found())
							_cNomeFor := Substr(SA2->A2_NOME,1,30)
						Endif
						AADD(_anPed,{SC7->C7_EMISSAO,; // 1
						TMP->D1_PEDIDO+TMP->D1_ITEMPC,; //2
						SC7->C7_FORNECE,; // 3
						_cNomeFor,; // 4
						TMP->D1_TOTAL,; //5
						SC7->C7_DATPRF,; // 6
						SC7->C7_COND,; // 7
	    				Space(10),; // 8
	 					SC7->C7_CC,; // 9
						SC7->C7_USER,; //10
						Space(30),; // 11
						SC7->C7_SIGLA,; // 12
						TMP->D1_VALIPI,; // 13
						TMP->DIA,; // 14
						TMP->D1_ITEMPC,; // 15
						TMP->D1_DOC,; // 16
						TMP->D1_DTDIGIT,; // 17
						TMP->D1_QUANT,; // 18
						TMP->D1_QUANT,; // 19
						TMP->D1_VUNIT,; // 20
						TMP->D1_IPI,; // 21
						0}) // 22

					Endif						
				Endif	
			Endif	
		Else
			If SC7->C7_SIGLA >=  Mv_par08  .AND. SC7->C7_SIGLA <=  Mv_par09 //FILTRA POR SIGLA

				//-- FILTRO POR PEDIDO ABERTO / FECHADO (OS: 062409)
				IF (MV_PAR11==2 .AND. SC7->C7_RESIDUO<>'S' .AND. SC7->C7_QUANT > SC7->C7_QUJE) .OR. ; // SOMENTE ABERTOS
				   (MV_PAR11==1 .AND. (SC7->C7_RESIDUO=='S' .OR. SC7->C7_QUANT == SC7->C7_QUJE)) .OR. ; // SOMENTE ATENDIDOS
				    MV_PAR11==3  // AMBOS
			

					_cNomeFor := Space(30)
					SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
					IF SA2->(Found())
						_cNomeFor := Substr(SA2->A2_NOME,1,30)
					Endif	
					AADD(_anPed,{SC7->C7_EMISSAO,; // 1
					TMP->D1_PEDIDO+TMP->D1_ITEMPC,; //2
					SC7->C7_FORNECE,; // 3
					_cNomeFor,; // 4
					TMP->D1_TOTAL,; //5
					SC7->C7_DATPRF,; // 6
					SC7->C7_COND,; // 7
	   				Space(10),; // 8
					SC7->C7_CC,; // 9
					SC7->C7_USER,; //10
					Space(30),; // 11
					SC7->C7_SIGLA,; // 12
					TMP->D1_VALIPI,; // 13
					TMP->DIA,; // 14
					TMP->D1_ITEMPC,; // 15
					TMP->D1_DOC,; // 16
					TMP->D1_DTDIGIT,; // 17
					TMP->D1_QUANT,; // 18
					TMP->D1_QUANT,; // 19
					TMP->D1_VUNIT,; // 20
					TMP->D1_IPI,; // 21
					0}) // 22
	    		Endif
			Endif	
		Endif
	Endif
	TMP->(Dbskip())
Enddo

If Len(_anPed) > 0
	_n       := 1
	_z       := 1
	_n       := 1
	nSubTot  := 0
	_nTotpe  := 0
	_nIpi    := 0
	_nSaldo  := 0
	_c7Num   := Space(06)
	_nJaEnt  := 0
	
	While _n <= Len(_anPed)
	   	IncProc("Processando..........."+ _c7Num)
		_c7Num := Substr(_anPed[_n,2],1,6) + Dtos(_anPed[_n,17])
		While _c7Num == Substr(_anPed[_n,2],1,6) + Dtos(_anPed[_n,17])

			// Calcula qtde entregue
			_nTotpe := _anPed[_n,18] * _anPed[_n,20]
			_nIpi   := ((_nTotpe * _anPed[_n,21])/100)
		      
			nSubTot   += (_nTotpe + _nIpi)
			_n++

			If _n > Len(_anPed)
				Exit
			Endif

		Enddo
		_n--
		Aadd(_aPed,{_anPed[_n,1],_anPed[_n,2],_anPed[_n,3],_anPed[_n,4],_anPed[_n,5],_anPed[_n,6],_anPed[_n,7],;
			        _anPed[_n,8],_anPed[_n,9],_anPed[_n,10],_anPed[_n,11],_anPed[_n,12],_anPed[_n,13],_anPed[_n,14],;
			        _anPed[_n,15],_anPed[_n,16],_anPed[_n,17],_anPed[_n,18],_anPed[_n,19],_anPed[_n,20],_anPed[_n,21],;
			        _anPed[_n,22],0})

		_aPed[_z,20] = nSubTot
	    _z++
		_n++
		nSubTot  := 0
		_nTotpe  := 0
		_nIpi    := 0

	Enddo
Endif
If Len(_aPed) <=0
	MsgBox("Nao existe dados para impressao","Relatorios","ALERT")
	Return
Endif	
        
Return

Static Function RptDet1()
Local _nAberto := 0, _aTotMes := {}, _aPosTmes := 0, lSd1 := .F.
_n := 1

//If Mv_Par11 == 2
//	titulo := "PEDIDOS ATENDIDOS NO PERIODO DE "+DTOC(Mv_Par06) + " ATE "+DTOC(Mv_Par07)
//Elseif Mv_Par11 == 3
//	titulo := "PEDIDOS ATENDIDOS NO PERIODO DE "+DTOC(Mv_Par06) + " ATE "+DTOC(Mv_Par07)
//Else
titulo := "PEDIDOS ATENDIDOS NO PERIODO DE "+DTOC(Mv_Par06) + " ATE "+DTOC(Mv_Par07)
//Endif

// imprime cabe�alho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
       
// calcula as datas finais para cada semana
dData1:= CTOD("//")
if _aPed[_n,14] < 7
   dData1 := Mv_par06 + 1 - _aPed[_n,14] // TMP->DIA      
else
   dData1 := Mv_par06 + 1
endif

// Inicializa variaveis
dData2      := dData1 + 7
dData3      := dData2 + 7
dData4      := dData3 + 7
dData5      := dData4 + 7
dData6      := dData5 + 7
cCentroC    := _aPed[_n,9] // TMP->C7_CC
_nSemana    := _aPed[_n,14] // TMP->DIA
_n          := 1
_nTotAberto := 0
_nTotAtende := 0
_nSubAberto := 0
_nSubAtende := 0

// inicializa totalizadores
nSubTot     := 0
_nTSemImp   := 0 //TOTAL SEM IMPOSTOS
nTotGer     := 0
nTotCC      := 0
nConta      := 1
_lPri       := .T.
_nTotItem   := 0
_nTotCIpi   := 0
nTotIpi     := 0
_nNfGe      := 0
_nNfGe2     := 0
_c7Num      := Space(06)
j           := 1
lSd1        := .F.

While _n <= Len(_aPed)

	IncProc("Imprimindo Pedidos Atendidos "  + _aPed[_n,2] ) // + TMP->C7_NUM)
  
	If Prow() > 60
		_nPag := _nPag + 1
		Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
	Endif   

	@ Prow() +1, 001 Psay _aPed[_n,1]  // TMP->C7_EMISSAO
	@ Prow()   , 012 Psay Substr(_aPed[_n,2],1,6)  // TMP->C7_NUM
	@ Prow()   , 021 Psay _aPed[_n,3] + " " + _aPed[_n,4]       // FORNECEDOR + DESC

	_nTotPe  := _nIpi := _nSaldo := _nBase1 := 0
	_nSaldo  := (_aPed[_n,18] - _aPed[_n,19]) // Saldo
	_nTotpe  := _aPed[_n,20]
	_nAberto := _aPed[_n,23]

	@ Prow()   , 065 Psay _aPed[_n,6]  // TMP->C7_DATPRF
	@ Prow()   , 077 Psay _aPed[_n,17] // Data de Entrada

	@ Prow()   , 090 Psay SUBSTR(_aPed[_n,8],1,9) // SUBSTR(TMP->E4_COND,1,12)

	if substr(_aPed[_n,8],1,2) <> '  '
	   @ Prow()   , 102 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],1,2)))
	endif

	if substr(_aPed[_n,8],4,2) <> '  '
	   	@ Prow()   , 114 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],4,2)))
	endif

	if substr(_aPed[_n,8],8,2) <> '  '
	   	@ Prow()   , 126 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],7,2)))
	endif

	if substr(_aPed[_n,8],12,2) <> '  '
	   	@ Prow()   , 138 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],10,2)))
	endif
                                                                                  
  	//nSubTot - variavel de subtotal para semanas
   	//nTotGer - variavel de total geral
	nSubTot += _nTotPe //+ _nIpi
	nTotGer += _nTotPe //+ _nIpi
	nTotIpi := _nTotPe //+ _nIpi

	_nTotAberto += _nAberto
	_nSubAberto += _nAberto
	_nTotAtende += (nTotIpi - _nAberto)
	_nSubAtende += (nTotIpi - _nAberto)
	
	@ Prow()   , 160 Psay transform(_aPed[_n,20],"@E 999,999,999.99") // VALOR UNITARIO
	@ Prow()   , 201 Psay _aPed[_n,12] + "  " +_aPed[_n,16]  //SIGLA + DOC
	_nSemana := _aPed[_n,14] // TMP->DIA

	SD1->(DbSetOrder(14))
	SD1->(DbSeek(xFilial("SD1")+Substr(_aPed[_n,2],1,6) ) )
	While !SD1->(Eof()) .And. SD1->D1_PEDIDO == Substr(_aPed[_n,2],1,6)

		If SD1->D1_DTDIGIT >=  Mv_par06 .And. SD1->D1_DTDIGIT <= Mv_par07 .And. SD1->D1_GRUPO >= Mv_par04 .And. SD1->D1_GRUPO <= Mv_par05
	       
			SC7->(DbSetOrder(1))
			SC7->(DbSeek(xFilial("SC7")+SD1->D1_PEDIDO + SD1->D1_ITEMPC))
			If SC7->(Found())

			    If SC7->C7_SIGLA >= Mv_par08  .AND. SC7->C7_SIGLA <= Mv_par09 .AND. SD1->D1_DTDIGIT == _aPed[_n,17] .AND. Substr(SC7->C7_PRODUTO,1,4) >= Mv_Par04 .And. Substr(SC7->C7_PRODUTO,1,4) <= Mv_Par05
			   
					//-- FILTRO POR PEDIDO ABERTO / FECHADO (OS: 062409)
					IF (MV_PAR11==2 .AND. SC7->C7_RESIDUO<>'S' .AND. SC7->C7_QUANT > SC7->C7_QUJE) .OR. ; // SOMENTE ABERTOS
					   (MV_PAR11==1 .AND. (SC7->C7_RESIDUO=='S' .OR. SC7->C7_QUANT == SC7->C7_QUJE)) .OR. ; // SOMENTE ATENDIDOS
					    MV_PAR11==3  // AMBOS

						If _lPri
							@ Prow() + 1, 001 Psay __PrtThinLine()
							_lPri := .F.
						Endif				
		
						_dDataEnt := SC7->C7_DATPRF
						_nTotpe   := _nIpi := _nTotPed := _Quant := 0
						//_nPosMes  := Ascan(_aMes,{ |x| x[1] == Month(_dDataEnt) })
						//_nPosTMes := Ascan(_aTotMes,{ |x| x[1] == Month(_dDataEnt) })   
		
						_nPosMes  := Ascan(_aMes,{ |x| x[1] == Substr(Dtos(_dDataEnt),5,2) +"/"+Substr(Dtos(_dDataEnt),1,4)})
						_nPosTMes := Ascan(_aTotMes,{ |x| x[1] == Substr(Dtos(_dDataEnt),5,2) +"/"+Substr(Dtos(_dDataEnt),1,4)})
					
						_nTotpe  := SD1->D1_QUANT * SD1->D1_VUNIT
						_nIpi    := ((_nTotpe * SD1->D1_IPI)/100)
				
			       		If 	Month(_dDataEnt) > 0
							If _nPosMes == 0
								AADD(_aMes,{ Substr(Dtos(_dDataEnt),5,2) +"/"+Substr(Dtos(_dDataEnt),1,4) , (_nTotpe+_nIpi), _nTotpe})
							Else
								_aMes[_nPosMes,2] += _nTotpe+_nIpi
								_aMes[_nPosMes,3] += _nTotpe
							Endif
		
							If _nPosTmes == 0
								AADD(_aTotMes,{ Substr(Dtos(_dDataEnt),5,2) +"/"+Substr(Dtos(_dDataEnt),1,4) , (_nTotpe+_nIpi),_nTotPe})
							Else
								_aTotMes[_nPosTmes,2] += _nTotpe+_nIpi
								_aTotMes[_nPosTmes,3] += _nTotpe
							Endif
		
							_nNfGe  += _nTotpe+_nIpi
							_nNfGe2 += _nTotpe
			
						Endif 
						
						If Prow() > 60
							_nPag := _nPag + 1
							Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
						Endif  				
					
						@ Prow() +1, 001 Psay SC7->C7_ITEM 
						@ Prow()   , 006 Psay SC7->C7_PRODUTO 
						@ Prow()   , 021 Psay Substr(SC7->C7_DESCRI,1,42) 
						@ Prow()   , 065 Psay SC7->C7_DATPRF 
						@ Prow()   , 077 Psay _aPed[_n,17] 
		
						@ Prow()   , 087 Psay SD1->D1_CUSTO Picture "@E 999,999,999.99"
						_nTSemImp +=  SD1->D1_CUSTO
		
						@ Prow()   , 106 Psay SD1->D1_QUANT  Picture "@E 99999.99" 
						@ Prow()   , 115 Psay SC7->C7_UM 
						@ Prow()   , 120 Psay SD1->D1_VUNIT  Picture "@E 999,999,999.99" 
						@ Prow()   , 140 Psay SD1->D1_VALIPI Picture "@E 999,999,999.99" 
						@ Prow()   , 160 Psay (SD1->D1_QUANT * SD1->D1_VUNIT) Picture "@E 999,999,999.99" 
						@ Prow()   , 178 Psay (SD1->D1_TOTAL + SD1->D1_VALIPI)  Picture "@E 999,999,999.99" 
						@ Prow()   , 201 Psay SC7->C7_SIGLA
		
						_nTotItem := _nTotItem + _nTotPe
						_nTotCIpi := _nTotCIpi + _nTotpe + _nIpi
						
						If mv_par12==1 //Imprime Obs da SC
							SC1->(dbSetOrder(1)) //C1_FILIAL+C1_NUM+C1_ITEM
							If SC1->(dbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
								@ Prow()+1 , 001 Psay "Obs. SC: "+SC7->C7_OBS
							EndIf
						EndIf
					Endif						
	            Endif
			Endif
		Endif  		
		SD1->(DbSkip())
	Enddo
	If _nTotItem > 0
		@ Prow() +2, 001 Psay " "
	Endif
	_lPri     := .T.
	_nTotItem := 0
	_nTotCIpi := 0
	_n++

	If _n <= Len(_aPed)

	    If _aPed[_n,14] <> _nSemana

			If Prow() > 60
				_nPag := _nPag + 1
				Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
			Endif

			@ Prow()+2 , 127 Psay "Total da " + Transform(nConta,"99") + ".a Semana"
			@ Prow()   , 160 Psay transform(nSubTot, "@E 999,999,999.99")
			@ Prow()   , 062 Psay "Total S/ Imp. + Despesas ->"
			@ Prow()   , 088 Psay transform(_nTSemImp, "@E 999,999,999.99")
	
			@ Prow()+1 , 132 Psay "Total Acumulado1"
			@ Prow()   , 160 Psay transform(nTotGer, "@E 999,999,999.99")
			@ Prow() + 1, 001 Psay __PrtThinLine()

  			_aMes := Asort(_aMes,,, { |x,y| x[1] > y[1] })
			For j := 1 To Len(_aMes)
				@ Prow()+1 , 064 Psay "Previsao PC mes " + _aMes[j,1]
				@ Prow()   , 088 Psay Transform(_aMes[j,3], "@E 999,999,999.99")
				@ Prow()   , 160 Psay Transform(_aMes[j,2], "@E 999,999,999.99")
			Next

			@ Prow()+1 , 001 Psay " "
			nSubTot     := 0
			_nSubAtende := 0
			_nSubAberto := 0
			_aMes       := {}
			nConta := nConta +1
			Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)

		Endif 

	Else 
	
		If Prow() > 60 
			_nPag := _nPag + 1 
			Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo) 
		Endif 

		@ Prow()+2 , 127 Psay "Total da " + Transform(nConta,"99") + ".a Semana" 
		@ Prow()   , 160 Psay transform(nSubTot, "@E 999,999,999.99") 

		@ Prow()   , 062 Psay "Total S/ Imp. + Despesas ->"
		@ Prow()   , 088 Psay transform(_nTSemImp, "@E 999,999,999.99")

		@ Prow()+1 , 132 Psay "Total Acumulado2" 
		@ Prow()   , 160 Psay transform(nTotGer, "@E 999,999,999.99") 
 		@ Prow() + 1, 001 Psay __PrtThinLine() 

		_aMes := Asort(_aMes,,, { |x,y| x[1] > y[1] })
		For j := 1 To Len(_aMes)

			If Prow() > 60 
				_nPag := _nPag + 1 
				Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo) 
			Endif 
			@ Prow()+1 , 064 Psay "Previsao PC mes " + _aMes[j,1]
			@ Prow()   , 088 Psay Transform(_aMes[j,3], "@E 999,999,999.99")
			@ Prow()   , 160 Psay Transform(_aMes[j,2], "@E 999,999,999.99")
		Next
		@ Prow()+1 , 001 Psay " "

	Endif 

Enddo 
If Prow() > 60 
	_nPag := _nPag + 1 
	Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo) 
Endif 

@ Prow() + 1, 001 Psay __PrtThinLine() 
@ Prow() +1 , 136 Psay "Total Geral3"
@ Prow()    , 160 Psay transform(nTotGer, "@E 999,999,999.99")
// @ Prow()+1 , 136 Psay "   Atendido"
// @ Prow()   , 160 Psay transform(_nTotAtende, "@E 999,999,999.99")
@ Prow()+1 , 001 Psay __PrtThinLine()

@ Prow()+1 , 064 Psay "Total Geral NF Periodo"
@ Prow()   , 088 Psay Transform(_nNfGe2, "@E 999,999,999.99")
@ Prow()   , 160 Psay Transform(_nNfGe, "@E 999,999,999.99")

_aTotMes := Asort(_aTotMes,,, { |x,y| x[1] > y[1] })
j := 1
For j := 1 To Len(_aTotMes)
	If Prow() > 60 
		_nPag := _nPag + 1 
		Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo) 
	Endif 
	@ Prow()+1 , 064 Psay "Previsao PC mes " + _aTotMes[j,1]
	@ Prow()   , 088 Psay Transform(_aTotMes[j,2], "@E 999,999,999.99")
	@ Prow()   , 160 Psay Transform(_aTotMes[j,2], "@E 999,999,999.99")
Next
@ Prow()+1 , 001 Psay __PrtThinLine()
@ Prow()+1 , 001 Psay " "

      
Return(nil) 

/*
Static Function RptDet2()
_n := 1

If Mv_Par11 == 2
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS EM ABERTO, PERIODO DE "+DTOC(Mv_Par06) + " ATE "+DTOC(Mv_Par07)
Elseif Mv_Par11 == 3
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS ATENDIDOS, PERIODO DE "+DTOC(Mv_Par06) + " ATE "+DTOC(Mv_Par07)
Else
	titulo := "PREVISAO DE DESEMBOLSO P/FORNECEDOR PEDIDOS EM ABERTO/ATENDIDOS, PERIODO DE "+DTOC(Mv_Par06) + " ATE "+DTOC(Mv_Par07)
Endif

TMP->(DbGoTop())
ProcRegua(TMP->(RecCount()))

// imprime cabe�alho
Cabec(Titulo, Cabec1,Cabec2,NomeProg, Tamanho, nTipo)
       
// calcula as datas finais para cada semana
          
dData1:= CTOD("//")
if _aPed[_n,14] < 7
   dData1 := Mv_par06 + 1 - _aPed[_n,14]
else
   dData1 := Mv_par06 + 1
endif

// inicializa variaveis    
nSubIpi  := 0
dData2   := dData1 + 7
dData3   := dData2 + 7
dData4   := dData3 + 7   
dData5   := dData4 + 7
dData6   := dData5 + 7   
cCentroC := _aPed[_n,9]
_nSemana := _aPed[_n,14]
_nTotAtende := 0
_nTotAberto := 0
_nSubAtende := 0
_nSubAberto := 0

// inicializa totalizadores   
nSubTot  := 0      
_nTSemImp := 0 //total sem impostos
nTotGer  := 0
nTotCC   := 0
nConta   := 1


While _n <= Len(_aPed)

   IncProc("Imprimindo Previsao de Desembolso " + _aPed[_n,2])
   
   If Prow() > 60
      _nPag := _nPag + 1
      Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
   Endif   

	@ Prow() +1, 001 Psay _aPed[_n,1]
	@ Prow()   , 012 Psay _aPed[_n,2]
	@ Prow()   , 020 Psay _aPed[_n,3] + " " + SUBSTR(_aPed[_n,4],1,30)	  	
	@ Prow()   , 059 Psay transform(_aPed[_n,20], "@E 999,999,999.99")
	@ Prow()   , 075 Psay _aPed[_n,6]
	@ Prow()   , 087 Psay SUBSTR(_aPed[_n,8],1,12) 

	if substr(_aPed[_n,8],1,2) <> '  ' 
	   @ Prow()   , 102 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],1,2)))
	endif
	if substr(_aPed[_n,8],4,2) <> '  ' 
   	@ Prow()   , 114 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],4,2))) 
	endif
	if substr(_aPed[_n,8],8,2) <> '  ' 
   	@ Prow()   , 126 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],7,2))) 
	endif           
	if substr(_aPed[_n,8],12,2) <> '  ' 
   	@ Prow()   , 138 Psay DTOC(_aPed[_n,6] + val(substr(_aPed[_n,8],10,2))) 
	endif           

  	//nSubTot - variavel de subtotal para semanas
    //nTotGer - variavel de total geral
	nSubTot  += _aPed[_n,20]
	nSubTot2 += _aPed[_n,20]
	nTotGer  += _aPed[_n,20]
	_nSaldo := 0
	_nSaldo := (_aPed[_n,18] - _aPed[_n,19]) // Saldo
	If _nSaldo > 20
		_nTotAberto += _aPed[_n,20]
		_nSubAberto += _aPed[_n,20]
	Else
		_nTotAtende += _aPed[_n,20]
		_nSubAtende += _aPed[_n,20]
	Endif

	@ Prow()   , 152 Psay transform(_aPed[_n,13],"@E 999,999,999.99")
	@ Prow()   , 170 Psay transform(_aPed[_n,20],"@E 999,999,999.99")
	@ Prow()   , 186 Psay transform(nSubTot,"@E 999,999,999.99")
	@ Prow()   , 206 Psay _aPed[_n,12] + "  " + _aPed[_n,16]
	_nSemana := _aPed[_n,14]
	_n++

	If _n <= Len(_aPed)
	    If _aPed[_n,14] <> _nSemana

			If Prow() > 60
				_nPag := _nPag + 1
				Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
			Endif   

			@ Prow()+2 , 127 Psay "Total da " + Transform(nConta,"99") + ".a Semana"
			@ Prow()   , 186 Psay transform(nSubTot, "@E 999,999,999.99")
	
			If Mv_Par11 == 1
				@ Prow()+1 , 132 Psay "       Atendido"
				@ Prow()   , 186 Psay transform(_nSubAtende, "@E 999,999,999.99")
				@ Prow()+1 , 131 Psay "       Em Aberto"
				@ Prow()   , 186 Psay transform(_nSubAberto, "@E 999,999,999.99")
			Endif	

			@ Prow()+1 , 132 Psay "Total Acumulado4"
			@ Prow()   , 186 Psay transform(nTotGer, "@E 999,999,999.99")
			@ Prow() + 1, 001 Psay __PrtThinLine()
			@ Prow()+1 , 001 Psay " "
			nSubTot     := 0
			_nSubAtende := 0
			_nSubAberto := 0
			nConta := nConta +1
			Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)
		Endif
	Else

		If Prow() > 60
			_nPag := _nPag + 1
			Cabec(Titulo, Cabec1, Cabec2,NomeProg, Tamanho, nTipo)                                                                   
		Endif   

		@ Prow()+2 , 127 Psay "Total da " + Transform(nConta,"99") + ".a Semana"

		@ Prow()   , 067 Psay "Total S/ Impostos -->"
		@ Prow()   , 088 Psay transform(nSubTot2, "@E 999,999,999.99")
		@ Prow()   , 186 Psay transform(nSubTot, "@E 999,999,999.99")

		If Mv_Par11 == 1
			@ Prow()+1 , 132 Psay "       Atendido"
			@ Prow()   , 186 Psay transform(_nSubAtende, "@E 999,999,999.99")
			@ Prow()+1 , 131 Psay "       Em Aberto"
			@ Prow()   , 186 Psay transform(_nSubAberto, "@E 999,999,999.99")
		Endif	

		@ Prow()+1 , 132 Psay "Total Acumulado5"
		@ Prow()   , 186 Psay transform(nTotGer, "@E 999,999,999.99")
		@ Prow() + 1, 001 Psay __PrtThinLine()
	Endif		

Enddo

@ Prow()+1 , 136 Psay "Total Geral6"
@ Prow()   , 186 Psay transform(nTotGer, "@E 999,999,999.99") 
@ Prow()+1 , 132 Psay "       Atendido"
@ Prow()   , 186 Psay transform(_nTotAtende, "@E 999,999,999.99") 
@ Prow()+1 , 131 Psay "       Em Aberto" 
@ Prow()   , 186 Psay transform(_nTotAberto, "@E 999,999,999.99") 
@ Prow() + 1, 001 Psay __PrtThinLine() 
      
Return(nil)      
*/