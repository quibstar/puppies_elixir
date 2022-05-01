/**
 * Stripe
 */

window.addEventListener('phx:page-loading-stop', (info) => {
  let paymentElement = document.getElementById('payment-element');
  if (paymentElement) {
    let publicKey = document.getElementById('pub-key');
    const stripe = Stripe(publicKey.value);

    const appearance = {
      theme: 'clean',
    };

    let clientSecret = document.querySelector('#ds').dataset.secret;

    elements = stripe.elements({ appearance, clientSecret });

    const paymentElement = elements.create('payment');
    paymentElement.mount('#payment-element');

    var form = document.getElementById('payment-form');
    form.addEventListener('submit', function (event) {
      event.preventDefault();
      handleSubmit(event, stripe);
    });
  }
});

async function handleSubmit(e, stripe) {
  setLoading(true);

  const { error } = await stripe.confirmPayment({
    elements,
    confirmParams: {
      // Make sure to change this to your payment completion page
      return_url: 'http://localhost:4000/success',
    },
  });

  if (error.type === 'card_error' || error.type === 'validation_error') {
    showMessage(error.message);
  } else {
    showMessage('An unexpected error occurred.');
  }

  setLoading(false);
}

function showMessage(messageText) {
  const messageContainer = document.querySelector('#payment-message');

  messageContainer.classList.remove('hidden');
  messageContainer.textContent = messageText;

  setTimeout(function () {
    messageContainer.classList.add('hidden');
    messageText.textContent = '';
  }, 4000);
}

// Show a spinner on payment submission
function setLoading(isLoading) {
  if (isLoading) {
    // Disable the button and show a spinner
    document.querySelector('#submit').disabled = true;
    document.querySelector('#spinner').classList.remove('hidden');
    document.querySelector('#button-text').classList.add('hidden');
  } else {
    document.querySelector('#submit').disabled = false;
    document.querySelector('#spinner').classList.add('hidden');
    document.querySelector('#button-text').classList.remove('hidden');
  }
}
