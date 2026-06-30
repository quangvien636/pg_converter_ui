-- ─── FUNCTION: schedule_insertreservationrivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertreservationrivision(character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertreservationrivision(
    revisiontype character varying,
    reguserno integer
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
