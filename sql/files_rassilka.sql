/* Formatted on 04/03/2015 10:28:38 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         ul.pos_id,
         ul.pos_name,
         ul.e_mail,
         ul.fio,
            'Здравствуйте, '
         || ul.fio
         || '.<br>'
         || CHR (10)
         || 'На корпоративный портал в раздел "Надо знать" загружен новый документ: <a href="https://ps.avk.ua/'
         || (SELECT PATH
               FROM files
              WHERE id = :id)
         || '">"'
         || (SELECT name
               FROM files
              WHERE id = :id)
         || '"</a>.<br>'
         || CHR (10)
         || 'Он расположен в подразделе "'
         || (SELECT name
               FROM files_sections
              WHERE id = (SELECT section
                            FROM files
                           WHERE id = :id))
         || '".<br>'
         || CHR (10)
         || 'Вам необходимо в кратчайшие сроки с ним ознакомиться.<br>'
            pos_msg
    FROM user_list ul,
         (SELECT pos_id
            FROM files_rights
           WHERE file_id = :id) pm
   WHERE     ul.access_ocenka = 1
         AND ul.pos_id = pm.pos_id
         AND ul.e_mail IS NOT NULL
         AND ul.dpt_id = :dpt_id
         AND ul.datauvol IS NULL
ORDER BY ul.pos_name