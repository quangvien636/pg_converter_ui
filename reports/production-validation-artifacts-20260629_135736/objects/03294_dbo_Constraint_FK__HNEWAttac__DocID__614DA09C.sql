-- ─── FK: fk__hnewattac__docid__614da09c ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__hnewattac__docid__614da09c' AND contype = 'f') THEN
        ALTER TABLE public."HNEWAttached" ADD CONSTRAINT fk__hnewattac__docid__614da09c
            FOREIGN KEY (DocID) REFERENCES public."HNEWMaster" (DocID);
    END IF;
END;
$$;
