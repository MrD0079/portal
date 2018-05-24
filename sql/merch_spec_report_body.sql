/* Formatted on 09.06.2012 12:50:21 (QP5 v5.163.1008.3004) */
  SELECT msb.id,
         msb.sort,
         msb.art,
         msb.name,
         msb.brand,
         msb.izm,
         msb.weight,
         msb.kod,
         msr.remain,
         msr.oos,
         msr.gos,
         msr.fcount,
         msr.price,
         msr.text
    FROM merch_spec_body msb,
         (SELECT *
            FROM merch_spec_report
           WHERE dt = TO_DATE (:dt, 'dd/mm/yyyy')) msr
   WHERE msb.head_id = :head_id AND msb.id = msr.spec_id(+)
ORDER BY msb.sort