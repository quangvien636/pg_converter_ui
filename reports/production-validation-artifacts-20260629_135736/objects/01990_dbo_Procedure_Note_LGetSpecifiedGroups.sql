-- ─── PROCEDURE→FUNCTION: note_lgetspecifiedgroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.note_lgetspecifiedgroups(integer);
CREATE OR REPLACE FUNCTION public.note_lgetspecifiedgroups(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    groupnos table (
		groupno uniqueidentifier
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	oPos := 1;
	nPos := 1;
	WHILE nPos > 0 LOOP
	
		nPos := STRPOS(ListOfGroupNos, oPos, ';');
		IF nPos = 0 THEN
			TmpVar := RIGHT(ListOfGroupNos, LEN(ListOfGroupNos) - oPos + 1);
		ELSE
			TmpVar := SUBSTRING(ListOfGroupNos, oPos, nPos - oPos);
		IF LEN(TmpVar) > 0 THEN;
			INSERT INTO GroupNos VALUES (TmpVar)
			
		oPos := nPos + 1;
	END LOOP;

	RETURN QUERY
	SELECT GroupNo, UserNo, Name, DateCreated, DateChanged, IsDefault
	FROM Note_LGroups
	WHERE GroupNo IN (SELECT GroupNo FROM GroupNos);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
