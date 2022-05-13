# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'
require 'pg'

class Memo 
  def initialize
    @conn = PG.connect(dbname: 'memos')
  end

  def create(title, content)
    @conn.exec("INSERT INTO memos (title, content) VALUES('#{title}', '#{content}')")
  end

  def update(title, content, id)
    @conn.exec("UPDATE memos SET title ='#{title}', content ='#{content}' WHERE id =#{id}")
  end

  def select(id)
    @conn.exec("SELECT * FROM memos WHERE id = #{id}")
  end

  def delete(id)
    @conn.exec("DELETE FROM memos WHERE id = '#{id}'")
  end

  def get
    @conn.exec('SELECT * FROM memos')
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  detabase = Memo.new
  @memos = detabase.get
  erb :index
end

get '/memos/new' do
  @memos = Memo.new
  @memos.create("#{params['title']}", "#{params['content']}")
  erb :new
end

patch '/memos/:id' do
  detabase = Memo.new
  @memos = detabase.update(params['title'], params['content'], params['id'])
  redirect("/memos/#{params['id']}")
end

get '/memos/:id' do
  detabase = Memo.new
  @memos = detabase.select(params['id'])
  erb :detail
end

post '/memos' do
  detabase = Memo.new
  @memos = detabase.create(params['title'], params['content'])
  redirect('/memos')
end

get '/memos/file_not_found' do
  erb :file_not_found
end

get '/memos/:id/edit' do
  detabase = Memo.new
  @memos = detabase.select(params['id'])
  erb :edit
end

delete '/memos/:id' do
  detabase = Memo.new
  @memos = detabase.delete(params["id"])
  redirect('/memos')
end
