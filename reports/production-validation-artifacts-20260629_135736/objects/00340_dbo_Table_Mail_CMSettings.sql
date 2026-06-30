-- ─── TABLE: Mail_CMSettings ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_CMSettings" (
    UserNo integer NOT NULL,
    PopAcc character varying(100) NOT NULL,
    Domain character varying(100) NOT NULL,
    AutoYN character(1) NOT NULL,
    AutoMessage text NOT NULL,
    AutoStartDate timestamp without time zone NOT NULL,
    AutoEndDate timestamp without time zone NOT NULL,
    MaxDisk integer NOT NULL,
    Forward text NOT NULL,
    ForwardRemark character varying(2000) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
