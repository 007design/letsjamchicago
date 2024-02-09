require 'emails'

class Api::V1::EventsController < ApplicationController
  include Emails
  before_action :authenticate_user!, except: [:index, :show]

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
        .left_outer_joins({:invitations => :user})
        .select("events.*, 
          array_remove(
            array_agg(invitations.user_id), NULL
          ) as invites,
          array_agg(
            distinct
            (select distinct users.name from 
              (select users.name where users.show_attending = true) 
            as att)
          ) filter (
            where users.show_attending = true
          ) as attendee_names,
          COUNT(distinct attendees.id) as attendee_count, 
          CAST(CASE WHEN events.user_id = #{user_id} 
            THEN true 
            ELSE false 
            END AS BOOLEAN) as owned, 
          CAST(CASE WHEN invitations.event_id = events.id
            THEN true
            ELSE false
          END AS BOOLEAN) as invited,
          EXISTS(SELECT * FROM attendees 
            WHERE attendees.user_id = #{user_id} 
            AND attendees.event_id = events.id) as attending"
          )
      events = events.where('start_date >= ?', DateTime.now) if params[:u].nil?
      events = events.where('events.user_id = ?', params[:u]) if params[:u].present? && user_id.to_s == params[:u]
      events = events.where('neighborhood = ?', params[:n]) if params[:n].present?
      events = events.group('events.id', 'invitations.event_id')
      events = events.order('events.start_date ASC')
      
      if user_id > 0
        render json: events.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'cancelled', 'attendee_count', 'owned', 'invited', 'attending', 'attendee_names', 'invites'])
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
    # event = Event.find(params[:id])
    # event = Event.left_outer_joins({:attendees => :user})
    #     .left_outer_joins({:invitations => :user})
    #     .select("events.*,
    #       array_remove(
    #         array_agg(distinct invitations.user_id), NULL
    #       ) as invites,
    #       json_agg(
    #         distinct jsonb_build_object(
    #           'id', users.id, 'name', users.name
    #         )
    #       ) as attendee_names, 
    #       CAST(CASE WHEN invitations.event_id = events.id
    #         THEN true
    #         ELSE false
    #       END AS BOOLEAN) as invited,
    #       COUNT(attendees.id) as attendee_count, 
    #       CAST(CASE WHEN events.user_id = #{user_id} 
    #         THEN true 
    #         ELSE false 
    #       END AS BOOLEAN) as owned, 
    #       EXISTS(
    #         SELECT * FROM attendees 
    #         WHERE attendees.user_id = #{user_id} 
    #         AND attendees.event_id = events.id
    #       ) as attending"
    #     )
    event = Event.where('events.id = ?', params[:id])
    event = event.where('events.user_id = ?', user_id)
    # event = event.group('events.id', 'invitations.event_id')
    .first
    
    render json: event.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date'])
      
    # if user_id > 0
    #     render json: event.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'cancelled', 'attendee_count', 'owned', 'attending', 'attendee_names', 'invites', 'invited'])
    # else
    #   render json: event.to_json(:only => ['id', 'name', 'location', 'description', 'neighborhood', 'map', 'start_date', 'cancelled', 'attendee_count'])
    # end
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

  def invite
    event = Event.find(params[:id])
    for i in params[:invitations] do
      user = User.find(i)
      invite = Invitation.new(event: event, user: user)
      if invite.save
        email_params = {
          "event_id" => event.id,
          "name" => user.name,
          "email" => user.email
        }
        send_invitation(email_params)
      end
    end

    render json: event.to_json
  end

  private

  def event_params
    safe_params = params.require(:event).permit(:id, :name, :location, :description, :neighborhood, :map, :start_date, :cancelled, :invitations)
    safe_params.to_hash
  end
end
