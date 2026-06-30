-- ─── INDEX: ux_users_guid ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ux_users_guid') THEN
        CREATE UNIQUE INDEX ux_users_guid ON public."Users" (Guid);
    END IF;
END;
$$;
