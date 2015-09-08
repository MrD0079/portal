/* Formatted on 20.07.2012 11:42:19 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c1,
       SUM (NVL (selected2, 0)) selected2,
       SUM (sales6) sales6,
       SUM (sales7) sales7,
       DECODE (
          SIGN (
             DECODE (SUM (sales6),
                     0, 0,
                     SUM (sales7) / SUM (sales6) * 100 - 100)),
          1, DECODE (SUM (sales6),
                     0, 0,
                     SUM (sales7) / SUM (sales6) * 100 - 100),
          0)
          rost_perc,
       DECODE (SIGN (SUM (sales7) - SUM (sales6)),
               1, SUM (sales7) - SUM (sales6),
               0)
          rost_uah,
       DECODE (SIGN (SUM (sales7) - SUM (sales6)),
               1, SUM (sales7) - SUM (sales6),
               0)
       * 0.15
          bonus_plan,
       COUNT (DISTINCT tp_kod) tp_kod,
       SUM (NVL (ok_traid, 0)) ok_traid
  FROM (  SELECT hot_july.tab_num,
                 st.fio fio_ts,
                 hot_july.fio_eta,
                 hot_july.tp_ur,
                 hot_july.tp_addr,
                 hot_july.tp_kod,
                 hot_julytps.selected,
                 hot_julytps.selected2,
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
                    sales7,
                 hot_julytps.ok_traid
            FROM hot_july_tp_select hot_julytps,
                 hot_july,
                 user_list st,
                 hot_july_action_nakl an
           WHERE     hot_july.tab_num = st.tab_num
                 AND st.tn IN
                        (SELECT slave
                                 FROM full
                                WHERE master =
                                   DECODE (:exp_list_without_ts,
                                           0, :tn,
                                           :exp_list_without_ts))
                 AND st.tn IN
                        (SELECT slave
                                 FROM full
                                WHERE master =
                                   DECODE (:exp_list_only_ts,
                                           0, :tn,
                                           :exp_list_only_ts))
                 AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                 AND hot_july.tp_kod = hot_julytps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
                 AND selected = 1
                 AND hot_july.tp_kod = an.tp_kod(+)
                 AND hot_july.nakl = an.nakl(+)
                 AND an.nakl IS NULL
                 AND selected2 = 1





                 AND DECODE (:ok_traid,  1, 0,  2, 1,  3, 0) =
                        DECODE (:ok_traid,
                                1, 0,
                                2, hot_julytps.ok_traid,
                                3, NVL (hot_julytps.ok_traid, 0))



         AND DECODE (:eta_list, '', hot_july.fio_eta, :eta_list) = hot_july.fio_eta



        GROUP BY hot_july.tab_num,
                 st.fio,
                 hot_july.fio_eta,
                 hot_july.tp_ur,
                 hot_july.tp_addr,
                 hot_july.tp_kod,
                 hot_julytps.selected,
                 hot_julytps.selected2,
                 hot_julytps.contact_lpr,
                 hot_julytps.ok_traid
        ORDER BY st.fio,
                 hot_july.fio_eta,
                 hot_july.tp_ur,
                 hot_july.tp_addr) z