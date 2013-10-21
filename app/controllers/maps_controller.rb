class MapsController < ApplicationController

  # GET /maps/:short_url
  def zession
    unless session_is_alive
      reset_session
      redirect_to root_url
      return
    end

    session[:short_url] ||= params[:short_url]
    session[:uuid]      ||= UUIDTools::UUID.random_create.to_s

    participants = session_participants_by_uuid
    participants << session[:uuid] unless participants.include?(session[:uuid])

    # update participants list
    $redis.setex("#{key}/participants", expr, ActiveSupport::JSON.encode(participants))
  end

  def create
    begin
      short_url = unique_url
      short_url_key = "smokesignals/short_url/#{short_url}"
    end while $redis.get(short_url_key)

    $redis.setex(short_url_key, expr, [])

    redirect_to map_path(:short_url => short_url)
  end

  def update_my_location
    if $redis.get("#{key}/participants/#{session[:uuid]}")
      $redis.setex("#{key}/participants/#{session[:uuid]}", expr, params[:location])
    end

    broadcast("/locations/new", params[:location])

    head :ok
  end

  private
  def broadcast(channel, message)
    message = {:channel => channel, :data => message}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def session_is_alive
    $redis.get("smokesignals/short_url/#{params[:short_url]}")
  end

  def session_participants_by_uuid
    ActiveSupport::JSON.decode($redis.get("#{key}/participants") || '[]')
  end

  def expr
    @expr ||= 1.day.to_i
  end

  def key
    "smokesignals/channel/#{params[:short_url]}"
  end

end
