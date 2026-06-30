-- ─── TABLE: DMake_Auth_Depart ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."DMake_Auth_Depart" (
    DepartNo integer NOT NULL,
    BoardNo integer NOT NULL,
    IsRead boolean,
    IsWrite boolean,
    IsDelete boolean,
    PRIMARY KEY (DepartNo, BoardNo)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
