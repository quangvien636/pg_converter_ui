-- ─── TABLE: Mail_FrequentlyUsedAddresses ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Mail_FrequentlyUsedAddresses" (
    AddressNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    Name character varying(100) NOT NULL,
    Address character varying(100) NOT NULL,
    UsedCount integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
