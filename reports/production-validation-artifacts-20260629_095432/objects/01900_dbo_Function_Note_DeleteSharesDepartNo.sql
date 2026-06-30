-- ─── FUNCTION: note_deletesharesdepartno ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_deletesharesdepartno(uuid, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_deletesharesdepartno(
    listno uuid,
    companyno integer,
    userno integer,
    sharecompanyno integer,
    shareuserno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN



	SELECT OwerNote = COUNT(ListNo) FROM Note_List WHERE UserNo = note_deletesharesdepartno.userno AND ListNo = note_deletesharesdepartno.listno
	IF OwerNote > 0 BEGIN;
		DELETE FROM Note_Share
		WHERE ShareType = 0 
			AND ListNo=note_deletesharesdepartno.listno
			AND UserShare = note_deletesharesdepartno.shareuserno
	END
	ELSE BEGIN;
		DELETE FROM Note_Share
		WHERE ShareType = 0 
			AND ListNo=note_deletesharesdepartno.listno
			AND UserShare = note_deletesharesdepartno.shareuserno
			AND UserNo=note_deletesharesdepartno.userno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
