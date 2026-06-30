-- ─── TABLE: Integrated_Files ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Integrated_Files" (
    FileNo bigserial NOT NULL,
    ContentNo bigint NOT NULL,
    Name character varying(260) NOT NULL,
    Size integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
