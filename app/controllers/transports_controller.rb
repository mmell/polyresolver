class TransportsController < ApplicationController
  
  before_filter :get_player
  
  def get_player
    @player = Player.find( params[:player_id] )
    redirect_to(players_path) and return false unless @player
  end

  # GET /transports
  # GET /transports.xml
  def index
    @transports = @player.transports.all
    if @transports.empty?
      flash[:notice] = "You have no Transports yet."
      redirect_to(new_player_transport_path(@player)) and return 
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transports }
    end
  end

  # GET /transports/1
  # GET /transports/1.xml
  def show
    @transport = @player.transports.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transport }
    end
  end

  # GET /transports/new
  # GET /transports/new.xml
  def new
    @transport = Transport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transport }
    end
  end

  # GET /transports/1/edit
  def edit
    @transport = @player.transports.find(params[:id])
  end

  # POST /transports
  # POST /transports.xml
  def create
    raise RuntimeError, "bad transport type" unless Transport::Types.include?(params[:transport][:transport])
    @transport = Transport.new(params[:transport].merge( :player => @player ) )

    respond_to do |format|
      if @transport.save
        flash[:notice] = 'Transport was successfully created.'
        # url_for(:action => :edit, :player_id => @player.id, :id => @transport.id)
        format.html { redirect_to( player_transport_path(@player, @transport ) ) }
        format.xml  { render :xml => @transport, :status => :created, :location => @transport }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transport.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transports/1
  # PUT /transports/1.xml
  def update
    @transport = @player.transports.find(params[:id])

    respond_to do |format|
      if @transport.update_attributes(params[:transport])
        flash[:notice] = 'Transport was successfully updated.'
        format.html { redirect_to( player_transport_path(@player, @transport ) ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transport.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transports/1
  # DELETE /transports/1.xml
  def destroy
    @transport = @player.transports.find(params[:id])
    @transport.destroy

    respond_to do |format|
      format.html { redirect_to(player_transports_url(@player)) }
      format.xml  { head :ok }
    end
  end
end
