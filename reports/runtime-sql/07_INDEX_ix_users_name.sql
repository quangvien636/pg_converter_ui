-- ─── INDEX: ix_users_name ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ix_users_name') THEN
        CREATE INDEX ix_users_name ON public."Users" (Name);
    END IF;
END;
$$;
