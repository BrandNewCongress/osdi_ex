# defmodule ContactTest do
#   alias Osdi.{Repo, Contact, Person, Question}
#   import ShorterMaps
#
#   defp create_question do
#
#   end
#
#   defp create_contact do
#     [target, contactor] = Repo.all(Person) |> Enum.take(2)
#
#     {identifiers, origin_system, action_date, contact_type, input_type, success,
#      status_code} =
#       {[Faker.Bitcoin.address()], Faker.Superhero.name(), DateTime.utc_now(), "in-person",
#        "web", true, "success"}
#
#     contact = struct(Contact, ~M(target contactor identifiers origin_system action_date contact_type input_type success status_code))
#     created = Repo.insert!(contact)
#
#     assert _num = created.id
#     assert _some_ref = created.target_id
#     assert _some_ref = created.contactor_id
#   end
#
#   test "create script, with script questions, and questions" do
#   end
#
#   test "record contact, with answers to questions" do
#   end
# end
