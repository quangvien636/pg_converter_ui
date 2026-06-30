-- ─── PROCEDURE→FUNCTION: note_linsertsharer ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_linsertsharer(uuid, integer, integer);
CREATE OR REPLACE FUNCTION public.note_linsertsharer(
    IN noteno uuid,
    IN userno integer,
    IN shareruserno integer
) RETURNS SETOF record
AS $function$
DECLARE
    shareno uuid;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	IF (SELECT COUNT(*) FROM Note_Share WHERE ListNo = note_linsertsharer.noteno AND UserShare = note_linsertsharer.userno) = 0 THEN

		ShareNo := NEWID();;
		INSERT INTO Note_Share (ShareNo, UserNo, ListNo, DayCreate, DayEdit, UserShare, GroupNo, IsRead, ReadDate,
			IsReads, FavoriteType, ShareType, timeOffset, CompanyNo, ShareCompanyNo)
		VALUES (ShareNo, UserNo, NoteNo, GETUTCDATE(), GETUTCDATE(), SharerUserNo, '00000000-0000-0000-0000-000000000000', 0, NULL,
			0, 0, 0, NULL, NULL, NULL)

		UPDATE Note_List SET DayEdit = GETUTCDATE()
		WHERE ListNo = note_linsertsharer.noteno

	END IF;

	ELSE BEGIN

		ShareNo := (SELECT ShareNo FROM Note_Share WHERE ListNo = note_linsertsharer.noteno AND UserShare = note_linsertsharer.userno);
	END;

	RETURN QUERY
	SELECT ShareNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
