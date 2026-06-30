-- ─── PROCEDURE→FUNCTION: vacation_add ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_add(integer, double precision, timestamp without time zone, integer, double precision, character varying);
CREATE OR REPLACE FUNCTION public.vacation_add(
    IN p_uno integer,
    IN p_used double precision,
    IN p_date timestamp without time zone,
    IN p_years integer,
    IN p_vacations double precision DEFAULT 0,
    IN p_note character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

INSERT INTO Vacation_Vacations
           (UserNo
           ,Vacations
           ,Used
           ,Note
           ,DateCreate,statusr, years)
     VALUES
           (p_Uno ,
			p_Vacations ,
			p_used ,
			p_Note ,
			p_date ,1, p_years )

			RETURN QUERY
			select lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
