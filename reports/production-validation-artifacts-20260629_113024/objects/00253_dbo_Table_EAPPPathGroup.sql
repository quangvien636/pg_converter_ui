-- ─── TABLE: EAPPPathGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EAPPPathGroup" (
    ID serial NOT NULL,
    FormID integer,
    GroupCd character varying(10),
    PathID integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
