# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

# TOP
get '/' do
  memos = JSON.parse(File.read('data.json'))
  selected_memos = memos.reject { |element| element['status'] == 'deleted' }
  erb :index, locals: { 'memos' => selected_memos }
end

# CREATE MEMO
get '/memos/create' do
  erb :create
end

# SHOW MEMO
get '/memos/:memo' do
  memos = JSON.parse(File.read('data.json'))
  index = memos.index { |element| element['id'] == params[:memo].to_i }
  erb :show, locals: { 'memo' => memos[index] }
end

# EDIT MEMO
get '/memos/:memo/edit' do
  memos = JSON.parse(File.read('data.json'))
  index = memos.index { |element| element['id'] == params[:memo].to_i }
  erb :edit, locals: { 'memo' => memos[index] }
end

# STORE MEMO
post '/memos' do
  memos = JSON.parse(File.read('data.json'))
  memos.push(
    {
      'id' => memos.count + 1,
      'title' => params[:title],
      'content' => params[:content],
      'status' => 'active'
    }
  )
  File.open('data.json', 'w') { |f| f.puts memos.to_json }
  redirect '/'
end

# UPDATE MEMO
patch '/memos/:memo' do
  memos = JSON.parse(File.read('data.json'))
  index = memos.index { |element| element['id'] == params[:memo].to_i }
  memos[index]['title'] = params[:title]
  memos[index]['content'] = params[:content]
  File.open('data.json', 'w') { |f| f.puts memos.to_json }
  redirect "/memos/#{memos[index]['id']}"
end

# DELETE MEMO
delete '/memos/:memo' do
  memos = JSON.parse(File.read('data.json'))
  index = memos.index { |element| element['id'] == params[:memo].to_i }
  memos[index]['status'] = 'deleted'
  File.open('data.json', 'w') { |f| f.puts memos.to_json }
  redirect '/'
end
