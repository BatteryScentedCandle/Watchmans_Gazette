# watchmans_gazette

A new Flutter project.

## Building
The application makes use of private API keys. One of which is the API key for
fscapi for fetching news. The api key should be included in a separate json
file. For instance, `keys.json`. This file should contain the following fields:

* NEWS_API_KEY

Example api key file:
```json
{
    "NEWS_API_KEY": "insert_api_key_here"
}
```

To build the program with the api key, you must add the 
`--dart-define-from-file` flag to the build command.

Here is an example of building the apk with `keys.json` as the api keys file:
```bash
flutter build apk --dart-define-from-file="keys.json"
```

Or to run:
```bash
flutter run --dart-define-from-file="keys.json"
```


