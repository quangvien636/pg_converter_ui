-- ─── FUNCTION: webservice_inserthistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.webservice_inserthistory(uuid, character varying, text, integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.webservice_inserthistory(
    historyno uuid,
    title character varying,
    message text,
    type integer,
    sucess integer,
    fail integer,
    multicast_id character varying
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WebService_HistoryGCM(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,AppKey,DateCreate)
	VALUES(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,AppKey,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
