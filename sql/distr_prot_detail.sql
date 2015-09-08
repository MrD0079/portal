/* Formatted on 07.10.2014 18:11:00 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c,
       SUM (DECODE (fn, NULL, 0, 1)) with_prot,
       COUNT (*) - SUM (DECODE (fn, NULL, 0, 1)) without_prot,
       SUM (DECODE (fn, NULL, 0, r_no)) r_no,
       SUM (DECODE (fn, NULL, 0, r_pr)) r_pr,
       SUM (DECODE (fn, NULL, 0, r_re)) r_re
  FROM distr_prot_conq_fil f,
       (  SELECT distr,
                 conq,
                 DECODE (SUM ( (SELECT COUNT (*)
                                  FROM distr_prot_files
                                 WHERE prot = p.id)),
                         0, NULL,
                         1)
                    fn,
                 DECODE (SUM (CASE WHEN result = 47085127 THEN 1 ELSE 0 END),
                         0, 0,
                         1)
                    r_no,
                 DECODE (SUM (CASE WHEN result = 47085135 THEN 1 ELSE 0 END),
                         0, 0,
                         1)
                    r_pr,
                 DECODE (SUM (CASE WHEN result = 47085136 THEN 1 ELSE 0 END),
                         0, 0,
                         1)
                    r_re
            FROM distr_prot p
           WHERE TRUNC (p.lu) BETWEEN TO_DATE (:da_sd, 'dd.mm.yyyy')
                                  AND TO_DATE (:da_ed, 'dd.mm.yyyy')
        GROUP BY distr, conq) p
 WHERE     f.conq = :da_conq
       AND f.fil = p.distr(+)
       AND f.conq = p.conq(+)
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