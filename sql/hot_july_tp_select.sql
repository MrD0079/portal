/* Formatted on 18.07.2012 11:00:56 (QP5 v5.163.1008.3004) */
  SELECT hot_july.tab_num,
         st.fio fio_ts,
         hot_july.fio_eta,
         hot_july.tp_ur,
         hot_july.tp_addr,
         hot_july.tp_kod,
         hot_julytps.selected,
         NVL (hot_julytps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = hot_july.tp_kod AND ROWNUM = 1))
            contact_lpr,
         /*hot_julytps.tp_kat,*/
         SUM (
            CASE
               WHEN TRUNC (hot_july.data, 'mm') =
                       TO_DATE ('01.06.2012', 'dd.mm.yyyy')
               THEN
                  hot_july.summa
               ELSE
                  0
            END)
            sales6,
         SUM (
            CASE
               WHEN TRUNC (hot_july.data, 'mm') =
                       TO_DATE ('01.07.2012', 'dd.mm.yyyy')
               THEN
                  hot_july.summa
               ELSE
                  0
            END)
            sales7
    FROM hot_july_tp_select hot_julytps, hot_july, user_list st
   WHERE     hot_july.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND hot_july.tp_kod = hot_julytps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY hot_july.tab_num,
         st.fio,
         hot_july.fio_eta,
         hot_july.tp_ur,
         hot_july.tp_addr,
         hot_july.tp_kod,
         hot_julytps.selected,
         hot_julytps.contact_lpr/*,
         hot_julytps.tp_kat*/
ORDER BY st.fio,
         hot_july.fio_eta,
         hot_july.tp_ur,
         hot_july.tp_addr