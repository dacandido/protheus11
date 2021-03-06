/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EST214  �Autor:Jos� Henrique M Felipetto � Data �  10/16/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Etq. Fiat Exporta��o                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EST                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function NHEST214()
Private oPrN,oFnt01,oFnt02,nAlt,nLar,_nQuant
                                            
oFnt01  := TFont():New("Arial",,16,,.T.,,,,,.F.)
oFnt02  := TFont():New("Arial",,08,,.F.,,,,,.F.)
oFnt03  := TFont():New("Arial",,14,,.T.,,,,,.F.)
oFnt04  := TFont():New("Arial",,26,,.T.,,,,,.F.)
oFnt05  := TFont():New("Arial",,18,,.T.,,,,,.F.)

nAlt := 40
nLar := 40
_nLarBar := 2.0
_nCont := 1
_nQuant := 0

If !Pergunte("EST214",.T.)
	Return
EndIf

dadosDaNf()

SB1->( DbSetOrder(1) )
SB1->( DbSeek(xFilial("SB1") + mv_par01 ))

_cCodAP5 := Len(Alltrim(SB1->B1_CODAP5))
_cCod2   := Replicate("0" , 11 - _cCodAP5) + SB1->B1_CODAP5
_cCodBar := Substr(_cCod2,0,11) + '00008FZA19424'

_cClass := ""
If mv_par03 == 1
	_cClass := "11"
Elseif mv_par03 == 2
	_cClass := "12"
Elseif mv_par03 == 3
	_cClass := "21"
Elseif mv_par03 == 4
	_cClass := "22"
EndIf

SD2->( DbSetOrder(3) )
SD2->( DbSeek(xFilial("SD2") + mv_par05 + mv_par06 + mv_par07 + mv_par08 ))

oPrn := tMsPrinter():New("Protheus")
oPrn:StartPage()

For i := 1 to mv_par02
	If _nCont > 2
		oPrn:EndPage()
		nAlt := 40
		nLar := 40
		_nLarBar := 1.0
		_nCont := 1
		oPrn:StartPage()
	EndIf
	oPrn:Line(nAlt,nLar,nAlt, nLar + 1165.6) 			 	   	 // 1� Linha Horizontal
	oPrn:Line(nAlt,nLar,nAlt + 1773.2,nLar)  				   	 // 1� Linha Vertical
	oPrn:Line(nAlt,nLar + 1165.6,nAlt + 1773.2,nLar + 1165.6)  	 // 2� Linha Vertical
	oPrn:Line(nAlt + 1773.2,nLar,nAlt + 1773.2, nLar + 1165.6) 	 // 2� Linha Horizonte

	oPrn:Line(nAlt + 180 ,nLar,nAlt + 180, nLar + 1165.6) 	   	 // 2� Linha Horizontal
	oPrn:Line(nAlt + 300 ,nLar,nAlt + 300, nLar + 1165.6) 	   	 // 3� Linha Horizontal
	oPrn:Line(nAlt + 420 ,nLar,nAlt + 420, nLar + 1165.6) 	   	 // 4� Linha Horizontal

	oPrn:Line(nAlt + 960 ,nLar,nAlt + 960, nLar + 1165.6) 	   	 // 5� Linha Horizontal
	oPrn:Line(nAlt + 1080 ,nLar,nAlt + 1080, nLar + 1165.6)    	 // 6� Linha Horizontal
	oPrn:Line(nAlt + 1200 ,nLar,nAlt + 1200, nLar + 1165.6)    	 // 7� Linha Horizontal
	oPrn:Line(nAlt + 1320 ,nLar,nAlt + 1320, nLar + 1165.6)    	 // 8� Linha Horizontal
	oPrn:Line(nAlt + 1440 ,nLar,nAlt + 1440, nLar + 1165.6)    	 // 9� Linha Horizontal
	oPrn:Line(nAlt + 1560 ,nLar,nAlt + 1560, nLar + 1165.6)    	 //10� Linha Horizontal

	oPrn:Line(nAlt,nLar + 582.8,nAlt + 420,nLar + 582.8) 	   	 // 3� Linha Vertical
	oPrn:Line(nAlt + 960,nLar + 582.8,nAlt + 1080,nLar + 582.8)  // 5� Linha Vertical

	oPrn:Line(nAlt + 1080,nLar + 422.8,nAlt + 1200,nLar + 422.8) // 6� Linha Vertical
	oPrn:Line(nAlt + 1080,nLar + 722.8,nAlt + 1200,nLar + 722.8) // 7� Linha Vertical
	oPrn:Line(nAlt + 1200,nLar + 422.8,nAlt + 1320,nLar + 422.8) // 8� Linha Vertical
	oPrn:Line(nAlt + 1200,nLar + 722.8,nAlt + 1320,nLar + 722.8) // 9� Linha Vertical

	oPrn:Line(nAlt + 1320,nLar + 582.8,nAlt + 1440,nLar + 582.8) // 10� Linha Vertical

	oPrn:Line(nAlt + 1560,nLar + 442.8,nAlt + 1560,nLar + 442.8) // 11� Linha Vertical
	oPrn:Line(nAlt + 1560,nLar + 742.8,nAlt + 1560,nLar + 742.8) // 12� Linha Vertical

	oPrn:Line(nAlt + 1440,nLar + 482.8,nAlt + 1560,nLar + 482.8) // 13� Linha Vertical
	oPrn:Line(nAlt + 1440,nLar + 782.8,nAlt + 1560,nLar + 782.8) // 14� Linha Vertical

	oPrn:Say(nAlt + 40,nLar + 30,OemtoAnsi("FIAT AUTOM�VEIS S.A"), oFnt03 )
	oPrn:Say(nAlt + 40,nLar + 642.8,OemtoAnsi("WHB FUNDI��O"), oFnt01 )

	oPrn:Say(nAlt + 180,nLar + 10,OemtoAnsi("Data"), oFnt02 )
	oPrn:Say(nAlt + 220,nLar + 20,OemtoAnsi( DTOC( Date() ) ), oFnt03 )

	oPrn:Say(nAlt + 180,nLar + 592.8,OemtoAnsi("C�d. Fornecedor"), oFnt02 )
	oPrn:Say(nAlt + 220,nLar + 602.8,OemtoAnsi("19424"), oFnt03 )

	oPrn:Say(nAlt + 310,nLar + 10,OemtoAnsi("Denomina��o"), oFnt02 )
	oPrn:Say(nAlt + 350,nLar + 20,OemtoAnsi(Substr(SB1->B1_DESC,1,15) ), oFnt03 )

	oPrn:Say(nAlt + 310,nLar + 592.8,OemtoAnsi("N� Doc. Fiscal (BAM)"), oFnt02 )
	oPrn:Say(nAlt + 350,nLar + 602.8,OemtoAnsi(mv_par05), oFnt03 )

	oPrn:Say(nAlt + 420,nLar + 10,OemtoAnsi("Desenho"), oFnt02 )

	oPrn:Say(nAlt + 530,nLar + 220,"000" + OemtoAnsi(SB1->B1_CODAP5), oFnt04 )
	MSBAR("CODE128",5.5,_nLarBar,"000" + Alltrim(SB1->B1_CODAP5),oPrn,.F., ,.T.  ,0.0524,0.85,NIL,NIL,NIL,.F.,,,.F.)//imprime cod. de barraS correto
	oPrn:Say(nAlt + 760,nLar + 140,OemtoAnsi(_cCodBar), oFnt05 )

	oPrn:Say(nAlt + 960,nLar + 10,OemtoAnsi("Data Produ��o do Lote"), oFnt02 )
	oPrn:Say(nAlt + 1000,nLar + 20,OemtoAnsi(DTOC(SD2->D2_EMISSAO)), oFnt03 )

	oPrn:Say(nAlt + 960,nLar + 592.8,OemtoAnsi("C�digo da Embalagem"), oFnt02 )
	oPrn:Say(nAlt + 1000,nLar + 602.8,OemtoAnsi("FZA"), oFnt03 )

	oPrn:Say(nAlt + 1080,nLar + 10,OemtoAnsi("N� do Lote"), oFnt02 )
	_cLote := U_NHEST002(SD2->D2_EMISSAO)
	oPrn:Say(nAlt + 1120,nLar + 20,OemtoAnsi(_cLote), oFnt03 )

	oPrn:Say(nAlt + 1080,nLar + 442.8,OemtoAnsi("Quant. do Lote"), oFnt02 )
	oPrn:Say(nAlt + 1120,nLar + 402.8,OemtoAnsi(Str(_nQuant)), oFnt03 )

	oPrn:Say(nAlt + 1080,nLar + 732.8,OemtoAnsi("Quant. da Embalagem"), oFnt02 )
	oPrn:Say(nAlt + 1120,nLar + 822.8,Alltrim(mv_par09), oFnt03)

	oPrn:Say(nAlt + 1200,nLar + 10,OemtoAnsi("Classe Funcional"), oFnt02 )
	oPrn:Say(nAlt + 1240,nLar + 20,_cClass, oFnt03 )

	oPrn:Say(nAlt + 1200,nLar + 442.8,OemtoAnsi("V�nculo"), oFnt02 )
	oPrn:Say(nAlt + 1240,nLar + 452.8,OemtoAnsi("W"), oFnt03 )

	oPrn:Say(nAlt + 1200,nLar + 732.8,OemtoAnsi("Indica��o suplementar"), oFnt02 )

	oPrn:Say(nAlt + 1320,nLar + 10,OemtoAnsi("Tipo de Ve�culo"), oFnt02 )

	oPrn:Say(nAlt + 1320,nLar + 592.8,OemtoAnsi("Ponto de entrega"), oFnt02 )
	oPrn:Say(nAlt + 1360,nLar + 602.8,OemtoAnsi("Fiat"), oFnt03 )

	oPrn:Say(nAlt + 1440,nLar + 10,OemtoAnsi("Embarque Controlado"), oFnt02)
	oPrn:Say(nAlt + 1480,nLar + 20,"NAO", oFnt03)

	oPrn:Say(nAlt + 1440,nLar + 502.8,OemtoAnsi("Lote Sob Desvio"), oFnt02 )
	oPrn:Say(nAlt + 1480,nLar + 528.8,OemtoAnsi("NAO"), oFnt03 )

	oPrn:Say(nAlt + 1440,nLar + 792.8,OemtoAnsi("DUM"), oFnt02 )
	oPrn:Say(nAlt + 1480,nLar + 832.8,OemtoAnsi("13092006"), oFnt03 )
	_nLarBar := 11.5
	nLar := 1245.6
	_nCont++
Next i

oPrn:Preview()
oPrn:EndPage()
oPrn:End()
Return

Static Function dadosdaNf()

SD2->( DbSetOrder(3) )
SD2->( DbSeek(xFilial("SD2") + mv_par05 + mv_par06 + mv_par07 + mv_par08 ))

//_cDoc := SD2->D2_DOC
//While SD2->( !Eof() ) .and. _cDoc == SD2->D2_DOC
WHILE SD2->(!EOF()) .AND. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA==mv_par05+MV_PAR06+MV_PAR07+MV_PAR08
	_nQuant += SD2->D2_QUANT
	SD2->( DbSkip() )
EndDo

Return