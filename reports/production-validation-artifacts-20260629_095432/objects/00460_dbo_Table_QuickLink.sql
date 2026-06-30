-- ─── TABLE: QuickLink ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."QuickLink" (
    Seq bigserial NOT NULL,
    Title text NOT NULL,
    Url character varying(1000) NOT NULL,
    UserNo integer NOT NULL,
    OrderId integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    IsActive boolean NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
