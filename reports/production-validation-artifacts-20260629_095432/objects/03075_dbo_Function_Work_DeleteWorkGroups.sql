-- ─── FUNCTION: work_deleteworkgroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_deleteworkgroups(character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_deleteworkgroups(
    groupnos character varying,
    moduserno integer,
    moddate timestamp without time zone
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tbgroupnos table (
		groupno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	SET StartIndex = 1
	SET SearchIndex = 1

	WHILE (SearchIndex > 0)
	BEGIN

		SET SearchIndex = STRPOS(GroupNos, StartIndex, ';')

		IF SearchIndex = 0 BEGIN

			SET TempStr = RIGHT(GroupNos, LEN(GroupNos) - StartIndex + 1)

		END

		ELSE BEGIN

			SET TempStr = SUBSTRING(GroupNos, StartIndex, SearchIndex - StartIndex)

		END

		IF LEN(TempStr) > 0 BEGIN

			INSERT INTO tbGroupNos VALUES(TempStr)

		END

		SET StartIndex = SearchIndex + 1 

	END

	UPDATE WorkGroups SET Enabled = FALSE, ModUserNo = work_deleteworkgroups.moduserno, ModDate = work_deleteworkgroups.moddate
	WHERE GroupNo IN (SELECT GroupNo FROM tbGroupNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
