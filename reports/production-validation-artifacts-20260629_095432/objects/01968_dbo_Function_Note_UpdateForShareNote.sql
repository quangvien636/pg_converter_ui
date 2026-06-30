-- ─── FUNCTION: note_updateforsharenote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_updateforsharenote(uuid, integer, uuid, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_updateforsharenote(
    listno uuid,
    usershare integer,
    groupno uuid,
    daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS void
AS $function$
BEGIN

	
			UPDATE Note_Share
			SET DayEdit=note_updateforsharenote.daycreate,GroupNo=note_updateforsharenote.groupno
			WHERE ListNo=note_updateforsharenote.listno AND UserShare=note_updateforsharenote.usershare;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
