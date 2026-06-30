-- TODO: view conversion is not implemented yet: dbo.Vacation_SumRequest
-- RAW:


	
CREATE VIEW [dbo].[Vacation_SumRequest] AS
SELECT 
	SUM(VacationsCount) Used
	, RQ.UserNo --
	, SUM(case when isnull(t.special,0) = 0 then VacationsCount else 0 end) Used1 -- basicc used
	, SUM(case when t.special = 1 then VacationsCount else 0 end) Used2 -- sepecial used
	, YEAR(Rq.Tod) as years
from Vacation_Requests RQ 
left join Vacation_Types t on rq.TypeId = t.TypeId
WHERE RQ.StatusAdmin != 1 
GROUP BY RQ.UserNo,  YEAR(Rq.Tod)

-- OWNER: postgres
