WITH PROD AS
(
SELECT DISTINCT CODPROD, CODEMP, (SELECT USOPROD FROM TGFPRO WHERE CODPROD = TGFCUS.CODPROD) AS USOPROD
FROM TGFCUS WHERE CODEMP = 1
),
PROD2 AS
(SELECT DISTINCT CODPROD, CODEMP , (SELECT USOPROD FROM TGFPRO WHERE CODPROD = TGFCUS.CODPROD) AS USOPROD
FROM TGFCUS WHERE CODEMP = 2
)


SELECT A.CODPROD, (SELECT DESCRPROD FROM TGFPRO WHERE CODPROD = A.CODPROD) AS PRODUTO, 
(SELECT NOMEFANTASIA FROM TSIEMP WHERE CODEMP = A.CODEMP) AS EMPRESA, A.CODEMP, CUS.CUSGER FROM
(SELECT CUS.CODPROD, CUS.CODEMP, MAX(DTATUAL) AS DTATUAL 
FROM TGFPRO PRO INNER JOIN TGFCUS CUS ON PRO.CODPROD = CUS.CODPROD 
WHERE PRO.CODPROD !=0 AND CUS.CODEMP IN(1,2) AND CUS.CUSGER > 0 AND PRO.USOPROD IN :P_USOPROD
GROUP BY CUS.CODPROD, CUS.CODEMP) A 
INNER JOIN TGFCUS CUS ON A.CODPROD = CUS.CODPROD AND A.DTATUAL = CUS.DTATUAL AND A.CODEMP = CUS.CODEMP
WHERE (A.CODEMP IN :P_CODEMP)

UNION ALL

SELECT PROD.CODPROD, (SELECT DESCRPROD FROM TGFPRO WHERE CODPROD = PROD.CODPROD) AS PRODUTO, 
(SELECT NOMEFANTASIA FROM TSIEMP WHERE CODEMP = CASE WHEN PROD.CODEMP = 1 THEN 2 ELSE 1 END) AS EMPRESA,
CASE WHEN PROD.CODEMP = 1 THEN 2 ELSE 1 END AS CODEMP, 0 AS CUSGER
FROM PROD LEFT JOIN PROD2 ON PROD.CODPROD=PROD2.CODPROD
WHERE PROD2.CODPROD IS NULL AND (PROD.USOPROD IN :P_USOPROD)
AND (CASE WHEN PROD.CODEMP = 1 THEN 2 ELSE 1 END IN :P_CODEMP)

UNION ALL

SELECT PROD2.CODPROD, (SELECT DESCRPROD FROM TGFPRO WHERE CODPROD = PROD2.CODPROD) AS PRODUTO, 
(SELECT NOMEFANTASIA FROM TSIEMP WHERE CODEMP = CASE WHEN PROD.CODEMP = 1 THEN 2 ELSE 1 END) AS EMPRESA, 
CASE WHEN PROD2.CODEMP = 1 THEN 2 ELSE 1 END AS CODEMP, 0 AS CUSGER
FROM PROD RIGHT JOIN PROD2 ON PROD.CODPROD=PROD2.CODPROD
WHERE PROD.CODPROD IS NULL AND (PROD2.USOPROD IN :P_USOPROD)
AND (CASE WHEN PROD2.CODEMP = 1 THEN 2 ELSE 1 END IN :P_CODEMP)

UNION ALL 

SELECT PRO.CODPROD, PRO.DESCRPROD,(SELECT NOMEFANTASIA FROM TSIEMP WHERE CODEMP =1) AS EMPRESA, 1 AS CODEMP, 0 AS CUSGER
FROM TGFPRO PRO LEFT JOIN PROD ON PRO.CODPROD = PROD.CODPROD LEFT JOIN PROD2 ON PRO.CODPROD = PROD2.CODPROD
WHERE PROD.CODPROD IS NULL AND PROD2.CODPROD IS NULL AND (PRO.USOPROD IN :P_USOPROD)
AND (1 IN :P_CODEMP)

UNION ALL

SELECT PRO.CODPROD, PRO.DESCRPROD,(SELECT NOMEFANTASIA FROM TSIEMP WHERE CODEMP =2) AS EMPRESA, 2 AS CODEMP, 0 AS CUSGER
FROM TGFPRO PRO LEFT JOIN PROD ON PRO.CODPROD = PROD.CODPROD LEFT JOIN PROD2 ON PRO.CODPROD = PROD2.CODPROD
WHERE PROD.CODPROD IS NULL AND PROD2.CODPROD IS NULL AND (PRO.USOPROD IN :P_USOPROD)
AND (2 IN :P_CODEMP)

