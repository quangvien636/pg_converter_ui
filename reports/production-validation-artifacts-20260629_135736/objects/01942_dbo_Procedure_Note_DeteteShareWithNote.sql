-- ─── PROCEDURE→FUNCTION: note_detetesharewithnote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_detetesharewithnote(uuid, integer);
CREATE OR REPLACE FUNCTION public.note_detetesharewithnote(
    IN listno uuid,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Note_Share
	WHERE ListNo=note_detetesharewithnote.listno AND UserNo=note_detetesharewithnote.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
