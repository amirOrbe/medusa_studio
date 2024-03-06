defmodule MedussaStudioWeb.UserSessionController do
  use MedussaStudioWeb, :controller

  alias MedussaStudio.Accounts
  alias MedussaStudioWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "¡Cuenta creada exitosamente!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "¡Contraseña actualizada exitosamente!")
  end

  def create(conn, params) do
    create(conn, params, "¡Bienvenido de nuevo!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Correo electrónico o contraseña no válidos.")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Cerró sesión exitosamente.")
    |> UserAuth.log_out_user()
  end
end
