defmodule Puppies.Mappings do
  @moduledoc """
  mappings for puppies
  """

  def listings do
    %{
      mappings: %{
        properties: %{
          id: %{type: :keyword},
          email: %{type: :keyword},
          first_name: %{type: :text},
          approved_to_sell: %{type: :boolean},
          last_name: %{type: :text},
          user_status: %{type: :text},
          photos: %{type: :keyword},
          deliver_on_site: %{type: :boolean},
          deliver_pick_up: %{type: :boolean},
          delivery_shipped: %{type: :boolean},
          champion_sired: %{type: :boolean},
          show_quality: %{type: :boolean},
          champion_bloodline: %{type: :boolean},
          registered: %{type: :boolean},
          registrable: %{type: :boolean},
          current_vaccinations: %{type: :boolean},
          veterinary_exam: %{type: :boolean},
          health_certificate: %{type: :boolean},
          health_guarantee: %{type: :boolean},
          pedigree: %{type: :boolean},
          hypoallergenic: %{type: :boolean},
          microchip: %{type: :boolean},
          purebred: %{type: :boolean},
          coat_color_pattern: %{type: :keyword},
          description: %{type: :text},
          dob: %{type: :date},
          name: %{type: :text},
          price: %{type: :integer},
          sex: %{type: :keyword},
          status: %{type: :keyword},
          breeds_slug: %{type: :keyword},
          breeds_name: %{type: :keyword},
          business_name: %{type: :keyword},
          business_slug: %{type: :keyword},
          business_photo: %{type: :keyword},
          business_breeds_slug: %{type: :keyword},
          phone: %{type: :keyword},
          state_license: %{type: :boolean},
          federal_license: %{type: :boolean},
          website: %{type: :keyword},
          place_name: %{type: :keyword},
          region_slug: %{type: :keyword},
          place_slug: %{type: :keyword},
          region_short_code: %{type: :keyword},
          place: %{type: :keyword},
          region: %{type: :keyword},
          location: %{type: :geo_point},
          updated_at: %{type: :date},
          views: %{type: :keyword}
        }
      }
    }
  end
end
