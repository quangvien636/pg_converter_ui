-- ─── TABLE: Users ───────────────────────────────────
-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.
CREATE TABLE IF NOT EXISTS public."Users" (
Id serial NOT NULL,
    TenantId bigint NOT NULL,
    IsActive boolean NOT NULL DEFAULT true,
    Name character varying(100) NOT NULL,
    Bio text NULL,
    CreatedAt timestamp without time zone NOT NULL DEFAULT now(),
    Guid uuid NOT NULL ,
    Balance numeric(19,4) NOT NULL DEFAULT (0),
    Payload bytea NULL,
    PRIMARY KEY (Id)
);
-- TODO: Owner mapping skipped. Target role qa_owner not verified.
