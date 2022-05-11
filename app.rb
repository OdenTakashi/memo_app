# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'
require 'pg'

before do
  @conn = PG.connect(dbname: 'memos')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def select(id)
    @conn.exec("SELECT * FROM memos WHERE id = #{id}")
  end
end

get '/memos' do
  @memos = @conn.exec('SELECT * FROM memos')
  erb :index
end

get '/memos/new' do
  erb :new
end

patch '/memos/:id' do
  @conn.exec("UPDATE memos SET title ='#{params['title']}', content ='#{params['content']}' WHERE id =#{params['id']}")
  redirect("/memos/#{params['id']}")
end

get '/memos/:id' do
  @memos = select(params['id'])
  erb :detail
end

post '/memos' do
  @conn.exec("INSERT INTO memos (title, content) VALUES('#{params['title']}', '#{params['content']}')")
  redirect('/memos')
end

get '/memos/file_not_found' do
  erb :file_not_found
end

get '/memos/:id/edit' do
  @memos = select(params['id'])
  erb :edit
end

delete '/memos/:id' do
  @conn.exec("DELETE FROM memos WHERE id = '#{params['id']}'")
  redirect('/memos')
end
