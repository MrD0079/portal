/* Formatted on 04/09/2015 15:49:46 (QP5 v5.227.12220.39724) */
  SELECT u.fio fio_ts,
         u.pos_name,
         a.*,
         TO_CHAR (a.dt, 'dd.mm.yyyy') dt
    FROM P_ACTIVITY a, user_list u
   WHERE     a.tab_num = u.tab_num
         AND u.dpt_id = :dpt_id
         AND TRUNC (dt, 'mm') = TRUNC (TO_DATE (:sd, 'dd.mm.yyyy'), 'mm')
         AND (    u.tn IN
                     (SELECT slave
                        FROM full
                       WHERE     master = :tn
                             AND full =
                                    DECODE (:fw_flt,
                                            1, -2,
                                            2, 1,
                                            3, 0,
                                            4, full))
              AND u.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn))
         AND DECODE (:pos, 0, 0, :pos) = DECODE (:pos, 0, 0, u.pos_id)
ORDER BY a.dt,
         u.fio,
         a.fio_eta,
         a.name