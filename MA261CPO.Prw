/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MA261CPO        � Alexandre R. Bento    � Data � 29.12.03 ���
������������������������������������������������������������������������Ĵ��
���Descri��o �  Ponto de Entrada que adiciona campos no browse da        ���
���          �  transferencias modelo II (MATA261)                       ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/


#INCLUDE "rwmake.ch"
#DEFINE USADO Chr(0)+Chr(0)+Chr(1)

User Function MA261CPO() 

Local aTam    := {}                               
   aTam := TamSX3('D3_CARDEF')
   Aadd(aHeader, {"Car.Defeito", 'D3_CARDEF' , PesqPict('SD3', 'D3_CARDEF', aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SD3', ''}) // 'Caracteristica do defeito'

   aTam := TamSX3('D3_DEFEITO')
   Aadd(aHeader, {"Defeito", 'D3_DEFEITO' , PesqPict('SD3', 'D3_DEFEITO', aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SD3', ''}) // 'Defeito'

   aTam := TamSX3('D3_OPERACA')
   aadd(aHeader, {"Operacao", 'D3_OPERACA' , PesqPict('SD3', 'D3_OPERACA', aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SD3', ''}) // 'Operacao.'

   aTam := TamSX3('D3_FORNECE')
   aadd(aHeader, {"Fornecedor", 'D3_FORNECE' , PesqPict('SD3', 'D3_FORNECE', aTam[1]), aTam[1], aTam[2], '', USADO, 'C', 'SD3', ''}) // 'Fornecedor'

   aTam := TamSX3('D3_LOJA' )
   Aadd(aHeader, {"Loja", 'D3_LOJA' , PesqPict('SD3', 'D3_LOJA' , aTam[1] ), aTam[1], aTam[2], ''       , USADO, 'C', 'SD3', ''}) // 'Loja.'

   aTam := TamSX3('D3_LOCORIG')
   Aadd(aHeader, {"Local Orig", 'D3_LOCORIG' , PesqPict('SD3', 'D3_LOCORIG' , aTam[1] ), aTam[1], aTam[2], ''       , USADO, 'C', 'SD3', ''}) // 'Local de Origem'

   aTam := TamSX3('D3_CC')
   Aadd(aHeader, {"Centro Custo", 'D3_CC' , PesqPict('SD3', 'D3_CC' , aTam[1] ), aTam[1], aTam[2], ''       , USADO, 'C', 'SD3', ''}) // 'Centro de Custo'

   aTam := TamSX3('D3_TURNO')
   Aadd(aHeader, {"Turno", 'D3_TURNO' , PesqPict('SD3', 'D3_TURNO' , aTam[1] ), aTam[1], aTam[2], ''       , USADO, 'C', 'SD3', ''}) // 'TURNO'

   aTam := TamSX3('D3_MAQUINA')
   Aadd(aHeader, {"Maquina", 'D3_MAQUINA' , PesqPict('SD3', 'D3_MAQUINA' , aTam[1] ), aTam[1], aTam[2], ''       , USADO, 'C', 'SD3', ''}) // 'Maquina'

   aTam := TamSX3('D3_LINHA')
   Aadd(aHeader, {"Linha Prod", 'D3_LINHA' , PesqPict('SD3', 'D3_LINHA' , aTam[1] ), aTam[1], aTam[2], ''       , USADO, 'C', 'SD3', ''}) // 'Maquina'
   
   // Adicionado em 13/12/12 - RNC
   aTam := TamSX3('D3_CODPA')
   Aadd(aHeader, {"Codigo PA", 'D3_CODPA' , PesqPict('SD3', 'D3_CODPA' , aTam[1] ), aTam[1], aTam[2], ''       , USADO, 'C', 'SD3', ''}) // 'Cod. PA'
   
   // Adicionado em 29/04/13 - RNC
   aTam := TamSX3('D3_DTREF')
   Aadd(aHeader, {"Data Referencia", 'D3_DTREF' , PesqPict('SD3', 'D3_DTREF' , aTam[1] ), aTam[1], aTam[2], ''  , USADO, 'D', 'SD3', ''}) // 'DATA DE REFERENCIA RNC'	
   
   // Adicionado em 30/09/13 - RASTRAMENTO DA CORRIDA WHB (FORJARIA)
   aTam := TamSX3('D3_CORRID')
   Aadd(aHeader, {"Corrida WHB", 'D3_CORRID' , PesqPict('SD3', 'D3_CORRID' , aTam[1] ), aTam[1], aTam[2], ''  , USADO, 'C', 'SD3', ''}) // 'CORRIDA WHB'	
   
   // Adicionado em 11/03/13 - RASTRAMENTO DA CORRIDA GERDAU (FORJARIA)
   aTam := TamSX3('D3_CORRIDA')
   //Aadd(aHeader, {"Corrida Gerdau", 'D3_CORRIDA' , PesqPict('SD3', 'D3_CORRIDA' , aTam[1] ), aTam[1], aTam[2], ''  , USADO, 'N', 'SD3', ''}) // 'CORRIDA GERDAU'	
   Aadd(aHeader, {"Corrida Gerdau", 'D3_CORRIDA' , X3PICTURE('D3_CORRIDA') , aTam[1], aTam[2], ''  , USADO, 'N', 'SD3', ''}) // 'CORRIDA GERDAU'	

   // Adicionado em 21/10/13 - op x oee
   aTam := TamSX3('D3_OP')
   Aadd(aHeader, {"Ord Producao",'D3_OP' , PesqPict('SD3', 'D3_OP' , aTam[1] ), aTam[1], aTam[2], ''  , USADO, 'C', 'SD3', ''}) // 'OP'	
   

Return(aHeader)

