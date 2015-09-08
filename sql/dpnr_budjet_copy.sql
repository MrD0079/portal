/* Formatted on 30/12/2014 11:14:57 (QP5 v5.227.12220.39724) */
BEGIN
   copy_dpnr_budjet (:market,
                     TO_DATE (:fd, 'dd.mm.yyyy'),
                     TO_DATE (:td, 'dd.mm.yyyy'));
END;