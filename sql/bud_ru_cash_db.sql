/* Formatted on 16.12.2013 12:25:40 (QP5 v5.227.12220.39724) */
SELECT u.tn, u.fio
  FROM bud_tn_fil tf, user_list u
 WHERE tf.bud_id = :fil AND u.tn = tf.tn