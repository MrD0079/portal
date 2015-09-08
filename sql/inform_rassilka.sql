/* Formatted on 2011/12/01 10:11 (Formatter Plus v4.8.8) */
SELECT DISTINCT ul.pos_id,
                ul.pos_name,
                ul.e_mail,
                ul.fio,
                'Здравствуйте, ' || ul.fio || '<br>. Информируем Вас о сроках подачи отчетности на ' || TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'mm'), 1), 'month') || '<br>' || pm.pos_msg pos_msg
           FROM user_list ul,
                pos_msg pm
          WHERE ul.access_ocenka = 1
            AND ul.pos_id = pm.pos_id(+)
            AND pm.pos_msg IS NOT NULL
            AND ul.e_mail IS NOT NULL
       ORDER BY ul.pos_name