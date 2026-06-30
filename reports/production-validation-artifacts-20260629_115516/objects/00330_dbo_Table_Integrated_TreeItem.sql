-- ─── TABLE: Integrated_TreeItem ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Integrated_TreeItem" (
    UserID character varying(50),
    Name character varying(100),
    ParentID integer,
    SortOrd integer,
    UseYn character(1),
    RegID character varying(50),
    RegDate timestamp without time zone,
    ModID character varying(50),
    ModDate timestamp without time zone,
    ID serial NOT NULL,
    TreeID integer,
    IsSet character(1)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
