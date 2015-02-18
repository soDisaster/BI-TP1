/* Exercice 2 */

/*
Tables de la base de données :
TEMPS (TID Numeric(4), annee Numeric(4), trimestre Numeric(2),mois Numeric(2), jour Numeric(2))

CLIENTS (CL_ID Numeric(2),CL_NAME varchar(50), CL_CITY varchar(30), CL_R varchar(30), CL_STATE varchar(30));

PRODUITS (PID Numeric(2), PNAME varchar(50), CATEGORY varchar(40),SUBCAT varchar(30));

VENTES (TID Numeric(4),PID Numeric(2),CID Numeric(2),QTE Numeric(3), PU Numeric(6,2));
*/

/* Question 2.1 */
/*
column a heading Annee Format 9999
column c heading CL_R Format a5
column ca heading CATEGORY Format a20
column CA_MOYEN Format 99999
SET pagesize 1000
SELECT t.annee a, c.CL_R c, p.CATEGORY ca, AVG(QTE*PU) AS CA_MOYEN
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid
AND (t.annee = 2009 or t.annee = 2010)
GROUP BY ROLLUP (t.annee, c.cl_r, p.CATEGORY);*/

/* Question 2.2 */

/*column c heading CL_R Format a5
column ca heading CATEGORY Format a20
column CA_MOYEN Format 99999
SET pagesize 1000
SELECT annee,  c.CL_R c, p.CATEGORY ca, AVG(QTE*PU) AS CA_MOYEN
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid
AND (t.annee = 2009 or t.annee = 2010)
GROUP BY CUBE (c.cl_r, p.CATEGORY, annee);*/

/* Question 2.3  */

SELECT  annee, p.PNAME, SUM(QTE*PU) as r
FROM(
SELECT  annee, p.PNAME, RANK() OVER(PARTITION BY annee, CATEGORY ORDER BY SUM(QTE*PU) DESC) as rang
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid)
WHERE r=1;

/* Question 2.4 

SELECT CATEGORY, annee, (QTE*PU) AS CA_TOTAL
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid;
*/
/* Question 2.5 

SELECT GROUPING_ID (annee), annee, CATEGORY, MAX(QTE*PU) AS CA_TOTAL
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid;


Question 2.6 

SELECT annee, CATEGORY, (QTE*PU) AS CA_TOTAL
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid
GROUP BY GROUPING SETS (CATEGORY, CL_NAME);

 Question 2.7 

SELECT CATEGORY, QTE, RANK ???
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid
GROUP BY CATEGORY; 

*/












