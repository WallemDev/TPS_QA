module QuotesHelper
  def self.get_value_ok(strQuotesNo,intQteVerNo)
    #intQteVerNo = intQteVerNo.to_i
    sql = "SELECT       t.[intMarkedValue]
          FROM [dbMPE].[dbo].[tblWSQuoteDtls] m LEFT JOIN [TPS-QA].[dbo].[tblTPSQAConfirmQuote] t
          ON
          m.[strQuotesNo] COLLATE DATABASE_DEFAULT LIKE t.[strQuotesNo] COLLATE DATABASE_DEFAULT
          AND
          m.[intQteVerNo] = t.[intQteVerNo]
          AND
          m.[intRQLineNo] = t.[intRQLineNo]
          WHERE m.[strQuotesNo] = '"+ strQuotesNo + "'" + " AND m.[intQteVerNo] = '" + intQteVerNo + "'"
    quotes = Quotes.find_by_sql(sql)
    quotes.each do  |quote|
      marked_value =quote[:intMarkedValue]
      if !marked_value.nil?
        if marked_value ==0
          return 0
        end
      else
       return -1
      end
    end
    return 1
  end
end
