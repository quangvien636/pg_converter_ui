-- ─── TABLE: ProposalUserApproval ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."ProposalUserApproval" (
    UserNo integer NOT NULL,
    DivisionNo integer NOT NULL,
    Kind integer NOT NULL,
    RegUserNo integer,
    RegDate timestamp without time zone,
    ModUserNo integer,
    ModDate timestamp without time zone,
    PRIMARY KEY (UserNo, DivisionNo, Kind)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
