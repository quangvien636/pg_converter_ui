-- ─── INDEX: idx_roomno ON CrewChat_RoomUsers ─────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_roomno') THEN
        CREATE INDEX idx_roomno ON public."CrewChat_RoomUsers" (RoomNo);
    END IF;
END;
$$;
