/* Formatted on 18.10.2012 10:12:38 (QP5 v5.163.1008.3004) */
  SELECT z.*,
         DECODE (SIGN (DECODE (sales7, 0, 0, sales8 / sales7 * 100 - 100)),
                 1, DECODE (sales7, 0, 0, sales8 / sales7 * 100 - 100),
                 0)
            rost_perc,
         DECODE (SIGN (sales8 - sales7), 1, sales8 - sales7, 0) rost_uah,
         DECODE (SIGN (sales8 - sales7), 1, sales8 - sales7, 0) * 0.2
            bonus_plan
    FROM (  SELECT truf_oct.tab_num,
                   st.fio fio_ts,
                   truf_oct.fio_eta,
                   truf_oct.tp_ur,
                   truf_oct.tp_addr,
                   truf_oct.tp_kod,
                   truf_octtps.selected2,
                   NVL (truf_octtps.contact_lpr,
                        (SELECT TRIM (contact_tel || ' ' || contact_fio)
                           FROM routes
                          WHERE tp_kod = truf_oct.tp_kod AND ROWNUM = 1))
                      contact_lpr,
                   /*truf_octtps.tp_kat,*/
                   SUM (
                      CASE
                         WHEN TRUNC (truf_oct.data, 'mm') =
                                 TO_DATE ('01.09.2012', 'dd.mm.yyyy')
                         THEN
                            truf_oct.summa
                         ELSE
                            0
                      END)
                      sales7,
                   SUM (
                      CASE
                         WHEN TRUNC (truf_oct.data, 'mm') =
                                 TO_DATE ('01.10.2012', 'dd.mm.yyyy')
                         THEN
                            truf_oct.summa
                         ELSE
                            0
                      END)
                      sales8,
                   truf_octtps.fakt_bonus,


         truf_octtps.ok_traid,
         truf_octtps.text_traid,
         truf_octtps.ok_ts,
         truf_octtps.ok_chief,
         fn_getname (
                      (SELECT parent
                         FROM parents
                        WHERE tn = st.tn))
            parent_fio,
         (SELECT parent
            FROM parents
           WHERE tn = st.tn)
            parent_tn,
         TO_CHAR (truf_octtps.ok_ts_date, 'dd.mm.yyyy hh24:mi:ss') ok_ts_date




,st.tn



              FROM truf_oct_tp_select truf_octtps,
                   a4p1 truf_oct,
                   user_list st,
                   a4p1_10_action_nakl an4,
                   a7p1_10_action_nakl an7
             WHERE     truf_oct.tab_num = st.tab_num
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
                   AND truf_oct.tp_kod = truf_octtps.tp_kod(+)
                   AND st.dpt_id = :dpt_id
                   AND selected = 1
                   AND DECODE (:pt,  1, 0,  2, 1,  3, 0) =
                          DECODE (:pt,
                                  1, 0,
                                  NVL (selected2, 0), 3,
                                  NVL (selected2, 0))
                   AND DECODE (:eta_list, '', truf_oct.fio_eta, :eta_list) =
                          truf_oct.fio_eta
                   AND truf_oct.nakl = an4.nakl(+)
                   AND truf_oct.nakl = an7.nakl(+)
                   AND truf_oct.tp_kod = an4.tp_kod(+)
                   AND truf_oct.tp_kod = an7.tp_kod(+)
                   AND an4.nakl IS NULL
                   AND an7.nakl IS NULL
                   AND an4.tp_kod IS NULL
                   AND an7.tp_kod IS NULL









AND truf_octtps.selected2=1
                   AND DECODE (:ok_traid,  1, 0,  2, 1, 3,0) =
                          DECODE (:ok_traid,
                                  1, 0,
                                  2, truf_octtps.ok_traid,
                                  3, nvl(truf_octtps.ok_traid,0)
                                  )

          GROUP BY truf_oct.tab_num,
                   st.fio,
                   truf_oct.fio_eta,
                   truf_oct.tp_ur,
                   truf_oct.tp_addr,
                   truf_oct.tp_kod,
                   truf_octtps.selected,
                   truf_octtps.selected2,
                   truf_octtps.contact_lpr,
                   truf_octtps.fakt_bonus,
                   truf_octtps.ok_traid,
                   truf_octtps.text_traid,
                   truf_octtps.ok_ts,
                   truf_octtps.ok_chief,
                   truf_octtps.ok_ts_date,
                   st.tn
          ORDER BY st.fio,
                   truf_oct.fio_eta,
                   truf_oct.tp_ur,
                   truf_oct.tp_addr) z
ORDER BY fio_ts,
         fio_eta,
         tp_ur,
         tp_addr