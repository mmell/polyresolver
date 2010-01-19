class ResolversController < ApplicationController
  protect_from_forgery :except => [:authenticate_end_point] 
  
  def resolve
    player = Player.find_by_signifier(params[:id])
    render(:text => 'Player not found', :layout => false, :status => :unprocessable_entity) and return unless player
    render(:text => player.public_key, :layout => false)
  end
  
  def authenticate_end_point
    player = Player.find_by_public_key(params[:public_key])
    render(:text => 'Public Key not found', :layout => false, :status => :unprocessable_entity) and return unless player
    render(:text => player.sign(params[:token]), :layout => false)
  end
  
=begin
  # GET /resolvers
  # GET /resolvers.xml
  def index
    @resolvers = Resolver.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resolvers }
    end
  end

  # GET /resolvers/1
  # GET /resolvers/1.xml
  def show
    @resolver = Resolver.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resolver }
    end
  end

  # GET /resolvers/new
  # GET /resolvers/new.xml
  def new
    @resolver = Resolver.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resolver }
    end
  end

  # GET /resolvers/1/edit
  def edit
    @resolver = Resolver.find(params[:id])
  end

  # POST /resolvers
  # POST /resolvers.xml
  def create
    @resolver = Resolver.new(params[:resolver])

    respond_to do |format|
      if @resolver.save
        flash[:notice] = 'Resolver was successfully created.'
        format.html { redirect_to(@resolver) }
        format.xml  { render :xml => @resolver, :status => :created, :location => @resolver }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resolver.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resolvers/1
  # PUT /resolvers/1.xml
  def update
    @resolver = Resolver.find(params[:id])

    respond_to do |format|
      if @resolver.update_attributes(params[:resolver])
        flash[:notice] = 'Resolver was successfully updated.'
        format.html { redirect_to(@resolver) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resolver.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resolvers/1
  # DELETE /resolvers/1.xml
  def destroy
    @resolver = Resolver.find(params[:id])
    @resolver.destroy

    respond_to do |format|
      format.html { redirect_to(resolvers_url) }
      format.xml  { head :ok }
    end
  end
=end

end
