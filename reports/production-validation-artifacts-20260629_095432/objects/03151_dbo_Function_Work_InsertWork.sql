-- ─── FUNCTION: work_insertwork ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertwork(integer, timestamp without time zone, integer, character varying, integer, integer, integer, date, boolean);
CREATE OR REPLACE FUNCTION public.work_insertwork(
    reguserno integer,
    regdate timestamp without time zone,
    groupno integer,
    title character varying,
    userno integer,
    divisionno integer,
    worktime integer,
    completedate date,
    iseveryperson boolean
) RETURNS TABLE(
    historyno text
)
AS $function$
DECLARE
    historyno integer;
    workno integer;
BEGIN


	INSERT INTO WorkHistorys(RegUserNo, RegDate, WorkNo, Title, UserNo, DivisionNo,
		WorkTime, CompleteDate, IsEveryPerson, Content)
	VALUES(RegUserNo, RegDate, 0, Title, UserNo, DivisionNo,
		WorkTime, CompleteDate, IsEveryPerson, Content)
	

	SET HistoryNo = lastval()
	
	INSERT INTO Works(RegUserNo, RegDate, ModUserNo, ModDate, GroupNo, HistoryNo, CompletionRate, Enabled)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate, GroupNo, HistoryNo, 0, 1)
	

	SET WorkNo = lastval()
	
	UPDATE WorkHistorys SET WorkNo = WorkNo
	WHERE HistoryNo = HistoryNo
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
