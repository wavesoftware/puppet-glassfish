# frozen_string_literal: true

class Puppet::Provider::Asadmin < Puppet::Provider
  def self.asadminpath
    asadmin = '/usr/bin/asadmin'
    asadmin
  end

  def asadmin_exec(passed_args)
    port = @resource[:portbase].to_i + 48
    args = []
    args << '--port' << port.to_s
    args << '--user' << @resource[:asadminuser]
    args << '--passwordfile' << @resource[:passwordfile] if @resource[:passwordfile] &&
                                                            !@resource[:passwordfile].empty?
    passed_args.each { |arg| args << arg }
    exec_args = args.join ' '
    path = Puppet::Provider::Asadmin.asadminpath
    command = "#{path} #{exec_args}"
    Puppet.debug("Command = #{command}")
    command = "su - #{@resource[:user]} -c \"#{command}\"" if @resource[:user] &&
                                                              !command.match(/create-service/)
    debug command
    result = `#{command}`
    raise result unless $CHILD_STATUS == 0
    result
  end

  def escape(value)
    # Add three backslashes to escape the colon
    value.gsub(/:/) { '\\:' }
  end

  def exists?
    commands asadmin: @@asadmin.to_s
    version = asadmin('version')
    return false if version.empty?

    version.each do |line|
      if line =~ /(Version)/
        return true
      else
        return false
      end
    end
  end

  protected

  def hasProperties?(props)
    return !props.to_s.empty? unless props.nil?
    false
  end

  def prepareProperties(properties)
    return properties if properties.is_a? String
    return properties.join ':' if properties.is_a? Array
    return properties.to_s unless properties.is_a? Hash
    list = []
    properties.each do |key, value|
      rkey = key.to_s.gsub(/([=:])/, '\\\\\\1')
      rvalue = value.to_s.gsub(/([=:])/, '\\\\\\1')
      list << "#{rkey}=#{rvalue}"
    end
    list.join ':'
  end
end
