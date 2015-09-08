/* Formatted on 10/10/2014 13:10:42 (QP5 v5.227.12220.39724) */
  SELECT f.id, f.name
    FROM bud_fil f, bud_tn_fil tf
   WHERE tf.tn = :tn AND f.id = tf.bud_id
ORDER BY f.name