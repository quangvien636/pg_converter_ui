-- ─── TABLE: DDay_Days ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DDay_Days" (
    DayNo bigserial NOT NULL,
    RegUserNo integer NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    GroupNo bigint NOT NULL,
    TypeNo integer NOT NULL,
    RepeatOptions text NOT NULL,
    Title character varying(1000) NOT NULL,
    Content text NOT NULL,
    CanHide boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
