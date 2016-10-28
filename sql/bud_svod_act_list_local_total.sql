/* Formatted on 09/04/2015 17:40:28 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c,
       SUM (s.summa) summa,
       SUM (t.bonus_sum) bonus_sum,
       DECODE (SUM (s.summa), 0, 0, SUM (t.bonus_sum) / SUM (s.summa) * 100)
          zat
  FROM (SELECT m.tab_num,
               m.tp_kod,
               m.y,
               m.m,
               m.summa,
               m.h_eta,
               m.eta
          FROM a14mega m
         WHERE m.dpt_id = :dpt_id AND TO_DATE (:dt, 'dd.mm.yyyy') = m.dt) s,
       user_list u,
       akcii_local_tp t,
       bud_ru_zay z
 WHERE     s.tp_kod = t.tp_kod
       AND t.z_id = z.id
       AND s.tab_num = u.tab_num
       AND u.dpt_id = :dpt_id
       AND t.z_id = :z_id
       /*AND (u.datauvol IS NULL or trunc(u.datauvol,'mm') >= TO_DATE (:dt, 'dd.mm.yyyy'))*/
       AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
       AND (   :exp_list_only_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
       AND (   u.tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
            OR (SELECT NVL (is_traid, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1
            OR (SELECT NVL (is_traid_kk, 0)
                  FROM user_list
                 WHERE tn = :tn) = 1)
       AND (:eta_list is null OR :eta_list = s.h_eta)
       AND z.tn = DECODE (:db, 0, z.tn, :db)
       AND DECODE (:fil, 0, z.fil, :fil) = z.fil
       AND (   z.fil IN (SELECT fil_id
                           FROM clusters_fils
                          WHERE :clusters = CLUSTER_ID)
            OR :clusters = 0)