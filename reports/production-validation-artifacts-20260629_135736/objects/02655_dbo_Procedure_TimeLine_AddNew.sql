-- ─── PROCEDURE→FUNCTION: timeline_addnew ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.timeline_addnew(integer, character varying, character varying, character varying, character varying, timestamp without time zone, integer, character varying);
CREATE OR REPLACE FUNCTION public.timeline_addnew(
    IN mode integer,
    IN title character varying,
    IN content character varying,
    IN isend character varying,
    IN memo character varying,
    IN viewdate timestamp without time zone,
    IN userno integer,
    IN linkurl character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
