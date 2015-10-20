# General considerations
This test API lets all users to consult the existing congresses and the events created for each congress. To consult this data (congresses and events) no log is needed.
There are also another entity, Users, that can only be managed via API by users with role admin.
The relation between congresses and events is 1 to many. Each congress could have several events and each event belongs to only one congress.
To modify existing data or create new data the user must be logged in. Users can have 2 roles, user or admin. Admin users can do any action. Users with role user can create new congresses and modifiy or delete only the congresses they have created. They can also create events but only in congresses they have created.
Users entity is only managed by admin users, and no other user can either read the data.
Although for a test is not necessary API is versionized, this is version v1.

# Login
To work with the API as an user first is necessary to send a POST request with email and password of the user. An example of a curl sentence sended to a local server is
  * curl -X POST -H 'Content-type:application/json' -d '{"email": "carlos@mail.es", "password": "carlos"}' localhost:3000/api/v1/sessions

If the response is wrong the body will have a JSON like {"error":"Unauthorized"} and the response status will be 401 (unauthorized)
If the response is right the status will be 201 (created) and needed data will be sended in the header of the response. The body will be empty. The header of the response will include this data, all related to the user:
  * Id → 5
  * Is-Admin → false
  * Name → carlos
  * Token → dsTGkJgUENzqHRI6tRX2ogtt

The token will be needed to identify the user in the next requests, sending it in the header. The name is sended just as aditional information, id is the user_id and permits identify which congresses and events will be able to edit, update and delete this user, is_admin allows to identify if a user has admin role.

To identify the user in all request the token must be sended in the header of the request, in the Authorization header field. An example of the header is (to get all existing users):
  * curl -H 'Content-type:application/json' -H 'Token token=dsTGkJgUENzqHRI6tRX2ogtt' localhost:3000/api/v1/users

# Read congresses and events
All GET requests to congresses and events are allowed, so no token has to be sended in the header. To get all existing congresses the sentence is:
  * curl localhost:3000/api/v1/congresses

If the response is right the status will be 200 (ok) and the data will be an array with all existing congresses. An example of returned information would be:
  * [
    {
        "id": 4,
        "name": "Congress 1",
        "location": "Exhibition Center",
        "start_date": "2015-10-26T00:00:00.000Z",
        "end_date": "2015-10-30T00:00:00.000Z",
        "created_at": "2015-10-20T10:41:05.154Z",
        "updated_at": "2015-10-20T10:41:05.154Z",
        "user_id": 5
    },
    {
        "id": 5,
        "name": "Pediatrics congress",
        "location": "Trade fair",
        "start_date": "2015-12-01T00:00:00.000Z",
        "end_date": "2015-12-05T00:00:00.000Z",
        "created_at": "2015-10-20T15:06:44.879Z",
        "updated_at": "2015-10-20T15:26:15.609Z",
        "user_id": 5
    }
]

It's only possible to get the events of one congress per request, so the congress_id must be include in the request. An example would be:
  * curl localhost:3000/api/v1/events?congress_id=5

If the response is right the status will be 200 (ok) and the data will be an array with all existing events for that congress. An example of returned information would be:
  * [
    {
        "id": 4,
        "name": "The flu",
        "location": "Yellow room",
        "start_date": "2015-12-01T10:00:00.000Z",
        "duration": 1,
        "capacity": 150,
        "created_at": "2015-10-20T15:50:00.699Z",
        "updated_at": "2015-10-20T16:41:07.270Z",
        "congress_id": 5
    },
    {
        "id": 5,
        "name": "Infant allergy",
        "location": "Room 001",
        "start_date": "2015-12-02T09:00:00.000Z",
        "duration": 1,
        "capacity": 50,
        "created_at": "2015-10-20T16:07:25.606Z",
        "updated_at": "2015-10-20T16:07:25.606Z",
        "congress_id": 5
    },
    {
        "id": 6,
        "name": "Child fever",
        "location": "Room 005",
        "start_date": "2015-12-02T09:00:00.000Z",
        "duration": 1,
        "capacity": 50,
        "created_at": "2015-10-20T16:17:04.009Z",
        "updated_at": "2015-10-20T16:17:04.009Z",
        "congress_id": 5
    },
    {
        "id": 7,
        "name": "The fathers",
        "location": "Room 008",
        "start_date": "2015-12-02T10:00:00.000Z",
        "duration": 1,
        "capacity": 20,
        "created_at": "2015-10-20T16:20:14.082Z",
        "updated_at": "2015-10-20T17:44:50.688Z",
        "congress_id": 5
    }
]

# Update congresses and events

# Users
