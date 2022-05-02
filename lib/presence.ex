defmodule PuppiesWeb.Presence do
  use Phoenix.Presence,
    otp_app: :puppies,
    pubsub_server: Puppies.PubSub
end
