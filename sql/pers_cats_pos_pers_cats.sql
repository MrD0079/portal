/* Formatted on 23/09/2015 17:17:50 (QP5 v5.227.12220.39724) */
SELECT wm_concat (name)
  FROM (  SELECT c.name
            FROM pers_cats c, pers_cats_poss cf
           WHERE c.id = cf.pers_cat_ID AND cf.pos_id = :id
        ORDER BY c.name)