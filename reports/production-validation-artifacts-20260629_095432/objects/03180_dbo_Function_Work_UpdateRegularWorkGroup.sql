-- ─── FUNCTION: work_updateregularworkgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_updateregularworkgroup(integer, integer, timestamp without time zone, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.work_updateregularworkgroup(
    groupno integer,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    divisionno integer,
    userno integer,
    iseveryperson boolean
) RETURNS TABLE(
    historyno text
)
AS $function$
DECLARE
    historyno integer;
BEGIN


	INSERT INTO RegularWorkGroupHistorys(RegUserNo, RegDate, GroupNo, Name,
		DivisionNo, UserNo, IsEveryPerson, Content)
	VALUES(ModUserNo, ModDate, GroupNo, Name, DivisionNo, UserNo, IsEveryPerson, Content)
	

	SET HistoryNo = lastval()
	
	UPDATE RegularWorkGroups SET
		ModUserNo = work_updateregularworkgroup.moduserno,
		ModDate = work_updateregularworkgroup.moddate,
		HistoryNo = HistoryNo
	WHERE GroupNo = work_updateregularworkgroup.groupno
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
