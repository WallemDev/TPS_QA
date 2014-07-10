class ConfirmQuotes < ActiveRecord::Base
  self.establish_connection 'TPSQA'
  self.table_name = 'tblTPSQAConfirmQuote'
   attr_accessible  :strQuotesNo,
                    :intQteVerNo,
                    :intRQLineNo,
                    :intMarkedValue,
                    :intMailedValue
end
