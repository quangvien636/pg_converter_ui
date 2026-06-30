-- ─── FUNCTION: work_insertregularworkgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertregularworkgroup(integer, timestamp without time zone, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.work_insertregularworkgroup(
    reguserno integer,
    regdate timestamp without time zone,
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
    groupno integer;
BEGIN


	INSERT INTO RegularWorkGroupHistorys(RegUserNo, RegDate, GroupNo, Name,
		DivisionNo, UserNo, IsEveryPerson, Content)
	VALUES(RegUserNo, RegDate, 0, Name, DivisionNo, UserNo, IsEveryPerson, Content)
	

	SET HistoryNo = lastval()
	
	INSERT INTO RegularWorkGroups(RegUserNo, RegDate, ModUserNo, ModDate, HistoryNo, Enabled)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate, HistoryNo, 1)
	

	SET GroupNo = lastval()
	
	UPDATE RegularWorkGroupHistorys SET GroupNo = GroupNo
	WHERE HistoryNo = HistoryNo
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
