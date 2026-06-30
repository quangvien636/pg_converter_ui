-- ─── TABLE: ScheduleResourceReservationsHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ScheduleResourceReservationsHistory" (
    ReservationNo integer NOT NULL,
    SeqNo integer NOT NULL,
    RsvnStatus character(2) NOT NULL,
    ProcessDate timestamp without time zone NOT NULL,
    ProcessUserNo integer NOT NULL,
    Reason character varying(500) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    RegUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    PRIMARY KEY (ReservationNo, SeqNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
