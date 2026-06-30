-- ─── FUNCTION: noticesyn_getcomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getcomment(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getcomment(
    noticeno integer
) RETURNS TABLE(
    commentno text,
    reguserno text,
    name text,
    regdate text,
    moduserno text,
    moddate text,
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CommentNo,C.RegUserNo,Name,C.RegDate,C.ModUserNo,C.ModDate,Content FROM NoticeSyn_Comments C
	INNER JOIN Organization_Users U ON C.RegUserNo = U.UserNo
	WHERE NoticeNo = noticesyn_getcomment.noticeno
	ORDER BY CommentNo DESC

END;
---------------------------------./////////////////////////////////////////////-----------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
