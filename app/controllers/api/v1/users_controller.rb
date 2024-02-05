class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.to_json(:only => ['id', 'name', 'email', 'neighborhoods', 'show_attending'])
  end

  def attending    
    user_id = current_user ? current_user.id : 0
    
    events = Event.left_outer_joins(:attendees)
      .select("events.*, COUNT(attendees.id) as attendee_count, TRUE as attending")
    events = events.where('start_date >= ?', DateTime.now)
    events = events.where("EXISTS(SELECT * FROM attendees WHERE attendees.user_id = #{user_id} AND attendees.event_id = events.id)")
    events = events.group('events.id')
    events = events.order('events.start_date DESC')
    render json: events.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'cancelled', 'attendee_count', 'owned', 'attending'])
  end

  # def update
  #   if params[:current_password].blank?
  #     resource.update_without_password(params.except(:current_password))
  #    else
  #      resource.update_with_password(params)
  #    end
  # end
end
