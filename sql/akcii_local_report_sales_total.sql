/* Formatted on 09/04/2015 17:29:50 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c,
       SUM (summa) summa,
       SUM (selected) selected,
       SUM (bonus_sum) bonus_sum,
       DECODE (SUM (summa), 0, 0, SUM (bonus_sum) / SUM (summa) * 100) zat
  FROM (  SELECT s.tp_kod,
                 u.fio ts,
                 s.tab_num tab_number,
                 s.eta,
                 r.tp_name,
                 r.address,
                 r.tp_place,
                 r.tp_type,
                 r.contact_tel,
                 r.contact_fio,
                 s.h_eta,
                 r.country,
                 s.summa,
                 DECODE (t.tp_kod, NULL, NULL, 1) selected,
                 t.bonus_sum,
                 DECODE (NVL (summa, 0),
                         0, 0,
                         bonus_sum / NVL (summa, 0) * 100)
                    zat
            FROM (SELECT DISTINCT tp_kod,
                                  ts,
                                  tab_number,
                                  tp_name,
                                  address,
                                  tp_place,
                                  tp_type,
                                  contact_tel,
                                  contact_fio,
                                  country
                    FROM routes
                   WHERE routes.dpt_id = :dpt_id) r,
                 (SELECT m.tab_num,
                         m.tp_kod,
                         m.y,
                         m.m,
                         m.summa,
                         m.h_eta,
                         m.eta
                    FROM a14mega m, bud_ru_zay z, user_list u1
                   WHERE     m.dpt_id = :dpt_id
                         AND z.id = :z_id
                         AND TRUNC (z.dt_start, 'mm') = m.dt
                         AND u1.tab_num = m.tab_num
                         AND u1.tn IN (SELECT slave
                                         FROM full
                                        WHERE master = z.tn)) s,
                 user_list u,
                 akcii_local_tp t
           WHERE     s.tp_kod = t.tp_kod(+)
                 AND t.z_id(+) = :z_id
                 AND r.tp_kod(+) = s.tp_kod
                 /*AND r.tab_number(+) = s.tab_num*/
                 AND s.tab_num = u.tab_num
                 AND u.dpt_id = :dpt_id
                 /*AND u.datauvol IS NULL*/
                 AND u.tn IN
                        (SELECT slave
                           FROM full
                          WHERE master =
                                   DECODE (:exp_list_without_ts,
                                           0, master,
                                           :exp_list_without_ts))
                 AND u.tn IN
                        (SELECT slave
                           FROM full
                          WHERE master =
                                   DECODE (:exp_list_only_ts,
                                           0, master,
                                           :exp_list_only_ts))
                 AND (   u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid_kk, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND DECODE (:eta_list, '', s.h_eta, :eta_list) = s.h_eta
                 AND DECODE (:ok_selected,  1, 0,  2, t.tp_kod) =
                        DECODE (:ok_selected,  1, 0,  2, NVL (t.tp_kod, 0))
        ORDER BY ts,
                 eta,
                 tp_name,
                 address)