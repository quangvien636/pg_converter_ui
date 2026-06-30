-- ─── INDEX: idx_eappprogress_arrivestate_representidaccesstype ON EAPPProgress ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_eappprogress_arrivestate_representidaccesstype') THEN
        CREATE INDEX idx_eappprogress_arrivestate_representidaccesstype ON public."EAPPProgress" (ArriveState, RepresentID, AccessType);
    END IF;
END;
$$;
