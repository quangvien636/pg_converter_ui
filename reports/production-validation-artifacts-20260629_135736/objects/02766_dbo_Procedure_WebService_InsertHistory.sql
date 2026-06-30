-- ─── PROCEDURE→FUNCTION: webservice_inserthistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.webservice_inserthistory(uuid, character varying, text, integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.webservice_inserthistory(
    IN historyno uuid,
    IN title character varying,
    IN message text,
    IN type integer,
    IN sucess integer,
    IN fail integer,
    IN multicast_id character varying
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WebService_HistoryGCM(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,AppKey,DateCreate)
	VALUES(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,AppKey,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
