-- ─── PROCEDURE→FUNCTION: board_updateapprovaldoc ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updateapprovaldoc(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.board_updateapprovaldoc(
    IN contentno integer,
    IN status character varying,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

UPDATE Board_Contents;
ApplyTo := board_updateapprovaldoc.status,ModUserNo=board_updateapprovaldoc.userno, ModDate=NOW();
Where ContentNo= board_updateapprovaldoc.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.