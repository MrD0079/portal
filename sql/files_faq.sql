/* Formatted on 04/03/2015 10:33:33 (QP5 v5.227.12220.39724) */
           SELECT *
             FROM (SELECT ID,
                          NAME,
                          NULL PATH,
                          NULL PARENT,
                          orderby,
                          TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu
                     FROM files_sections
                    WHERE dpt_id = :dpt_id
                   UNION
                   SELECT 0,
                          'Прочее',
                          NULL PATH,
                          NULL PARENT,
                          9999999999,
                          TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi:ss') lu
                     FROM DUAL
                   UNION
                   SELECT f.ID,
                          f.NAME,
                          f.PATH,
                          f.section PARENT,
                          f.orderby,
                          TO_CHAR (f.lu, 'dd.mm.yyyy hh24:mi:ss') lu
                     FROM files f
                    WHERE    (SELECT COUNT (*)
                                FROM files_rights
                               WHERE     file_id = f.ID
                                     AND DECODE (:pos_id, 0, pos_id, :pos_id) = pos_id) >
                                0
                          OR (SELECT is_admin
                                FROM user_list
                               WHERE tn = :tn) = 1)
       START WITH PARENT IS NULL
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY orderby