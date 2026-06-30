-- ─── TABLE: Work_CooperationFiles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Work_CooperationFiles" (
    FileNo bigserial NOT NULL,
    CooperationNo integer NOT NULL,
    Name character varying(260) NOT NULL,
    Length integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
