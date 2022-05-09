# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def get_file_path(id)
    "./db/memos_#{id}.json"
  end
end

get '/memos' do
  files = Dir.glob('./db/*.json')
  @memos = files.map do |file|
    JSON.parse(File.open(file).read)
  end
  erb :index
end

get '/memos/new' do
  erb :new
end

patch '/memos/:id' do
  file_path = get_file_path(params[:id])
  File.open(file_path.to_s, 'w') do |f|
    memo = {
      'id' => params['id'],
      'title' => h(params['title']),
      'content' => h(params['content']),
      'time' => Time.now.strftime("%Y-%m-%d %H:%M:%S")
    }
    JSON.dump(memo, f)
  end
  redirect("/memos/#{params['id']}")
end

get '/memos/:id' do
  file_path = get_file_path(params[:id])
  if File.exist?(file_path)
    (memo = File.open(file_path) do |file|
       JSON.parse(file.read)
     end)
  else
    redirect('/memos/file_not_found')
  end
  @id = memo['id']
  @title = memo['title']
  @content = memo['content']
  @time = memo['time']
  erb :detail
end

post '/memos' do
  memo = {
    'id' => SecureRandom.uuid,
    'title' => h(params['title']),
    'content' => h(params['content']),
    'time' => Time.now.strftime("%Y-%m-%d %H:%M:%S")
  }
  File.open("./db/memos_#{memo['id']}.json", 'w') do |f|
    JSON.dump(memo, f)
  end
  redirect('/memos')
end

get '/memos/file_not_found' do
  erb :file_not_found
end

get '/memos/:id/edit' do
  file_path = get_file_path(params[:id])
  if File.exist?(file_path)
    (memo = File.open(file_path) do |file|
       JSON.parse(file.read)
     end)
  else
    redirect('/memos/file_not_found')
  end
  @id = memo['id']
  @title = memo['title']
  @content = memo['content']
  erb :edit
end

delete '/memos/:id' do
  file_path = get_file_path(params[:id])
  File.delete(file_path)
  redirect('/memos')
end
