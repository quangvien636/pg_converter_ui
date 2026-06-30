-- ─── FUNCTION: note_addhistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_addhistory(uuid, character varying, text, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_addhistory(
    historyno uuid,
    title character varying,
    message text,
    type integer,
    sucess integer,
    fail integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Note_HistoryGCM(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,DateCreate)
	VALUES(HistoryNo,Title,Message,Type,Sucess,Fail,multicast_id,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
