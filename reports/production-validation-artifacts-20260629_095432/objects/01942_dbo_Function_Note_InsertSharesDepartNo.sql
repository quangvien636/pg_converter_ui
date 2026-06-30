-- ─── FUNCTION: note_insertsharesdepartno ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_insertsharesdepartno(uuid, integer, integer, double precision, uuid, integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_insertsharesdepartno(
    listno uuid,
    companyno integer,
    userno integer,
    notetimezone double precision,
    groupno uuid,
    sharecompanyno integer,
    departno integer,
    daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	SELECT CheckInsert = COUNT(ShareNo) FROM Note_Share WHERE ShareCompanyNo = note_insertsharesdepartno.sharecompanyno AND UserShare = note_insertsharesdepartno.departno AND ShareType = 0
	IF CheckInsert = 0 BEGIN;
		INSERT INTO Note_Share(ShareNo,CompanyNo,UserNo,ListNo,DayCreate,DayEdit,ShareCompanyNo,UserShare,GroupNo,ShareType,ReadDate,timeOffset)
						VALUES(NEWID (),CompanyNo,UserNo,ListNo,DayCreate,DayCreate,ShareCompanyNo,DepartNo,GroupNo,0,DayCreate,NoteTimeZone)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
