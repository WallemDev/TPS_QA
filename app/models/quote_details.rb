class QuoteDetails < ActiveRecord::Base
  self.establish_connection 'development'
  self.table_name = 'tblWSQuoteDtls'
   attr_accessible :intID,
   :intWSQuoteHdrID,
   :strIMONo,
   :strVslCode,
   :strRMSTPID,
   :strQuotesNo,
   :intQteVerNo,
   :intRQLineNo,
   :strItemCode,
   :strItemDesc,
   :strUnit,
   :strQty,
   :strPrice,
   :intDiscRate,
   :strDaysReady,
   :strAmount,
   :strVariance,
   :dteDateCreated,
   :dteUpdated,
   :strFileName,
   :binContents,
   :bolQuoted,
   :guiID
   #:strQuotesNo,
   #:intQteVerNo,
   #:intRQLineNo,
   #:intMarkedValue
   #:intMailedValue
end
