-- ─── FUNCTION: note_lgetspecifiedgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_lgetspecifiedgroups(integer);
CREATE OR REPLACE FUNCTION public.note_lgetspecifiedgroups(
    userno integer
) RETURNS TABLE(
    groupno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    groupnos table (
		groupno uniqueidentifier
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SET oPos = 1
	SET nPos = 1

	WHILE (nPos > 0) BEGIN
	
		SET nPos = STRPOS(ListOfGroupNos, oPos, ';')

		IF (nPos = 0)
			SET TmpVar = RIGHT(ListOfGroupNos, LEN(ListOfGroupNos) - oPos + 1)
		ELSE
			SET TmpVar = SUBSTRING(ListOfGroupNos, oPos, nPos - oPos)

		IF (LEN(TmpVar) > 0);
			INSERT INTO GroupNos VALUES (TmpVar)
			
		SET oPos = nPos + 1

	END

	RETURN QUERY
	SELECT GroupNo, UserNo, Name, DateCreated, DateChanged, IsDefault
	FROM Note_LGroups
	WHERE GroupNo IN (SELECT GroupNo FROM GroupNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
