-- ─── TABLE: VOTEResult ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."VOTEResult" (
    ID bigserial NOT NULL,
    MasterID integer NOT NULL,
    ParentID integer NOT NULL,
    Type integer NOT NULL,
    UserNo integer NOT NULL,
    Result character varying(2000) NOT NULL,
    PollDate timestamp without time zone,
    PRIMARY KEY (ID, ParentID)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
