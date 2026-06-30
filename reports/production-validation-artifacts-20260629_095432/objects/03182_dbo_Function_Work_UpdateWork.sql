-- ─── FUNCTION: work_updatework ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updatework(integer, integer, timestamp without time zone, integer, character varying, integer, integer, integer, date, boolean);
CREATE OR REPLACE FUNCTION public.work_updatework(
    workno integer,
    moduserno integer,
    moddate timestamp without time zone,
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
BEGIN


	INSERT INTO WorkHistorys(RegUserNo, RegDate, WorkNo, Title, UserNo, DivisionNo,
		WorkTime, CompleteDate, IsEveryPerson, Content)
	VALUES(ModUserNo, ModDate, WorkNo, Title, UserNo, DivisionNo,
		WorkTime, CompleteDate, IsEveryPerson, Content)
	

	SET HistoryNo = lastval()
	
	UPDATE Works SET
		ModUserNo = work_updatework.moduserno,
		ModDate = work_updatework.moddate,
		GroupNo = work_updatework.groupno,
		HistoryNo = HistoryNo
	WHERE WorkNo = work_updatework.workno
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
