-- ─── INDEX: ix_users_active ON Users ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ix_users_active') THEN
        CREATE INDEX ix_users_active ON public."Users" (IsActive);
    END IF;
END;
$$;
