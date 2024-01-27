class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  # GET /v1/events
  def index
    user_id = current_user ? current_user.id : 0
    # TODO Sort by neighborhood
    events = Event.left_outer_joins(:attendees).select("events.*, COUNT(attendees.id) as attendee_count, CAST(CASE WHEN events.user_id = #{user_id} THEN true ELSE false END AS BOOLEAN) as owned").where('start_date >= ?', DateTime.now).group('events.id')
    render json: events.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'start_time', 'attendee_count', 'owned'])
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
      render json: event.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'start_time'])
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

  private

  def event_params
    params.require(:event).permit(:id, :name, :location, :description, :neighborhood, :map, :start_date, :start_time)
  end
end
