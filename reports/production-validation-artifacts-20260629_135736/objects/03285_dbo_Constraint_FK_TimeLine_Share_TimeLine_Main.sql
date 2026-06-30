-- ─── FK: fk_timeline_share_timeline_main ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_timeline_share_timeline_main' AND contype = 'f') THEN
        ALTER TABLE public."TimeLine_Share" ADD CONSTRAINT fk_timeline_share_timeline_main
            FOREIGN KEY (Seq) REFERENCES public."TimeLine_Main" (Seq);
    END IF;
END;
$$;
