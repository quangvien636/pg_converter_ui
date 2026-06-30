-- ─── TABLE: ContactsGroupUserHistory ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsGroupUserHistory" (
    HistoryNo integer NOT NULL,
    Seq integer NOT NULL,
    GroupNo integer,
    UserSeq integer,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModDate timestamp without time zone,
    PRIMARY KEY (HistoryNo, Seq)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
