defmodule Transformers.Nb.People do
  use Remodel

  attributes ~w(
    given_name family_name additional_name honorific_prefix
    honorific_suffix gender birthdate languages_spoken party_identification
    parties postal_addresses email_addresses phone_numbers profiles
    attendances taggings
  )a

  def family_name(p), do: p.last_name
  def given_name(p), do: p.first_name
  def additional_name(p), do: p[:middle_name]
  def honorific_prefix(p), do: p[:prefix]
  def honorific_suffix(p), do: p[:suffix]
  def gender(p), do: p.sex
  def birthdate(p), do: p.birthdate
  def party_identification(p), do: p.party
  def languages_spoken(p), do:
    if p[:language], do: [p.language], else: []

  def postal_addresses(p) do
    ~W(primary_address work_address mailing_address submitted_address
       registered_address home_address)
    |> Enum.map(fn type -> extract_address(type, p) end)
    |> Enum.filter(fn obj -> obj != nil end)
  end

  def email_addresses(p) do
    ~W(1 2 3 4)
    |> Enum.map(fn rank -> extract_email(rank, p) end)
    |> Enum.filter(fn obj -> obj != nil end)
  end

  def phone_numbers(p) do
    ~W(mobile phone)
    |> Enum.map(fn type -> extract_phone(type, p) end)
    |> Enum.filter(fn obj -> obj != nil end)
  end

  def profiles(p) do
    ~W(twitter facebook linkedin)
    |> Enum.map(fn type -> extract_profile(type, p) end)
    |> Enum.filter(fn obj -> obj != nil end)
  end

  def taggings(%{id: id}) do
    %{body: %{"taggings" => taggings}} = Nb.Api.get("people/#{id}/taggings")

    taggings
    |> Enum.map(
        fn %{"created_at" => created_at, "tag" => tag}
          -> %{created_at: created_at, tag: %{name: tag}}
        end)
  end

  def extract_address(type, person) do
    transform_address(type, person[type])
  end

  def extract_email(rank, p) do
    address = p["email#{rank}" |> String.to_atom()]

    if address do
      status = if p["email#{rank}_is_bad" |> String.to_atom()], do: "bouncing", else: "subscribed"

      %{primary: rank == "1", address: address,
        status: status}
    else
      nil
    end
  end

  def extract_phone(type, p) do
    number = p[type |> String.to_atom()]

    if number do
      %{primary: type == "mobile", number: number,
        sms_capable: type == "mobile", do_not_call: p.do_not_call,
        number_type:
          case type do
            "mobile" -> "Mobile"
            "phone" -> "Home"
          end
        }
    else
      nil
    end
  end

  def extract_profile("twitter", p) do
    if p.twitter_name do
      %{provider: "twitter", url: "https://twitter.com/#{p.twitter_name}",
        handle: p.twitter_name}
    else
      nil
    end
  end

  def extract_profile("facebook", p) do
    if p.has_facebook do
      %{provider: "facebook", url: "https://facebook.com/#{p.facebook_username}",
        handle: p.facebook_username}
    else
      nil
    end
  end

  def extract_profile("linkedin", p) do
    if p.linkedin_id do
      %{provider: "linkedin", url: "https://linkedin.com/in/#{p.linkedin_id}",
        handle: p.linkedin_id}
    else
      nil
    end
  end

  def transform_address(_type, nil) do
    nil
  end

  def transform_address(type, %{
    "zip" => zip, "state" => state, "lng" => longitude, "lat" => latitude,
    "country_code" => country, "city" => city, "address1" => address1}) do

    %{venue: nil, address_lines: [address1], locality: city, region: state,
      postal_code: zip, country: country, status: "Potential",
      location: %{longitude: longitude, latitude: latitude, type: type}}
  end
end
