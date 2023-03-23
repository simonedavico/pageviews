import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {
    tracking: {
      mounted() {
        // N.B: listening to visibilitychange will not handle all cases. The event
        // will not be fired when alt+tabbing to another window. In order to make detection
        // more robust, we could track activity on the page, and after some time without
        // any activity, check document.hasFocus() (https://developer.mozilla.org/en-US/docs/Web/API/Document/hasFocus).
        // In this case, I'm keeping things simple and ignoring this case.
        window.addEventListener("visibilitychange", (e) => {
          if (document.visibilityState === "hidden") {
            this.pushEvent("pause", { at: new Date().toISOString() });
          } else {
            this.pushEvent("resume", { at: new Date().toISOString() });
          }
        });
      },
    },
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });

window.addEventListener("phx:page-loading-start", (_info) => {
  topbar.show(300);
});

window.addEventListener("phx:page-loading-stop", (_info) => {
  topbar.hide();
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
