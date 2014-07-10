class QuoteDetailsController < ApplicationController
  def show

    strQuotesNo = params[:strQuotesNo]
    intQteVerNo = params[:intQteVerNo]

    #sql = "SELECT TOP 2 * FROM tblWSQuoteDtls WHERE strQuotesNo = '"+ strQuotesNo + "'" + " AND intQteVerNo = '" + intQteVerNo + "'"

    sql = "SELECT       t.*,
                        m.[intQteVerNo] AS QteVerNo ,
                        m.[intRQLineNo] AS RQLineNo,
                        m.intRQLineNo   AS RQLineNo,
                        m.strItemCode,
                        m.strItemDesc,
                        m.strPrice,
                        m.strQty,
                        m.strVariance ,
                        m.strQuotesNo
          FROM [dbMPE].[dbo].[tblWSQuoteDtls] m LEFT JOIN [TPS-QA].[dbo].[tblTPSQAConfirmQuote] t
          ON
          m.[strQuotesNo] COLLATE DATABASE_DEFAULT LIKE t.[strQuotesNo] COLLATE DATABASE_DEFAULT
          AND
          m.[intQteVerNo] = t.[intQteVerNo]
          AND
          m.[intRQLineNo] = t.[intRQLineNo]
          WHERE m.[strQuotesNo] = '"+ strQuotesNo + "'" + " AND m.[intQteVerNo] = '" + intQteVerNo + "'"

    @quote_details = QuoteDetails.find_by_sql(sql)

    #Get Remark & QuoteNo to show into view.
    sql_quotes = "SELECT q.[strQuotesNo], q.[strSupRemark], q.[intID], C.[strCompName], D.[strRQNo], q.[strSupRefNo]
                  FROM tblWSQuoteHdr q
                  INNER JOIN [dbMPEMultiparty].[dbo].[tblSuppliers] C ON
                  q.strBuyRMSTPID = C.strBuyRMSTPID AND q.strRMSTPID = C.strRMSTPID
                  INNER JOIN [dbMPE].[dbo].[tblRQHeader] D ON
                  q.strBuyRMSTPID = D.strBuyRMSTPID AND q.strIMONo = D.strIMONo AND q.strVslCode = D.strVslCode AND q.strRQNo = D.strRQNo
                  WHERE q.[strQuotesNo] = '"+ strQuotesNo + "'" + " AND q.[intQteVerNo] = '" + intQteVerNo + "'"

    LoggerHelper.log_info('quote.log', sql_quotes, __FILE__,__LINE__)
    begin
    quote   = Quotes.find_by_sql(sql_quotes)
    @strQuotesNo = quote[0].strQuotesNo
    @strSupRemark = quote[0].strSupRemark

    @supplierName = quote[0]['strCompName']
    @strRQNo = quote[0]['strRQNo']
    @quotation = quote[0]['strSupRefNo']

    LoggerHelper.log_info('quote.log', "Supplier Name: #{@supplierName}",__FILE__,__LINE__)
    LoggerHelper.log_info('quote.log', "Quotation: #{@quotation}",__FILE__,__LINE__)
    LoggerHelper.log_info('quote.log', "RQ No: #{@strRQNo}",__FILE__,__LINE__)
    @intID = quote[0].intID
    rescue => ex
      LoggerHelper.log_error('quote.log', ex.to_s,__FILE__,__LINE__)
    end
    #render :partial => 'quotes_details'
    render :partial => 'quotes_details_ver2'


  end
end
