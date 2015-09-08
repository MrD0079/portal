/* Formatted on 10.12.2014 20:28:38 (QP5 v5.227.12220.39724) */
  SELECT cpp.tz_oblast,
         n.net_name,
         cpp.ur_tz_name,
         cpp.tz_address,
         cpp.kodtp,
         sbh.id,
         sbh.ok_ms,
         sbh.ok_kk,
         sbh.ok_ms_fio,
         TO_CHAR (sbh.ok_ms_lu, 'dd.mm.yyyy') ok_ms_lu,
         sbh.ok_kk_fio,
         TO_CHAR (sbh.ok_kk_lu, 'dd.mm.yyyy') ok_kk_lu
    FROM routes_head h,
         cpp,
         svms_oblast s,
         routes_tp rt,
         ms_nets n,
         (SELECT DISTINCT head_id, kodtp, day_num FROM routes_body1) rb,
         calendar c,
         (SELECT *
            FROM merch_report_sb_head
           WHERE dt = TO_DATE (:data, 'dd.mm.yyyy')) sbh
   WHERE     rb.head_id = sbh.head_id(+)
         AND rb.kodtp = sbh.kod_tp(+)
         AND h.id = :route
         AND s.tn = h.tn
         AND rt.head_id = h.id
         AND rb.head_id = h.id
         AND rb.kodtp = rt.kodtp
         AND cpp.kodtp = rt.kodtp
         AND cpp.tz_oblast = s.oblast
         AND n.id_net = cpp.id_net
         AND rb.day_num = c.dm
         AND TRUNC (c.data, 'mm') = h.data
         AND c.data = TO_DATE (:data, 'dd.mm.yyyy')
ORDER BY cpp.tz_oblast,
         n.net_name,
         cpp.ur_tz_name,
         cpp.tz_address,
         cpp.kodtp