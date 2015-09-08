/* Formatted on 23.07.2012 15:10:03 (QP5 v5.163.1008.3004) */
  SELECT z.*,
         DECODE (SIGN (DECODE (sales6, 0, 0, sales7 / sales6 * 100 - 100)),
                 1, DECODE (sales6, 0, 0, sales7 / sales6 * 100 - 100),
                 0)
            rost_perc,
         DECODE (SIGN (sales7 - sales6), 1, sales7 - sales6, 0) rost_uah,
         DECODE (SIGN (sales7 - sales6), 1, sales7 - sales6, 0) * 0.15
            bonus_plan
    FROM (  SELECT hot_july.tab_num,
                   st.fio fio_ts,
                   hot_july.fio_eta,
                   hot_july.tp_ur,
                   hot_july.tp_addr,
                   hot_july.tp_kod,
                   hot_julytps.selected2,
                   hot_julytps.ok_traid,
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
                   fn_getname (
                                (SELECT parent
                                   FROM parents
                                  WHERE tn = st.tn))
                      parent_fio,
                   (SELECT parent
                      FROM parents
                     WHERE tn = st.tn)
                      parent_tn,
                   st.tn,
                   TO_CHAR (hot_julytps.ok_ts_date, 'dd.mm.yyyy') ok_ts_date,
                   hot_julytps.ok_ts,
                   hot_julytps.ok_chief,
                   hot_julytps.fakt_bonus
              FROM hot_july_tp_select hot_julytps,
                   hot_july,
                   user_list st,
                   hot_july_action_nakl an
             WHERE hot_july.tab_num = st.tab_num
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
                   AND hot_julytps.ok_traid = 1
                   AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) =
                          DECODE (:ok_ts, 1, 0, NVL (hot_julytps.ok_ts, 0))
                   AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
                          DECODE (:ok_chief, 1, 0, NVL (hot_julytps.ok_chief, 0))
          GROUP BY hot_july.tab_num,
                   st.fio,
                   hot_july.fio_eta,
                   hot_july.tp_ur,
                   hot_july.tp_addr,
                   hot_july.tp_kod,
                   hot_julytps.selected,
                   hot_julytps.selected2,
                   hot_julytps.ok_traid,
                   hot_julytps.contact_lpr,
                   st.tn,
                   hot_julytps.ok_ts_date,
                   hot_julytps.ok_ts,
                   hot_julytps.ok_chief,
                   hot_julytps.fakt_bonus
          ORDER BY st.fio,
                   hot_july.fio_eta,
                   hot_july.tp_ur,
                   hot_july.tp_addr,
                   st.tn) z
ORDER BY fio_ts,
         fio_eta,
         tp_ur,
         tp_addr