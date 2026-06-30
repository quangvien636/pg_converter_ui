-- ─── TABLE: EAPPHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPHistory" (
    ID serial NOT NULL,
    HType integer,
    TargetID integer,
    ActorID character varying(50),
    ActState integer,
    ActDate timestamp without time zone,
    Comment text,
    IsMobile character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
