-- ─── TABLE: VOTESubItem ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."VOTESubItem" (
    ID bigserial NOT NULL,
    ParentID integer NOT NULL,
    MasterID integer NOT NULL,
    Title text,
    ResultCount integer NOT NULL,
    PRIMARY KEY (ID, ParentID)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
