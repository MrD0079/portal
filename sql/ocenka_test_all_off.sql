/* Formatted on 11.06.2014 9:39:40 (QP5 v5.227.12220.39724) */
DELETE FROM ocenka_test_list
      WHERE tn IN (SELECT tn
                     FROM user_list
                    WHERE dpt_id = :dpt_id AND datauvol IS NULL)