/* Formatted on 16.01.2013 11:42:59 (QP5 v5.163.1008.3004) */
  SELECT a.*, DECODE (ha.id, NULL, 0, 1) checked
    FROM merch_spec_fld_ag ha, MERCH_SPEC_FIELDS a
   WHERE hA.ag_ID(+) = :ag AND A.ID = HA.field_ID(+)
ORDER BY a.sort