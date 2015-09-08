/* Formatted on 26/11/2014 17:27:29 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT a1502kfk.tab_num,
                 st.fio fio_ts,
                 a1502kfk.fio_eta,
                 a1502kfk.tp_ur,
                 a1502kfk.tp_addr,
                 a1502kfk.tp_kod,
                 DECODE (a1502kfktps.tp_kod, NULL, NULL, 1) selected,
                 NVL (a1502kfktps.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = a1502kfk.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a1502kfk_tp_select a1502kfktps, a1502kfk, user_list st
           WHERE     a1502kfk.tab_num = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND a1502kfk.tp_kod = a1502kfktps.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        GROUP BY a1502kfk.tab_num,
                 st.fio,
                 a1502kfk.fio_eta,
                 a1502kfk.tp_ur,
                 a1502kfk.tp_addr,
                 a1502kfk.tp_kod,
                 a1502kfktps.contact_lpr,
                 DECODE (a1502kfktps.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, a1502kfk.fio_eta, a1502kfk.tp_ur)