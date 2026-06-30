-- ─── PROCEDURE→FUNCTION: schedule_insertreservationrivision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertreservationrivision(character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertreservationrivision(
    IN revisiontype character varying,
    IN reguserno integer
) RETURNS void
AS $function$
BEGIN

	INSERT INTO ScheduleResourceReservationsRevision
	(
		ReservationNo,
		RevisionType,
		RegDate,
		RegUserNo
	)
	VALUES
	(
		ReservationNo,
		RevisionType,
		NOW(),
		RegUserNo
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
