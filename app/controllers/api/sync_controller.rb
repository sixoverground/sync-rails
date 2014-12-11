class Api::SyncController < Api::ApplicationController

  # POST /sync
  # Send updated objects from client to server.
  def create

    # Create response.
    events_success = []
    events_error = []
    event_uuids = []

    # Loop through all posted events, and update or create as needed.
    post_events = params[:events]
    if post_events.present?
      post_events.each do |event_json|
        uuid = event_json[:uuid]

        # Make sure we have a UUID.
        if uuid.present?
          event_uuids << uuid
          event = Event.unscoped.find_by_uuid(uuid)
          if event.nil?

            # Create new event.
            event = Event.new(event_params(event_json))
            if event.save
              events_success << event.as_json(except: [:id, :created_at])
            else
              events_error << generate_error(event)
            end
          else

            # Update existing event.
            if event.update(event_params(event_json))
              events_success << event.as_json(except: [:id, :created_at])
            else
              events_error << generate_error(event)
            end
          end
        else

          # No UUID supplied.
          events_error << { message: 'UUID not supplied.' }
        end
      end
    end

    # Find the rest of the events modified on server since updated at flag.
    get_events = Event.unscoped.where.not(uuid: event_uuids)
    if params[:updated_at].present?
      get_events = get_events.where("date_trunc('second', updated_at) > ?", params[:updated_at])
    else
      get_events = get_events.where(deleted_at: nil)
    end
    get_events.each do |event|
      events_success << event.as_json(except: [:id, :created_at])
    end

    render json: { events: { success: events_success, error: events_error } }
  end

  private

  def event_params(json)
    json.permit(:title, :uuid, :deleted_at)
  end

  def generate_error(object)
    { uuid: object.uuid, message: object.errors.full_messages.join('. ').concat('.') }
  end
end
