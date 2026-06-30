-- ─── PROCEDURE→FUNCTION: vacation_addepdetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_addepdetail(integer, timestamp without time zone, timestamp without time zone, double precision, integer, character varying);
CREATE OR REPLACE FUNCTION public.vacation_addepdetail(
    IN p_type integer,
    IN p_from timestamp without time zone,
    IN p_to timestamp without time zone,
    IN p_td double precision,
    IN p_uno integer,
    IN p_note character varying DEFAULT ''
) RETURNS void
AS $function$
BEGIN

		-----INSERT INTO if null;
		INSERT INTO Vacation_RequestEps (TypeId, Fromd, Tod, Note,DateCreate, UserNo, UsernoI, TimeDis)
		values( p_type,p_from,p_to,p_Note,NOW(),CONVERT(VARCHAR(50),p_Uno)+',', p_Uno, p_td);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
