-- ─── TABLE: Board_ReplyFiles ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_ReplyFiles" (
    ReplyFileNo bigserial NOT NULL,
    ReplyNo bigint NOT NULL,
    Name character varying(260) NOT NULL,
    Size integer NOT NULL,
    Url text
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
