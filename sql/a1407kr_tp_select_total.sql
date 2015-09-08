/* Formatted on 24.01.2014 16:38:04 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1407kr.tab_num,
                 st.fio fio_ts,
                 a1407kr.fio_eta,
                 a1407kr.tp_ur,
                 a1407kr.tp_addr,
                 a1407kr.tp_kod,
                 DECODE (a1407krtps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1407krtps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1407kr.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1407kr_tp_select a1407krtps, a1407kr, user_list st
           WHERE     a1407kr.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1407kr.tp_kod = a1407krtps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1407kr.tab_num,
                 st.fio,
                 a1407kr.fio_eta,
                 a1407kr.tp_ur,
                 a1407kr.tp_addr,
                 a1407kr.tp_kod,
                 a1407krtps.contact_lpr,
                 DECODE (a1407krtps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1407kr.fio_eta, a1407kr.tp_ur)