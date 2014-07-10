class Quotes < ActiveRecord::Base
  self.establish_connection 'development'
  self.table_name = 'tblWSQuoteHdr'
  #self.primary_key = "intID"
  attr_accessible :intID,
                  :strIMONo,
                  :strVslcode,
                  :strRMSTPID,
                  :strQuotesNo,
                  :intQteVerNo,
                  :lngRFQNo,
                  :strRQNo,
                  :strRFQNo,
                  :intRFQVerNo,
                  :dteCreated,
                  :dteUpdated,
                  :strSupRemark,
                  :bolOrigMaker,
                  :bolOtherSupplier,
                  :strCurCode,
                  :strOrigCountryCode,
                  :sboldiscount,
                  :strPayTerm,
                  :strDaysReady,
                  :strGrossWt,
                  :bolAllQuoted,
                  :strSupRefNo,
                  :strDiscByPerc,
                  :strDiscByCurr,
                  :strDiscDesc,
                  :strSupContact1,
                  :strSupContact2,
                  :intDelivCharge,
                  :dteQuoteValid,
                  :bolWebSupplier,
                  :strQuoteStatus,
                  :strBuyRMSTPID,
                  :bolBuyerRaised,
                  :strCountryCode,
                  :strCountryCodeEx
  def self.get_quote_details(quote_no, quote_ver)
    strQuotesNo = quote_no.to_s
    intQteVerNo = quote_ver.to_s

    sql = "SELECT TOP 2 * FROM tblWSQuoteDtls WHERE strQuotesNo = '"+ strQuotesNo + "'" + " AND intQteVerNo = '" + intQteVerNo + "'"

    sql = "SELECT       t.*,
                        m.[intQteVerNo] AS QteVerNo ,
                        m.[intRQLineNo] AS RQLineNo,
                        m.intRQLineNo   AS RQLineNo,
                        m.strItemCode,
                        m.strItemDesc,
                        m.strPrice,
                        m.strVariance ,
                        m.strQuotesNo ,
                        m.strQty
          FROM [dbMPE].[dbo].[tblWSQuoteDtls] m LEFT JOIN [TPS-QA].[dbo].[tblTPSQAConfirmQuote] t
          ON
          m.[strQuotesNo] COLLATE DATABASE_DEFAULT LIKE t.[strQuotesNo] COLLATE DATABASE_DEFAULT
          AND
          m.[intQteVerNo] = t.[intQteVerNo]
          AND
          m.[intRQLineNo] = t.[intRQLineNo]
          WHERE m.[strQuotesNo] = '"+ strQuotesNo + "'" + " AND m.[intQteVerNo] = '" + intQteVerNo + "'"

    quote_details = QuoteDetails.find_by_sql(sql)
    quote_details
  end
end
