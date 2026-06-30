# QA Converter Report

Generated: 2026-06-30 13:11:19

## Status

- Build status: pass
- PostgreSQL runtime validation: CHƯA XÁC MINH
- PostgreSQL syntax/runtime execution: not run because `psql` and `docker` are not available in PATH

## Validation Method

- expected-pattern check
- basic syntax pattern check
- warning validation

## Artifacts

- Sample MSSQL input: `reports/generated/sample-mssql-input.sql`
- Generated PostgreSQL output: `reports/generated/converted-output.sql`
- Temporary test runner: `%TEMP%\PgConverterQaRunner2`

## Coverage

- TABLE parsed/tested: 2
- STORED PROCEDURE parsed/tested: 2
- FUNCTION parsed/tested: 2
- INDEX parsed/tested: 6

## Commands Run

```powershell
dotnet build
dotnet run --project $env:TEMP\PgConverterQaRunner2\PgConverterQaRunner.csproj
```

## Summary

- Total checks: 27
- PASS: 27
- FAIL: 0

Không kết luận Convert PGSQL đúng hoàn toàn. Không kết luận file PGSQL chạy được runtime.

## Findings

| ID | Object Type | Test Case | Input MSSQL | Expected PGSQL | Actual PGSQL | Status | Severity | Suggested Fix |
|---|---|---|---|---|---|---|---|---|
| ID-001 | TABLE | Parse CREATE TABLE | <pre>CREATE TABLE [dbo].[Users] (
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [TenantId] [bigint] NOT NULL,
    [IsActive] [bit] NOT NULL CONSTRAINT [DF_Users_IsActive] DEFAULT ((1)),
    [Name] [nvarchar](100) NOT NULL,
    [Bio] [varchar](MAX) NULL,
    [CreatedAt] [datetime2](7) NOT NULL CONSTRAINT [DF_Users_CreatedAt] DEFAULT (GETDATE()),
    [Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Users_Guid] DEFAULT (NEWID()),
    [Balance] [money] NOT NULL DEFAULT ((0)),
    [Payload] [varbinary](MAX) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
)</pre> | <pre>ObjectType.Table</pre> | <pre>Table</pre> | PASS | Critical | Improve parser for CREATE TABLE blocks. |
| ID-002 | STORED PROCEDURE | Parse CREATE PROCEDURE | <pre>CREATE PROCEDURE [dbo].[usp_InsertUser]
    @Name nvarchar(100),
    @IsActive bit = 1,
    @NewId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Users] ([Name], [IsActive]) VALUES (@Name, @IsActive);
    SET @NewId = SCOPE_IDENTITY();
    RETURN 0;
END</pre> | <pre>ObjectType.Procedure</pre> | <pre>Procedure</pre> | PASS | Critical | Keep stored procedures as ObjectType.Procedure. |
| ID-003 | FUNCTION | Parse CREATE FUNCTION | <pre>CREATE FUNCTION [dbo].[fn_UserLabel](@Name nvarchar(100), @IsActive bit)
RETURNS nvarchar(200)
AS
BEGIN
    RETURN ISNULL(@Name, N&#39;&#39;) + CASE WHEN @IsActive = 1 THEN N&#39; Active&#39; ELSE N&#39; Inactive&#39; END;
END</pre> | <pre>ObjectType.Function</pre> | <pre>Function</pre> | PASS | Critical | Improve parser for CREATE FUNCTION blocks. |
| ID-004 | INDEX | Parse CREATE INDEX | <pre>CREATE INDEX [IX_Users_Name] ON [dbo].[Users] ([Name])</pre> | <pre>ObjectType.Index</pre> | <pre>Index</pre> | PASS | Critical | Improve parser for CREATE INDEX blocks. |
| ID-005 | TABLE | IDENTITY mapping | <pre>CREATE TABLE [dbo].[Users] (
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [TenantId] [bigint] NOT NULL,
    [IsActive] [bit] NOT NULL CONSTRAINT [DF_Users_IsActive] DEFAULT ((1)),
    [Name] [nvarchar](100) NOT NULL,
    [Bio] [varchar](MAX) NULL,
    [CreatedAt] [datetime2](7) NOT NULL CONSTRAINT [DF_Users_CreatedAt] DEFAULT (GETDATE()),
    [Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Users_Guid] DEFAULT (NEWID()),
    [Balance] [money] NOT NULL DEFAULT ((0)),
    [Payload] [varbinary](MAX) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
)</pre> | <pre>serial</pre> | <pre>-- ─── TABLE: Users ───────────────────────────────────
-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.
CREATE TABLE IF NOT EXISTS public.&quot;Users&quot; (
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
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | Critical | Map MSSQL IDENTITY to PostgreSQL identity syntax. |
| ID-006 | TABLE | Data type mapping | <pre>CREATE TABLE [dbo].[Users] (
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [TenantId] [bigint] NOT NULL,
    [IsActive] [bit] NOT NULL CONSTRAINT [DF_Users_IsActive] DEFAULT ((1)),
    [Name] [nvarchar](100) NOT NULL,
    [Bio] [varchar](MAX) NULL,
    [CreatedAt] [datetime2](7) NOT NULL CONSTRAINT [DF_Users_CreatedAt] DEFAULT (GETDATE()),
    [Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Users_Guid] DEFAULT (NEWID()),
    [Balance] [money] NOT NULL DEFAULT ((0)),
    [Payload] [varbinary](MAX) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
)</pre> | <pre>bigint, boolean, text/varchar, timestamp, uuid, numeric(19,4), bytea</pre> | <pre>-- ─── TABLE: Users ───────────────────────────────────
-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.
CREATE TABLE IF NOT EXISTS public.&quot;Users&quot; (
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
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | Critical | Complete table type mapping. |
| ID-007 | TABLE | DEFAULT function mapping | <pre>CREATE TABLE [dbo].[Users] (
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [TenantId] [bigint] NOT NULL,
    [IsActive] [bit] NOT NULL CONSTRAINT [DF_Users_IsActive] DEFAULT ((1)),
    [Name] [nvarchar](100) NOT NULL,
    [Bio] [varchar](MAX) NULL,
    [CreatedAt] [datetime2](7) NOT NULL CONSTRAINT [DF_Users_CreatedAt] DEFAULT (GETDATE()),
    [Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Users_Guid] DEFAULT (NEWID()),
    [Balance] [money] NOT NULL DEFAULT ((0)),
    [Payload] [varbinary](MAX) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
)</pre> | <pre>GETDATE() -&gt; now(); NEWID() -&gt; PostgreSQL 9.3 warning</pre> | <pre>-- ─── TABLE: Users ───────────────────────────────────
-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.
CREATE TABLE IF NOT EXISTS public.&quot;Users&quot; (
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
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | High | Warn that MSSQL NEWID() requires a manual PostgreSQL 9.3 rewrite or uuid-ossp. |
| ID-008 | TABLE | Primary key preserved | <pre>CREATE TABLE [dbo].[Users] (
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [TenantId] [bigint] NOT NULL,
    [IsActive] [bit] NOT NULL CONSTRAINT [DF_Users_IsActive] DEFAULT ((1)),
    [Name] [nvarchar](100) NOT NULL,
    [Bio] [varchar](MAX) NULL,
    [CreatedAt] [datetime2](7) NOT NULL CONSTRAINT [DF_Users_CreatedAt] DEFAULT (GETDATE()),
    [Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Users_Guid] DEFAULT (NEWID()),
    [Balance] [money] NOT NULL DEFAULT ((0)),
    [Payload] [varbinary](MAX) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
)</pre> | <pre>PRIMARY KEY preserved</pre> | <pre>-- ─── TABLE: Users ───────────────────────────────────
-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.
CREATE TABLE IF NOT EXISTS public.&quot;Users&quot; (
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
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | Critical | Preserve primary key constraints. |
| ID-009 | TABLE | Foreign key schema mapping | <pre>CREATE TABLE [dbo].[Orders] (
    [OrderId] [int] IDENTITY(1,1) NOT NULL,
    [UserId] [int] NOT NULL,
    [Amount] [decimal](18,2) NOT NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY ([OrderId]),
    CONSTRAINT [FK_Orders_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id])
)</pre> | <pre>FOREIGN KEY REFERENCES public.&quot;Users&quot;; no dbo schema</pre> | <pre>-- ─── TABLE: Orders ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public.&quot;Orders&quot; (
OrderId serial NOT NULL,
    UserId integer NOT NULL,
    Amount numeric(18,2) NOT NULL,
    PRIMARY KEY (OrderId),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES public.&quot;Users&quot;(Id)
);
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | Critical | Map MSSQL dbo references to the PostgreSQL public schema. |
| ID-010 | STORED PROCEDURE | Procedure converted to PostgreSQL function | <pre>CREATE PROCEDURE [dbo].[usp_InsertUser]
    @Name nvarchar(100),
    @IsActive bit = 1,
    @NewId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Users] ([Name], [IsActive]) VALUES (@Name, @IsActive);
    SET @NewId = SCOPE_IDENTITY();
    RETURN 0;
END</pre> | <pre>CREATE OR REPLACE FUNCTION public.usp_insertuser; no CREATE PROCEDURE; NOTE/TODO present</pre> | <pre>-- ─── PROCEDURE→FUNCTION: usp_insertuser ───────────────────────────────
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

    INSERT INTO public.&quot;Users&quot; (Name, IsActive) VALUES (Name, IsActive);
    NewId := lastval();
    RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_o
... &lt;truncated&gt;</pre> | PASS | Critical | Convert SQL Server stored procedure to PostgreSQL function; do not emit unsupported PROCEDURE DDL. |
| ID-011 | STORED PROCEDURE | OUTPUT parameter becomes INOUT | <pre>CREATE PROCEDURE [dbo].[usp_InsertUser]
    @Name nvarchar(100),
    @IsActive bit = 1,
    @NewId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Users] ([Name], [IsActive]) VALUES (@Name, @IsActive);
    SET @NewId = SCOPE_IDENTITY();
    RETURN 0;
END</pre> | <pre>INOUT newid integer (OUTPUT → INOUT); no bare OUT newid</pre> | <pre>-- ─── PROCEDURE→FUNCTION: usp_insertuser ───────────────────────────────
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

    INSERT INTO public.&quot;Users&quot; (Name, IsActive) VALUES (Name, IsActive);
    NewId := lastval();
    RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_o
... &lt;truncated&gt;</pre> | PASS | High | Convert SQL Server OUTPUT parameters to INOUT in the generated PostgreSQL function signature. |
| ID-012 | STORED PROCEDURE | RETURN semantics warning | <pre>CREATE PROCEDURE [dbo].[usp_InsertUser]
    @Name nvarchar(100),
    @IsActive bit = 1,
    @NewId int OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [dbo].[Users] ([Name], [IsActive]) VALUES (@Name, @IsActive);
    SET @NewId = SCOPE_IDENTITY();
    RETURN 0;
END</pre> | <pre>RETURN 0 rewritten or warned</pre> | <pre>-- ─── PROCEDURE→FUNCTION: usp_insertuser ───────────────────────────────
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

    INSERT INTO public.&quot;Users&quot; (Name, IsActive) VALUES (Name, IsActive);
    NewId := lastval();
    RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_o
... &lt;truncated&gt;</pre> | PASS | High | Warn/rewrite SQL Server stored procedure return code semantics. |
| ID-013 | STORED PROCEDURE | Dynamic SQL warning | <pre>CREATE PROCEDURE [dbo].[usp_Dynamic]
    @TableName nvarchar(100)
AS
BEGIN
    DECLARE @sql nvarchar(max);
    SET @sql = N&#39;SELECT TOP 1 * FROM &#39; + @TableName;
    EXEC sp_executesql @sql;
END</pre> | <pre>TODO/WARNING for dynamic SQL</pre> | <pre>-- ─── PROCEDURE→FUNCTION: usp_dynamic ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.usp_dynamic();
CREATE OR REPLACE FUNCTION public.usp_dynamic(
) RETURNS SETOF record
AS $functio
... &lt;truncated&gt;</pre> | PASS | High | Emit warning for dynamic SQL conversion. |
| ID-014 | STORED PROCEDURE | TOP warning | <pre>CREATE PROCEDURE [dbo].[usp_Dynamic]
    @TableName nvarchar(100)
AS
BEGIN
    DECLARE @sql nvarchar(max);
    SET @sql = N&#39;SELECT TOP 1 * FROM &#39; + @TableName;
    EXEC sp_executesql @sql;
END</pre> | <pre>TOP converted to LIMIT or warned</pre> | <pre>-- ─── PROCEDURE→FUNCTION: usp_dynamic ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.usp_dynamic();
CREATE OR REPLACE FUNCTION public.usp_dynamic(
) RETURNS SETOF record
AS $functio
... &lt;truncated&gt;</pre> | PASS | Medium | Convert TOP to LIMIT or emit warning. |
| ID-015 | FUNCTION | Scalar signature and return type | <pre>CREATE FUNCTION [dbo].[fn_UserLabel](@Name nvarchar(100), @IsActive bit)
RETURNS nvarchar(200)
AS
BEGIN
    RETURN ISNULL(@Name, N&#39;&#39;) + CASE WHEN @IsActive = 1 THEN N&#39; Active&#39; ELSE N&#39; Inactive&#39; END;
END</pre> | <pre>name varchar, isactive boolean; RETURNS character varying</pre> | <pre>-- ─── FUNCTION: fn_userlabel ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_userlabel(character varying, boolean);
CREATE OR REPLACE FUNCTION public.fn_userlabel(
    name character varying,
    isactive boolean
) RETURNS character varying
AS $function$
BEGIN

    RETURN COALESCE(Name, &#39;&#39;) || CASE WHEN IsActive = TRUE THEN &#39; Active&#39; ELSE &#39; Inactive&#39; END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | Critical | Preserve every scalar-function parameter and MSSQL return type. |
| ID-016 | FUNCTION | Scalar body mapping | <pre>CREATE FUNCTION [dbo].[fn_UserLabel](@Name nvarchar(100), @IsActive bit)
RETURNS nvarchar(200)
AS
BEGIN
    RETURN ISNULL(@Name, N&#39;&#39;) + CASE WHEN @IsActive = 1 THEN N&#39; Active&#39; ELSE N&#39; Inactive&#39; END;
END</pre> | <pre>COALESCE(...) and PostgreSQL || concatenation</pre> | <pre>-- ─── FUNCTION: fn_userlabel ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_userlabel(character varying, boolean);
CREATE OR REPLACE FUNCTION public.fn_userlabel(
    name character varying,
    isactive boolean
) RETURNS character varying
AS $function$
BEGIN

    RETURN COALESCE(Name, &#39;&#39;) || CASE WHEN IsActive = TRUE THEN &#39; Active&#39; ELSE &#39; Inactive&#39; END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | Medium | Map ISNULL and string concatenation to executable PostgreSQL syntax. |
| ID-017 | FUNCTION | TVF parameter preserved | <pre>CREATE FUNCTION [dbo].[fn_UserOrders](@UserId int)
RETURNS @Result TABLE ([OrderId] int, [Amount] decimal(18,2))
AS
BEGIN
    INSERT INTO @Result SELECT [OrderId], [Amount] FROM [dbo].[Orders] WHERE [UserId] = @UserId;
    RETURN;
END</pre> | <pre>userid integer parameter</pre> | <pre>-- ─── FUNCTION: fn_userorders ───────────────────────────────
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

    RETURN QUERY SELECT OrderId, Amount FROM public.&quot;Orders&quot; WHERE UserId = fn_userorders.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | Critical | Preserve TVF parameters. |
| ID-018 | FUNCTION | TVF return table and body | <pre>CREATE FUNCTION [dbo].[fn_UserOrders](@UserId int)
RETURNS @Result TABLE ([OrderId] int, [Amount] decimal(18,2))
AS
BEGIN
    INSERT INTO @Result SELECT [OrderId], [Amount] FROM [dbo].[Orders] WHERE [UserId] = @UserId;
    RETURN;
END</pre> | <pre>Typed RETURNS TABLE and RETURN QUERY against public.&quot;Orders&quot;</pre> | <pre>-- ─── FUNCTION: fn_userorders ───────────────────────────────
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

    RETURN QUERY SELECT OrderId, Amount FROM public.&quot;Orders&quot; WHERE UserId = fn_userorders.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.</pre> | PASS | Critical | Parse declared TVF types and return rows without a SQL Server table variable. |
| ID-019 | INDEX | Normal index | <pre>CREATE INDEX [IX_Users_Name] ON [dbo].[Users] ([Name])</pre> | <pre>CREATE INDEX ix_users_name</pre> | <pre>-- ─── INDEX: ix_users_name ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = &#39;public&#39; AND indexname = &#39;ix_users_name&#39;) THEN
        CREATE INDEX ix_users_name ON public.&quot;Users&quot; (Name);
    END IF;
END;
$$;</pre> | PASS | High | Convert normal indexes. |
| ID-020 | INDEX | Unique index | <pre>CREATE UNIQUE INDEX [UX_Users_Guid] ON [dbo].[Users] ([Guid])</pre> | <pre>CREATE UNIQUE INDEX ux_users_guid</pre> | <pre>-- ─── INDEX: ux_users_guid ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = &#39;public&#39; AND indexname = &#39;ux_users_guid&#39;) THEN
        CREATE UNIQUE INDEX ux_users_guid ON public.&quot;Users&quot; (Guid);
    END IF;
END;
$$;</pre> | PASS | High | Preserve UNIQUE indexes. |
| ID-021 | INDEX | Composite index | <pre>CREATE NONCLUSTERED INDEX [IX_Orders_User_Amount] ON [dbo].[Orders] ([UserId], [Amount] DESC)</pre> | <pre>UserId, Amount</pre> | <pre>-- ─── INDEX: ix_orders_user_amount ON Orders ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = &#39;public&#39; AND indexname = &#39;ix_orders_user_amount&#39;) THEN
        CREATE INDEX ix_orders_user_amount ON public.&quot;Orders&quot; (UserId, Amount);
    END IF;
END;
$$;</pre> | PASS | High | Preserve composite index columns. |
| ID-022 | INDEX | Filtered index | <pre>CREATE INDEX [IX_Users_Active] ON [dbo].[Users] ([IsActive]) WHERE [IsActive] = 1</pre> | <pre>partial index WHERE or TODO/WARNING</pre> | <pre>-- ─── INDEX: ix_users_active ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = &#39;public&#39; AND indexname = &#39;ix_users_active&#39;) THEN
        CREATE INDEX ix_users_active ON public.&quot;Users&quot; (IsActive) WHERE IsActive = 1;
    END IF;
END;
$$;</pre> | PASS | High | Convert filtered index to partial index or warn. |
| ID-023 | INDEX | Included columns | <pre>CREATE NONCLUSTERED INDEX [IX_Orders_User_Include] ON [dbo].[Orders] ([UserId]) INCLUDE ([Amount])</pre> | <pre>INCLUDE or TODO/WARNING</pre> | <pre>-- ─── INDEX: ix_orders_user_include ON Orders ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = &#39;public&#39; AND indexname = &#39;ix_orders_user_include&#39;) THEN
        CREATE INDEX ix_orders_user_include ON public.&quot;Orders&quot; (UserId);
    END IF;
END;
$$;</pre> | PASS | High | Preserve INCLUDE columns or warn. |
| ID-024 | INDEX | Clustered index semantics | <pre>CREATE CLUSTERED INDEX [CX_Users_Tenant] ON [dbo].[Users] ([TenantId])</pre> | <pre>TODO/WARNING for clustered index</pre> | <pre>-- ─── INDEX: cx_users_tenant ON Users ─────────────────────
-- TODO: SQL Server CLUSTERED index detected. PostgreSQL does not maintain clustered indexes the same way. Manual review required.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = &#39;public&#39; AND indexname = &#39;cx_users_tenant&#39;) THEN
        CREATE INDEX cx_users_tenant ON public.&quot;Users&quot; (TenantId);
    END IF;
END;
$$;</pre> | PASS | High | Warn because SQL Server clustered index semantics differ in PostgreSQL. |
| ID-025 | BASIC SYNTAX | No square bracket syntax remains | <pre>Generated output</pre> | <pre>No [dbo] or [Name] syntax</pre> | <pre>-- ─── TABLE: Users ───────────────────────────────────
-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.
CREATE TABLE IF NOT EXISTS public.&quot;Users&quot; (
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
CREATE TABLE IF NOT EXISTS public.&quot;Orders&quot; (
Order
... &lt;truncated&gt;</pre> | PASS | Critical | Remove or quote SQL Server bracket identifiers. |
| ID-026 | BASIC SYNTAX | No batch/session syntax remains | <pre>Generated output</pre> | <pre>No GO/SET ANSI_NULLS/SET QUOTED_IDENTIFIER/SET NOCOUNT</pre> | <pre>-- ─── TABLE: Users ───────────────────────────────────
-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.
CREATE TABLE IF NOT EXISTS public.&quot;Users&quot; (
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
CREATE TABLE IF NOT EXISTS public.&quot;Orders&quot; (
Order
... &lt;truncated&gt;</pre> | PASS | High | Strip MSSQL-only batch/session statements. |
| ID-027 | WARNING VALIDATION | Unsupported features are not silent | <pre>Dynamic SQL, TOP, filtered index, included columns, clustered index</pre> | <pre>Each unsupported/partial feature has TODO/WARNING or equivalent converted syntax</pre> | <pre>-- ─── PROCEDURE→FUNCTION: usp_dynamic ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.usp_dynamic();
CREATE OR REPLACE FUNCTION public.usp_dynamic(
) RETURNS SETOF record
AS $functio
... &lt;truncated&gt;</pre> | PASS | Critical | Emit clear warnings for every unsupported or partial conversion. |
