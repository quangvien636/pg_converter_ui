-- ─── FUNCTION: integrated_getcomment ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_getcomment(integer);
CREATE OR REPLACE FUNCTION public.integrated_getcomment(
    integratedno integer
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
	SELECT CommentNo,C.RegUserNo,Name,C.RegDate,C.ModUserNo,C.ModDate,Content FROM Integrated_Comments C
	INNER JOIN Organization_Users U ON C.RegUserNo = U.UserNo
	WHERE IntegratedNo = integrated_getcomment.integratedno
	ORDER BY CommentNo DESC

END;


--------------------////////////////////---------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
