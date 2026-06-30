-- ─── TABLE: ContactsCompany ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ContactsCompany" (
    Seq serial NOT NULL,
    RegUserNo integer,
    UserSeq integer,
    Company character varying(50),
    Depart character varying(50),
    Position character varying(50),
    IsDefault character(1),
    RegDate timestamp without time zone DEFAULT now(),
    ModDate timestamp without time zone DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
