class BartendersController < ApplicationController

  before_action :set_bartender, only: [:show, :edit, :update, :destroy]
  before_filter :check_permissions, :only => [:edit, :update, :destroy]

  # GET /bartenders
  def index

    limit = 100
    if params[:limit]
      limit = params[:limit]
    end

    @bartenders = Bartender.top_bartenders(limit)

    if(params[:search])
      @bartenders = @bartenders.joins(:user).where("lower(bar) like lower('%#{params[:search]}%') or lower(users.name) like lower('%#{params[:search]}%')")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bartenders }
    end

  end

  # GET /bartenders/1
  def show
  end

  # GET /bartenders/new
  def new
    @bartender = Bartender.new

    if params[:user_id]
      @bartender.user_id = params[:user_id]
    end

  end

  # GET /bartenders/1/edit
  def edit
  end

  # POST /bartenders
  def create
    @bartender = Bartender.new(bartender_params)

    if @bartender.save
      redirect_to @bartender, notice: 'Bartender was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bartenders/1
  def update
    if @bartender.update(bartender_params)
      redirect_to @bartender, notice: 'Bartender was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bartenders/1
  def destroy
    @bartender.destroy
    redirect_to bartenders_url, notice: 'Bartender was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bartender
      @bartender = Bartender.find(params[:id])
    end


  # Only allow a trusted parameter "white list" through.
  def bartender_params
    params.require(:bartender).permit(:bar, :user_id, :is_working, :background)
  end

  def check_permissions
    redirect_to(root_path, :flash => {:success =>"You Don't Have Access"}) unless  current_user and (current_user.admin or current_user.bartender == @bartender)
  end

end
