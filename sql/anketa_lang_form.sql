/* Formatted on 05/03/2015 11:19:20 (QP5 v5.227.12220.39724) */
  SELECT l.id, l.name, al.lang_level
    FROM lang l,
         (SELECT *
            FROM anketa_lang
           WHERE tn = :tn OR h_eta = :h_eta) al
   WHERE l.id = al.lang_id(+)
ORDER BY l.name