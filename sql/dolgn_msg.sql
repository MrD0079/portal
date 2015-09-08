/* Formatted on 2011/11/27 17:52 (Formatter Plus v4.8.8) */
SELECT DISTINCT ul.pos_id,
                ul.pos_name,
                pm.pos_msg
           FROM user_list ul,
                pos_msg pm
          WHERE ul.access_ocenka = 1
            AND ul.pos_id = pm.pos_id(+)
       ORDER BY ul.pos_name