/* Formatted on 27.10.2014 21:58:33 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT pb.tab_num,
                 st.fio fio_ts,
                 pb.fio_eta,
                 pb.tp_name,
                 pb.tp_kod,
                 DECODE (tp.tp_kod, NULL, NULL, 1) selected,
                 NVL (tp.contact_lpr,
                      (SELECT TRIM (contact_tel || ' ' || contact_fio)
                         FROM routes
                        WHERE tp_kod = pb.tp_kod AND ROWNUM = 1))
                    contact_lpr
            FROM a14ss_tp_select tp, a14ss_pb pb, user_list st
           WHERE     pb.tab_num = st.tab_num
         AND (   st.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
                 AND pb.tp_kod = tp.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        /*AND tp.m(+) = :month*/
        GROUP BY pb.tab_num,
                 st.fio,
                 pb.fio_eta,
                 pb.tp_name,
                 pb.tp_kod,
                 tp.contact_lpr,
                 DECODE (tp.tp_kod, NULL, NULL, 1)
        ORDER BY st.fio, pb.fio_eta, pb.tp_name)