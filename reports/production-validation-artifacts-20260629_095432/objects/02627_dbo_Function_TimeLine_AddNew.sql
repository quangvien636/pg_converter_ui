-- ─── FUNCTION: timeline_addnew ───────────────────────────────
DROP FUNCTION IF EXISTS public.timeline_addnew(integer, character varying, character varying, character varying, character varying, timestamp without time zone, integer, character varying);
CREATE OR REPLACE FUNCTION public.timeline_addnew(
    mode integer,
    title character varying,
    content character varying,
    isend character varying,
    memo character varying,
    viewdate timestamp without time zone,
    userno integer,
    linkurl character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN



	IF( LinkUrl IS NULL) SELECT LinkUrl = ''
	IF( LinkKey IS NULL) SELECT LinkKey = ''

	INSERT INTO public."TimeLine_Main"
           (Mode
           ,Title
           ,Content
           ,IsEnd
           ,Memo
           ,ViewDate
           ,UserNo
           ,RegDate
           ,LinkUrl
           ,LinkKey)
     VALUES
           (Mode ,Title ,Content ,IsEnd ,Memo ,ViewDate ,UserNo ,NOW() ,LinkUrl ,LinkKey)

	RETURN QUERY
	SELECT * FROM public."TimeLine_Main" 
	WHERE Mode=timeline_addnew.mode and Title=timeline_addnew.title and UserNo=timeline_addnew.userno 
		AND CONVERT(VARCHAR(20),RegDate,101)=CONVERT(VARCHAR(20),NOW(),101);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
