/* Formatted on 16/07/2015 13:48:31 (QP5 v5.227.12220.39724) */
  SELECT *
    FROM (SELECT fn_getname (prob_tn) prob_name,
                 fn_getdolgn (prob_tn) prob_dolgn,
                 fn_getname (inst_tn) inst_name,
                 fn_getdolgn (inst_tn) inst_dolgn,
                 fn_getname (chief_tn) chief_name,
                 fn_getdolgn (chief_tn) chief_dolgn,
                 fn_getname (dir_tn) dir_name,
                 fn_getdolgn (dir_tn) dir_dolgn,
                 TO_CHAR (p.data_start, 'dd.mm.yyyy') data_start_t,
                 TO_CHAR (p.data_end, 'dd.mm.yyyy') data_end_t,
                 p.*,
                 CASE WHEN p.data_end <= SYSDATE THEN 1 ELSE 0 END period_ended,
                 DECODE (
                      DECODE (:tn, NVL (inst_tn, 0), 1, 0)
                    + DECODE (:tn, NVL (chief_tn, 0), 1, 0)
                    + DECODE (:tn, NVL (dir_tn, 0), 1, 0),
                    0, 1,
                    0)
                    read_only,
                 CASE
                    WHEN (    (pp.ok_employee = 1 OR inst_tn IS NULL)
                          AND (pp.ok_teacher = 1 OR chief_tn IS NULL)
                          AND (pp.ok_chief = 1 OR dir_tn IS NULL))
                    THEN
                       1
                    ELSE
                       0
                 END
                    ad_completed,
                 TO_CHAR (
                    DECODE (
                       SIGN (
                            DECODE (SIGN (stamp_employee - stamp_chief),
                                    1, stamp_employee,
                                    stamp_chief)
                          - stamp_teacher),
                       1, DECODE (SIGN (stamp_employee - stamp_chief),
                                  1, stamp_employee,
                                  stamp_chief),
                       stamp_teacher),
                    'dd.mm.yyyy')
                    ad_completed_data,
                 (SELECT TO_CHAR (datauvol, 'dd.mm.yyyy')
                    FROM spdtree
                   WHERE svideninn = p.prob_tn)
                    datauvol,
                 pp.ok_employee,
                 pp.ok_teacher,
                 pp.ok_chief,
                 pp.stamp_employee,
                 pp.stamp_teacher,
                 pp.stamp_chief
            FROM p_prob_inst p, p_plan pp
           WHERE     (   :tn IN (inst_tn, chief_tn, dir_tn)
                      OR (SELECT is_super
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT is_admin
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND p.prob_tn = pp.tn
                 AND :dpt_id = (SELECT dpt_id
                                  FROM spdtree
                                 WHERE svideninn = p.prob_tn))
   WHERE DECODE (:ad_completed,  1, 0,  2, 0,  3, 1) =
            DECODE (:ad_completed, 1, 0, ad_completed)
ORDER BY data_start DESC, data_end DESC, prob_name