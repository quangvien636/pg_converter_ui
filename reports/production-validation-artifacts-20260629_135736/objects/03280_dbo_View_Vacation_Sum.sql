-- ─── VIEW: Vacation_Sum ───────────────────────────────
DROP VIEW IF EXISTS public."Vacation_Sum";
CREATE OR REPLACE VIEW public."Vacation_Sum" AS
SELECT 
		R.UsernoI
	, SUM( CASE WHEN COALESCE(T1.special,0) != 1 THEN R.TimeDis ELSE 0 END) AS Addition1 -- ADDITION NORMAL
	, SUM( CASE WHEN T1.special = 1 THEN R.TimeDis ELSE 0 END) AS Addition2 -- ADDITION SPECIAL Addition2
	, SUM(R.TimeDis)  AS TimeDis -- ADDITION 
	, YEAR(R.Tod) as Years
	, UseVacationCnt = (select SUM(VacationsCount) FROM Vacation_Requests V 
			JOIN Vacation_Types T ON V.TypeId = T.TypeId WHERE T.special =1 AND V.UserNo = R.UsernoI AND YEAR(V.Tod) = YEAR(R.Tod))
FROM  Vacation_RequestEps R 
LEFT JOIN Vacation_Types T1 ON R.TypeId = T1.TypeId
GROUP BY R.UsernoI, YEAR(R.Tod)
;
-- TODO: Owner mapping skipped. Target role postgres not verified.
