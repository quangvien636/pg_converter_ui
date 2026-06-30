-- ─── TABLE: ContactsCompanyHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsCompanyHistory" (
    HistoryNo integer NOT NULL,
    Seq integer NOT NULL,
    RegUserNo integer,
    UserSeq integer,
    Company character varying(50),
    Depart character varying(50),
    Position character varying(50),
    IsDefault character(1),
    RegDate timestamp without time zone,
    ModDate timestamp without time zone,
    PRIMARY KEY (HistoryNo, Seq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
