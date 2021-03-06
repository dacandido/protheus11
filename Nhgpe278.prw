/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE278  �Autor  �Marcos R Roquitski  � Data �  09/12/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera arquivo holerite Mensal DLL Informatica.              ���
���          � 13o. Segunda Parcela.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � ITESAPAR                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"                                                                     
#include "protheus.ch"
#include "topconn.ch" 

User Function Nhgpe278()     


SetPrvt("CARQTXT,CCONTA,CDIGIT,NPONTO,X,NLIN")
SetPrvt("NTOT,CNRCOB,NVALOR,CDATVEN,")
SetPrvt("nHdl,cLin,cFnl,_cMat,_cMvGpe125")

_cMvGpe125s := Alltrim(GETMV("MV_GPE125S")) // Sequencial

SRI->(DbSetOrder(1))

dbSelectArea("SX1")
dbSetOrder(1)
SX1->(DbSeek("NHGP125"))
While !Sx1->(Eof()) .and. SX1->X1_GRUPO = "NHGP125"
	If SX1->X1_ORDEM == '08'
		RecLock('SX1')
		SX1->X1_CNT01 := _cMvGpe125s      
		MsUnLock('SX1')
	Endif	
	SX1->(DbSkip())
Enddo

If !Pergunte("NHGP125",.T.)
	Return
Endif

//Depositos
fTmp0Dep()
DbSelectArea("TMP0")
If !Empty(TMP0->RA_MAT) 
	cArqDep := "C:\RELATO\IT13D"+SM0->M0_CODFIL + Substr(Dtos(dDataBase),5,4) + ".REM" // Deposito
	cFnl    := CHR(13)+CHR(10)
	nHdl    := fCreate(cArqDep)
	lEnd    := .F.

	MsAguarde ( {|lEnd| fArqDep() },"Aguarde","Gerando arquivo...",.T.)

Endif


Return


// Holerite Banco do Brasil
Static Function fArqDep()
Local nSega := nSegd := nSege := nSegt := 1
Local _nTotsa := 0
Local _nSalFunc := 0
Local _cMat := Space(06)
Local _n736Fgts := _nVlCre := _nVlDeb := _nVlLiq := _nVlSal := _n701Irrf := _n735Fgts := _n715Fgts := _n723Irad := _n799Liqu := 0

	nlin := 0

	** Visao 1
	cLin := StrZero(0,20)
	cLin := cLin + "00"
	cLin := cLin + "0"
	cLin := cLin + StrZero(val(substr(mv_par02,1,4)),4) // Agencia
	cLin := cLin + fGeracc()
	cLin := cLin + "EDO001"

	If SM0->M0_CODIGO == "FN"
		cLin := cLin + "000000003307"  // Contrato Fundicao
	Else
		cLin := cLin + "000000003304"  // Contrato Usinagem
	Endif
		
	cLin := cLin + StrZero(Val(MV_PAR08),6)
	cLin := cLin + "00315"
	cLin := cLin + "00001"
	cLin := cLin + Substr(Dtos(dDataBase),1,4)
	cLin := cLin + Substr(Dtos(dDataBase),5,2)
	cLin := cLin + "00"
	cLin := cLin + Substr(Dtos(mv_par04),7,2)+Substr(Dtos(mv_par04),5,2)+Substr(Dtos(mv_par04),1,4)				
	cLin := cLin + Space(12)
	cLin := cLin + cFnl
	fWrite(nHdl,cLin,Len(cLin))
	_nSeq  := 1
	_nFunc := 0
	

	** Visao 2
	DbSelectarea("TMP0")
	TMP0->(DbGotop())
	While !TMP0->(Eof())		

		_nSeq  := 1
		_nFunc++

		// Processa PROVENTOS
		
		_n738Fgts := 0
		_n705Irrf := 0
		_n739Fgts := 0
		_n718Inss := 0
		_n411Irad := 0
		_n797Liqu := 0
        
		_nLinPro :=  0
		DbSelectarea("SRI")
		SRI->(DbSeek(xFilial("SRI")+TMP0->RA_MAT))
		While !SRI->(Eof()) .AND. SRI->RI_MAT == TMP0->RA_MAT .AND. SRI->RI_FILIAL == TMP0->RA_FILIAL
			If SRV->(DbSeek(xFilial("SRV") + SRI->RI_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '1' // Provento/Credito
					_nLinPro++
				Endif
			Endif
			IIf(SRI->RI_PD == '738',_n738Fgts := SRI->RI_VALOR,0)
			IIf(SRI->RI_PD == '705',_n705Irrf := SRI->RI_VALOR,0)
			IIF(SRI->RI_PD == '739',_n739Fgts := SRI->RI_VALOR,0)
			IIF(SRI->RI_PD == '718',_n718Inss := SRI->RI_VALOR,0)
			IIF(SRI->RI_PD == '411',_n411Irad := SRI->RI_VALOR,0)
			IIF(SRI->RI_PD == '797',_n797Liqu := SRI->RI_VALOR,0)
			SRI->(DbSkip())
		Enddo


		// Processa DESCONTO
		DbSelectarea("SRI")
		SRI->(DbSeek(xFilial("SRI")+TMP0->RA_MAT))
		While !SRI->(Eof()) .AND. SRI->RI_MAT == TMP0->RA_MAT .AND. SRI->RI_FILIAL == TMP0->RA_FILIAL
			If SRV->(DbSeek(xFilial("SRV") + SRI->RI_PD)) 
				If 	SRV->RV_TIPOCOD == '2' // Desconto
					_nLinPro++
				Endif
			Endif
			SRI->(DbSkip())
		Enddo

		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + "00" 
		cLin := cLin + "1" 
		cLin := cLin + Substr(TMP0->RA_BCDEPSA,4,4) // Agencia sem DV 
		cLin := cLin + StrZero(Val(Substr(TMP0->RA_CTDEPSA,1,8)),11) // Conta corrente sem dv 
		cLin := cLin + StrZero(_nLinPro+23,2) 
		cLin := cLin + TMP0->RA_NOME + Space(10) 
		cLin := cLin + TMP0->RA_CIC 
		cLin := cLin + Space(09)
		cLin := cLin + cFnl
		fWrite(nHdl,cLin,Len(cLin))


		** Visao 3
		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "DEMONSTRATIVO DE PAGAMENTO"
		cLin := cLin + Space(22)
		cLin := cLin + "1"	
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))
                                     

		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
  		cLin := cLin + "EMPRESA: ITESAPAR FUNDICAO S/A          " + Space(08)
		cLin := cLin + "1"	
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++		
		fWrite(nHdl,cLin,Len(cLin))


		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "CNPJ   : "+ Transform(Substr(SM0->M0_CGC,1,14),"@R 99.999.999/9999-99")
		cLin := cLin + Space(21)
		cLin := cLin + "1"	
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "FUNCIONARIO: "+ TMP0->RA_MAT + ' ' + Substr(TMP0->RA_NOME,1,28)
		cLin := cLin + "0"	
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		_cDescf := Space(20)
		SRJ->(DbSeek(xFilial("SRJ")+TMP0->RA_CODFUNC))
		If SRJ->(Found())
			_cDescf := SRJ->RJ_DESC
		Endif

		_cDescc := Space(25)
		CTT->(DbSeek(xFilial("CTT")+TMP0->RA_CC))
		If CTT->(Found())
			_cDescc := Substr(CTT->CTT_DESC01,1,25)
		Endif		

		cLin := StrZero(Val(TMP0->RA_MAT),20)     
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "C. CUSTO   : "+ TMP0->RA_CC + ' ' + _cDescc
		cLin := cLin + "0"	
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "DATA DE ADMISSAO: "+ Substr(TMP0->RA_ADMISSA,7,2)+'/'+Substr(TMP0->RA_ADMISSA,5,2)+'/'+Substr(TMP0->RA_ADMISSA,1,4)
		cLin := cLin + Space(20)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "CARGO           : "+ TMP0->RA_CODFUNC + ' ' + _cDescf
		cLin := cLin + Space(05)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "AGENCIA/CONTA   : "+ Substr(TMP0->RA_BCDEPSA,4,3)+'/'+TMP0->RA_CTDEPSA
		cLin := cLin + Space(14)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "DATA DE PAGTO   : "+ Substr(Dtos(mv_par04),7,2)+'/'+Substr(Dtos(mv_par04),5,2)+'/'+Substr(Dtos(mv_par04),1,4)
		cLin := cLin + Space(20)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + 'MES REFERENCIA  : '+Substr(Dtos(dDataBase),5,2)+'/'+Substr(Dtos(dDataBase),1,4)
		cLin := cLin + Space(23)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "FOLHA           : 13o. 2o. PARCELA"
		cLin := cLin + Space(14)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		// Processa PROVENTOS
		_nTotPro :=  0
		DbSelectarea("SRI")
		SRI->(DbSeek(xFilial("SRI")+TMP0->RA_MAT))
		While !SRI->(Eof()) .AND. SRI->RI_MAT == TMP0->RA_MAT .AND. SRI->RI_FILIAL == TMP0->RA_FILIAL
			If SRV->(DbSeek(xFilial("SRV") + SRI->RI_PD)) // Verbas
				If 	SRV->RV_TIPOCOD == '1' // Provento/Credito
					cLin := StrZero(Val(TMP0->RA_MAT),20)
					cLin := cLin + StrZero(_nSeq,2)
					cLin := cLin + "2"
					cLin := cLin + SRV->RV_COD + ' ' + SRV->RV_DESC + ' '+ Str(SRI->RI_HORAS,8,2) +  '  ' + Transform(SRI->RI_VALOR,"@E 99,999,999.99")
					cLin := cLin + "0"
					cLin := cLin + Space(28)
					cLin := cLin + cFnl
					_nTotPro += SRI->RI_VALOR
					_nSeq++
					fWrite(nHdl,cLin,Len(cLin))
				Endif
			Endif
			SRI->(DbSkip()) 
		Enddo

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "TOTAL DE PROVENTOS                 " + Transform(_nTotPro,"@E 99,999,999.99")
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotPro := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + Space(48)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "          "
		cLin := cLin + Space(38)
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))
		

		// Processa DESCONTO
		_nTotDes := 0
		DbSelectarea("SRI")
		SRI->(DbSeek(xFilial("SRI")+TMP0->RA_MAT))
		While !SRI->(Eof()) .AND. SRI->RI_MAT == TMP0->RA_MAT .AND. SRI->RI_FILIAL == TMP0->RA_FILIAL
			If SRV->(DbSeek(xFilial("SRV") + SRI->RI_PD)) 
				If 	SRV->RV_TIPOCOD == '2' // Desconto
					cLin := StrZero(Val(TMP0->RA_MAT),20)
					cLin := cLin + StrZero(_nSeq,2)
					cLin := cLin + "2"
					cLin := cLin + SRV->RV_COD + ' ' + SRV->RV_DESC + ' '+ Str(SRI->RI_HORAS,8,2) +  '  ' + Transform(SRI->RI_VALOR,"@E 99,999,999.99")
					cLin := cLin + "0"
					cLin := cLin + Space(28)
					cLin := cLin + cFnl     
					_nTotDes += SRI->RI_VALOR
					_nSeq++
					fWrite(nHdl,cLin,Len(cLin))
				Endif
			Endif
			SRI->(DbSkip()) 
		Enddo

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "TOTAL DE DESCONTOS                 " + Transform(_nTotDes,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

        
		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + Space(48)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))


		cLin := StrZero(Val(TMP0->RA_MAT),20) 
		cLin := cLin + StrZero(_nSeq,2) 
		cLin := cLin + "2" 
		cLin := cLin + "LIQUIDO A RECEBER                  " + Transform(_n797Liqu,"@E 99,999,999.99") 
		cLin := cLin + "1" 
		cLin := cLin + Space(28) 
		cLin := cLin + cFnl 
		_nTotDes := 0 
		_nSeq++ 
		fWrite(nHdl,cLin,Len(cLin)) 


		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + Space(48)
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		_nSalFunc := 0
		If TMP0->RA_CATFUNC == 'H'
			_nSalFunc := TMP0->RA_SALARIO

			cLin := StrZero(Val(TMP0->RA_MAT),20)
			cLin := cLin + StrZero(_nSeq,2)
			cLin := cLin + "2"
			cLin := cLin + "SALARIO HORA                       " + Transform(_nSalFunc,"@E 99,999,999.99")
			cLin := cLin + "0"
			cLin := cLin + Space(28)
			cLin := cLin + cFnl
			_nTotDes := 0
			_nSeq++
			fWrite(nHdl,cLin,Len(cLin))

		Else
			_nSalFunc := TMP0->RA_SALARIO		
			cLin := StrZero(Val(TMP0->RA_MAT),20)
			cLin := cLin + StrZero(_nSeq,2)
			cLin := cLin + "2"
			cLin := cLin + "SALARIO MENSAL                     " + Transform(_nSalFunc,"@E 99,999,999.99")
			cLin := cLin + "0"
			cLin := cLin + Space(28)
			cLin := cLin + cFnl
			_nTotDes := 0
			_nSeq++
			fWrite(nHdl,cLin,Len(cLin))

		Endif	

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "SALARIO CONTRIBUICAO INSS          " + Transform(_n718Inss,"@E 99,999,999.99")
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "FGTS                               " + Transform(_n739Fgts,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "IRPF 13 SALARIO                    " + Transform(_n411Irad,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "BASE DE CALCULO IRPF               " + Transform(_n705Irrf,"@E 99,999,999.99")
		cLin := cLin + "1"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		cLin := StrZero(Val(TMP0->RA_MAT),20)
		cLin := cLin + StrZero(_nSeq,2)
		cLin := cLin + "2"
		cLin := cLin + "BASE DE CALCULO FGTS               " + Transform(_n738Fgts,"@E 99,999,999.99")
		cLin := cLin + "0"
		cLin := cLin + Space(28)
		cLin := cLin + cFnl
		_nTotDes := 0
		_nSeq++
		fWrite(nHdl,cLin,Len(cLin))

		TMP0->(DbSkip())

	Enddo


// Visao 4
cLin := "99999999999999999999" 
cLin := cLin + "99" 
cLin := cLin + "9" 
cLin := cLin + "999999999999999"
cLin := cLin + StrZero(_nFunc,11) 
cLin := cLin + Space(51) 
cLin := cLin + cFnl 
fWrite(nHdl,cLin,Len(cLin)) 

fClose(nHdl) 

// Grava sx6.

If SX6->(DbSeek(xFilial()+"MV_GPE125S"))
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD:= mv_par08
	MsUnlock("SX6")
Endif	


DbSelectArea("TMP0")
DbCloseArea("TMP0")

Return(nil)



Static Function fGeracc()
Local _cRet,cConta,i
Local cDac := ''

	cConta    := StrZero(Val(Substr(MV_PAR03,1,AT("-",MV_PAR03))),12,0)
	_cRet := StrZero(Val(cConta),11)
	
Return(_cRet)



Static Functio fGeraat()
Local _cAgencia := _cConta := _cRet :=  _cDac := ''

	_cAgencia  := StrZero(Val(Substr(TMT->ZRA_AGENCI,1,4)),5,0)+Substr(TMT->ZRA_AGENCI,5,1)
	_cConta    := StrZero(Val(Substr(TMT->ZRA_CONTA,1,AT("-",TMT->ZRA_CONTA))),12,0)

	i := 1
	For i := 1 To 12
		If Substr(TMT->ZRA_CONTA,i,1) == "-"
			_cDac := _cDac + Substr(TMT->ZRA_CONTA,i+1,2)
			Exit
		Endif
	Next
	_cDac   := Alltrim(_cDac)
      
	If     Len(_cDac) == 1
		_cRet := _cAgencia+_cConta+_cDac+" "
	Elseif Len(_cDac) == 2
		_cConta := StrZero(Val(Substr(TMT->ZRA_CONTA,1,AT("-",TMT->ZRA_CONTA))),12,0)
		_cRet   := _cAgencia+_cConta+_cDac 
	Else
		_cRet   := _cAgencia+_cConta+Space(02)
	Endif

Return(_cRet) 


Static Functio fGerado()
Local _cAgencia := _cConta := _cRet :=  _cDac := ''

	_cAgencia  := StrZero(Val(Substr(TMD->ZRA_AGENCI,1,4)),5,0)+Substr(TMD->ZRA_AGENCI,5,1)
	_cConta    := StrZero(Val(Substr(TMD->ZRA_CONTA,1,AT("-",TMD->ZRA_CONTA))),12,0)

	i := 1
	For i := 1 To 12
		If Substr(TMD->ZRA_CONTA,i,1) == "-"
			_cDac := _cDac + Substr(TMD->ZRA_CONTA,i+1,2)
			Exit
		Endif
	Next
	_cDac   := Alltrim(_cDac)
      
	If     Len(_cDac) == 1
		_cRet := _cAgencia+_cConta+_cDac+" "
	Elseif Len(_cDac) == 2
		_cConta := StrZero(Val(Substr(TMD->ZRA_CONTA,1,AT("-",TMD->ZRA_CONTA))),12,0)
		_cRet   := _cAgencia+_cConta+_cDac 
	Else
		_cRet   := _cAgencia+_cConta+Space(02)
	Endif

Return(_cRet) 


// Liquidos
Static Function fTmp0Dep()

cQuery := "SELECT * FROM " + RetSqlName('SRA') + " RA "
cQuery += "WHERE RA.D_E_L_E_T_ = ' ' " 
cQuery += "AND RA.RA_FILIAL = '" + xFilial("SRA")+ "'"
cQuery += "AND RA.RA_DEMISSA = ' ' " 
cQuery += "AND RA.RA_CATFUNC NOT IN ('G','P','A') " 
cQuery += "AND SUBSTRING(RA.RA_BCDEPSA,1,3) = '399' " 
cQuery += "AND RA.RA_MAT BETWEEN '"+ Mv_par06 + "' AND '"+ Mv_par07 + "' "
cQuery += "ORDER BY RA.RA_CC "

TCQUERY cQuery NEW ALIAS "TMP0" 

DbSelectArea("TMP0")
TMP0->(Dbgotop())

