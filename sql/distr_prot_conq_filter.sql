/* Formatted on 16.09.2014 18:44:50 (QP5 v5.227.12220.39724) */
SELECT *
  FROM distr_prot_conq
 WHERE id IN (SELECT conq
                FROM distr_prot
               WHERE cat = :cat)