-- ─── PROCEDURE→FUNCTION: work_deleteregularworkgroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.work_deleteregularworkgroups(character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.work_deleteregularworkgroups(
    IN groupnos character varying,
    IN moduserno integer,
    IN moddate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    tbgroupnos table (
		groupno int
	);
    tempstr character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	StartIndex := 1;
	SearchIndex := 1;
	WHILE SearchIndex > 0 LOOP

		SearchIndex := STRPOS(GroupNos, StartIndex, ';');
		IF SearchIndex = 0 THEN

			TempStr := RIGHT(GroupNos, LEN(GroupNos) - StartIndex + 1);
		END IF;

		ELSE BEGIN

			TempStr := SUBSTRING(GroupNos, StartIndex, SearchIndex - StartIndex);
		END LOOP;

		IF LEN(TempStr) > 0 THEN

			INSERT INTO tbGroupNos VALUES(TempStr)

		END IF;

		StartIndex := SearchIndex + 1;
	END;

	UPDATE RegularWorkGroups SET Enabled = FALSE, ModUserNo = work_deleteregularworkgroups.moduserno, ModDate = work_deleteregularworkgroups.moddate
	WHERE GroupNo IN (SELECT GroupNo FROM tbGroupNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
