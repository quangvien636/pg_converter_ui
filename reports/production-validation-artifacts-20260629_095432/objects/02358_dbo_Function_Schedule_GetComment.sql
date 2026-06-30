-- ─── FUNCTION: schedule_getcomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcomment(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcomment(
    scheduleno integer
) RETURNS TABLE(
    commentno text,
    reguserno text,
    name text,
    regdate text,
    moduserno text,
    moddate text,
    content text,
    photo text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CommentNo,C.RegUserNo,Name,C.RegDate,C.ModUserNo,C.ModDate,Content, U.Photo 
	FROM Schedule_Comments C
	INNER JOIN Organization_Users U ON C.RegUserNo = U.UserNo
	WHERE ScheduleNo = schedule_getcomment.scheduleno
	ORDER BY CommentNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
