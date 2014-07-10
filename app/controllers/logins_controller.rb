class LoginsController < ApplicationController
  # GET /logins
  # GET /logins.json
  def index
    session[:user_name]
    if !session[:user_name].nil?
      #authentication password
      redirect_to quotes_path
    end
  end

  # GET /logins/1
  # GET /logins/1.json
  def show

  end

  # GET /logins/new
  # GET /logins/new.json
  def new

  end

  # GET /logins/1/edit
  def edit

  end

  # POST /logins
  # POST /logins.json
  def create
    #@login = Login.new(params[:login])
    user_name = params[:login][:username]
    pass = params[:login][:password]
    if user_name.eql? 'admin' and pass.eql? 'admin'     #authentication user
      session[:user_name] = user_name
      session[:password] = pass
      redirect_to quotes_path
    else
      flash[:error] = 'Invalid Username or Password.'
      render 'logins/index'
    end
  end

  # PUT /logins/1
  # PUT /logins/1.json
  def update

  end

  # DELETE /logins/1
  # DELETE /logins/1.json
  def destroy
    #@login = Login.find(params[:id])
    #@login.destroy
    session[:user_name] = nil
    session[:password] = nil
    redirect_to logins_path
  end

  def home
    @logins = Login.new
    render 'logins/home'
  end

  # check login
  def check_login

  end
end
