-- ─── FUNCTION: note_linsertsharer ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_linsertsharer(uuid, integer, integer);
CREATE OR REPLACE FUNCTION public.note_linsertsharer(
    noteno uuid,
    userno integer,
    shareruserno integer
) RETURNS TABLE(
    shareno text
)
AS $function$
DECLARE
    shareno uuid;
BEGIN



	IF ((SELECT COUNT(*) FROM Note_Share WHERE ListNo = note_linsertsharer.noteno AND UserShare = note_linsertsharer.userno) = 0) BEGIN

		SET ShareNo = NEWID()

		INSERT INTO Note_Share (ShareNo, UserNo, ListNo, DayCreate, DayEdit, UserShare, GroupNo, IsRead, ReadDate,
			IsReads, FavoriteType, ShareType, timeOffset, CompanyNo, ShareCompanyNo)
		VALUES (ShareNo, UserNo, NoteNo, GETUTCDATE(), GETUTCDATE(), SharerUserNo, '00000000-0000-0000-0000-000000000000', 0, NULL,
			0, 0, 0, NULL, NULL, NULL)

		UPDATE Note_List SET DayEdit = GETUTCDATE()
		WHERE ListNo = note_linsertsharer.noteno

	END

	ELSE BEGIN

		SET ShareNo = (SELECT ShareNo FROM Note_Share WHERE ListNo = note_linsertsharer.noteno AND UserShare = note_linsertsharer.userno)

	END

	RETURN QUERY
	SELECT ShareNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
