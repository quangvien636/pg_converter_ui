-- ─── INDEX: idx_eapphistory_targetid ON EAPPHistory ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eapphistory_targetid') THEN
        CREATE INDEX idx_eapphistory_targetid ON public."EAPPHistory" (TargetID);
    END IF;
END;
$$;
