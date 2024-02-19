defmodule MedussaStudioWeb.ServiceHTML do
  use MedussaStudioWeb, :html

  embed_templates "service_html/*"

  @doc """
  Renders a service form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def service_form(assigns)
end
