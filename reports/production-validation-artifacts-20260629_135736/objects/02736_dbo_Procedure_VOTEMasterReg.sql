-- ─── PROCEDURE→FUNCTION: votemasterreg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.votemasterreg(character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, smallint, smallint);
CREATE OR REPLACE FUNCTION public.votemasterreg(
    IN title character varying,
    IN type character varying,
    IN popup character varying,
    IN startdate character varying,
    IN enddate character varying,
    IN public character varying,
    IN itemcnt integer,
    IN reguserno integer,
    IN isstandby smallint,
    IN isreg smallint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO VOTEMaster
			(Title
			,Type
			,PopUp
			,StartDate
			,EndDate
			,Public
			,ItemCnt
			,IsStandBy
			,IsReg
			,RegUserNo
			,RegDate)
		 VALUES
			(Title
			,Type
			,PopUp
			,StartDate
			,EndDate
			,Public
			,ItemCnt
			,IsStandBy
			,IsReg
			,RegUserNo
			,NOW())

	RETURN QUERY
	SELECT lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
