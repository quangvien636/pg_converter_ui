-- ─── PROCEDURE→FUNCTION: vacation_addrequest ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_addrequest(integer, integer, timestamp without time zone, timestamp without time zone, double precision, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.vacation_addrequest(
    IN p_uno integer,
    IN p_type integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_vcount double precision,
    IN p_date timestamp without time zone,
    IN p_note character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

INSERT INTO Vacation_Requests
           (UserNo
           ,TypeId
           ,Fromd
           ,Tod
		   ,VacationsCount
		   ,Note
           ,DateCreate,StatusUser, StatusAdmin)
     VALUES
           (
				p_Uno ,
				p_type ,
				p_from ,
				p_to ,
				p_vcount,
				p_Note ,
				p_date, 0, 0
			)

			RETURN QUERY
			select lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
