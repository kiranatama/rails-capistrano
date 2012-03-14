class FrooblesController < ApplicationController
  # GET /froobles
  # GET /froobles.json
  def index
    @froobles = Frooble.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @froobles }
    end
  end

  # GET /froobles/1
  # GET /froobles/1.json
  def show
    @frooble = Frooble.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @frooble }
    end
  end

  # GET /froobles/new
  # GET /froobles/new.json
  def new
    @frooble = Frooble.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @frooble }
    end
  end

  # GET /froobles/1/edit
  def edit
    @frooble = Frooble.find(params[:id])
  end

  # POST /froobles
  # POST /froobles.json
  def create
    @frooble = Frooble.new(params[:frooble])

    respond_to do |format|
      if @frooble.save
        format.html { redirect_to @frooble, notice: 'Frooble was successfully created.' }
        format.json { render json: @frooble, status: :created, location: @frooble }
      else
        format.html { render action: "new" }
        format.json { render json: @frooble.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /froobles/1
  # PUT /froobles/1.json
  def update
    @frooble = Frooble.find(params[:id])

    respond_to do |format|
      if @frooble.update_attributes(params[:frooble])
        format.html { redirect_to @frooble, notice: 'Frooble was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @frooble.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /froobles/1
  # DELETE /froobles/1.json
  def destroy
    @frooble = Frooble.find(params[:id])
    @frooble.destroy

    respond_to do |format|
      format.html { redirect_to froobles_url }
      format.json { head :no_content }
    end
  end
end
