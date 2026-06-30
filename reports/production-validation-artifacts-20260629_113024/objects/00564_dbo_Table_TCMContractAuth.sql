-- ─── TABLE: TCMContractAuth ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."TCMContractAuth" (
    UserNo integer,
    UseYN character varying(1) DEFAULT 'N'
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
