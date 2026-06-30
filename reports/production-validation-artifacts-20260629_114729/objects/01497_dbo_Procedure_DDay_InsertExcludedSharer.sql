-- ─── PROCEDURE→FUNCTION: dday_insertexcludedsharer ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_insertexcludedsharer(bigint, integer);
CREATE OR REPLACE FUNCTION public.dday_insertexcludedsharer(
    IN dayno bigint,
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_GroupInfoOfSharedDays WHERE DayNo = dday_insertexcludedsharer.dayno

	INSERT INTO DDay_ExcludedSharers (DayNo, UserNo)
	VALUES (DayNo, UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
