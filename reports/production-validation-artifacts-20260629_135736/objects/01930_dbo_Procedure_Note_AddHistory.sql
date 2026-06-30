-- ─── PROCEDURE→FUNCTION: note_addhistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_addhistory(uuid, character varying, text, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_addhistory(
    IN historyno uuid,
    IN title character varying,
    IN message text,
    IN type integer,
    IN sucess integer,
    IN fail integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Note_HistoryGCM(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,DateCreate)
	VALUES(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
