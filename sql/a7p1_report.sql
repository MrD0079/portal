/* Formatted on 11.09.2012 16:14:04 (QP5 v5.163.1008.3004) */
  SELECT d.tab_num,
         st.fio fio_ts,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.tp_kod,
         d.nakl,
         TO_CHAR (d.data, 'dd.mm.yyyy') data,
         d.summa,
         d.summnds_pg,
         d.action_sum_ya,
         d.action_qt_ya,
         CASE
            WHEN d.action_qt_ya >= 7 AND d.action_sum_ya = 1 THEN 1
            /*WHEN d.oltype_id = 15 AND d.action_sum_ya >= 8 THEN 1*/
            ELSE 0
         END
            action_nakl,
         /*CASE
            WHEN d.oltype_id <> 15 THEN TRUNC (d.action_sum_ya / 4)
            WHEN d.oltype_id = 15 THEN TRUNC (d.action_sum_ya / 8)
            ELSE 0
         END
            max_ya,*/
         DECODE (an.nakl, NULL, 0, 1) selected,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         an.bonus,
         an.text,
         an.ya fakt_ya,
         an.text_traid,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         ts.contact_lpr,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         st.tn,
         TO_CHAR (an.ok_ts_date, 'dd.mm.yyyy') ok_ts_date
    FROM a4p1 d,
         a7p1_action_nakl an,
         user_list st,
         a7p1_tp_select ts
   WHERE d.tab_num = st.tab_num
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
         AND st.dpt_id = :dpt_id
         AND d.tp_kod = an.tp_kod
         AND d.nakl = an.nakl
         AND d.tp_kod = ts.tp_kod
         AND DECODE (:ok_traid,  1, 0,  2, 1) =
                DECODE (:ok_traid,
                        1, 0,
                        2, an.ok_traid)
         AND DECODE (:eta_list, '', d.fio_eta, :eta_list) = d.fio_eta
         and ts.selected=1
ORDER BY st.fio,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.data,
         d.nakl