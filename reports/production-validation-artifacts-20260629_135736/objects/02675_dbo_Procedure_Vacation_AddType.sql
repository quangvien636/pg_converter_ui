-- ─── PROCEDURE→FUNCTION: vacation_addtype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_addtype(integer, integer, integer, double precision, character varying, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.vacation_addtype(
    IN p_uno integer,
    IN p_typei integer,
    IN p_time integer,
    IN p_timed double precision,
    IN p_name character varying DEFAULT '',
    IN p_note character varying DEFAULT '',
    IN p_offtype integer DEFAULT -1,
    IN p_special integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

INSERT INTO Vacation_Types
           (UserNo
		   ,Name
           ,Typei
           ,Time
           ,TimeDis
           ,DateCreate,statusr, Note, Sort, OffType, special)
     VALUES
           (p_Uno ,
			p_Name ,
			p_Typei ,
			p_Time ,
			p_Timed ,SYSDATETIME() ,1, p_Note, -99,  p_OffType, p_Special)

			RETURN QUERY
			select lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
