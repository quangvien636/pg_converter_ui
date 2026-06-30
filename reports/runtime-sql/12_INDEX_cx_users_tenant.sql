-- ─── INDEX: cx_users_tenant ON Users ─────────────────────
-- TODO: SQL Server CLUSTERED index detected. PostgreSQL does not maintain clustered indexes the same way. Manual review required.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'cx_users_tenant') THEN
        CREATE INDEX cx_users_tenant ON public."Users" (TenantId);
    END IF;
END;
$$;
