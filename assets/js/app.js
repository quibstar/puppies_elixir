// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import './user_socket.js';

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
import moment from 'moment';
import 'phoenix_html';
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import topbar from '../vendor/topbar';
import Alpine from 'alpinejs';

import './socket';
import './checkout';

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

Hooks.chatMessages = {
  mounted() {
    this.el.scrollTop = this.el.scrollHeight;
  },
  updated() {
    console.log(this.el);
    this.el.scrollTop = this.el.scrollHeight;
  },
};

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

// messages dates
document.addEventListener('phx:update', () => {
  const timeElements = document.querySelectorAll('.messages-time');
  let i = 0;
  while (i < timeElements.length) {
    let ele = timeElements[i];
    let time = timeElements[i].getAttribute('data-time');
    let newTime = moment.utc(time).local().format('h:mm a');
    ele.innerText = newTime;
    i++;
  }

  const messageDates = document.querySelectorAll('.messages-date');
  let j = 0;
  while (j < messageDates.length) {
    let ele = messageDates[j];
    let time = messageDates[j].getAttribute('data-date');
    let newTime = moment.utc(time).format('MM/DD/YYYY');
    ele.innerText = newTime;
    j++;
  }
});

// Phone
Hooks.silver_modal = {
  mounted() {
    silverReputationValidation();
  },
};

let silverReputationValidation = () => {
  const phoneInputField = document.querySelector('#phone');
  if (phoneInputField) {
    phoneInputField.value = '';

    const formattedPhone = document.querySelector('#phone_intl_format');
    const submitInput = document.querySelector('#submit-phone-number');

    const phoneInput = window.intlTelInput(phoneInputField, {
      utilsScript: 'https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js',
    });

    function validatePhoneNumber() {
      const phoneNumber = phoneInput.getNumber();
      let valid = phoneInput.isValidNumber();
      if (valid) {
        formattedPhone.value = phoneNumber;
        submitInput.classList.remove('hidden');
      } else {
        formattedPhone.value = '';
        submitInput.classList.add('hidden');
      }
    }

    window.validatePhoneNumber = validatePhoneNumber;
  }
};

Hooks.PhoneNumber = {
  mounted() {
    this.el.addEventListener('input', (e) => {
      console.log(e);
      let match = this.el.value.replace(/\D/g, '').match(/^(\d{3})(\d{3})(\d{4})$/);
      if (match) {
        this.el.value = `${match[1]}${match[2]}${match[3]}`;
      }
    });
  },
};

// ID
Hooks.verifyIdentity = {
  mounted() {
    let publicKey = document.getElementById('pub-key');
    var stripe = Stripe(publicKey.value);
    this.el.addEventListener('click', function () {
      let errorDiv = document.getElementById('error-container');
      let errorText = document.getElementById('error-text');
      let cs = document.getElementById('cs').value;
      stripe
        .verifyIdentity(cs)
        .then(function (result) {
          if (result.error) {
            if (!result.error.code === 'session_cancelled') {
              errorDiv.classList.remove('hidden');
              errorText.textContent = result.error;
            }
          } else {
            window.location.assign('/verifications?gv=true');
          }
        })
        .catch(function (error) {
          errorDiv.classList.remove('hidden');
          errorText.textContent = 'There was an error, please try again';
        });
    });
  },
};

window.addEventListener('phx:page-loading-stop', () => {
  const messagesDrawer = document.getElementById('message-drawer-opener');
  const chatContainer = document.getElementById('chat-container');
  const messagesDrawerCloser = document.getElementById('message-closer');
  if (messagesDrawer) {
    messagesDrawer.addEventListener('click', () => {
      chatContainer.classList.add('show-list');
    });
  }

  if (messagesDrawerCloser) {
    messagesDrawerCloser.addEventListener('click', () => {
      chatContainer.classList.remove('show-list');
    });
  }
});
