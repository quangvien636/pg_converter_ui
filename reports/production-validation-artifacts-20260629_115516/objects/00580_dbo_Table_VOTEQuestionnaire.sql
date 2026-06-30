-- ─── TABLE: VOTEQuestionnaire ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."VOTEQuestionnaire" (
    MasterID integer NOT NULL,
    No integer NOT NULL,
    Type character varying(2) NOT NULL,
    Name character varying(100) NOT NULL,
    PRIMARY KEY (MasterID, No, Type)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
