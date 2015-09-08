/* Formatted on 11.02.2014 21:46:57 (QP5 v5.227.12220.39724) */
  SELECT f.*
    FROM MERCH_SPEC_REPORT_FILES_CHAT c, MERCH_SPEC_REPORT_FILES_CHAT_F f
   WHERE c.id = f.chat_id AND c.msr_file_id = :msr_file_id
ORDER BY f.fn