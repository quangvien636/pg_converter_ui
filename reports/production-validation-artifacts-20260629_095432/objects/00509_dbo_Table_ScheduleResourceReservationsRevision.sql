-- ─── TABLE: ScheduleResourceReservationsRevision ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourceReservationsRevision" (
    RevisionNo serial NOT NULL,
    ReservationNo integer NOT NULL,
    RevisionType character varying(1) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    RegUserNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
