-- ─── PROCEDURE→FUNCTION: schedule_insertdivision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_insertdivision(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertdivision(
    IN name character varying,
    IN nameen character varying,
    IN namejp character varying,
    IN namech character varying,
    IN namevn character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT count(*) INTO row from ScheduleDivisions
	if(row > 0)
	begin
		SELECT MAX(SortOrder) INTO maxorder from ScheduleDivisions
	END;
	ELSE
		maxOrder := (1);
	END IF;
		 
	INSERT INTO ScheduleDivisions
	(
		Name,
		NameEn,
		NameJp,
		NameCh,
		NameVn,
		Color,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		SortOrder
	)
	VALUES
	(
		Name,
		NameEn,
		NameJp,
		NameCh,
		NameVn,
		Color,
		UserNo,
		NOW(),
		UserNo,
		NOW(),
		maxOrder
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
