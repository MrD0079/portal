/* Formatted on 08/12/2014 12:48:23 (QP5 v5.227.12220.39724) */
SELECT (SELECT sales
          FROM nets_plan_year
         WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
          plan_cur_year,
       (SELECT sales_prev
          FROM nets_plan_year
         WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
          plan_prev_year,
       (SELECT sales_ng
          FROM nets_plan_year
         WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
          plan_cur_year_ng,
       (SELECT sales_prev_ng
          FROM nets_plan_year
         WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
          plan_prev_year_ng,
       DECODE (
          NVL (
             (SELECT sales_prev
                FROM nets_plan_year
               WHERE     YEAR = :YEAR
                     AND plan_type = :plan_type
                     AND id_net = :net),
             0),
          0, 0,
              (SELECT sales
                 FROM nets_plan_year
                WHERE     YEAR = :YEAR
                      AND plan_type = :plan_type
                      AND id_net = :net)
            / (SELECT sales_prev
                 FROM nets_plan_year
                WHERE     YEAR = :YEAR
                      AND plan_type = :plan_type
                      AND id_net = :net)
            * 100
          - 100)
          plan_rost,
       (SELECT   NVL (
                      (SELECT sales_prev
                         FROM nets_plan_year
                        WHERE     YEAR = :YEAR
                              AND plan_type = :plan_type
                              AND id_net = :net)
                    / 100
                    * b_perc,
                    0)
               + NVL (b_sum, 0)
                  b_total
          FROM (SELECT SUM (CASE pay_format WHEN 1 THEN summa END) b_perc,
                       SUM (CASE pay_format WHEN 2 THEN summa END) b_sum
                  FROM sdu_terms_year
                 WHERE     id_net = :net
                       AND ver = (SELECT NVL (MAX (ver), 0)
                                    FROM sdu
                                   WHERE id_net = :net AND year = :year - 1)
                       AND YEAR = :YEAR - 1))
          b_prev_year,
       NVL (z.b_perc, 0) b_perc,
       NVL (z.b_sum, 0) b_sum,
         (SELECT sales
            FROM nets_plan_year
           WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
       / 100
       * NVL (b_perc, 0)
          b_perc_uah,
         NVL (
              (SELECT sales
                 FROM nets_plan_year
                WHERE     YEAR = :YEAR
                      AND plan_type = :plan_type
                      AND id_net = :net)
            / 100
            * b_perc,
            0)
       + NVL (b_sum, 0)
          b_total,
         NVL (b_perc, 0)
       + DECODE (
            NVL (
               (SELECT sales
                  FROM nets_plan_year
                 WHERE     YEAR = :YEAR
                       AND plan_type = :plan_type
                       AND id_net = :net),
               0),
            0, 0,
              NVL (b_sum, 0)
            * 100
            / (SELECT sales
                 FROM nets_plan_year
                WHERE     YEAR = :YEAR
                      AND plan_type = :plan_type
                      AND id_net = :net))
          b_total_perc,
       DECODE (
          (SELECT   NVL (
                         (SELECT sales_prev
                            FROM nets_plan_year
                           WHERE     YEAR = :YEAR
                                 AND plan_type = :plan_type
                                 AND id_net = :net)
                       / 100
                       * b_perc,
                       0)
                  + NVL (b_sum, 0)
                     b_total
             FROM (SELECT SUM (CASE pay_format WHEN 1 THEN summa END) b_perc,
                          SUM (CASE pay_format WHEN 2 THEN summa END) b_sum
                     FROM sdu_terms_year
                    WHERE     id_net = :net
                          AND ver =
                                 (SELECT NVL (MAX (ver), 0)
                                    FROM sdu
                                   WHERE id_net = :net AND year = :year - 1)
                          AND YEAR = :YEAR - 1)),
          0, 0,
              (  NVL (
                      (SELECT sales
                         FROM nets_plan_year
                        WHERE     YEAR = :YEAR
                              AND plan_type = :plan_type
                              AND id_net = :net)
                    / 100
                    * b_perc,
                    0)
               + NVL (b_sum, 0))
            / (SELECT   NVL (
                             (SELECT sales_prev
                                FROM nets_plan_year
                               WHERE     YEAR = :YEAR
                                     AND plan_type = :plan_type
                                     AND id_net = :net)
                           / 100
                           * b_perc,
                           0)
                      + NVL (b_sum, 0)
                         b_total
                 FROM (SELECT SUM (CASE pay_format WHEN 1 THEN summa END)
                                 b_perc,
                              SUM (CASE pay_format WHEN 2 THEN summa END)
                                 b_sum
                         FROM sdu_terms_year
                        WHERE     id_net = :net
                              AND ver =
                                     (SELECT NVL (MAX (ver), 0)
                                        FROM sdu
                                       WHERE     id_net = :net
                                             AND year = :year - 1)
                              AND YEAR = :YEAR - 1))
            * 100
          - 100)
          b_rost,
       (SELECT NVL (SUM (total), 0)
          FROM nets_plan_month m
         WHERE     m.YEAR = :YEAR
               AND m.plan_type = :plan_type
               AND m.id_net = :net)
          fin_zatr,
       DECODE (
          NVL (
             (SELECT sales
                FROM nets_plan_year
               WHERE     YEAR = :YEAR
                     AND plan_type = :plan_type
                     AND id_net = :net),
             0),
          0, 0,
            (SELECT NVL (SUM (total), 0)
               FROM nets_plan_month m
              WHERE     m.YEAR = :YEAR
                    AND m.plan_type = :plan_type
                    AND m.id_net = :net)
          / (SELECT sales
               FROM nets_plan_year
              WHERE YEAR = :YEAR AND plan_type = :plan_type AND id_net = :net)
          * 100)
          fin_perc
  FROM (SELECT SUM (CASE pay_format WHEN 1 THEN summa END) b_perc,
               SUM (CASE pay_format WHEN 2 THEN summa END) b_sum
          FROM sdu_terms_year
         WHERE     id_net = :net
               AND ver = (SELECT NVL (MAX (ver), 0)
                            FROM sdu
                           WHERE id_net = :net AND year = :year)
               AND YEAR = :YEAR) z