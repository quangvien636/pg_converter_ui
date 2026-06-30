-- ─── INDEX: idx_eapphistory_htype_targetid_actorid ON EAPPHistory ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = 'idx_eapphistory_htype_targetid_actorid') THEN
        CREATE INDEX idx_eapphistory_htype_targetid_actorid ON public."EAPPHistory" (HType, TargetID, ActorID);
    END IF;
END;
$$;
