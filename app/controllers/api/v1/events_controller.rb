class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  # GET /v1/events
  def index
    user_id = current_user ? current_user.id : 0
    
    if (params[:u].present? && params[:u] != user_id.to_s)
      render json: { 
        status: 401,
        error: 'You cannot view other users events.',
      }, status: :unauthorized
    else
      events = Event.left_outer_joins({:attendees => :user})
        .select("events.*, coalesce(json_agg((select * from (select users.name where users.show_attending = true) as name)) filter (where users.show_attending = true)) as attendee_names, COUNT(attendees.id) as attendee_count, CAST(CASE WHEN events.user_id = #{user_id} THEN true ELSE false END AS BOOLEAN) as owned, EXISTS(SELECT * FROM attendees WHERE attendees.user_id = #{user_id} AND attendees.event_id = events.id) as attending")
      events = events.where('start_date >= ?', DateTime.now) if params[:u].nil?
      events = events.where('events.user_id = ?', params[:u]) if params[:u].present? && user_id.to_s == params[:u]
      events = events.where('neighborhood = ?', params[:n]) if params[:n].present?
      events = events.group('events.id')
      events = events.order('events.start_date ASC')
      
      if user_id > 0
        render json: events.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'cancelled', 'attendee_count', 'owned', 'attending', 'attendee_names'])
      else
        render json: events.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'cancelled', 'attendee_count'])
      end
    end
  end

  # POST /v1/events
  def create
    event = current_user.events.new(event_params)

    if event.save
      render json: event.to_json
    else
      render json: event.errors.to_json
    end
  end

  # GET /v1/events/:id
  def show
    user_id = current_user ? current_user.id : 0
    event = Event.find(params[:id])
    if (user_id === event.user_id)
      render json: event.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'cancelled'])
    else
      render json: { 
        status: 401,
        error: 'You do not own this event.',
      }, status: :unauthorized
    end
  end

  # PATCH /v1/events/:id
  def update
    event = Event.find(params[:id])

    if event.update(event_params)
      render json: event.to_json
    else
      render json: event.errors.to_json
    end
  end

  # DELETE /v1/events/:id
  def destroy
    event = Event.find(params[:id])
    event.destroy

    render json: event.to_json
  end

  def attend
    event = Event.find(params[:id])
    attendee = Attendee.new(event: event, user: current_user)

    if attendee.save
      render json: attendee.to_json
    else
      render json: attendee.errors.to_json
    end
  end

  def decline
    event = Event.find(params[:id])
    attendee = Attendee.find_by(event: event, user: current_user)
    attendee.destroy

    render json: event.to_json
  end

  private

  def event_params
    safe_params = params.require(:event).permit(:id, :name, :location, :description, :neighborhood, :map, :start_date, :cancelled)
    safe_params.to_hash
  end
end
