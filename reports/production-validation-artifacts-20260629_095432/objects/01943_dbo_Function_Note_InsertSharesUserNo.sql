-- ─── FUNCTION: note_insertsharesuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_insertsharesuserno(uuid, integer, integer, double precision, uuid, integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_insertsharesuserno(
    listno uuid,
    companyno integer,
    userno integer,
    notetimezone double precision,
    groupno uuid,
    sharecompanyno integer,
    shareuserno integer,
    daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	SELECT CheckInsert = COUNT(ShareNo) FROM Note_Share WHERE ListNo = note_insertsharesuserno.listno AND ShareCompanyNo = note_insertsharesuserno.sharecompanyno AND UserShare = note_insertsharesuserno.shareuserno AND ShareType = 2
	IF CheckInsert = 0 BEGIN;
		INSERT INTO Note_Share(ShareNo,CompanyNo,UserNo,ListNo,DayCreate,DayEdit,ShareCompanyNo,UserShare,GroupNo,ShareType,ReadDate,timeOffset)
						VALUES(NEWID (),CompanyNo,UserNo,ListNo,DayCreate,DayCreate,ShareCompanyNo,ShareUserNo,GroupNo,2,DayCreate,NoteTimeZone)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
