# frozen_string_literal: true

require 'puppet/provider/asadmin'
Puppet::Type.type(:authrealm).provide(:asadmin, parent: Puppet::Provider::Asadmin) do
  desc 'Glassfish authentication realms support.'
  commands asadmin: Puppet::Provider::Asadmin.asadminpath.to_s

  def create
    args = []
    args << 'create-auth-realm'
    args << '--classname' << @resource[:classname]
    if hasProperties? @resource[:properties]
      args << '--property'
      args << "\"#{prepareProperties @resource[:properties]}\""
    end
    args << @resource[:name]
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << 'delete-auth-realm' << @resource[:name]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(['list-auth-realms']).each do |line|
      return true if @resource[:name] == line.split(' ')[0]
    end
    false
  end
end
