class UserMailer < ActionMailer::Base
  @@mail_server = MailConfig.read_mail_server_config

  if GlobalConstant::DEBUG == true
    default from: @@mail_server.mail_from_debug
  else
    default from: @@mail_server.mail_from
  end


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send.subject
  #
  def config_mail
    ActionMailer::Base.raise_delivery_errors = true
    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.perform_deliveries = true
    #mail_server = MailConfig.read_mail_server_config

    ActionMailer::Base.smtp_settings = {
        :address => @@mail_server.mail_server_address,
        :port => @@mail_server.mail_server_port,
        :domain => @@mail_server.mail_server_domain,
        #:authentication => :plain,
        #:user_name => mail_server.mail_server_username,
        # hthngoc - Fix: decode pwd before use
        #:password => mail_server.mail_server_password,
        :enable_starttls_auto => @@mail_server.mail_server_enable_tls,
        :openssl_verify_mode => 'none'
    }
  end

  def send_mail(quote_no, quote_ver, quote_details)
    # query db to get ...
    begin
      #HUNG LE:: get user's email
      if GlobalConstant::DEBUG == true
        #to_email = 'cmsam@tma.com.vn'
        #to_email1 = 'lvanhung@tma.com.vn'
        #to_email2 = 'phtkiet@tma.com.vn'
        #recipients = to_email, to_email1, to_email2
        to_email = @@mail_server.mail_to_debug
        cc_mail = @@mail_server.mail_cc_debug
      else
      #  sql = "SELECT [dbCLIFF].[dbo].[MPE_BC_User].[UserEmail],tblWSQuoteHdr.strQuotesNo  FROM
      #tblRFQHeader INNER JOIN tblWSQuoteHdr ON tblRFQHeader.strVslCode = tblWSQuoteHdr.strVslCode AND tblRFQHeader.strRQNo = tblWSQuoteHdr.strRQNo
      #INNER JOIN tblRFQCoversheet ON tblWSQuoteHdr.strQuotesNo = tblRFQCoversheet.QuoteNo
      #INNER JOIN [dbCLIFF].[dbo].[MPE_BC_User] ON tblRFQCoversheet.strFullName = [dbCLIFF].[dbo].[MPE_BC_User].UserName
      #WHERE tblWSQuoteHdr.strQuotesNo = '#{quote_no}'"
      sql= "select UserEmail , strQuotesNo  FROM [dbMPE].[dbo].[tblWSQuoteHdr] w
            inner join [dbMPE].[dbo].[tblRFQHeader] rqh on w.[lngRFQNo]=rqh.[lngRFQNo]
            inner JOIN [dbMPE].[dbo].[tblRFQCoversheet] c ON w.[lngRFQNo] = c.[lngRFQNo]
            inner JOIN [dbCLIFF].[dbo].[MPE_BC_User] ON c.strFullName = [dbCLIFF].[dbo].[MPE_BC_User].UserName
            where strQuotesNo = '#{quote_no}'"
        puts sql
        @result = ''
        @temporary = 0
        begin
          @result = SqlHelper.select_all('development', sql)
          @temporary = 1
        rescue => ex
          LoggerHelper.log_error('sendmail.log', ex.to_s,__FILE__,__LINE__)
          @temporary = 0
        end

        if @temporary == 1
          if !@result.empty?
            to_email = @result[0]['UserEmail']
          else
            to_email = @@mail_server.mail_cc
          end
          cc_mail = @@mail_server.mail_cc
        else
          to_email = @@mail_server.mail_cc
          cc_mail = @@mail_server.mail_cc
        end
      end
      LoggerHelper.log_info('sendmail.log', to_email, __FILE__, __LINE__)
      #CMSAM:: get info send mail
      if GlobalConstant::DEBUG == false
        sql_base = "SELECT TOP 1 strIMONo,strVslCode,strBuyRMSTPID, strRMSTPID, strRQNo
                FROM [dbMPE].[dbo].[tblWSQuoteHdr]
                WHERE strQuotesNo = '#{quote_no}'"
        LoggerHelper.log_info('sendmail.log', sql_base, __FILE__, __LINE__)
        vsl_hash = SqlHelper.select_all('TPSQA', sql_base)

        strVslCode = vsl_hash[0]['strVslCode']
        strIMONo = vsl_hash[0]['strIMONo']
        strBuyRMSTPID = vsl_hash[0]['strBuyRMSTPID']
        strRMSTPID = vsl_hash[0]['strRMSTPID']
        strRQNo = vsl_hash[0]['strRQNo']

        sql = "SELECT B.strVslName FROM [dbMPE].[dbo].tblWSQuoteHdr A INNER JOIN [dbMPE].[dbo].tblVesselInfo B
            ON A.strBuyRMSTPID = B.strRMSTPID AND A.strIMONo = B.strIMONo AND A.strVslCode = B.strVslCode
            WHERE A.strBuyRMSTPID = '#{strBuyRMSTPID}' AND A.strIMONo = '#{strIMONo}' AND A.strVslCode = '#{strVslCode}'"
        LoggerHelper.log_info('sendmail.log', sql, __FILE__, __LINE__)
        vslname_hash = SqlHelper.select_all('TPSQA', sql)


        sql = "SELECT B1.strEqptTitle FROM [dbMPE].[dbo].[tblWSQuoteHdr] A1 INNER JOIN [dbMPE].[dbo].[tblRQHeader] B1
            ON A1.strBuyRMSTPID = B1.strBuyRMSTPID AND A1.strIMONo = B1.strIMONo AND A1.strVslCode = B1.strVslCode AND A1.strRQNo = B1.strRQNo
            WHERE A1.strBuyRMSTPID = '#{strBuyRMSTPID}' AND A1.strIMONo = '#{strIMONo}' AND A1.strVslCode = '#{strVslCode}'
            AND A1.strRQNo = '#{strRQNo}'"
        LoggerHelper.log_info('sendmail.log', sql, __FILE__, __LINE__)
        eqp_hash = SqlHelper.select_all('TPSQA', sql)

        sql = "SELECT B.strCompName
            FROM [dbMPE].[dbo].[tblWSQuoteHdr] A INNER JOIN [dbMPEMultiparty].[dbo].[tblSuppliers ] B
            ON A.strBuyRMSTPID collate DATABASE_DEFAULT = B.strBuyRMSTPID
            AND A.strRMSTPID collate DATABASE_DEFAULT = B.strRMSTPID
            WHERE A.strBuyRMSTPID = '#{strBuyRMSTPID}' AND A.strRMSTPID = '#{strRMSTPID}'"
        LoggerHelper.log_info('sendmail.log', sql, __FILE__, __LINE__)
        compname_hash = SqlHelper.select_all('TPSQA', sql)

        if !compname_hash.empty?
          @strCompName = compname_hash[0]['strCompName']
        else
          @strCompName = 'No Supplier Name'
        end
        if !vslname_hash.empty?
          @strVslName = vslname_hash[0]['strVslName']
        else
          @strVslName = 'No Vessel Name'
        end
        if !eqp_hash.empty?
          @strEqptTitle = eqp_hash[0]['strEqptTitle']
        else
          @strEqptTitle = 'No Equipment Title'
        end

        LoggerHelper.log_info('sendmail.log', "Supplier: #{@strCompName}", __FILE__, __LINE__)
        LoggerHelper.log_info('sendmail.log', "VesselName: #{@strVslName}", __FILE__, __LINE__)
        LoggerHelper.log_info('sendmail.log', "EquipTitle: #{@strEqptTitle}", __FILE__, __LINE__)
      else
        @strCompName = 'TestSupplier'
        @strVslName = 'TestVessel'
        @strEqptTitle = 'TestEquipTitle'
      end
    rescue => ex
      LoggerHelper.log_error('sendmail.log', ex.to_s, __FILE__, __LINE__)
    end

    @rq_no = Quotes.where(:strQuotesNo => quote_no, :intQteVerNo => quote_ver).first.strRQNo
    @quote_ref_no = Quotes.where(:strQuotesNo => quote_no, :intQteVerNo => quote_ver).first.strSupRefNo
    if (@quote_ref_no.nil?) ||(@quote_ref_no.blank?)
      @quote_ref_no = 'No Supplier Quotation Reference'
    end
    @sup_remark = Quotes.where(:strQuotesNo => quote_no, :intQteVerNo => quote_ver).first.strSupRemark
    @quote_id = Quotes.where(:strQuotesNo => quote_no, :intQteVerNo => quote_ver).first.intID

    LoggerHelper.log_info('sendmail.log', "Requisition No: #{@rq_no}", __FILE__, __LINE__)
    LoggerHelper.log_info('sendmail.log', "Quote Ref No: #{@quote_ref_no}", __FILE__, __LINE__)
    LoggerHelper.log_info('sendmail.log', "Supplier Remark: #{@sup_remark}", __FILE__, __LINE__)
    LoggerHelper.log_info('sendmail.log', "Quote ID: #{@quote_id}", __FILE__, __LINE__)

    subject = "QuoteQA: #{@strVslName} - #{@rq_no} - #{@strCompName} - #{@quote_id.to_s}- #{@quote_ref_no}"
    #cmsam config the mail
    UserMailer.config_mail
    @quote_no = quote_no
    @quote_details = quote_details
    mail(:to => to_email,
         :cc => cc_mail,
         :subject => subject,
    ).deliver!

  end

  def test_mail
    to = 'cmsam@tma.com.vn'
    #to = 'rqatest1@wallem.com'
    UserMailer.config_mail
    mail(:to => to,
         :subject => 'test',
    ).deliver!
  end

  #cmsam get quoteNO and QuoteVer to send fail mail
  def get_quote_for_sending_mail
    sql = 'SELECT TOP 2 strQuotesNo, intQteVerNo FROM [tblTPSQAConfirmQuote]'
    sql << ' WHERE intMailedValue = 0'
    sql << ' GROUP BY strQuotesNo, intQteVerNo'
    result = SqlHelper.select_all('TPSQA', sql)
    result.each do |r|
      quote_no = r['strQuotesNo']
      quote_ver = r['intQteVerNo']
      quote_details = Quotes.get_quote_details(quote_no, quote_ver)
      begin
        UserMailer.send_mail(quote_no, quote_ver, quote_details)
        sql_update = 'UPDATE [TPS-QA].[dbo].[tblTPSQAConfirmQuote]'
        sql_update << ' SET intMailedValue = 1'
        sql_update << " WHERE strQuotesNo = '#{quote_no}'"
        SqlHelper.ExecuteCommand('TPSQA', sql_update)
      rescue => ex
        LoggerHelper.log_error('sendmail.log', ex.to_s, __FILE__, __LINE__)
      end
    end
  end

end
