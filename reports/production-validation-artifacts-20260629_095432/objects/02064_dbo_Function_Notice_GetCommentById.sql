-- ─── FUNCTION: notice_getcommentbyid ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_getcommentbyid(integer);
CREATE OR REPLACE FUNCTION public.notice_getcommentbyid(
    p_no integer
) RETURNS TABLE(
    commentno serial,
    noticeno integer,
    reguserno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    content character varying(500),
    modusername character varying(100),
    modpositionno integer,
    modpositionname character varying(100),
    moddepartno integer,
    moddepartname character varying(100),
    groupno bigint,
    orderno integer,
    depth integer
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT *
	FROM NoticeComments 
	
	WHERE CommentNo = notice_getcommentbyid.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
