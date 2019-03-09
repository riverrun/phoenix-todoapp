# TodoApp

An example todo api using [Phauxth authentication](https://github.com/riverrun/phauxth)
with the [Phoenix web framework](http://www.phoenixframework.org/).

## Getting started

1. Install dependencies:

```
mix deps.get
```

2. Setup database:

```
mix ecto.setup
```

3. Start the app:

```
iex -S mix phx.server
```

### Using Curl

With Curl, the above example would be:

```
curl --request POST \
  --url http://localhost:4000/api/sessions \
  --header 'content-type: application/json' \
  --data '{
	"session": {
		"email": "jane.doe@example.com",
		"password": "password"
	}
}'
```

The response will be in the form `{"access_token": token}`

Then you can access the /users route by running this command
(replace token with the value of the token):

```
curl --request GET \
  --url http://localhost:4000/api/users \
  --header 'content-type: application/json' \
  --header 'Authorization: token' \
```
