/* Formatted on 09.06.2012 12:52:24 (QP5 v5.163.1008.3004) */
  SELECT SUM (msb.weight) weight,
         SUM (msr.remain) remain,
         SUM (msr.oos) oos,
         SUM (msr.gos) gos,
         SUM (msr.fcount) fcount,
         SUM (msr.price) price
    FROM merch_spec_body msb,
         (SELECT *
            FROM merch_spec_report
           WHERE dt = TO_DATE (:dt, 'dd/mm/yyyy')) msr
   WHERE msb.head_id = :head_id AND msb.id = msr.spec_id(+)
ORDER BY msb.sort