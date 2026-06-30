-- ─── FUNCTION: work_insertworkgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertworkgroup(integer, timestamp without time zone, character varying, integer, character varying, date, date, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkgroup(
    reguserno integer,
    regdate timestamp without time zone,
    name character varying,
    userno integer,
    content character varying,
    completedate date,
    startdate date,
    state integer
) RETURNS TABLE(
    historyno text
)
AS $function$
DECLARE
    historyno integer;
    groupno integer;
BEGIN


	INSERT INTO WorkGroupHistorys(RegUserNo, RegDate, GroupNo, Name, UserNo, Content, CompleteDate, StartDate)
	VALUES(RegUserNo, RegDate, 0, Name, UserNo, Content, CompleteDate,StartDate)
	

	SET HistoryNo = lastval()
	
	INSERT INTO WorkGroups(RegUserNo, RegDate, ModUserNo, ModDate, HistoryNo,
		IsLock, State, Enabled)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate, HistoryNo, 0, State, 1)
	

	SET GroupNo = lastval()
	
	UPDATE WorkGroupHistorys SET GroupNo = GroupNo
	WHERE HistoryNo = HistoryNo
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
