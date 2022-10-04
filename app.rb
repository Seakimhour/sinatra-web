# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

# Database Schema
# CREATE DATABASE memos;
# CREATE TABLE memo (
#     id BIGSERIAL NOT NULL PRIMARY KEY,
#     title VARCHAR(200) NOT NULL,
#     content VARCHAR(250) NOT NULL
# );

# Connections to the DB
conn = PG.connect(dbname: 'memos')
conn.prepare('get_memo', 'SELECT * FROM memo WHERE id = $1')
conn.prepare('store_memo', 'INSERT INTO memo (title, content) VALUES ($1, $2)')
conn.prepare('update_memo', 'UPDATE memo SET title = $1, content = $2 Where id = $3')
conn.prepare('delete_memo', 'DELETE FROM memo Where id = $1')

# TOP
get '/' do
  memos = conn.exec('SELECT * FROM memo')
  erb :index, locals: { 'memos' => memos }
end

# CREATE MEMO
get '/memos/create' do
  erb :create
end

# SHOW MEMO
get '/memos/:memo' do
  memo = conn.exec_prepared('get_memo', [params[:memo]])
  erb :show, locals: { 'memo' => memo[0] }
end

# EDIT MEMO
get '/memos/:memo/edit' do
  memo = conn.exec_prepared('get_memo', [params[:memo]])
  erb :edit, locals: { 'memo' => memo[0] }
end

# STORE MEMO
post '/memos' do
  conn.exec_prepared('store_memo', [params[:title], params[:content]])
  redirect '/'
end

# UPDATE MEMO
patch '/memos/:memo' do
  conn.exec_prepared('update_memo', [params[:title], params[:content], params[:memo]])
  redirect "/memos/#{params[:memo]}"
end

# DELETE MEMO
delete '/memos/:memo' do
  conn.exec_prepared('delete_memo', [params[:memo]])
  redirect '/'
end
