-- ─── TABLE: PersonalGroupUser ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."PersonalGroupUser" (
    GroupNo integer NOT NULL,
    SeqNo integer NOT NULL,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone,
    UserNo integer NOT NULL,
    PRIMARY KEY (GroupNo, SeqNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
