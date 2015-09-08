/* Formatted on 23.07.2012 15:04:14 (QP5 v5.163.1008.3004) */
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
         d.qtysku,
         CASE WHEN d.summnds_pg >= 250 AND d.qtysku >= 3 THEN 1 END action_nakl,
         DECODE (an.nakl, NULL, 0, 1) selected,
         an.ok_traid,
         an.ok_ts,
         an.ok_chief,
         an.bonus,
         an.text,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         ts.contact_lpr,
         st.tn,
         TO_CHAR (an.ok_ts_date, 'dd.mm.yyyy') ok_ts_date
    FROM hot_july d,
         hot_july_action_nakl an,
         user_list st,
         hot_july_tp_select ts
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
         /*         AND DECODE (:tp, 0, d.tp_kod, :tp) = d.tp_kod
                  AND DECODE (:tp, 0, d.nakl, 0) = DECODE (:tp, 0, an.nakl, 0)*/
         AND d.tp_kod = an.tp_kod                                      /*(+)*/
         AND d.nakl = an.nakl                                          /*(+)*/
         AND d.tp_kod = ts.tp_kod
         AND d.data BETWEEN TO_DATE ('09.07.2012', 'dd.mm.yyyy')
                        AND TO_DATE ('31.07.2012', 'dd.mm.yyyy')
         AND an.ok_traid = 1
         AND DECODE (:ok_ts,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_ts, 1, 0, NVL (an.ok_ts, 0))
         AND DECODE (:ok_chief,  1, 0,  2, 1,  3, 0) =
                DECODE (:ok_chief, 1, 0, NVL (an.ok_chief, 0))
ORDER BY st.fio,
         d.fio_eta,
         d.tp_ur,
         d.tp_addr,
         d.data,
         d.nakl