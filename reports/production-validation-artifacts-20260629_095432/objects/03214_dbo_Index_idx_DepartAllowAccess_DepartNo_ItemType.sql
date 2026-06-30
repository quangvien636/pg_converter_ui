-- ─── INDEX: idx_departallowaccess_departno_itemtype ON Board_DepartAllowAccess ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_departallowaccess_departno_itemtype') THEN
        CREATE INDEX idx_departallowaccess_departno_itemtype ON public."Board_DepartAllowAccess" (DepartNo, ItemType);
    END IF;
END;
$$;
