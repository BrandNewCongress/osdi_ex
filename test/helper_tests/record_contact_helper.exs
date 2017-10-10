defmodule RecordContactHelperTest do
  use ExUnit.Case
  alias Osdi.{Repo, RecordContact, Contact, Person}

  test "record contact helper" do
    [target, contactor] = Repo.all(from p in Person, limit: 2, select: p.id)

    body = %{
      contact: %{
        target: target,
        contactor: contactor,
        origin_system: "twilio",
        contact_type: "phone",
        input_type: "api",
        action_date: DateTime.utc_now(),
        success: true,
        status_code: "left-voicemail",
        custom_fields: %{
          voicemail_url: "https://www.google.com"
        }
      }
    }

    c = RecordContact.main(body)

    assert %Contact{id: id} = created
  end
end
