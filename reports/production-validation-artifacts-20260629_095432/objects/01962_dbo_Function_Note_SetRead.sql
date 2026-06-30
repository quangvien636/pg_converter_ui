-- ─── FUNCTION: note_setread ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_setread(uuid, integer, double precision);
CREATE OR REPLACE FUNCTION public.note_setread(
    listno uuid,
    userno integer,
    timeoffset double precision DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	UPDATE Note_Share
	SET IsReads=2,ReadDate=GETUTCDATE(), timeOffset = note_setread.timeoffset
	WHERE ListNo=note_setread.listno AND UserNo=UserShare;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
