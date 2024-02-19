defmodule MedussaStudio.ServicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MedussaStudio.Services` context.
  """

  @doc """
  Generate a service.
  """
  def service_fixture(attrs \\ %{}) do
    {:ok, service} =
      attrs
      |> Enum.into(%{
        name: "some name",
        price: "120.5"
      })
      |> MedussaStudio.Services.create_service()

    service
  end
end
