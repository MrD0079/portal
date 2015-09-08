/* Formatted on 07.10.2014 18:10:24 (QP5 v5.227.12220.39724) */
SELECT f.*,
       bf.name fil_name,
       nd.name nd_name,
       FN_QUERY2STR (
             '  SELECT    t2.fio
         || '', ''
         || t2.pos_name
         || '', ''
         || t2.department_name
         || '', ''
         || t2.region_name
         || '', e-mail: ''
         || t2.e_mail
         || '', skype: ''
         || t2.skype
         || '', тел.: ''
         || t2.phone
         || '', рук-ль: ''
         || tp.fio
         || '', ''
         || tp.pos_name
            chief
    FROM bud_tn_fil t1,
         user_list t2,
         parents p,
         user_list tp
   WHERE     t1.bud_id = '
          || f.fil
          || '
         AND t1.tn = t2.tn
         AND t2.tn = p.tn
         AND tp.tn = p.parent
ORDER BY t2.fio',
          '<br>')
          db_list,
       p.*
  FROM bud_nd nd,
       bud_fil bf,
       distr_prot_conq_fil f,
       (  SELECT distr,
                 conq,
                 DECODE (SUM ( (SELECT COUNT (*)
                                  FROM distr_prot_files
                                 WHERE prot = p.id)),
                         0, NULL,
                         1)
                    fn
            FROM distr_prot p
           WHERE TRUNC (p.lu) BETWEEN TO_DATE (:da_sd, 'dd.mm.yyyy')
                                  AND TO_DATE (:da_ed, 'dd.mm.yyyy')
        GROUP BY distr, conq) p
 WHERE     f.conq = :da_conq
       AND f.fil = p.distr(+)
       AND f.conq = p.conq(+)
       AND p.fn IS NULL
       AND f.fil = bf.id
       AND bf.nd = nd.id(+)
       AND f.fil IN
              (SELECT bud_id
                 FROM bud_tn_fil
                WHERE    (   tn IN
                                (SELECT slave
                                   FROM full
                                  WHERE master IN
                                           (SELECT parent
                                              FROM assist
                                             WHERE     child = :tn
                                                   AND dpt_id = :dpt_id
                                            UNION
                                            SELECT :tn FROM DUAL))
                          OR (SELECT NVL (is_admin, 0)
                                FROM user_list
                               WHERE tn = :tn) = 1
                          OR (SELECT NVL (is_super, 0)
                                FROM user_list
                               WHERE tn = :tn) = 1)
                      OR (SELECT NVL (is_do, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)