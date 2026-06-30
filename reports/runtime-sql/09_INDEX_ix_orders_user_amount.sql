-- ─── INDEX: ix_orders_user_amount ON Orders ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'ix_orders_user_amount') THEN
        CREATE INDEX ix_orders_user_amount ON public."Orders" (UserId, Amount);
    END IF;
END;
$$;
