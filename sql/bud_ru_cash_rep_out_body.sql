/* Formatted on 31.01.2014 10:03:38 (QP5 v5.227.12220.39724) */
  SELECT stp.id st,
         SUM (b.plan) plan,
         SUM (b.fakt) fakt,
         SUM (b.zd_fakt) zd_fakt,
         stp.name,
         stp.sort,
         COUNT (*) c
    FROM bud_ru_st_ras st, bud_ru_st_ras stp, bud_ru_cash_out_body b
   WHERE     b.st = st.id
         AND b.head_id = :id
         AND st.parent <> 0
         AND st.parent = stp.id
         /*:st_ras*/
         /*:kat*/
         AND st.dpt_id = :dpt_id
         AND stp.dpt_id = :dpt_id
GROUP BY stp.name, stp.sort, stp.id
ORDER BY stp.sort