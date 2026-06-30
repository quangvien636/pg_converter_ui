-- ─── INDEX: ix_orders_user_include ON Orders ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ix_orders_user_include') THEN
        CREATE INDEX ix_orders_user_include ON public."Orders" (UserId);
    END IF;
END;
$$;
