defmodule Frdapp.RoomChannel do
  use Frdapp.Web, :channel
  use Guardian.Channel


  # def join("rooms:lobby", payload, socket) do
  #   if authorized?(payload) do
  #     {:ok, socket}
  #   else
  #     {:error, %{reason: "unauthorized"}}
  #   end
  # end

  def join("rooms:lobby", message, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  # def handle_in("shout", msg, socket) do
  #   broadcast socket, "shout", %{user: msg["user"], body: msg["body"]}
  #   {:noreply, socket}
  # end


  def handle_in("new:message", msg, socket) do    
    broadcast! socket, "new:message", %{user: msg["user"], body: msg["body"], lat: msg["lat"], lng: msg["lng"]}
    {:noreply, socket}
  end
  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
