/* Formatted on 15.01.2013 11:06:42 (QP5 v5.163.1008.3004) */
  SELECT z.*
    FROM (SELECT cr.id_num,
                 cr.NAME,
                 cr.description,
                 NVL (cr.weight, 0) weight,
                 cr.num,
                 cr.otdel,
                 cr.TYPE,
                 (SELECT score
                    FROM ocenka_score
                   WHERE tn = :emp_tn AND exp_tn = :exp_tn AND event = :event AND criteria = cr.id_num)
                    score,
                 cr.pos,
                 NVL ( (SELECT score
                          FROM ocenka_score
                         WHERE tn = :emp_tn AND exp_tn = :exp_tn AND event = :event AND criteria = cr.id_num)
                      * cr.weight,
                      0)
                    total
            FROM ocenka_criteria cr
           WHERE     cr.event = :event
                 AND cr.TYPE = 4
                 AND cr.pos = (SELECT pos_id
                                 FROM spdtree
                                WHERE svideninn = :emp_tn)) z
ORDER BY TYPE DESC, num, NAME