module LoggerHelper
  require 'logger'

  def self.backup_log
    max_log_size  = 10.megabytes
    $arrays_name  = ['auto_upload.log','catalog.log','development.log','dj.log',
                     'emergency_update_version.log','req_save_requisition_item.log','rqa.log',
                     'tracking_mail.log','tracking_version.log','upload_csv.log','upload_rmt.log']
    $arrays_name.each do |element|
      $path_file_log =  File.join(Rails.root,'log',"#{element}")
      if(File.exist?($path_file_log))
        if (File.size($path_file_log).to_i >max_log_size)
          $folder_path = File.join(Rails.root,'log')
          current_date = DateTime.now.strftime('%Y%m%d%H%M%S')
          new_name_log = element +'__' + current_date
          begin
            $path_file_blank  = File.join(Rails.root,'log','blank.log')
            LoggerHelper.log_info('rqa.log', 'Backup Log File '+element, __FILE__, __LINE__)
            if(!File.exist?($path_file_blank))
              File.write($path_file_blank,'')
            end
            FileUtils.copy_file($path_file_log,$folder_path+"/"+new_name_log)
            FileUtils.copy_file($path_file_blank, $path_file_log)
          rescue => ex
            LoggerHelper.log_error('rqa.log', ex.message, __FILE__, __LINE__)
          end
        end
      end
    end
  end

  def self.delete_log
    max_date_delete = 90
    $list_file_log = Dir[File.join(Rails.root,'log')+'/*'];
    $list_file_log.each do |element|
      file_name = File.basename(element)
      if(file_name.include?'__')
        string_old_date = file_name.split('__')[1]
        old_date =     Date.strptime(string_old_date,'%Y%m%d%H%M%S')
        current_date  = Date.today
        distance_date = (current_date-old_date).to_i
        if(distance_date>max_date_delete)
          begin
            LoggerHelper.log_info('rqa.log', 'Delete Log File '+element, __FILE__, __LINE__)
            File.delete(element)
          rescue => ex
            LoggerHelper.log_error('rqa.log', ex.message, __FILE__, __LINE__)
          end
        end
      end
    end
  end

  def self.log_error(log_file_name, message, src_file = __FILE__, log_line = __LINE__)
    logger = Logger.new(File.join(Rails.root, 'log', "#{log_file_name}"))
    logger.datetime_format = '%Y-%m-%d %H:%M:%S'
    logger.error('ERROR - ' + '(' + Time.now.to_s + ') ' + src_file.to_s + ' - line ' + log_line.to_s + ': ' + message)
    logger.close
  end

  def self.log_fatal(log_file_name, message, src_file = __FILE__, log_line = __LINE__)
    logger = Logger.new(File.join(Rails.root, 'log', "#{log_file_name}"))
    logger.datetime_format = '%Y-%m-%d %H:%M:%S'
    logger.fatal('FATAL - ' + '(' + Time.now.to_s + ') ' + src_file.to_s + ' - line ' + log_line.to_s + ': ' + message)
    logger.close
  end

  def self.log_info(log_file_name, message, src_file = __FILE__, log_line = __LINE__)
    logger = Logger.new(File.join(Rails.root, 'log', "#{log_file_name}"))
    logger.datetime_format = '%Y-%m-%d %H:%M:%S'
    logger.info('INFO - ' + '(' + Time.now.to_s + ') ' + src_file.to_s + ' - line ' + log_line.to_s + ': ' + message)
    logger.close
  end

  def self.log_debug(log_file_name, message, src_file = __FILE__, log_line = __LINE__)
    logger = Logger.new(File.join(Rails.root, 'log', "#{log_file_name}"))
    logger.datetime_format = '%Y-%m-%d %H:%M:%S'
    logger.debug('DEBUG - ' + '(' + Time.now.to_s + ') ' + src_file.to_s + ' - line ' + log_line.to_s + ': ' + message)
    logger.close
  end

  def self.log_warn(log_file_name, message, src_file = __FILE__, log_line = __LINE__)
    logger = Logger.new(File.join(Rails.root, 'log', "#{log_file_name}"))
    logger.datetime_format = '%Y-%m-%d %H:%M:%S'
    logger.warn('WARN - ' + '(' + Time.now.to_s + ') ' + src_file.to_s + ' - line ' + log_line.to_s + ': ' + message)
    logger.close
  end

end