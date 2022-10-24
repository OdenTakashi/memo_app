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

  def get_file_path(id)
    "./db/memos_#{id}.json"
  end

  def open_file(path)
    return unless File.exist?(path)
    File.open(path) {|file| JSON.parse(file.read)}
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
  file_path = get_file_path(params[:id])
  File.open(file_path, 'w') do |f|
    memo = {
      'id' => params['id'],
      'title' => h(params['title']),
      'content' => h(params['content']),
      'time' => Time.now.strftime('%Y-%m-%d %H:%M:%S')
    }
    JSON.dump(memo, f)
  end
  redirect("/memos/#{params['id']}")
end

get '/memos/file_not_found' do
  erb :file_not_found
end

get '/memos/:id' do
  file_path = get_file_path(params[:id])
  memo = open_file(file_path)
  redirect('/memos/file_not_found') if memo.nil?
  @id = memo['id']
  @title = memo['title']
  @content = memo['content']
  @time = memo['time']
>>>>>>> 3ea9d0caa9a0d29f40e638967e91c70389e1a849
  erb :detail
end

post '/memos' do
<<<<<<< HEAD
  memo = Memo.new
  @memos = memo.create(params['title'], params['content'])
=======
  memo = {
    'id' => SecureRandom.uuid,
    'title' => h(params['title']),
    'content' => h(params['content']),
    'time' => Time.now.strftime('%Y-%m-%d %H:%M:%S')
  }
  File.open("./db/memos_#{memo['id']}.json", 'w') do |f|
    JSON.dump(memo, f)
  end
>>>>>>> 3ea9d0caa9a0d29f40e638967e91c70389e1a849
  redirect('/memos')
end

get '/memos/:id/edit' do
<<<<<<< HEAD
  memo = Memo.new
  count = memo.find(params['id']).ntuples
  status 404 if count.zero?
  @memos = memo.find(params['id'])
=======
  file_path = get_file_path(params[:id])
  memo = open_file(file_path)
  redirect('/memos/file_not_found') if memo.nil?
  @id = memo['id']
  @title = memo['title']
  @content = memo['content']
>>>>>>> 3ea9d0caa9a0d29f40e638967e91c70389e1a849
  erb :edit
end

delete '/memos/:id' do
  memo = Memo.new
  @memos = memo.delete(params['id'])
  redirect('/memos')
end
