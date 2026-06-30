-- ─── VIEW: Vacation_SumRequest ───────────────────────────────
DROP VIEW IF EXISTS public."Vacation_SumRequest";
CREATE OR REPLACE VIEW public."Vacation_SumRequest" AS
SELECT 
	SUM(VacationsCount) Used
	, RQ.UserNo --
	, SUM(case when COALESCE(t.special,0) = 0 then VacationsCount else 0 end) Used1 -- basicc used
	, SUM(case when t.special = 1 then VacationsCount else 0 end) Used2 -- sepecial used
	, YEAR(Rq.Tod) as years
from Vacation_Requests RQ 
left join Vacation_Types t on rq.TypeId = t.TypeId
WHERE RQ.StatusAdmin != 1 
GROUP BY RQ.UserNo,  YEAR(Rq.Tod)
;
-- TODO: Owner mapping skipped. Target role postgres not verified.
