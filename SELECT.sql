SELECT
CAB.CODEMP,
CAB.NUNOTA,
CAB.NUMNOTA,
CAB.DTMOV,
CAB.DTNEG,
CAB.CODPARC,
PAR.RAZAOSOCIAL,
(SELECT SUM(QTDNEG) FROM TGFITE WHERE NUNOTA = CAB.NUNOTA) as Qtdprodutos,
(SELECT COUNT(CODPROD) FROM TGFITE WHERE NUNOTA = CAB.NUNOTA) as totalintens,
VS.VLRPED as VlrTot,
CAB.CODTIPOPER as Tipooperacao,
PAR.CODTIPPARC AS Perfil,
NTA.NOMETAB,
CAB.VLRFRETE,
CAB.AD_VLRFRETECOTADO,
PAR2.RAZAOSOCIAL as Transportadora,
CAB.QTDVOL,
CAB.PESOBRUTO,
CAB.STATUSNOTA,
CAB.AD_DTINCLUSAO,
CAB.AD_DTSEPARACAO as DTseparacao,
CAB.AD_INISEPARACAO as iniseparacao,
CAB.AD_TERMSEPARACAO as termseparacao,
CAB.AD_DTCONFERENCIA as Dtconferencia,
CAB.AD_INICONFERENCIA as iniconfe,
CAB.AD_TERMCONFERENCIA as termconfe,
CAB.AD_DTEMBALAGEM as Dtembalagem,
CAB.AD_INIEMBALAGEM as iniembalagem,
CAB.AD_TERMEMBALAGEM as termembalagem,
CAB.AD_QTDCXP as CaixaP,
CAB.AD_QTDCXM as caixaM,
CAB.AD_QTDCXG as Caixag,
CAB.AD_QTDCXR as CaixaR,
CAB.AD_QTDCXPP as CaixaPP,
CAB.AD_QTDCXCG as CaixaCG,
CAB.AD_QTDCXCP as CaixaCP,
CAB.AD_SEPARADOR as Separador,
CAB.AD_EMBALADOR as Embalador,
CAB.AD_CONFERENTE as Conferente




FROM TGFCAB CAB
			  JOIN TGFPAR PAR ON PAR.CODPARC = CAB.CODPARC
			  JOIN TGFPAR PAR2 ON PAR2.CODPARC = CAB.CODPARCTRANSP
			  JOIN VIEW_SEPARACAO VS ON VS.NUNOTA = CAB.NUNOTA
			  JOIN TGFTAB TAB ON TAB.NUTAB = (SELECT MAX(NUTAB) FROM TGFITE WHERE NUNOTA = CAB.NUNOTA)
              LEFT JOIN TGFNTA NTA ON NTA.CODTAB = TAB.CODTAB
              



		WHERE CAB.CODTIPOPER IN (3200,3212,30,3208,3217,3227)
		AND CAB.TIPMOV = 'V'
        
        
        














