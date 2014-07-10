class SendMailJob < Struct.new(:param)
  require 'timeout'

  def perform
    #UserMailer.send_mail('cmsam@tma.com.vn', 'test delayed_job')
    #puts 'test'
    #mail = MailConfig.email
    #mail_to = mail.mail_to
    #mail_subject = mail.mail_subject
    #UserMailer.send_mail(mail_to, mail_subject)
    GC.start
    time_out = 300
    begin
      Timeout.timeout(time_out) do
        begin
          UserMailer.get_quote_for_sending_mail
        rescue => ex
          LoggerHelper.log_error('sendmail_bg.log', ex.to_s, __FILE__, __LINE__)
        end
      end
    rescue Timeout::Error => ex
      LoggerHelper.log_error('sendmail_bg.log', ex.to_s, __FILE__, __LINE__)
    end
  end
end
