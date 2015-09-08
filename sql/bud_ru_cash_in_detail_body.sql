/* Formatted on 25/10/2013 13:44:24 (QP5 v5.227.12220.39724) */
  SELECT st.id st,
         st.name,
         b.plan,
         b.fakt,
         b.text,
         b.id
    FROM bud_ru_st_pri st, bud_ru_cash_in_body b
   WHERE b.st = st.id AND b.head_id = :id
ORDER BY st.sort