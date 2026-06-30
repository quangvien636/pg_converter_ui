-- ─── FUNCTION: work_insertcooperation ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertcooperation(integer, integer, timestamp without time zone, integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.work_insertcooperation(
    groupno integer,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    title character varying
) RETURNS TABLE(
    cooperationno text
)
AS $function$
DECLARE
    cooperationno integer;
BEGIN


	INSERT INTO Work_Cooperation VALUES (GroupNo, RegUserNo, RegDate, ModUserNo, 
	ModDate,Title, Content)

	SET CooperationNo = lastval()
	exec Work_ReadCooperation CooperationNo,RegUserNo,RegDate
	RETURN QUERY
	SELECT CooperationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
