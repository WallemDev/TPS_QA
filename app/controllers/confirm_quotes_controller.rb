class ConfirmQuotesController < ApplicationController
  def create
    #Get parameter from ajax
    strQuotesNo = params[:strQuotesNo]
    intQteVerNo = params[:intQteVerNo]
    intRQLineNo = params[:intRQLineNo]
    intMarkedValue = params[:intMarkedValue]
    intMailedValue = params[:intMailedValue]

    is_render_view = params[:is_render_view]

    #confirm_quote =  ConfirmQuotes.new
    #confirm_quote.strQuotesNo= strQuotesNo
    #confirm_quote.intQteVerNo= intQteVerNo
    #confirm_quote.intRQLineNo= intRQLineNo
    #confirm_quote.intMarkedValue= intMarkedValue
    #confirm_quote.intMailedValue = intMailedValue
    #confirm_quote.save

    #Check confirm_quote has existed in db . if No ->save
    is_exist_confirm_quote  = is_exist_confirm_quote(strQuotesNo,intQteVerNo,intRQLineNo)

    if(!is_exist_confirm_quote)
      @command = "INSERT INTO tblTPSQAConfirmQuote
          ([strQuotesNo]
          ,[intQteVerNo]
          ,[intRQLineNo]
          ,[intMarkedValue]
          ,[intMailedValue])
          VALUES
          ('#{strQuotesNo}'
              ,#{intQteVerNo}
              ,#{intRQLineNo}
              ,#{intMarkedValue}
              ,#{intMailedValue})"

      SqlHelper.ExecuteCommand('TPSQA',@command)
    end

    if is_render_view=='1'
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

      render :partial => 'quote_details/quotes_details_ver2'
      #render :partial => 'quotes_details'
      #render :partial => 'quote_details/quotes_details'
      #render :partial => 'quote_details/quotes_details_ver2'
    else
      render :text => 0
    end

  end
  def send_mail_for_quote
    static_strQuotesNo = params[:static_strQuotesNo]
    static_intQteVerNo = params[:static_intQteVerNo]
    quote_details = Quotes.get_quote_details(static_strQuotesNo, static_intQteVerNo)
    begin
      UserMailer.send_mail(static_strQuotesNo, static_intQteVerNo, quote_details)
      sql_update = 'UPDATE [TPS-QA].[dbo].[tblTPSQAConfirmQuote]'
      sql_update << ' SET intMailedValue = 1'
      sql_update << " WHERE strQuotesNo = '#{static_strQuotesNo}'"
      SqlHelper.ExecuteCommand('TPSQA', sql_update)
    rescue => ex

    end
    render :text => 'ok'
  end

  def is_exist_confirm_quote(strQuotesNo,intQteVerNo,intRQLineNo)
    sql ="SELECT [strQuotesNo]
          FROM [tblTPSQAConfirmQuote]
          WHERE [strQuotesNo] = '"+ strQuotesNo + "'" + " AND [intQteVerNo] = '" + intQteVerNo + "' AND [intRQLineNo]= '" + intRQLineNo + "'"
    result = SqlHelper.select_all('TPSQA',sql)
    if result.empty?
      return  false
    else return true
    end
  end
end
