-- ─── PROCEDURE→FUNCTION: note_deletesharesdepartno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_deletesharesdepartno(uuid, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_deletesharesdepartno(
    IN listno uuid,
    IN companyno integer,
    IN userno integer,
    IN sharecompanyno integer,
    IN shareuserno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(ListNo) INTO owernote FROM Note_List WHERE UserNo = note_deletesharesdepartno.userno AND ListNo = note_deletesharesdepartno.listno
	IF OwerNote > 0 THEN;
		DELETE FROM Note_Share
		WHERE ShareType = 0 
			AND ListNo=note_deletesharesdepartno.listno
			AND UserShare = note_deletesharesdepartno.shareuserno
	END IF;
	ELSE BEGIN;
		DELETE FROM Note_Share
		WHERE ShareType = 0 
			AND ListNo=note_deletesharesdepartno.listno
			AND UserShare = note_deletesharesdepartno.shareuserno
			AND UserNo=note_deletesharesdepartno.userno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
