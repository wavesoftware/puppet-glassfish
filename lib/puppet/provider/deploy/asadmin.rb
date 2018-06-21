# frozen_string_literal: true

require 'puppet/provider/asadmin'
Puppet::Type.type(:deploy).provide(:asadmin, parent: Puppet::Provider::Asadmin) do
  desc 'Glassfish application deployment support.'
  commands asadmin: Puppet::Provider::Asadmin.asadminpath.to_s

  def create
    args = []
    args << 'deploy' << '--precompilejsp=true'
    unless @resource[:contextroot] == ''
      args << '--contextroot' << @resource[:contextroot]
    end
    args << '--name' << @resource[:name]
    args << @resource[:source]
    asadmin_exec(args)
  end

  def destroy
    args = []
    args << 'undeploy' << @resource[:name]
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(['list-applications']).each do |line|
      return true if @resource[:name] == line.split(' ')[0]
    end
    false
  end
end
