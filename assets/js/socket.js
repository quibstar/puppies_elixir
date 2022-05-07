import { Socket, Presence } from 'phoenix';

let socket = new Socket('/socket', {
  params: { user_id: window.userId },
});

// let onlineChannel = socket.channel('online:users', {});
// let onlineJoined = false;
// let presences = {};

// window.addEventListener('phx:page-loading-stop', (info) => {
//   if (!onlineJoined) {
//     onlineChannel.join();
//     onlineJoined = true;
//   }

//   onlineChannel.on('presence_state', (state) => {
//     presences = Object.assign(presences, state);
//     renderOnlineUsers(presences);
//   });

//   onlineChannel.on('presence_diff', (diff) => {
//     presences = Object.assign(presences, diff.joins);
//     renderOnlineUsers(presences);
//     renderOffOnlineUsers(diff.leaves);
//   });

//   renderOnlineUsers(presences);
// });

// const renderOnlineUsers = function (presences) {
//   Presence.list(presences, (id, { metas: [user, ...rest] }) => {
//     let threadListItem = document.getElementById(`uid-${id}`);
//     let userOnline = document.getElementById(`user-${id}-online`);
//     if (threadListItem) {
//       threadListItem.classList.add('online');
//     }
//     if (userOnline) {
//       userOnline.value = 'online';
//     }
//   });
// };

// const renderOffOnlineUsers = function (presences) {
//   Presence.list(presences, (id, { metas: [user, ...rest] }) => {
//     let threadListItem = document.getElementById(`uid-${id}`);
//     let userOnline = document.getElementById(`user-${id}-online`);
//     if (threadListItem) {
//       threadListItem.classList.remove('online');
//     }
//     if (userOnline) {
//       userOnline.value = 'offline';
//     }
//     // onlineChannel.push('online:leave', { id: id });
//   });
// };

// let messageLinks = document.getElementsByClassName('messages-nav-link');
// Array.from(messageLinks).forEach((link) => {
//   if (link) {
//     link.addEventListener('click', () => {
//       updateDotsByCountAndClass(0, 'messages-dot');
//     });
//   }
// });

let messagesChannel = socket.channel('messages:user:' + window.userId, {});
messagesChannel.join();

messagesChannel.on('update_nav_messages_link', (event) => {
  // let path = window.location.pathname;
  // if (!path.includes('messages') && event.id == window.userId) {
  const listings = event.listing_count;
  console.log('listings', listings);
  const count = listings.reduce((acc, obj) => {
    return acc + obj.count;
  }, 0);

  setTimeout(() => {
    listings.forEach((listing) => {
      const id = `${event.id}-listing-${listing.id}`;
      console.log(id);
      const htmlEle = document.getElementById(id);
      if (htmlEle) {
        htmlEle.classList.remove('hidden');
        htmlEle.innerHTML = listing.count;
      }
    });
  }, 750);

  updateDotsByCountAndClass(count, 'messages-dot');
  // }
});

messagesChannel.on('update_messages_count', (event) => {
  console.log('update_messages_count');
  messagesChannel.push('push_check_count', { received_by: event.user_id });
});

// let notificationsChannel = socket.channel('notifications:user:' + window.userId, {});
// notificationsChannel.join();

// notificationsChannel.on('update_nav_notifications_link', (event) => {
//   updateDotsByCountAndClass(event.notifications_count, 'notifications-dot');
// });

// notificationsChannel.on('update_count', (event) => {
//   updateDotsByCountAndClass(event.notifications_count, 'notifications-dot');
// });

updateDotsByCountAndClass = (count, targetClass) => {
  let dots = document.getElementsByClassName(targetClass);
  Array.from(dots).forEach((dot) => {
    dot.classList.remove('hidden');
    dot.innerHTML = count > 0 ? count : '';
  });
};

if (window.userId) {
  socket.connect();
}

export default socket;
