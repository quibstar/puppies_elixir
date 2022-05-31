# Listings

```
id: listing.id,
deliver_on_site: listing.deliver_on_site,
deliver_pick_up: listing.deliver_pick_up,
delivery_shipped: listing.delivery_shipped,
champion_sired: listing.champion_sired,
show_quality: listing.show_quality,
champion_bloodline: listing.champion_bloodline,
registered: listing.registered,
registrable: listing.registrable,
current_vaccinations: listing.current_vaccinations,
veterinary_exam: listing.veterinary_exam,
health_certificate: listing.health_certificate,
health_guarantee: listing.health_guarantee,
pedigree: listing.pedigree,
hypoallergenic: listing.hypoallergenic,
microchip: listing.microchip,
purebred: listing.purebred,
coat_color_pattern: listing.coat_color_pattern,
description: listing.description,
dob: listing.dob,
name: listing.name,
price: listing.price,
sex: listing.sex,
status: listing.status,
photos: Enum.reduce(listing.photos, [], fn photo, acc -> [photo.url | acc] end),
breeds_slug: Enum.reduce(listing.breeds, [], fn breed, acc -> [breed.slug | acc] end),
breeds_name: Enum.reduce(listing.breeds, [], fn breed, acc -> [breed.name | acc] end),
state_license: listing.user.business.state_license,
federal_license: listing.user.business.federal_license,
website: listing.user.business.website,
place_name: listing.user.business.location.place_name,
region_slug: listing.user.business.location.region_slug,
place_slug: listing.user.business.location.place_slug,
region_short_code: listing.user.business.location.region_short_code,
place: listing.user.business.location.place,
region: listing.user.business.location.region,
location: %{
	lat: listing.user.business.location.lat,
	lon: listing.user.business.location.lng
},
updated_at: listing.updated_at,
views: listing.views,
business_name: listing.user.business.name,
business_slug: listing.user.business.slug,
business_photo: business_photo_url,
business_breeds_slug: Enum.reduce(listing.user.business.breeds, [], fn breed, acc -> [breed.slug | acc] end),
user_status: listing.user.status,
reputation_level: listing.user.reputation_level,
approved_to_sell: listing.user.approved_to_sell,
locked: listing.user.locked,
```

# User

user.email,
user.first_name,
user.last_name,
user.status,
user.membership_end_date,
user.phone_number,
user.visitor_id,
user.is_seller,
user.approved_to_sell,
user.reputation_level,
user.locked,

# Business

business.name,
business.slug,
business.phone_number,
business.state_license,
business.federal_license,
business.description,

# Transaction

charge_id
customer_id
invoice_id
merchant
status
subscription_id
description
refund_id
reference_number
last_4
