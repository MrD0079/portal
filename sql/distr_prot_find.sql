/* Formatted on 09/10/2014 10:55:23 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) exist,
       SUM (
          CASE
             WHEN    p.lu_tn IN
                        (SELECT slave
                           FROM full
                          WHERE master IN
                                   (SELECT parent
                                      FROM assist
                                     WHERE child = :tn AND dpt_id = :dpt_id
                                    UNION
                                    SELECT :tn FROM DUAL))
                  OR (SELECT NVL (is_admin, 0)
                        FROM user_list
                       WHERE tn = :tn) = 1
                  OR (SELECT NVL (is_super, 0)
                        FROM user_list
                       WHERE tn = :tn) = 1
                  OR (SELECT NVL (is_do, 0)
                        FROM user_list
                       WHERE tn = :tn) = 1
             THEN
                1
             ELSE
                0
          END)
          visible
  FROM bud_fil z,
       bud_nd nd,
       spr_users s,
       bud_tn_fil bf,
       user_list u,
       user_list pu,
       distr_prot p,
       distr_prot_status ps,
       distr_prot_ok_chief po,
       distr_prot_ok_chief po_dpu,
       distr_prot_ok_chief po_nm,
       distr_prot_cat cat,
       distr_prot_conq conq,
       distr_prot_status status,
       distr_prot_result result
 WHERE     p.cat = cat.id(+)
       AND p.conq = conq.id(+)
       AND p.status_id = status.id(+)
       AND p.result = result.id(+)
       AND u.tn = bf.tn
       AND z.dpt_id = :dpt_id
       AND z.login = s.login(+)
       AND z.nd = nd.id(+)
       AND z.id = bf.bud_id(+)
       AND z.id = p.distr
       AND p.status_id = ps.id
       AND p.ok_chief = po.id
       AND p.ok_dpu = po_dpu.id
       AND p.ok_nm = po_nm.id
       AND pu.tn = p.lu_tn
       AND p.dpt_id = :dpt_id
       AND p.id = :prot_id