# frozen_string_literal: true

Puppet::Type.newtype(:deploy) do
  @doc = 'Manage deployment of applications on Glassfish domains'
  ensurable

  newparam(:name) do
    desc 'The application name.'
    isnamevar
  end

  newparam(:contextroot) do
    desc 'The URL context root.'
    defaultto ''
  end

  newparam(:source) do
    desc 'The WAR file.'
  end

  newparam(:portbase) do
    desc 'The Glassfish domain port base. Default: 4800'
    defaultto '4800'
  end

  newparam(:asadminuser) do
    desc 'The internal Glassfish user asadmin uses. Default: admin'
    defaultto 'admin'
  end

  newparam(:passwordfile) do
    desc 'The file containing the password for the user.'

    validate do |value|
      unless File.exist? value
        raise ArgumentError, format('%s does not exists', value)
      end
    end
  end

  newparam(:user) do
    desc 'The user to run the command as.'

    validate do |_user|
      unless Puppet.features.root?
        raise 'Only root can execute commands as other users'
      end
    end
  end
end
