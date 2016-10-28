/* Formatted on 26/05/2015 12:12:06 (QP5 v5.227.12220.39724) */
  SELECT u.fio,
         u.pos_name,
         al.tn,
         al.h_eta,
         (SELECT opit
            FROM anketa_langh
           WHERE (u.tn = tn OR u.h_eta = h_eta))
            opit,
         l.id,
         l.name lang_name,
         lev.name lang_level_name,
         eta_parents.tn eta_parent_tn,
         (SELECT fio
            FROM user_list
           WHERE tn = DECODE (al.h_eta, NULL, p.parent, eta_parents.tn))
            parent_fio,
         DECODE (al.h_eta,
                 NULL, u.region_name,
                 (SELECT region_name
                    FROM user_list
                   WHERE tn = eta_parents.tn))
            region_name
    FROM lang l,
         anketa_lang al,
         anketa_lang_level lev,
         user_list u,
         (SELECT DISTINCT u1.tn, r.h_eta
            FROM routes r, user_list u1
           WHERE     u1.tab_num = r.tab_number
                 AND NVL (u1.tab_num, 0) <> 0
                 AND u1.dpt_id = r.dpt_id
                 AND NVL (u1.tn, 0) <> 0) eta_parents,
         parents p
   WHERE     l.id = al.lang_id
         AND al.lang_level = lev.id
         AND (u.tn = al.tn OR u.h_eta = al.h_eta)
         AND al.tn = p.tn(+)
         AND al.lang_level IN (:lang_level)
         AND al.lang_id IN (:lang)
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = DECODE (:tn, -1, master, :tn))
              OR eta_parents.tn IN
                    (SELECT slave
                       FROM full
                      WHERE master = DECODE (:tn, -1, master, :tn))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND al.h_eta = eta_parents.h_eta(+)
         AND (:eta_list is null OR :eta_list = al.h_eta)
ORDER BY u.fio, u.pos_name, l.name