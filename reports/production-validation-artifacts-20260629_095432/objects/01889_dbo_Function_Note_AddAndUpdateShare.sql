-- ─── FUNCTION: note_addandupdateshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_addandupdateshare(uuid, integer, uuid, integer, integer, uuid, timestamp without time zone, double precision);
CREATE OR REPLACE FUNCTION public.note_addandupdateshare(
    shareno uuid,
    userno integer,
    listno uuid,
    usershare integer,
    type integer,
    groupno uuid,
    daycreate timestamp without time zone DEFAULT 'GETUTCDATE',
    timeoffset double precision DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF Type=1
		BEGIN;
			INSERT INTO Note_Share(ShareNo,UserNo,ListNo,UserShare,DayCreate,DayEdit,GroupNo,ReadDate, timeOffset)
			VALUES(ShareNo,UserNo,ListNo,UserShare,DayCreate,DayCreate,GroupNo,DayCreate, timeOffset)
		END
	IF Type=2
		BEGIN;
			UPDATE Note_Share
			SET ListNo=note_addandupdateshare.listno,UserShare=note_addandupdateshare.usershare,DayEdit=note_addandupdateshare.daycreate,GroupNo=note_addandupdateshare.groupno, timeOffset = note_addandupdateshare.timeoffset
			WHERE ShareNo=note_addandupdateshare.shareno 
		END
	IF Type=3
		BEGIn;
			DELETE FROM Note_Share
			WHERE ShareNo=note_addandupdateshare.shareno
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
