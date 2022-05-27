# Puppies remake for fun

mix test.watch
or
mix test.watch test/file/to_test.exs
mix test.watch --stale

### Review's

- [ ] Lister marks listing as sold,
- [ ] we send an email to the user
  - [ ] perishable link: email, uuid.
- [ ] Buyer hits the email link, signs up, and the listing is transferred to the user.
- [ ] The new user can write a review.

### models

reviews: first_name, rating, descriptions, email
review_link: email, uuid, listing_id

mix phx.gen.context Reviews Review reviews first_name:string rating:integer description:text email:string
mix phx.gen.context ReviewLinks ReviewLink review_links email:string listing_id:references:listing uuid:uuid

# Next

- [x] Favorites
- [x] Plans page
- [x] Message read when viewed
- [x] Site maps generation
- [x] state/breed pages
- [x] city/state/breed pages
- [x] create products on Stripe
- [x] Pull products in from Stripe
- [x] Checkout
- [x] verify phone
- [x] verify ID
- [x] Message access based on reputation level
- [x] Filter for search
- [x] Record IP data
- [ ] Record Activities
- [ ] background tasks/notifications
- [ ] Popular breeds generation gen_server
- [ ] delete user
- [ ] Email set up
- [ ] Apply Fraud detection for domains
- [ ] Apply Fraud detection for ip address
- [ ] Apply Fraud detection for content
- [ ] Apply Fraud detection countries
- [ ] make review updatable

# Admin

- [x] Create Admin Site
- [x] Layout
- [x] Notes
- [x] Transactions
- [x] Flags
- [x] Reviews
- [x] Listing
- [x] IP Address
- [ ] Activities
- [ ] Elasticsearch

TODO: finish subscriptions
http://localhost:4000/success?payment_intent=pi_3Ktl0uJLqL890V2T13dikKLg&payment_intent_client_secret=pi_3Ktl0uJLqL890V2T13dikKLg_secret_FtSK0uxZfT9q8h70N390AsCsR&redirect_status=succeeded

https://stripe.com/docs/billing/subscriptions/build-subscriptions?card-or-payment-element=payment-element#display-payment-method

stripe login --api-key rk_test_51KszeNJLqL890V2TZMXtWB3lEToc5Z2PYTIbqYq7RXkAN7muNsIeC9piJ12khnEC8nFSYlInzL2Hvdxuibcd3txx006PDHpqxs
stripe listen --forward-to http://localhost:4000/stripe/webhooks

# Activities to record

- [x] log in
- [x] log out
- [x] update email
- [x] update password
- [x] create listing
- [-] update listing
  - [ ] photos
  - [x] breeds
- [x] create business
- [-] update business
  - [ ] photo
  - [x] breeds
- [ ] Blacklists by user
  - [x] ip
  - [ ] content
  - [ ] phone
  - [x] country
- [ ] membership
- [ ] verifications
