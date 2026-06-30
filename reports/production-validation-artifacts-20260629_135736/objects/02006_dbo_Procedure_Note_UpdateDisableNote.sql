-- ─── PROCEDURE→FUNCTION: note_updatedisablenote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_updatedisablenote(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_updatedisablenote(
    IN groupno uuid,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_List
	Show := 2;
	WHERE GroupNo=note_updatedisablenote.groupno AND UserNo=note_updatedisablenote.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
