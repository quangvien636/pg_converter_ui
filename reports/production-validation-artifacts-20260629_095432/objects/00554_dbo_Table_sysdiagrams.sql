-- ─── TABLE: sysdiagrams ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."sysdiagrams" (
    name sysname NOT NULL,
    principal_id integer NOT NULL,
    diagram_id serial NOT NULL,
    version integer,
    definition bytea
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
