/* Formatted on 25/07/2014 15:39:21 (QP5 v5.227.12220.39724) */
SELECT SUM (selected)
  FROM (  SELECT x.tab_number,
                 st.fio fio_ts,
                 x.eta,
                 x.tp_name,
                 x.address,
                 x.tp_kod,
                 DECODE (tp.tp_kod, NULL, NULL, 1) selected,
                 NVL (tp.contact_lpr, x.contact_lpr) contact_lpr
            FROM a1407nto_tp_select tp,
                 (SELECT DISTINCT
                         tp_kod,
                         tab_number,
                         eta,
                         tp_name,
                         address,
                         TRIM (contact_tel || ' ' || contact_fio) contact_lpr,
                         d.dpt_id
                    FROM routes r, departments d
                   WHERE d.manufak = r.country AND d.dpt_id = :dpt_id) x,
                 user_list st
           WHERE     x.tab_number = st.tab_num
                 AND (   st.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND x.tp_kod = tp.tp_kod(+)
                 AND st.dpt_id = :dpt_id
        ORDER BY st.fio,
                 x.eta,
                 x.tp_name,
                 x.address)