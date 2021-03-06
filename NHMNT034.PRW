#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHMNT034  �Autor �Jo�o Felipe da Rosa � Data �  00/00/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � ATENDIMENTOS �S O.S. DE MANUTEN��O                         ���
�������������������������������������������������������������������������͹��
���Uso       � MANUTENCAO DE ATIVOS                                       ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NHMNT034()   

Private _aSrv := {}
Agrupo 	  := {}
cString   := ""
cDesc1    := OemToAnsi("Este relat�rio apresenta a quantidade de O.S. atendidas")
cDesc2    := OemToAnsi("por funcion�rio, dividido por turno, f�brica e tipo de O.S.")
cDesc3    := OemToAnsi("")
tamanho   := "G"
limite    := 220
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "NHMNT034" //nome do arquivo
aLinha    := { }
nLastKey  := 0
titulo    := OemToAnsi("ATENDIMENTO �S O.S. DE MANUTEN��O") //t�tulo
//           |01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

If SM0->M0_CODIGO=="NH" //EMPRESA USINAGEM
	cabec1    := " Turno   Nome                         Servico->      000     001     006     018     019     026     003     011     010     016     022     012     014     005     007     002     024                              Total"
ElseIf SM0->M0_CODIGO=="FN"
	cabec1    := " Turno   Nome                         Servico->      000     001     002     003     005     006     008     009     010     011     012     013     014     016     024     029     031     032     033     034      Total"	
EndIf

cabec2    := ""
cabec3    := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
_nPag     := 1 //Variavel que acumula numero da pagina 
M_PAG     := 1
wnrel     := nomeprog //"NH"
_cPerg    := "MNT034" 
_aMat     := {}

//��������������������������Ŀ
//�MV_PAR01 - De Data ?      �
//�MV_PAR02 - Ate Data ?     �
//�MV_PAR03 - De Matricula ? �
//�MV_PAR04 - Ate Matricula ?�
//�MV_PAR05 - De Turno ?     �
//�MV_PAR06 - Ate Turno ?    �
//�MV_PAR07 - De C.Trab. ?   �
//�MV_PAR08 - Ate C.Trab. ?  �
//�MV_PAR09 - De Servico ?   �
//�MV_PAR10 - Ate Servico ?  �
//����������������������������

If !Pergunte(_cPerg,.T.)
   Return(nil)
Endif 

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

If SM0->M0_CODIGO=="NH" //EMPRESA USINAGEM
	aAdd(_aSrv,"000000")
	aAdd(_aSrv,"000001")
	aAdd(_aSrv,"000006")
	aAdd(_aSrv,"000018")
	aAdd(_aSrv,"000019")
	aAdd(_aSrv,"000026")
	aAdd(_aSrv,"000003")
	aAdd(_aSrv,"000011")
	aAdd(_aSrv,"000010")
	aAdd(_aSrv,"000016")
	aAdd(_aSrv,"000022")
	aAdd(_aSrv,"000012")
	aAdd(_aSrv,"000014")
	aAdd(_aSrv,"000005")
	aAdd(_aSrv,"000007")
	aAdd(_aSrv,"000002")
	aAdd(_aSrv,"000024")
ElseIf SM0->M0_CODIGO=="FN"
	aAdd(_aSrv,"000000")
	aAdd(_aSrv,"000001")
	aAdd(_aSrv,"000002")
	aAdd(_aSrv,"000003")
	aAdd(_aSrv,"000005")
	aAdd(_aSrv,"000006")
	aAdd(_aSrv,"000008")
	aAdd(_aSrv,"000009")
	aAdd(_aSrv,"000010")
	aAdd(_aSrv,"000011")
	aAdd(_aSrv,"000012")
	aAdd(_aSrv,"000013")
	aAdd(_aSrv,"000014")
	aAdd(_aSrv,"000016")
	aAdd(_aSrv,"000024")
	aAdd(_aSrv,"000029")
	aAdd(_aSrv,"000031")
	aAdd(_aSrv,"000032")
	aAdd(_aSrv,"000033")
	aAdd(_aSrv,"000034")
EndIf

	
//�������������Ŀ
//�MONTA A QUERY�
//���������������

cQuery := "SELECT  T1_CODFUNC,T1.T1_TURNO, T1.T1_NOME, "

For _x := 1 to (len(_aSrv)-1)
	cQuery += QtdAtend(_aSrv[_x])+","
Next   

cQuery += QtdAtend(_aSrv[len(_aSrv)])
cQuery += " FROM "+RetSqlName("ST1")+" T1"
cQuery += " WHERE T1.T1_CODFUNC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cquery += " AND T1.T1_TURNO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQuery += " AND T1.T1_TIPOFUN = 'S'"
cQuery += " AND T1.T1_DISPONI = 'S'"
cQuery += " AND T1.D_E_L_E_T_ = '' "
cQuery += " AND T1.T1_FILIAL = '"+XFILIAL("ST1")+"'"   
cQuery += " ORDER BY T1.T1_TURNO, T1.T1_NOME"

//MemoWrit('C:\TEMP\'+nomeprog+'.SQL',cQuery)
TCQUERY cQuery NEW ALIAS "TRA1" 

TRA1->(DbGotop())

Return  
 
//��������������������������������������������������Ŀ
//� QUERY PARA BUSCAR A QUANTIDADE DE O.S. ATENDIDAS �
//����������������������������������������������������

Static Function QtdAtend(cSrv)
Local _cStrQry
                  
_cStrQry := " (SELECT COUNT(TL.TL_ORDEM) "
_cStrQry += " FROM "+RetSqlName("STL")+" TL, "+RetSqlName("STJ")+" TJ, "+RetSqlName("ST9")+" T9"
_cStrQry += " WHERE TL.TL_ORDEM = TJ.TJ_ORDEM"
_cStrQry += " AND TJ.TJ_DTORIGI BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
_cStrQry += " AND TL.TL_CODIGO = T1.T1_CODFUNC"
_cStrQry += " AND TL.TL_TIPOREG = 'M'"
_cStrQry += " AND TJ.TJ_CODBEM = T9.T9_CODBEM AND T9.T9_CENTRAB BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
_cStrQry += " AND TJ.TJ_SERVICO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
_cStrQry += " AND TJ.TJ_SERVICO = '"+cSrv+"'" 
_cStrQry += " AND TJ.D_E_L_E_T_ = '' AND TJ.TJ_FILIAL = '"+XFILIAL("STJ")+"'"
_cStrQry += " AND TL.D_E_L_E_T_ = '' AND TL.TL_FILIAL = '"+XFILIAL("STL")+"'"
_cStrQry += " AND T9.D_E_L_E_T_ = '' AND T9.T9_FILIAL = '"+XFILIAL("ST9")+"') AS S"+cSrv

Return _cStrQry

//����������������������������������Ŀ
//�FUNCAO PARA IMPRESSAO DO RELAT�RIO�
//������������������������������������

Static Function Imprime()
Local _nTS// Total Servi�o
Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 

SetRegua(TRA1->(RecCount()))

While TRA1->(!Eof())  

	If Prow() > 65 
		_nPag  := _nPag + 1   
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo) 
  	Endif

	IncRegua()

	_nTS := 0
		
	@Prow()+1, 001 psay TRA1->T1_TURNO
	@Prow()  , 009 psay SUBSTR(TRA1->T1_NOME,1,45)

	nLin := 50
	
	For x:=1 to Len(_aSrv)
		cField := "TRA1->S"+_aSrv[x]
		@Prow()  , nLin psay &(cField) Picture "@e 999999"
		_nTS += &(cField)
		nLin += 8
	Next	
			
/*	
	@Prow()  , 066 psay TRA1->S000001 //CORRETIVA PROGRAMADA
	_nTS += TRA1->S000001
	@Prow()  , 074 psay TRA1->S000006 //CORRETIVA PROGRAMADA DE LUBRIFICA��O
	_nTS += TRA1->S000006
	@Prow()  , 082 psay TRA1->S000018 //LABORAT�RIO DE ELETR�NICA
	_nTS += TRA1->S000018
	@Prow()  , 090 psay TRA1->S000019 //LABORAT�RIO DE FUSOS
	_nTS += TRA1->S000019
	@Prow()  , 098 psay TRA1->S000026 //LABORAT�RIO DE HIDR�ULICA E PNEUM�TICA
	_nTS += TRA1->S000026
	@Prow()  , 106 psay TRA1->S000003 //LUBRIFICACAO PREVENTIVA
	_nTS += TRA1->S000003
	@Prow()  , 114 psay TRA1->S000011 //MANUTENCAO DE REFRIGERACAO
	_nTS += TRA1->S000011
	@Prow()  , 122 psay TRA1->S000010 //MANUTENCAO ELETRICA
	_nTS += TRA1->S000010
	@Prow()  , 130 psay TRA1->S000016 //MELHORIAS
	_nTS += TRA1->S000016
	@Prow()  , 138 psay TRA1->S000022 //MONTAGEM DE M�QUINA
	_nTS += TRA1->S000022
	@Prow()  , 146 psay TRA1->S000012 //MUDANCA DE MAQUINA
	_nTS += TRA1->S000012
	@Prow()  , 154 psay TRA1->S000014 //PREDITIVA DE OLEO   
	_nTS += TRA1->S000014
	@Prow()  , 162 psay TRA1->S000005 //PREVENTIVA  
	_nTS += TRA1->S000005
	@Prow()  , 170 psay TRA1->S000007 //RECEBIMENTO DE MAQUINAS
	_nTS += TRA1->S000007
	@Prow()  , 178 psay TRA1->S000002 //ROTAS DE INSPE��O
	_nTS += TRA1->S000002
	@Prow()  , 186 psay TRA1->S000024 //SERVI�OS GERAIS
	_nTS += TRA1->S000024
*/

	@Prow()  , 211 psay _nTS picture "@e 99999999"
	
	
	TRA1->(DbSkip())

EndDo

@ prow()+1,000 PSAY __PrtThinLine() 
@ Prow()+1, 001 psay "LEGENDA:"

If SM0->M0_CODIGO=="NH" //EMPRESA USINAGEM
	@Prow()+1  , 001 psay "000 : CORRETIVA"
	@Prow()+1  , 001 psay "001 : CORRETIVA PROGRAMADA"
	@Prow()+1  , 001 psay "006 : CORRETIVA PROGRAMADA DE LUBRIFICA��O"
	@Prow()+1  , 001 psay "018 : LABORAT�RIO DE ELETR�NICA"
	@Prow()+1  , 001 psay "019 : LABORAT�RIO DE FUSOS"
	@Prow()+1  , 001 psay "026 : LABORAT�RIO DE HIDR�ULICA E PNEUM�TICA"
	@Prow()+1  , 001 psay "003 : LUBRIFICACAO PREVENTIVA"
	@Prow()+1  , 001 psay "011 : MANUTENCAO DE REFRIGERACAO"
	@Prow()+1  , 001 psay "010 : MANUTENCAO ELETRICA"
	@Prow()+1  , 001 psay "016 : MELHORIAS"
	@Prow()+1  , 001 psay "022 : MONTAGEM DE M�QUINA"
	@Prow()+1  , 001 psay "012 : MUDANCA DE MAQUINA"
	@Prow()+1  , 001 psay "014 : PREDITIVA DE OLEO"   
	@Prow()+1  , 001 psay "005 : PREVENTIVA"  
	@Prow()+1  , 001 psay "007 : RECEBIMENTO DE MAQUINAS"
	@Prow()+1  , 001 psay "002 : ROTAS DE INSPE��O"
	@Prow()+1  , 001 psay "024 : SERVI�OS GERAIS"
ElseIf SM0->M0_CODIGO=="FN" //EMPRESA FUNDICAO
	@Prow()+1  , 001 psay "000 : CORRETIVA"
	@Prow()+1  , 001 psay "001 : CORRETIVA PROGRAMADA"
	@Prow()+1  , 001 psay "002 : ROTAS DE INSPECAO MECANICA"
	@Prow()+1  , 001 psay "003 : LUBRIFICA��O PREVENTIVA"
	@Prow()+1  , 001 psay "005 : MANUTEN��O PREVENTIVA"
	@Prow()+1  , 001 psay "006 : CORRETIVA PROGRAMADA DE LUBRIFICA��O"
	@Prow()+1  , 001 psay "008 : REFORMA DE M�QUINAS"
	@Prow()+1  , 001 psay "009 : PREDITIVA TERMOGRAFIA"
	@Prow()+1  , 001 psay "010 : MANUTENCAO ELETRICA"
	@Prow()+1  , 001 psay "011 : PREDITIVA DE VIBRA��O"
	@Prow()+1  , 001 psay "012 : MUDANCA DE MAQUINA"
	@Prow()+1  , 001 psay "013 : ROTA DE INSPECAO ELETRICA"
	@Prow()+1  , 001 psay "014 : PREDITIVA DE �LEO"
	@Prow()+1  , 001 psay "016 : MELHORIAS"
	@Prow()+1  , 001 psay "024 : SERVI�OS GERAIS"
	@Prow()+1  , 001 psay "029 : SERVI�OS DE CALDEIRARIA"
	@Prow()+1  , 001 psay "031 : SERVI�OS RECUPERA��O MEC�NICA-OFICINA"
	@Prow()+1  , 001 psay "032 : SERVI�OS DE RECUPERA��O EL�TRICA-OFICINA"
	@Prow()+1  , 001 psay "033 : SERVI�OS DE RECUPERA��O EXTERNOS"
	@Prow()+1  , 001 psay "034 : MANUTEN��O DE AR CONDICIONADO"
EndIf
	
@ prow()+1,000 PSAY __PrtThinLine() 

TRA1->(DbCloseArea())

Return(nil)