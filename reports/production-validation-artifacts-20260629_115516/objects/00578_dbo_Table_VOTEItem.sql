-- ─── TABLE: VOTEItem ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."VOTEItem" (
    ID serial NOT NULL,
    ParentID integer NOT NULL,
    Title text,
    Type integer NOT NULL,
    Cnt integer NOT NULL,
    SelectOption smallint NOT NULL DEFAULT 0,
    PRIMARY KEY (ID, ParentID)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
