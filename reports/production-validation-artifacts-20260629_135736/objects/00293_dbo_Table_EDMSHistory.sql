-- ─── TABLE: EDMSHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSHistory" (
    ID serial NOT NULL,
    HType integer,
    TargetID integer,
    ActorID character varying(50),
    ActState integer,
    ActDate timestamp without time zone,
    Comment character varying(200)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
