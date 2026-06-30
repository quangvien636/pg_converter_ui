-- ─── FUNCTION: webservice_addhistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.webservice_addhistory(uuid, character varying, text, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.webservice_addhistory(
    historyno uuid,
    title character varying,
    message text,
    type integer,
    sucess integer,
    fail integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO WebService_HistoryGCM(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,DateCreate)
	VALUES(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
