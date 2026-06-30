-- ─── PROCEDURE→FUNCTION: note_updateforsharenote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_updateforsharenote(uuid, integer, uuid, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_updateforsharenote(
    IN listno uuid,
    IN usershare integer,
    IN groupno uuid,
    IN daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS void
AS $function$
BEGIN

	
			UPDATE Note_Share
			DayEdit := note_updateforsharenote.daycreate,GroupNo=note_updateforsharenote.groupno;
			WHERE ListNo=note_updateforsharenote.listno AND UserShare=note_updateforsharenote.usershare;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
