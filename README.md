# osdi_ex

Ecto.Schemas and schemas for the Open Supporter Data Interface, with some basic changesets

## Progress for V1

### General Schema / Model Development

- [x] Osdi.Person
- [x] Osdi.Event
- [x] Osdi.Donation
- [x] Osdi.Tag
- [x] Osdi.Tagging
- [x] Osdi.Attendence

Associations for:
- [x] People to events (organizier / host)
- [x] People to events (creator)
- [x] People to events (attendees)
- [x] Taggings to tags
- [x] Taggings to people
- [x] Donations to people

Embedded structs for

- [ ] Events
  - [ ] Location
  - [ ] Reminders

- [ ] People
  - [ ] Parties
  - [ ] Address
  - [ ] Email Address
  - [ ] Phone Number
  - [ ] Profiles

- [ ] Donations
  - [ ] Referrer data
  - [ ] Payment
  - [ ] Recipient

## Next Models

- [ ] Petitions
- [ ] Outreaches + Canvasses
- [ ] Messages
