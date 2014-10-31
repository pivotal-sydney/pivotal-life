require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

#TODO: Request id and secret from a different account
CLIENT_ID = '551647463843-ujkp9ouirdpk34e25mpe43i749piprq5.apps.googleusercontent.com'
CLIENT_SECRET = 'rK5_AGwSfnnST3LDMn5-Aw6E'
REFRESH_TOKEN = '1/SLD1by-eSeTslM9vDB0Bt0xTCFASPj7aSl6LixmUi0I'
SCOPE = ['https://www.googleapis.com/auth/calendar']

class MeetingsFetcher

  def initialize()
    @client = Google::APIClient.new(
      application_name: 'PivotalMeetingRooms',
      application_version: '1.0.0'
    )

<<<<<<< HEAD
    @client.authorization.refresh_token=REFRESH_TOKEN
    @client.authorization.client_id=CLIENT_ID
    @client.authorization.client_secret=CLIENT_SECRET
=======
    @client.authorization.client_id=ENV['GOOGLE_CLIENT_ID']
    @client.authorization.client_secret=ENV['GOOGLE_CLIENT_SECRET']
    @client.authorization.refresh_token=ENV['GOOGLE_REFRESH_TOKEN']
>>>>>>> 8c26b41... Added Meeting Rooms Dashboard + Widget

    @calendar = @client.discovered_api('calendar', 'v3')
  end

  def get_new_refresh_token
    @client.authorization = begin
      installed_app_flow = ::Google::APIClient::InstalledAppFlow.new(
        client_id:     CLIENT_ID,
        client_secret: CLIENT_SECRET,
        scope:         SCOPE
      )
      installed_app_flow.authorize()
    end
  end

  def get_room_events(calendar_id)
    response = @client.execute({
      api_method: @calendar.events.list,
      parameters: {
        calendarId: calendar_id,
        timeMax: (Time.now + (60*60*24)).utc.iso8601,
<<<<<<< HEAD
        timeMin: Time.now.utc.iso8601
=======
<<<<<<< HEAD
        timeMin: Time.now.utc.iso8601,
        singleEvents: true,
        orderBy: "startTime"
=======
        timeMin: Time.now.utc.iso8601
>>>>>>> Added Meeting Rooms Dashboard + Widget
>>>>>>> 8c26b41... Added Meeting Rooms Dashboard + Widget
      },
      headers: {'Content-Type' => 'application/json'}
    })

    organize_events(JSON.parse(response.body))
  end

  def organize_events(events)
    array = []
    events['items'].each do |event|
      next unless event['status'] == 'confirmed'
      temp = {
        title: event['visibility']=='private' ? 'Private' : event['summary'],
        location: event['location'].nil? ? '' : event['location'],
<<<<<<< HEAD
        organizer: event['organizer'].nil? ? '' : event['organizer']['displayName'],
=======
<<<<<<< HEAD
        organizer: event['organizer'].nil? ? 'Anonymous' : event['organizer']['displayName'],
=======
        organizer: event['organizer'].nil? ? '' : event['organizer']['displayName'],
>>>>>>> Added Meeting Rooms Dashboard + Widget
>>>>>>> 8c26b41... Added Meeting Rooms Dashboard + Widget
        organizer_email: event['organizer'].nil? ? '' : event['organizer']['email'],
        start: Time.parse(event['start']['dateTime']).to_i,
        end: Time.parse(event['end']['dateTime']).to_i,
        time: Time.parse(event['start']['dateTime']).strftime("%b %d, %I:%M %p")+" - "+Time.parse(event['end']['dateTime']).strftime("%I:%M %p"),
        link: event['htmlLink'].nil? ? '#' : event['htmlLink']
      }

      array.push(temp) if (temp[:end] >= Time.now.to_i)
    end

    array.sort_by { |hash| hash[:start] }
  end

  def get_room_status(events)
<<<<<<< HEAD
    green =  { text: 'Available', style: 'green' }
    yellow = { text: 'Reserved', style: 'yellow' }
    red =    { text: 'In Use', style: 'red' }
=======
<<<<<<< HEAD
    green =  { text: 'Available - Room is not Booked', style: 'green' }
    yellow = { text: 'Reserved - A Meeting will Start Soon', style: 'yellow' }
    red =    { text: 'In Use - Room is Booked', style: 'red' }

=======
    green =  { text: 'Available', style: 'green' }
    yellow = { text: 'Reserved', style: 'yellow' }
    red =    { text: 'In Use', style: 'red' }
>>>>>>> Added Meeting Rooms Dashboard + Widget
>>>>>>> 8c26b41... Added Meeting Rooms Dashboard + Widget
    status = green
    current_time = Time.now.to_i
    warning_time = 5*60
    events.each do |item|
      if (item[:start]-current_time) <= warning_time && (item[:start]-current_time) > 0
        status = yellow
      end
      if (item[:start]..item[:end]).include?(current_time)
        status = red
        break
      end
    end

    status
  end

  def refresh_access_token
    @client.authorization.fetch_access_token!
  end

  def get_summarized_events(calendar_id)
    events = get_room_events(calendar_id)
    { items: events, status: get_room_status(events) }
  end
end