# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

# TOP
get '/' do
  memos = File.read('data.json')
  erb :index, locals: { 'memos' => JSON.parse(memos) }
end

# CREATE MEMO
get '/memos/create' do
  erb :create
end

# SHOW MEMO
get '/memos/:memo' do
  memos = JSON.parse(File.read('data.json'))
  erb :show, locals: { 'memo' => memos[params[:memo].to_i], index: params[:memo].to_i }
end

# EDIT MEMO
get '/memos/:memo/edit' do
  memos = JSON.parse(File.read('data.json'))
  erb :edit, locals: { 'memo' => memos[params[:memo].to_i], index: params[:memo].to_i }
end

# STORE MEMO
post '/memos' do
  memos = JSON.parse(File.read('data.json'))
  memos.push({ 'title' => params[:title], 'content' => params[:content] })
  File.open('data.json', 'w') { |f| f.puts memos.to_json }
  redirect '/'
end

# UPDATE MEMO
patch '/memos/:memo' do |i|
  memos = JSON.parse(File.read('data.json'))
  memos[i.to_i]['title'] = params[:title]
  memos[i.to_i]['content'] = params[:content]
  File.open('data.json', 'w') { |f| f.puts memos.to_json }
  redirect "/memos/#{i}"
end

# DELETE MEMO
delete '/memos/:memo' do |i|
  memos = JSON.parse(File.read('data.json'))
  memos.delete_at(i.to_i)
  File.open('data.json', 'w') { |f| f.puts memos.to_json }
  redirect '/'
end
