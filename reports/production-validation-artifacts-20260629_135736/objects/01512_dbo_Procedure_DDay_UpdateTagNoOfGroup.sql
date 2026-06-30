-- ─── PROCEDURE→FUNCTION: dday_updatetagnoofgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_updatetagnoofgroup(bigint, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.dday_updatetagnoofgroup(
    IN groupno bigint,
    IN moddate timestamp without time zone,
    IN tagno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE DDay_Groups SET
		ModDate = dday_updatetagnoofgroup.moddate,
		TagNo = dday_updatetagnoofgroup.tagno
	WHERE GroupNo = dday_updatetagnoofgroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
