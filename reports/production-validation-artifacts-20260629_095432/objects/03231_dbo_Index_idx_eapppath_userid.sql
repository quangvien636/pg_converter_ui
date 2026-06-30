-- ─── INDEX: idx_eapppath_userid ON EAPPPath ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eapppath_userid') THEN
        CREATE INDEX idx_eapppath_userid ON public."EAPPPath" (UserID);
    END IF;
END;
$$;
