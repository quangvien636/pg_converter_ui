-- ─── TABLE: ScheduleResourceReservationsRevision ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourceReservationsRevision" (
    RevisionNo serial NOT NULL,
    ReservationNo integer NOT NULL DEFAULT 0,
    RevisionType character varying(1) NOT NULL DEFAULT 'I',
    RegDate timestamp without time zone NOT NULL DEFAULT now(),
    RegUserNo integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
