/* Formatted on 18.07.2012 11:00:56 (QP5 v5.163.1008.3004) */
  SELECT a4p1.tab_num,
         st.fio fio_ts,
         a4p1.fio_eta,
         a4p1.tp_ur,
         a4p1.tp_addr,
         a4p1.tp_kod,
         a7p1tps.selected,
         NVL (a7p1tps.contact_lpr,
              (SELECT TRIM (contact_tel || ' ' || contact_fio)
                 FROM routes
                WHERE tp_kod = a4p1.tp_kod AND ROWNUM = 1))
            contact_lpr,
         /*a7p1tps.tp_kat,*/
         SUM (
            CASE
               WHEN TRUNC (a4p1.data, 'mm') =
                       TO_DATE ('01.09.2012', 'dd.mm.yyyy')
               THEN
                  a4p1.summa
               ELSE
                  0
            END)
            sales9,
         SUM (
            CASE
               WHEN TRUNC (a4p1.data, 'mm') =
                       TO_DATE ('01.10.2012', 'dd.mm.yyyy')
               THEN
                  a4p1.summa
               ELSE
                  0
            END)
            sales10
    FROM a7p1_tp_select a7p1tps, a4p1, user_list st
   WHERE     a4p1.tab_num = st.tab_num
         AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
         AND a4p1.tp_kod = a7p1tps.tp_kod(+)
         AND st.dpt_id = :dpt_id
GROUP BY a4p1.tab_num,
         st.fio,
         a4p1.fio_eta,
         a4p1.tp_ur,
         a4p1.tp_addr,
         a4p1.tp_kod,
         a7p1tps.selected,
         a7p1tps.contact_lpr/*,
         a7p1tps.tp_kat*/
ORDER BY st.fio,
         a4p1.fio_eta,
         a4p1.tp_ur,
         a4p1.tp_addr