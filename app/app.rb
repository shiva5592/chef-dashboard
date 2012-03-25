require 'sinatra'
require 'yajl'

require 'dashboard'
require 'db'

$db = Chef::Dashboard::DB.new("sqlite://dashboard.db")

set :haml, :layout => :application_layout

get '/' do
  @nodes = Node.reporting_nodes.all
  p @nodes
  @success, @failure = @nodes.partition(&:last_run_success?)

  @last_node = @nodes.sort_by { |x| x.last_report.created_at }.last

  p @last_node

  haml :index
end

get '/nodes' do
  haml :nodes
end

put '/report' do
  Node.create_report(Yajl.load(request.body.read))
  return 200
end
