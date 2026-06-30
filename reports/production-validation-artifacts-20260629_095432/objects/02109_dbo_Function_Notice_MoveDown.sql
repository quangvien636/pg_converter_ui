-- ─── FUNCTION: notice_movedown ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_movedown(integer);
CREATE OR REPLACE FUNCTION public.notice_movedown(
    p_fno integer
) RETURNS TABLE(
    attachno serial,
    noticeno integer,
    filename character varying(260),
    filelength bigint,
    filepath character varying(500),
    sort double precision
)
AS $function$
BEGIN


	With cte As
	(
		SELECT AttachNo,Sort,
		ROW_NUMBER() OVER (ORDER BY COALESCE(Sort,0) ASC, AttachNo ASC) AS RN
		FROM NoticeAttachments where NoticeNo = parentid 
	)
	--select * from cte;
	UPDATE cte SET Sort=RN;;
	UPDATE NoticeAttachments set Sort = Sort + 1.01 Where AttachNo =  notice_movedown.p_fno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
