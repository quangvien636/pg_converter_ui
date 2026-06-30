-- ─── FUNCTION: work_updateworkgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateworkgroup(integer, integer, timestamp without time zone, character varying, integer, character varying, date, date);
CREATE OR REPLACE FUNCTION public.work_updateworkgroup(
    groupno integer,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    userno integer,
    content character varying,
    completedate date,
    startdate date
) RETURNS TABLE(
    historyno text
)
AS $function$
DECLARE
    historyno integer;
BEGIN


	INSERT INTO WorkGroupHistorys(RegUserNo, RegDate, GroupNo, Name, UserNo, Content, CompleteDate,StartDate)
	VALUES(ModUserNo, ModDate, GroupNo, Name, UserNo, Content, CompleteDate,StartDate)
	

	SET HistoryNo = lastval()
	
	UPDATE WorkGroups SET
		ModUserNo = work_updateworkgroup.moduserno,
		ModDate = work_updateworkgroup.moddate,
		HistoryNo = HistoryNo
	WHERE GroupNo = work_updateworkgroup.groupno
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
