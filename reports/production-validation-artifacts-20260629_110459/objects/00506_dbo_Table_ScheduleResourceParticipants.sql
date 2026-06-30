-- ─── TABLE: ScheduleResourceParticipants ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourceParticipants" (
    ReservationNo integer NOT NULL,
    UserNo integer NOT NULL,
    DepartNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
