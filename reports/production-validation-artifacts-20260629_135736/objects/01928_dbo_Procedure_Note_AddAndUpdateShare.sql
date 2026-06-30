-- ─── PROCEDURE→FUNCTION: note_addandupdateshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_addandupdateshare(uuid, integer, uuid, integer, integer, uuid, timestamp without time zone, double precision);
CREATE OR REPLACE FUNCTION public.note_addandupdateshare(
    IN shareno uuid,
    IN userno integer,
    IN listno uuid,
    IN usershare integer,
    IN type integer,
    IN groupno uuid,
    IN daycreate timestamp without time zone DEFAULT 'GETUTCDATE',
    IN timeoffset double precision DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	IF Type=1 THEN;
			INSERT INTO Note_Share(ShareNo,UserNo,ListNo,UserShare,DayCreate,DayEdit,GroupNo,ReadDate, timeOffset)
			VALUES(ShareNo,UserNo,ListNo,UserShare,DayCreate,DayCreate,GroupNo,DayCreate, timeOffset)
		END IF;
	IF Type=2 THEN;
			UPDATE Note_Share
			ListNo := note_addandupdateshare.listno,UserShare=note_addandupdateshare.usershare,DayEdit=note_addandupdateshare.daycreate,GroupNo=note_addandupdateshare.groupno, timeOffset = note_addandupdateshare.timeoffset;
			WHERE ShareNo=note_addandupdateshare.shareno 
		END IF;
	IF Type=3 THEN;
			DELETE FROM Note_Share
			WHERE ShareNo=note_addandupdateshare.shareno
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
