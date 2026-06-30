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

-- ─── TABLE: Orders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Orders" (
OrderId serial NOT NULL,
    UserId integer NOT NULL,
    Amount numeric(18,2) NOT NULL,
    PRIMARY KEY (OrderId),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES public."Users"(Id)
);
-- TODO: Owner mapping skipped. Target role qa_owner not verified.

-- ─── PROCEDURE→FUNCTION: usp_insertuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.usp_insertuser(character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.usp_insertuser(
    IN name character varying,
    INOUT newid integer,
    IN isactive boolean DEFAULT TRUE
) RETURNS void
AS $function$
BEGIN

    INSERT INTO public."Users" (Name, IsActive) VALUES (Name, IsActive);
    NewId := lastval();
    RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.

-- ─── PROCEDURE→FUNCTION: usp_dynamic ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.usp_dynamic();
CREATE OR REPLACE FUNCTION public.usp_dynamic(
) RETURNS SETOF record
AS $function$
DECLARE
    sql character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


    sql := 'SELECT /* /* TOP 1 */ */ * FROM ' || TableName;
    PERFORM sql();
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.

-- ─── FUNCTION: fn_userlabel ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_userlabel(character varying, boolean);
CREATE OR REPLACE FUNCTION public.fn_userlabel(
    name character varying,
    isactive boolean
) RETURNS character varying
AS $function$
BEGIN

    RETURN COALESCE(Name, '') || CASE WHEN IsActive = TRUE THEN ' Active' ELSE ' Inactive' END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.

-- ─── FUNCTION: fn_userorders ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_userorders(integer);
CREATE OR REPLACE FUNCTION public.fn_userorders(
    userid integer
) RETURNS TABLE(
    orderid integer,
    amount numeric
)
AS $function$
#variable_conflict use_column
BEGIN

    RETURN QUERY SELECT OrderId, Amount FROM public."Orders" WHERE UserId = fn_userorders.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.

-- ─── INDEX: ix_users_name ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_users_name') THEN
        CREATE INDEX ix_users_name ON public."Users" (Name);
    END IF;
END;
$$;

-- ─── INDEX: ux_users_guid ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ux_users_guid') THEN
        CREATE UNIQUE INDEX ux_users_guid ON public."Users" (Guid);
    END IF;
END;
$$;

-- ─── INDEX: ix_orders_user_amount ON Orders ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_orders_user_amount') THEN
        CREATE INDEX ix_orders_user_amount ON public."Orders" (UserId, Amount);
    END IF;
END;
$$;

-- ─── INDEX: ix_users_active ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_users_active') THEN
        CREATE INDEX ix_users_active ON public."Users" (IsActive) WHERE IsActive = 1;
    END IF;
END;
$$;

-- ─── INDEX: ix_orders_user_include ON Orders ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'ix_orders_user_include') THEN
        CREATE INDEX ix_orders_user_include ON public."Orders" (UserId);
    END IF;
END;
$$;

-- ─── INDEX: cx_users_tenant ON Users ─────────────────────
-- TODO: SQL Server CLUSTERED index detected. PostgreSQL does not maintain clustered indexes the same way. Manual review required.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'cx_users_tenant') THEN
        CREATE INDEX cx_users_tenant ON public."Users" (TenantId);
    END IF;
END;
$$;