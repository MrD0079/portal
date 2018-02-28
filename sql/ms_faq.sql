/* Formatted on 21/08/2015 14:55:39 (QP5 v5.227.12220.39724) */
           SELECT LEVEL,
                  f1.*,
                  (SELECT COUNT (*)
                     FROM ms_faq_rights
                    WHERE     file_id = f1.id
                          AND pos_id IN (SELECT pos_id
                                           FROM user_list
                                          WHERE datauvol IS NULL))
                     cnt
             FROM (SELECT ID,
                          NAME,
                          avatar PATH,
                          NULL PARENT,
                          orderby,
                          TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu,
                          'ms_faq_sections' fr
                     FROM ms_faq_sections
                 
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
                          'ms_faq' fr
                     FROM ms_faq f) f1
            WHERE    DECODE (
                        :ms_faq_activ,
                        2, 2,
                        DECODE (
                           (SELECT COUNT (*)
                              FROM ms_faq_rights
                             WHERE     file_id = f1.id
                                   AND pos_id IN
                                          (SELECT pos_id
                                             FROM user_list
                                            WHERE datauvol IS NULL )),
                           0, 0,
                           1)) = :ms_faq_activ
                  OR LEVEL = 1
       START WITH f1.PARENT IS NULL
       CONNECT BY PRIOR f1.ID = f1.PARENT
ORDER SIBLINGS BY f1.orderby