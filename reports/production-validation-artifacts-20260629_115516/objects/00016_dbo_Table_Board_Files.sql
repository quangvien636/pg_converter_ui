-- ─── TABLE: Board_Files ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_Files" (
    FileNo bigserial NOT NULL,
    ContentNo bigint NOT NULL,
    Name character varying(260) NOT NULL,
    Size integer NOT NULL,
    Url text,
    Sort integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
