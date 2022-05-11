# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def get_file_path(id)
    "./db/memos_#{id}.json"
  end
end

get '/memos' do
  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec("SELECT * FROM memos")
  erb :index
end

get '/memos/new' do
  erb :new
end

patch '/memos/:id' do
  conn = PG.connect(dbname: 'memos')
  conn.exec("UPDATE memos SET title = '#{params['title']}', content = '#{params['content']}' WHERE id = #{params['id']}")
  redirect("/memos/#{params['id']}")
end

get '/memos/:id' do
  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec("SELECT * FROM memos WHERE id = #{params['id']}")
  erb :detail
end

post '/memos' do
  conn = PG.connect(dbname: 'memos')
  conn.exec("INSERT INTO memos (title, content) VALUES('#{params['title']}', '#{params['content']}')")
  redirect('/memos')
end

get '/memos/file_not_found' do
  erb :file_not_found
end

get '/memos/:id/edit' do
  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec("SELECT * FROM memos WHERE id = #{params['id']}")
  erb :edit
end

delete '/memos/:id' do
  conn = PG.connect(dbname: 'memos')
  conn.exec("DELETE FROM memos WHERE id = '#{params['id']}'")
  redirect('/memos')
end
