# osdi_ex

Ecto models and schemas for the Open Supporter Data Interface, with some basic changesets

## Progress for V1

### General Schema / Model Development

- [x] Osdi.Person
- [x] Osdi.Event
- [x] Osdi.Donation
- [x] Osdi.Tag
- [ ] Osdi.Tagging
- [ ] Osdi.Attendence

Associations for:
- [ ] People to events (organizier / host)
- [ ] People to events (creator)
- [ ] People to events (attendees)
- [ ] Taggings to tags
- [ ] Taggings to people
- [ ] Donations to people

## Helper methods

- [ ] People
  - [x] Osdi.People.signup_email
  - [ ] Osdi.People.signup_phone
  - [ ] Osdi.People.signup_multiple
  - [ ] Osdi.People.match

- [ ] Events
  - [ ] Osdi.Event.create (creates person with host info if need be)

- [ ] Donations
  - [ ] Osdi.Donation.create (creates person for donation if need be)

## Next

- [ ] Petitions
- [ ] Outreaches + Canvasses
- [ ] Messages
