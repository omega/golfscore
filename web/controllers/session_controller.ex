defmodule Golf.SessionController do
  use Golf.Web, :controller

  alias Golf.User
  import Comeonin.Bcrypt, only: [checkpw: 2]
  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    render conn, "new.html", changeset: User.changeset(%User{})
  end

  def create(conn, %{"user" => user_params}) do
    Repo.get_by(User, email: user_params["email"])
    |> sign_in(user_params["password"], conn)
  end

  def logout(conn, _params) do
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end

  defp sign_in(user, _password, conn) when is_nil(user) do
    conn
    |> put_flash(:error, "Invalid username/password")
    |> redirect(to: session_path(conn, :new))
  end

  defp sign_in(user, password, conn) do
    if checkpw(password, user.password_digest) do
      conn
      |> put_session(:current_user, %{id: user.id, email: user.email})
      |> put_flash(:info, "Logged in")
      |> redirect(to: page_path(conn, :index))
    else
      conn
      |> put_session(:current_user, nil)
      |> put_flash(:error, "Invalid username/password")
      |> redirect(to: session_path(conn, :new))
    end
  end

end

