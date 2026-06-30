-- ─── FUNCTION: work_insertcooperationcomments ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertcooperationcomments(integer, integer, integer, timestamp without time zone, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_insertcooperationcomments(
    groupno integer,
    cooperationno integer,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS TABLE(
    commentno text
)
AS $function$
DECLARE
    commentno integer;
BEGIN


	INSERT INTO Work_CooperationComments VALUES (GroupNo, CooperationNo,RegUserNo, RegDate, ModUserNo, 
	ModDate,Content)

	SET CommentNo = lastval()
	exec Work_ReadCooperationComments CommentNo,RegUserNo,RegDate
	RETURN QUERY
	SELECT CommentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
