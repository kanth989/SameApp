defmodule Frdapp.AuthController do
  use Frdapp.Web, :controller

  alias Frdapp.Auth

  plug :scrub_params, "auth" when action in [:create, :update]

  plug Ueberauth

  def login(conn, _params, current_user, _claims) do
    render(conn, "index.json", auths: auths, current_user: current_user, current_auths: auths(current_user))

    # render conn, "login.html", current_user: current_user, current_auths: auths(current_user)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params, current_user, _claims) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("login.html", current_user: current_user, current_auths: auths(current_user))
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do
    case UserFromAuth.get_or_insert(auth, current_user, Repo) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed in as #{user.name}")
        |> Guardian.Plug.sign_in(user, :token, perms: %{default: Guardian.Permissions.max})
        |> redirect(to: private_page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not authenticate")
        |> render("login.html", current_user: current_user, current_auths: auths(current_user))
    end
  end

  def logout(conn, _params, current_user, _claims) do
    if current_user do
      conn
      # This clears the whole session.
      # We could use sign_out(:default) to just revoke this token
      # but I prefer to clear out the session. This means that because we
      # use tokens in two locations - :default and :admin - we need to load it (see above)
      |> Guardian.P.
      -lug.sign_out
      |> put_flash(:info, "Signed out")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:info, "Not logged in")
      |> redirect(to: "/")
    end
  end

  defp auths(nil), do: []
  defp auths(%Frdapp.User{} = user) do
    Ecto.Model.assoc(user, :authorizations)
      |> Repo.all
      |> Enum.map(&(&1.provider))
  end
  # def index(conn, _params) do
  #   auths = Repo.all(Auth)
  #   render(conn, "index.json", auths: auths)
  # end

  # def create(conn, %{"auth" => auth_params}) do
  #   changeset = Auth.changeset(%Auth{}, auth_params)

  #   case Repo.insert(changeset) do
  #     {:ok, auth} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", auth_path(conn, :show, auth))
  #       |> render("show.json", auth: auth)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(Frdapp.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   auth = Repo.get!(Auth, id)
  #   render(conn, "show.json", auth: auth)
  # end

  # def update(conn, %{"id" => id, "auth" => auth_params}) do
  #   auth = Repo.get!(Auth, id)
  #   changeset = Auth.changeset(auth, auth_params)

  #   case Repo.update(changeset) do
  #     {:ok, auth} ->
  #       render(conn, "show.json", auth: auth)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(Frdapp.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   auth = Repo.get!(Auth, id)

  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(auth)

  #   send_resp(conn, :no_content, "")
  # end
end
