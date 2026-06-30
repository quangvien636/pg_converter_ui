-- ─── INDEX: idx_eappformdepart_formid ON EAPPFormDepart ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eappformdepart_formid') THEN
        CREATE INDEX idx_eappformdepart_formid ON public."EAPPFormDepart" (DepartID);
    END IF;
END;
$$;
