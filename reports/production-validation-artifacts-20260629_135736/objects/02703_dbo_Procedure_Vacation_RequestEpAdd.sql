-- ─── PROCEDURE→FUNCTION: vacation_requestepadd ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_requestepadd(integer, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, integer, double precision, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_requestepadd(
    IN p_unoi integer,
    IN p_type integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_date timestamp without time zone,
    IN p_typea integer,
    IN p_td double precision,
    IN p_uno character varying,
    IN p_dno character varying,
    IN p_note character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

INSERT INTO Vacation_RequestEps
           (
            TypeId
           ,Fromd
           ,Tod
		   ,Note
           ,DateCreate,StatusUser, StatusAdmin, TypeForAll, TimeDis, UserNo, departno, UsernoI)
     VALUES
           (
				p_type ,
				p_from ,
				p_to ,
				p_Note ,
				p_date, 0, 0, p_typea, p_td, p_Uno, p_Dno, p_UnoI
			)

			RETURN QUERY
			select lastval();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
