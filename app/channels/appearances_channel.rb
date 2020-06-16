class AppearancesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearances_channel"
  end

  def unsubscribed
    stop_all_streams
  end
  # def subscribed
  #   redis.set("user_#{current_user.id}_online", "1")
  #   stream_from("appearances_channel")
  #   ActionCable.server.broadcast "appearances_channel",
  #                                user_id: current_user,
  #                                online: true
  # end

  # def unsubscribed
  #   redis.del("user_#{current_user.id}_online")
  #   ActionCable.server.broadcast "appearances_channel",
  #                                user_id: current_user,
  #                                online: false
  # end

  # private

  # def redis
  #   Redis.new
  # end
end
