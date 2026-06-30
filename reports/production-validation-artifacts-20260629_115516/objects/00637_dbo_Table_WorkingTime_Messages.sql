-- ─── TABLE: WorkingTime_Messages ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_Messages" (
    MessageNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    Message character varying(1000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
