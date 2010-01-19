class PeersController < ApplicationController
  before_filter :get_player
  
  def get_player
    @player = Player.find( params[:player_id] )
    redirect_to(players_path) and return false unless @player
  end

  # GET /peers
  # GET /peers.xml
  def index
    @peers = @player.peers.all
    if @peers.empty?
      flash[:notice] = "You have no Peers yet."
      redirect_to(new_player_peer_path(@player)) and return
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @peers }
    end
  end

  # GET /peers/1
  # GET /peers/1.xml
  def show
    @peer = @player.peers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @peer }
    end
  end

  # GET /peers/new
  # GET /peers/new.xml
  def new
    @peer = Peer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @peer }
    end
  end

  # GET /peers/1/edit
  def edit
    @peer = @player.peers.find(params[:id])
  end

  # POST /peers
  # POST /peers.xml
  def create
    @peer = @player.peer_from_peer_url(params[:peer_url] )

    respond_to do |format|
      if @peer.save
        flash[:notice] = 'Peer was successfully created.'
        format.html { redirect_to( player_peer_path(@player, @peer)) }
        format.xml  { render :xml => @peer, :status => :created, :location => @peer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @peer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /peers/1
  # PUT /peers/1.xml
  def update
    @peer = @player.peers.find(params[:id])

    respond_to do |format|
      if @peer.update_attributes(params[:peer])
        flash[:notice] = 'Peer was successfully updated.'
        format.html { redirect_to(player_peer_path(@player, @peer)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @peer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /peers/1
  # DELETE /peers/1.xml
  def destroy
    @peer = @player.peers.find(params[:id])
    @peer.destroy

    respond_to do |format|
      format.html { redirect_to(player_peers_url(@player)) }
      format.xml  { head :ok }
    end
  end
end
