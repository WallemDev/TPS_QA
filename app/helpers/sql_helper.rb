module SqlHelper
  def self.ExecuteCommand(database, command)
    ActiveRecord::Base.establish_connection(database)
    result = ActiveRecord::Base.connection().execute(command)
    ActiveRecord::Base.connection().close
    result
  end

  def self.variable(key)
    ActiveRecord::Base.establish_connection('delayed_job')
    sql_cmd = "SELECT value FROM variables WHERE key = '#{key}'"
    val = ActiveRecord::Base.connection().execute(sql_cmd)
    ActiveRecord::Base.connection().close
    val[0][0]
  end

  def self.select_all(database, command)
    ActiveRecord::Base.establish_connection(database)
    result = ActiveRecord::Base.connection().select_all(command)
    ActiveRecord::Base.connection().close
    result
  end
end