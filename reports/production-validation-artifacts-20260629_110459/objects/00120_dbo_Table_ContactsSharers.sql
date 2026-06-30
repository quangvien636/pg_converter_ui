-- ─── TABLE: ContactsSharers ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsSharers" (
    Seq integer NOT NULL,
    DepartNo integer NOT NULL,
    DepartName character varying(100),
    IsChild character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
