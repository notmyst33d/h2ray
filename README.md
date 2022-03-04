# Deploy
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?template=https://github.com/notmyst33d/hyperwarp)

# Cloudflare Workers Configuration
```
servers = [
  "http://yourserver.com"
]

async function selectServer(event) {
  let selectedServer = null

  for(server of servers) {
    let serverResponse = await fetch(`${server}/ping`)
    if (serverResponse.status == 200) {
      selectedServer = server
      break
    }
  }

  if (selectedServer == null)
    return new Response("Could not find a usable server")

  return fetch(new Request(selectedServer, event.request))
}

addEventListener("fetch", (event) => event.respondWith(selectServer(event)))
```
