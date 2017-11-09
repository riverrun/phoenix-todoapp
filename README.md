# TodoApp

An example todo api using Phauxth authentication with Phoenix.

## Getting started

1. Install dependencies 

```
mix deps.get
```

2. Setup database

```
mix ecto.setup
```

3. Start the app

```
mix phx.server
```

## Start a session

Request:

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

Response:

```
{
  "access_token": "SFMyNTY.eyJzaWduZWQiOjE1MTAyMzQzNDksImRhdGEiOjF9.oWzXkXckzZgQrD_BQ5YSF_g4VzMCOvuQNb8dGU8u8CE"
}
```



