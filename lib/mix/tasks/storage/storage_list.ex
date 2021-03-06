defmodule Mix.Tasks.Nomad.Storage.List do
  use Mix.Task

  @moduledoc"""
  Task for automatically listing all remote storages on a pre-determined
  cloud provider. The storage listing in done through the cloud
  provider's API.

  Usage:

    mix nomad.storage.list
  """

  @shortdoc"Lists all storages on the chosen cloud provider's storage service."

  @provider Nomad.TasksHelper.get_provider

  @spec run(list) :: binary
  def run(_args) do
    Nomad.TasksHelper.start_apps_for_adapter(@provider)
    list_storages_api_call
  end

  defp list_storages_api_call do
    provider =
      case @provider do
        :aws -> "Amazon Web Services"
        :gcl -> "Google Cloud Platform"
      end

    res = Nomad.Storage.list_storages

    if is_list(res) && res != [] do
      res = into_list(res)

      TableRex.quick_render!(res, [provider]) |> Mix.Shell.IO.info

    else
      if res == [] do
        Mix.Shell.IO.info("There are no storages to be listed.")
      else
        Mix.Shell.IO.info("There was a problem listing the storages:\n#{res}")
      end
    end
  end

  defp into_list(list) do
    for elem <- list do
      [elem]
    end
  end
end
