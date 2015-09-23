/* Formatted on 23/09/2015 17:03:16 (QP5 v5.227.12220.39724) */
  SELECT f.pos_name,
         f.pos_id,
         DECODE (cf.pos_id, NULL, NULL, 1) selected,
         FN_QUERY2STR (
               'SELECT c.name '
            || 'FROM pers_cats c, pers_cats_poss cf '
            || 'WHERE c.id = cf.pers_cat_ID AND cf.pos_id = '
            || f.pos_id
            || ' order by c.name',
            ',')
            pers_cats_list
    FROM pers_cats c, pers_cats_poss cf, pos f
   WHERE cf.pers_cat_ID(+) = :id AND cf.pos_id(+) = f.pos_id AND c.id = :id
ORDER BY f.pos_name