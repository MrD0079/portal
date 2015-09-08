/* Formatted on 11.11.2013 14:46:40 (QP5 v5.227.12220.39724) */
  SELECT st.id kat_id,
         st.name kat_name,
         st.sort kat_sort,
         b.plan,
         b.fakt,
         b.text,
         b.zd_fakt,
         b.zd_text,
         b.id,
         stp.id st_id,
         stp.name st_name,
         stp.sort st_sort
    FROM bud_ru_st_ras st, bud_ru_st_ras stp, bud_ru_cash_out_body b
   WHERE     b.st = st.id
         AND b.head_id = :id
         AND st.parent <> 0
         AND st.parent = stp.id
         AND st.dpt_id = :dpt_id
         AND stp.dpt_id = :dpt_id
ORDER BY stp.sort, st.sort