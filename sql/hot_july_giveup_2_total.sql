/* Formatted on 23.07.2012 15:10:32 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c1,
       SUM (NVL (selected2, 0)) selected2,
       SUM (sales6) sales6,
       SUM (sales7) sales7,
       SUM (fakt_bonus) fakt_bonus,
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
       SUM (NVL (ok_traid, 0)) ok_traid,
       SUM (NVL (ok_ts, 0)) ok_ts,
       SUM (NVL (ok_chief, 0)) ok_chief
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