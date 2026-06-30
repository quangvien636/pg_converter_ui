# Post-Commit QA Automation Report

**Date:** 2026-06-30 09:51:46  
**Target Commit:** 46e4b93dfa8157f5e982905f99592929c6d42ce9 (Fix CTE termination before RETURN QUERY and DML)

---

## 1. Validation Checklist Status
- [x] Build Release: **PASS**
- [x] NUnit Tests: **31 PASS / 0 FAIL**
- [x] Board% Procedures: **150 PASS / 12 FAIL**
- [x] Contact% Procedures: **118 PASS / 71 FAIL**

---

## 2. Comparison Metrics

| Metric Suite | Baseline PASS | Post-Commit PASS | Delta | Regressions | Status |
|--------------|---------------|------------------|-------|-------------|--------|
| **NUnit Tests** | 20 | 31 | 11 | 0 | PASS |
| **Board% Procs** | 140 | 150 | 10 | 0 | PASS |
| **Contact% Procs** | 107 | 118 | 11 | 0 | PASS |

---

## 3. Recommendation
**Proceed to next ROI rank.**

---

## 4. Run Details
* **Build Status:** PASS
* **Detected Regressions:**
  * NUnit: 0
  * Board%: 0
  * Contact%: 0