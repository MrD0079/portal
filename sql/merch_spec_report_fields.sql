/* Formatted on 16.01.2013 11:42:41 (QP5 v5.163.1008.3004) */
  SELECT f.*
    FROM merch_spec_fields f,
         (SELECT *
            FROM merch_spec_fld_ag
           WHERE ag_id = :ag_id) a
   WHERE f.id = a.field_id
ORDER BY f.name