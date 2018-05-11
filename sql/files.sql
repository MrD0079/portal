/* Formatted on 11/05/2018 09:05:36 (QP5 v5.252.13127.32867) */
           SELECT LEVEL,
                  f1.*,
                  (SELECT COUNT (*)
                     FROM files_rights
                    WHERE     file_id = f1.id
                          AND pos_id IN (SELECT pos_id
                                           FROM user_list
                                          WHERE datauvol IS NULL AND dpt_id = :dpt_id))
                     cnt
             FROM (SELECT ID,
                          NAME,
                          avatar PATH,
                          NULL PARENT,
                          orderby,
                          TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu,
                          'files_sections' fr
                     FROM files_sections
                    WHERE dpt_id = :dpt_id
                   UNION
                   SELECT 0,
                          'Прочее',
                          NULL PATH,
                          NULL PARENT,
                          9999999999,
                          TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi:ss') lu,
                          'dual' fr
                     FROM DUAL
                   UNION
                   SELECT f.ID,
                          f.NAME,
                          f.PATH,
                          f.section PARENT,
                          f.orderby,
                          TO_CHAR (f.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
                          'files' fr
                     FROM files f
                    WHERE DECODE (
                             :files_activ,
                             2, 2,
                             DECODE (
                                (SELECT COUNT (*)
                                   FROM files_rights
                                  WHERE     file_id = f.id
                                        AND pos_id IN (SELECT pos_id
                                                         FROM user_list
                                                        WHERE     datauvol IS NULL
                                                              AND dpt_id = :dpt_id)),
                                0, 0,
                                1)) = :files_activ) f1
       START WITH f1.PARENT IS NULL
       CONNECT BY PRIOR f1.ID = f1.PARENT
ORDER SIBLINGS BY f1.orderby