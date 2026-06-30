-- ─── TABLE: WorkToDo_FilesOfToDo ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkToDo_FilesOfToDo" (
    FileNo bigserial NOT NULL,
    DataNo bigint NOT NULL,
    Name character varying(260) NOT NULL,
    Length integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
