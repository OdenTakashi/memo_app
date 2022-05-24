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
    @conn.exec_params('INSERT INTO memos (title, content) VALUES($1, $2)', [title, content])
  end

  def update(title, content, id)
    @conn.exec_params('UPDATE memos SET title =$1, content =$2 WHERE id =$3', [title, content, id])
  end

  def find(id)
    @conn.exec_params('SELECT * FROM memos WHERE id =$1', [id])
  end

  def delete(id)
    @conn.exec('DELETE FROM memos WHERE id =$1', [id])
  end

  def all
    @conn.exec('SELECT * FROM memos ORDER BY id ASC')
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

not_found do
  'ファイルが存在しません'
end

get '/memos/deta_not_found' do
  erb :deta_not_found
end

get '/memos/:id' do
  memo = Memo.new
  count = memo.find(params['id']).ntuples
  redirect('/memos/deta_not_found') if count.zero?
  @memo = memo.find(params['id'])
  erb :detail
end

post '/memos' do
  memo = Memo.new
  @memos = memo.create(h(params['title']), h(params['content']))
  redirect('/memos')
end

get '/memos/:id/edit' do
  memo = Memo.new
  count = memo.find(params['id']).ntuples
  redirect('/memos/deta_not_found') if count.zero?
  @memos = memo.find(params['id'])
  erb :edit
end

delete '/memos/:id' do
  memo = Memo.new
  @memos = memo.delete(params['id'])
  redirect('/memos')
end
