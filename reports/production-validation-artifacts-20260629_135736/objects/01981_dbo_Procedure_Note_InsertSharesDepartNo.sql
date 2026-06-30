-- ─── PROCEDURE→FUNCTION: note_insertsharesdepartno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_insertsharesdepartno(uuid, integer, integer, double precision, uuid, integer, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_insertsharesdepartno(
    IN listno uuid,
    IN companyno integer,
    IN userno integer,
    IN notetimezone double precision,
    IN groupno uuid,
    IN sharecompanyno integer,
    IN departno integer,
    IN daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT COUNT(ShareNo) INTO checkinsert FROM Note_Share WHERE ShareCompanyNo = note_insertsharesdepartno.sharecompanyno AND UserShare = note_insertsharesdepartno.departno AND ShareType = 0
	IF CheckInsert = 0 THEN;
		INSERT INTO Note_Share(ShareNo,CompanyNo,UserNo,ListNo,DayCreate,DayEdit,ShareCompanyNo,UserShare,GroupNo,ShareType,ReadDate,timeOffset)
						VALUES(NEWID (),CompanyNo,UserNo,ListNo,DayCreate,DayCreate,ShareCompanyNo,DepartNo,GroupNo,0,DayCreate,NoteTimeZone)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
