/* Formatted on 31.01.2014 10:03:08 (QP5 v5.227.12220.39724) */
  SELECT st.id st,
         st.name,
         b.plan,
         b.fakt,
         b.text,
         b.id
    FROM bud_ru_st_pri st, bud_ru_cash_in_body b
   WHERE b.st = st.id                                              /*:st_pri*/
                     AND b.head_id = :id AND st.dpt_id = :dpt_id
ORDER BY st.sort