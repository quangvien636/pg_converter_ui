# Runtime test dependency check

Status: `NEED VERIFICATION`.

Required order: schemas/types/sequences → tables → PK/unique/check → FK/index →
helper functions → views → converted routines → triggers → seed/reference data.

Runtime catalog objects observed: 2001. Constraint, trigger, and
seed-data dependency edges are not yet fully reconstructed by the catalog exporter.