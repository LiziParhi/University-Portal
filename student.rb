require 'sinatra'
require 'dm-core'
require 'dm-migrations'
require 'slim'
require 'data_mapper'

class Student
  include DataMapper::Resource
  property :id, Serial, :required => true
  property :name, Text
  property :age, Integer
  property :address, Text
  property :birthday, DateTime
  property :major , Text
  property :guardian, Text

  def birthday=date
    super Date.strptime(date,'%m/%d/%Y')
  end
end

configure do
  enable :sessions
  set :username, 'lizi'
  set :password, 'parhi'
end


DataMapper.finalize


get '/students' do
      halt(401,'You are not authorized!') unless session[:admin]

  @student = Student.all
  slim :students
end


get '/students/new' do
    halt(401,'You are not authorized!') unless session[:admin]

  @student = Student.new
  slim :new_student
end

get '/students/:id' do
      halt(401,'You are not authorized!') unless session[:admin]

  @student = Student.get(params[:id])
  slim :show_student
end

get '/students/:id/edit' do
      halt(401,'You are not authorized!') unless session[:admin]

  @student = Student.get(params[:id])
  slim :edit_student
end

post '/students' do 
    halt(401,'Not Authorized') unless session[:admin]

  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
      halt(401,'Not Authorized') unless session[:admin]

  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
      halt(401,'Not Authorized') unless session[:admin]

  Student.get(params[:id]).destroy
  redirect to('/students')
end
