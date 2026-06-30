-- ─── PROCEDURE→FUNCTION: notice_setshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_setshare(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.notice_setshare(
    IN noticeno integer,
    IN departno integer,
    IN userno integer,
    IN ischild character varying
) RETURNS SETOF record
AS $function$
DECLARE
    departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0 THEN

		DepartName := public."COMNGetDepartName"(DepartNo);
		if((select count(*) from NoticeSharers b where b.NoticeNo = notice_setshare.noticeno and b.DepartNo=notice_setshare.departno and b.Userno=notice_setshare.userno)=0) begin;
			INSERT INTO NoticeSharers(NoticeNo,DepartNo,DepartName,IsChild,UserNo)
			VALUES(NoticeNo,DepartNo,DepartName,IsChild, UserNo)
			END IF;
	END;
	ELSE;
		DELETE FROM NoticeSharers WHERE NoticeNo = notice_setshare.noticeno
	END IF;
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
