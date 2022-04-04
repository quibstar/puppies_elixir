// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import 'phoenix_html';
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import topbar from '../vendor/topbar';
import Alpine from 'alpinejs';
window.Alpine = Alpine;
Alpine.start();

var Hooks = {};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' });
window.addEventListener('phx:page-loading-start', (info) => topbar.show());
window.addEventListener('phx:page-loading-stop', (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

let currentPhotoIndex = 0;
let galleryViewer;
let photoViewer;
let photoUrl;

window.showImage = (index) => {
  currentPhotoIndex = index;
  let image = photoUrl[currentPhotoIndex];
  photoViewer.style.backgroundImage = `url(${image})`;
  galleryViewer = document.getElementById('current-image');
  galleryViewer.src = image;
};

window.getCurrentIndexAndSetPrevNext = () => {
  const dataUrl = document.querySelectorAll('img[data-url]');
  photoUrl = [...dataUrl].map((photoUrl) => {
    return photoUrl.getAttribute('data-url');
  });

  photoViewer = document.getElementById('photo-view');
  let image = photoUrl[currentPhotoIndex];
  photoViewer.style.backgroundImage = `url(${image})`;
  galleryViewer = document.getElementById('current-image');
  galleryViewer.src = image;

  let prev = document.getElementById('image-viewer-prev');
  let next = document.getElementById('image-viewer-next');

  prev.addEventListener('click', prevAction);

  next.addEventListener('click', nextAction);
};

const prevAction = () => {
  currentPhotoIndex -= 1;
  if (currentPhotoIndex <= 0) {
    currentPhotoIndex = photoUrl.length - 1;
  }
  galleryViewer.src = photoUrl[currentPhotoIndex];
};
const nextAction = () => {
  currentPhotoIndex += 1;
  if (currentPhotoIndex >= photoUrl.length) {
    currentPhotoIndex = 0;
  }
  galleryViewer.src = photoUrl[currentPhotoIndex];
};
