class MailConfig
  attr_accessor :mail_server_address,
                :mail_server_port,
                :mail_server_domain,
                :mail_server_username,
                :mail_server_password,
                :mail_server_enable_tls,
                :mail_from,
                :mail_from_debug,
                :mail_to,
                :mail_to_debug,
                :mail_cc,
                :mail_cc_debug,
                :mail_subject
  @smtp_mail_config = Rails.root.join('public/config/Mail_Config.xml').to_s


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def self.read_mail_server_config
    file = File.open(@smtp_mail_config)
    root = Nokogiri::XML(file)
    m = MailConfig.new(
        mail_server_address: root.xpath('//*//mail_server_address').text,
        mail_server_port: root.xpath('//*//mail_server_port').text,
        mail_server_domain: root.xpath('//*//mail_server_domain').text,
        mail_server_username: root.xpath('//*//mail_server_username').text,
        mail_server_password: root.xpath('//*//mail_server_password').text,
        mail_server_enable_tls: root.xpath('//*//mail_server_enable_tls').text,
        mail_from: root.xpath('//*//mail_from').text,
        mail_from_debug: root.xpath('//*//mail_from_debug').text,
        mail_to: root.xpath('//*//mail_to').text,
        mail_to_debug: root.xpath('//*//mail_to_debug').text,
        mail_cc: root.xpath('//*//mail_cc').text,
        mail_cc_debug: root.xpath('//*//mail_cc_debug').text)
    file.close
    m
  end

  def self.email
    file = File.open(@smtp_mail_config)
    root = Nokogiri::XML(file)
    m = MailConfig.new(
        mail_to: root.xpath('//*//mail_to').text,
        mail_subject: root.xpath('//*//mail_subject').text)
    file.close
    m
  end
end