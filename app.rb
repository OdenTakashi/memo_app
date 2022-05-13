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

  def find(id)
    @conn.exec("SELECT * FROM memos WHERE id = #{id}")
  end

  def delete(id)
    @conn.exec("DELETE FROM memos WHERE id = '#{id}'")
  end

  def all
    @conn.exec('SELECT * FROM memos')
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  memo = Memo.new
  @memos = memo.all
  erb :index
end

get '/memos/new' do
  erb :new
end

patch '/memos/:id' do
  memo = Memo.new
  @memos = memo.update(h(params['title']), h(params['content']), params['id'])
  redirect("/memos/#{params['id']}")
end

get '/memos/:id' do
  memo = Memo.new
  @memos = memo.find(params['id'])
  erb :detail
end

post '/memos' do
  memo = Memo.new
  @memos = memo.create(h(params['title']), h(params['content']))
  redirect('/memos')
end

get '/memos/file_not_found' do
  erb :file_not_found
end

get '/memos/:id/edit' do
  memo = Memo.new
  @memos = memo.find(params['id'])
  erb :edit
end

delete '/memos/:id' do
  memo = Memo.new
  @memos = memo.delete(params["id"])
  redirect('/memos')
end
