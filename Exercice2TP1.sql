/* Exercice 2 */

/*
Tables de la base de données :
TEMPS (TID Numeric(4), annee Numeric(4), trimestre Numeric(2),mois Numeric(2), jour Numeric(2))

CLIENTS (CL_ID Numeric(2),CL_NAME varchar(50), CL_CITY varchar(30), CL_R varchar(30), CL_STATE varchar(30));

PRODUITS (PID Numeric(2), PNAME varchar(50), CATEGORY varchar(40),SUBCAT varchar(30));

VENTES (TID Numeric(4),PID Numeric(2),CID Numeric(2),QTE Numeric(3), PU Numeric(6,2));
*/



/* Question 2.1 */ 

column a heading Annee Format 9999
column c heading CL_R Format a5
column ca heading CATEGORY Format a20
column CA_MOYEN Format 99999
SET pagesize 1000
SELECT t.annee a, c.CL_R c, p.CATEGORY, AVG(QTE*PU) AS CA_MOYEN
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid
AND (t.annee = 2009 or t.annee = 2010)
GROUP BY ROLLUP (t.annee, c.cl_r, p.CATEGORY);



/* Question 2.2 */

column c heading CL_R Format a5
column ca heading CATEGORY Format a20
column CA_MOYEN Format 99999
SET pagesize 1000
SELECT annee,  c.CL_R c, p.CATEGORY ca, AVG(QTE*PU) AS CA_MOYEN
FROM VENTES v, TEMPS t, PRODUITS p, CLIENTS c
WHERE c.cl_id = v.cid
AND v.pid = p.pid
AND v.tid = t.tid
AND (t.annee = 2009 or t.annee = 2010)
GROUP BY CUBE (c.cl_r, p.CATEGORY, annee);


/* Question 2.3  */


SELECT annee, category, PNAME
FROM(
SELECT  t.annee, p.PNAME, CATEGORY,  RANK() OVER(PARTITION BY t.annee, p.CATEGORY ORDER BY SUM(v.QTE*v.PU) DESC) as rang
FROM VENTES v, TEMPS t, PRODUITS p
WHERE v.pid = p.pid
AND v.tid = t.tid
GROUP BY GROUPING SETS ((t.annee, p.CATEGORY, p.PNAME)))
WHERE rang=1;




/* Question 2.4 */

column annee heading annee Format 9999
column category heading CATEGORY Format a25
column CA_MOYEN Format 999999
SELECT 
CASE
	WHEN GROUPING_ID (annee,category) < 3 THEN annee 
END ANNEE,
category, sum(pu*qte) as CA_TOTAL
from produits p, ventes v, temps t
WHERE t.tid = v.tid
AND v.pid = p.pid
group by rollup(annee,category)
order by ANNEE;


/* Question 2.5 */ 

SELECT *
FROM (
	SELECT annee, mois, SUM(v.pu*v.qte) as ca_annee
	FROM produits p, ventes v, temps t
	WHERE p.pid = v.pid
	AND t.tid = v.tid
	AND p.pname = 'Sirop d érable'
	group by (t.annee,t.mois)
	order by t.annee,t.mois
	)
WHERE ca_annee in (
			SELECT ca_mois	 
			FROM (
				SELECT annee, MAX(ca_annee) as ca_mois
				FROM (
					SELECT annee, mois, SUM(v.pu*v.qte) as ca_annee
					FROM produits p, ventes v, temps t
					WHERE p.pid = v.pid
					AND t.tid = v.tid
					AND p.pname = 'Sirop d érable'
					group by (t.annee,t.mois)
					order by t.annee,t.mois
					)
				GROUP BY (annee)
			)
		);


/* Question 2.6 */ 

SELECT annee, c.CL_NAME, p.category, SUM(v.QTE*v.PU) as CA_TOTAL
FROM clients c, produits p, temps t, ventes v
WHERE p.pid = v.pid
AND t.tid = v.tid
AND c.CL_ID = v.cid
GROUP BY grouping sets ((p.category,t.annee), (c.CL_NAME, t.annee))
ORDER BY CA_TOTAL;



/* Question 2.7 */ 

SELECT p.category, sum(v.qte), NTILE(3) OVER(ORDER BY sum(v.qte) DESC) as TIERS
from produits p, ventes v, temps t
WHERE v.pid = p.pid
AND v.tid = t.tid
AND t.annee = 2010
GROUP BY (p.category);


/* Question 2.8 */ 

SELECT p.category, t.mois, sum(v.qte)
FROM produits p, temps t, ventes v
WHERE v.pid = p.pid
AND v.tid = t.tid
AND t.jour <= 5
AND t.annee = 2010
group by (category, mois)
order by mois ASC;
