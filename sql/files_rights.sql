/* Formatted on 23/09/2015 17:59:14 (QP5 v5.227.12220.39724) */
SELECT pos.pos_id id,
       pos.pos_name name,
       f.ID fid,
       'pos' tbl,
       'yellow' color
  FROM pos,
       (SELECT *
          FROM files_rights
         WHERE file_id = :id) f
 WHERE     pos.pos_id = f.pos_id(+)
       AND pos.pos_id IN
              (SELECT pos_id
                 FROM user_list
                WHERE     datauvol IS NULL
                      AND dpt_id = :dpt_id)
UNION
SELECT pers_cats.id,
       pers_cats.name,
       f.ID fid,
       'cat' tbl,
       'lightblue' color
  FROM pers_cats,
       (SELECT *
          FROM files_rights
         WHERE file_id = :id) f
 WHERE pers_cats.id = f.cat_id(+)
ORDER BY tbl, name