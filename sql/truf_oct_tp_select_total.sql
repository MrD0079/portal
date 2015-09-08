/* Formatted on 19.07.2012 11:46:19 (QP5 v5.163.1008.3004) */
SELECT SUM (sales9) sales9, SUM (sales10) sales10, SUM (selected) selected
  FROM (  SELECT a4p1.tab_num,
                 st.fio fio_ts,
                 a4p1.fio_eta,
                 a4p1.tp_ur,
                 a4p1.tp_addr,
                 a4p1.tp_kod,
         truf_octtps.ok_traid,
                 truf_octtps.selected,
                 NVL (truf_octtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a4p1.tp_kod AND ROWNUM = 1))
                    contact_lpr,
                 /*truf_octtps.tp_kat,*/
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
            FROM truf_oct_tp_select truf_octtps, a4p1, user_list st
           WHERE     a4p1.tab_num = st.tab_num
                 AND st.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                 AND a4p1.tp_kod = truf_octtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a4p1.tab_num,
                 st.fio,
                 a4p1.fio_eta,
                 a4p1.tp_ur,
                 a4p1.tp_addr,
                 a4p1.tp_kod,
         truf_octtps.ok_traid,
                 truf_octtps.selected,
                 truf_octtps.contact_lpr)