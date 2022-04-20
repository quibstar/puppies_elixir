# Puppies remake for fun

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
