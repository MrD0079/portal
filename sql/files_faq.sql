/* Formatted on 11/05/2018 09:18:52 (QP5 v5.252.13127.32867) */
           SELECT *
             FROM (SELECT ID,
                          NAME,
                          avatar PATH,
                          NULL PARENT,
                          orderby,
                          TO_CHAR (lu, 'dd.mm.yyyy hh24:mi') lu
                     FROM files_sections
                    WHERE dpt_id = :dpt_id
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
                     FROM files f
                    WHERE    (SELECT COUNT (*)
                                FROM files_rights
                               WHERE     file_id = f.ID
                                     AND pos_id = (SELECT pos_id
                                                     FROM user_list
                                                    WHERE tn = :tn)) > 0
                          OR (SELECT COUNT (*)
                                FROM files_rights
                               WHERE     file_id = f.ID
                                     AND cat_id =
                                            (SELECT pers_cat_id
                                               FROM pers_cats_poss
                                              WHERE pos_id =
                                                       (SELECT pos_id
                                                          FROM user_list
                                                         WHERE     tn = :tn
                                                               AND dpt_id = :dpt_id))) > 0
                          OR (    (SELECT is_admin
                                     FROM user_list
                                    WHERE tn = :tn) = 1
                              AND (   (SELECT COUNT (*)
                                         FROM files_rights
                                        WHERE     file_id = f.ID
                                              AND pos_id IN (SELECT pos_id
                                                               FROM user_list
                                                              WHERE     datauvol IS NULL
                                                                    AND dpt_id = :dpt_id)) >
                                         0
                                   OR (SELECT COUNT (*)
                                         FROM files_rights
                                        WHERE     file_id = f.ID
                                              AND cat_id IN (SELECT pers_cat_id
                                                               FROM pers_cats_poss
                                                              WHERE pos_id IN (SELECT pos_id
                                                                                 FROM user_list
                                                                                WHERE     datauvol
                                                                                             IS NULL
                                                                                      AND dpt_id =
                                                                                             :dpt_id))) >
                                         0)))
       START WITH PARENT IS NULL
       CONNECT BY PRIOR ID = PARENT
ORDER SIBLINGS BY orderby