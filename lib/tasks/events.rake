namespace :events do
  desc 'create event everyday'

  task create: :environment do
    events = Event.where(repeat: true)

    Event.transaction do
      events.each do |event|
        new_event = event.dup.update!(
          is_repeat: false, event_origin_id: event.id, day: Date.current
        )
      end
    end
  end
end
