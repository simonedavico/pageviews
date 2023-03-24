# Challenge solution

In this document, I describe how I structured the solution to the challenge.

# Project structure

- The `marko_pageviews` folder contains the business logic for the tracking of sessions and pageviews;
- The `marko_pageviews_web` folder contains the implementation of the LiveViews (under the `live` folder) and the components required to enable pageview tracking.

## How session tracking works

We check for the existence of a `_marko_pageviews_web_tracking_session` cookie containing the session id; if it is not found, a new session is created on the fly.

- Module `MarkoPageviews.Tracking` includes the logic for session creation and session lookup;
- Module `MarkoPageviewsWeb.Tracking.Plug` implements a plug to fetch/attach the session to the `conn`.

We include the session id into the `conn.assigns`, making it available to the LiveViews.

## How pageview tracking works

Pageview tracking is implemented by monitoring the LiveView processes. When a LiveView websocket connection is established, we start monitoring the LiveView process.
When the LiveView process is killed, we calculate the engagement time and store a pageview in the database.
Pausing/resuming engagement time tracking is implemented by sending events from the browser (triggered on `visibilitychange`). When the mounted LiveView receives the events, it computes the partial engagement time.

- Module `MarkoPageviews.Tracking` implements the business logic for updating pageview info;
- Module `MarkoPageviewsWeb.Tracking.PageviewTracker` implements a behaviour for a pageview tracker. The behaviour is useful to replace the full-fledged process with a stub module in tests;
- Module `MarkoPageviewsWeb.Tracking.InMemoryPageviewTracker` implements the process responsible for monitoring LiveViews and keeping track of the pageview entry for each one.
- Module `MarkoPageviewsWeb.Tracking.Hooks` implements LiveView hooks that get attached to all LiveViews.

## About the implementation

Some things about the implementation could be improved:

- In the browser, we only react to `visibilitychange` events to pause/resume engagement time tracking. This implementation does not account for putting another window in front of the browser, but the `app.js` file includes suggestions for a more complete implementation.
- Having a single process that holds pageviews entries in memory may not be the most optimal solution under load, for two reasons:
  1. A lot of objects in the process heap may cause long GC times; an alternative implementation could store pageview entries in ETS, so that they are stored off heap.
  2. The process could become a bottleneck as its mailbox fills up. To account for this, we could setup a pool of processes, of dynamically start a process for each session id.
  3. Some parts of the code are not optimally covered by tests, but I believe I covered the most critical parts, showing I can handle both unit and integration tests.
