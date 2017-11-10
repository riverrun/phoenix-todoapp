# TodoApp

An example todo api using Phauxth authentication with Phoenix.

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

## Making requests

This app includes [Wuffwuff](https://github.com/riverrun/wuff_wuff), a simple
http client, as a dependency, and this makes testing the app more staightforward
(there is also an example using Curl below).

The following commands show an example of how you can log in and then access
the /users route:

```elixir
import Wuffwuff.Api

%{"access_token" => token} = login_user(:email, "ted@mail.com")
%{"data" => data} = get!("/users", ~a(#{token})).body
```

The `login_user`, `get!` functions and the `~a` sigil are all provided
by the Wuffwuff.Api module.

The `~a` sigil adds the access token to the request headers.

See the tests in the `test/integration directory` for more examples.

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

