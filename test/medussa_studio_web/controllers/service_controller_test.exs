defmodule MedussaStudioWeb.ServiceControllerTest do
  use MedussaStudioWeb.ConnCase

  import MedussaStudio.ServicesFixtures

  @create_attrs %{name: "some name", price: "120.5"}
  @update_attrs %{name: "some updated name", price: "456.7"}
  @invalid_attrs %{name: nil, price: nil}

  describe "index" do
    test "lists all services", %{conn: conn} do
      conn = get(conn, ~p"/services")
      assert html_response(conn, 200) =~ "Listing Services"
    end
  end

  describe "new service" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/services/new")
      assert html_response(conn, 200) =~ "New Service"
    end
  end

  describe "create service" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/services", service: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/services/#{id}"

      conn = get(conn, ~p"/services/#{id}")
      assert html_response(conn, 200) =~ "Service #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/services", service: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Service"
    end
  end

  describe "edit service" do
    setup [:create_service]

    test "renders form for editing chosen service", %{conn: conn, service: service} do
      conn = get(conn, ~p"/services/#{service}/edit")
      assert html_response(conn, 200) =~ "Edit Service"
    end
  end

  describe "update service" do
    setup [:create_service]

    test "redirects when data is valid", %{conn: conn, service: service} do
      conn = put(conn, ~p"/services/#{service}", service: @update_attrs)
      assert redirected_to(conn) == ~p"/services/#{service}"

      conn = get(conn, ~p"/services/#{service}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, service: service} do
      conn = put(conn, ~p"/services/#{service}", service: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Service"
    end
  end

  describe "delete service" do
    setup [:create_service]

    test "deletes chosen service", %{conn: conn, service: service} do
      conn = delete(conn, ~p"/services/#{service}")
      assert redirected_to(conn) == ~p"/services"

      assert_error_sent 404, fn ->
        get(conn, ~p"/services/#{service}")
      end
    end
  end

  defp create_service(_) do
    service = service_fixture()
    %{service: service}
  end
end
