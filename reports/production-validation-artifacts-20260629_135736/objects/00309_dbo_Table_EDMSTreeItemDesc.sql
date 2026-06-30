-- ─── TABLE: EDMSTreeItemDesc ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."EDMSTreeItemDesc" (
    ID character varying(100) NOT NULL,
    DivID character varying(100) NOT NULL,
    Desc1 character varying(2000),
    Desc2 character varying(2000),
    Desc3 character varying(3000),
    PRIMARY KEY (ID, DivID)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
