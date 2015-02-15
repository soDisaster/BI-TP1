/* Exercice 1 */
/* Question 1.a */
SET pagesize 1000
SELECT DEPTNO, ENAME, SAL, RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) as rang
FROM EMP
WHERE DEPTNO = 10 OR DEPTNO = 30
ORDER BY DEPTNO;

/* Question 1.b */
SET pagesize 1000
SELECT DEPTNO, ENAME, SAL, DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) as rang
FROM EMP
WHERE DEPTNO = 10 OR DEPTNO = 30
ORDER BY DEPTNO;

/* Question 1.c */
SET pagesize 1000
SELECT distinct e.DEPTNO, e.SAL, DENSE_RANK() OVER(PARTITION BY e.DEPTNO ORDER BY e.SAL DESC) as rang
FROM EMP e
WHERE e.DEPTNO = 10 OR e.DEPTNO = 20
ORDER BY e.DEPTNO;

/* Question 1.d */
SET pagesize 1000
SELECT DISTINCT JOB, SUM(SAL) over (PARTITION BY JOB ORDER BY JOB) AS "TOT_SAL_SUM"
FROM EMP;

SELECT JOB, SUM(SAL)
FROM EMP
GROUP BY JOB;

/* Question 1.e */

/*
Premièrement, on écrit le "PARTITION BY" dans le "SELECT" et le "GROUP BY" à la fin d'une requête.
Le "GROUP BY" est une fonction d'agrégat. Le "PARTITION BY" une fonction de fenêtrage.
Le "GROUP BY" réduit le nombre de lignes retourné et calcule des moyennes ou des sommes pour chaque ligne. 
"PARTITION BY" n'affecte pas le nombre de lignes retourné mais la fonction de fenêtre est appliquée à chaque partition
séparément et le calcul redémarre pour chaque partition.
Une fonction de fenêtrage effectue un calcul sur un jeu d'enregistrements liés d'une certaine façon à l'enregistrement courant contrairement
à une fonction d'agrégat, l'utilisation d'une fonction de fenêtrage n'entraîne pas le regroupement des enregistrements traités en un seul.
Chaque enregistrement garde son identité propre



/* Question 1.f */
SET pagesize 1000
SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
GROUP BY ROLLUP (DEPTNO,JOB)
ORDER BY DEPTNO, JOB;

/* Question 1.g */
/* Première version avec NVL */
/* Si la valeur est nulle, la fonction NVL permet de remplacer cette valeur nulle par ce que l'on souhaite. Les types doivent correspondre. DEPTNO doit donc être casté en CHAR */ 
SET pagesize 1000
SELECT NVL(TO_CHAR(DEPTNO),'TousDep') as DEPTNO, NVL(JOB,'TousEmployes') as JOB, SUM(SAL)
FROM EMP
GROUP BY ROLLUP (DEPTNO,JOB)
ORDER BY DEPTNO, JOB;

/* Deuxième version avec GROUPING */
SET pagesize 1000
SELECT
CASE 
	WHEN GROUPING(DEPTNO)  = 1 THEN 'TousDep' 
	ELSE TO_CHAR(DEPTNO)
END DEPARTEMENT,	
CASE 
	WHEN GROUPING(JOB)  = 1 THEN 'TousEmployes' 
	ELSE JOB
END AS JOB,
SUM(SAL)
FROM EMP 
GROUP BY ROLLUP (DEPTNO,JOB)
ORDER BY DEPTNO, JOB;



