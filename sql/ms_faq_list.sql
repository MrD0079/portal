/* Formatted on 28.02.2018 15:18:12 (QP5 v5.252.13127.32867) */
           SELECT *
             FROM (SELECT ID,
                          NAME,
                          avatar PATH,
                          NULL PARENT,
                          orderby,
                          TO_CHAR (lu, 'dd.mm.yyyy hh24:mi') lu
                     FROM ms_faq_sections
                   UNION
                   SELECT 0,
                          'Прочее',
                          NULL PATH,
                          NULL PARENT,
                          9999999999,
                          TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi') lu
                     FROM DUAL
                   UNION
                   SELECT f.ID,
                          f.NAME,
                          f.PATH,
                          f.section PARENT,
                          f.orderby,
                          TO_CHAR (f.lu, 'dd.mm.yyyy hh24:mi') lu
                     FROM ms_faq f
                    WHERE (SELECT COUNT (*)
                             FROM ms_faq_rights
                            WHERE     file_id = f.ID
                                  AND pos_id = (SELECT pos_id
                                                  FROM spr_users_ms
                                                 WHERE login = :login)) > 0)
       START WITH PARENT IS NULL
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY orderby