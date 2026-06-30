-- ─── TABLE: EAPPDocRotation ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPDocRotation" (
    ID serial NOT NULL,
    DocID integer NOT NULL,
    Sender character varying(20) NOT NULL,
    Receiver character varying(20) NOT NULL,
    SendDate timestamp without time zone NOT NULL,
    Sdel character(1),
    Rdel character(1),
    IsOP character(1),
    Comment character varying(3000)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
