-- ─── PROCEDURE→FUNCTION: note_setread ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_setread(uuid, integer, double precision);
CREATE OR REPLACE FUNCTION public.note_setread(
    IN listno uuid,
    IN userno integer,
    IN timeoffset double precision DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_Share
	IsReads := 2,ReadDate=GETUTCDATE(), timeOffset = note_setread.timeoffset;
	WHERE ListNo=note_setread.listno AND UserNo=UserShare;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
