defmodule Mix.Tasks.Nomad.DatabaseInstance.Delete do
  use Mix.Task

  @moduledoc """
  Task for automatically deleting a remote SQL database on a pre-determined
  cloud provider. The instance deletion is done through the cloud provider's
  API.

  Usage:
    
    mix nomad.database_instance.delete
      # Will be prompted for name 

    mix nomad.database_instance.delete <name>  
      # Won't be prompted for name  
  """

  @shortdoc"Delete a SQL database instance on the chosen cloud provider's SQL service."

  @provider Nomad.TasksHelper.get_provider

  @doc """
  Runs the task for the chosen cloud provider. The shell prompts for the 
  instance's name and informs of the result.
  """
  @spec run(list) :: binary
  def run(args) do 
    Nomad.TasksHelper.start_apps_for_adapter(@provider)
    delete_instance_api_call args
  end

  # When no args are provided the prompt asks for the instance's name
  defp delete_instance_api_call([]) do 
    name = Mix.Shell.IO.prompt("Insert the name of the instance you want to delete: ")
    |> String.rstrip

    del name
  end

  # When a name is provided the API call is made directly
  defp delete_instance_api_call([name]) do 
    del name
  end

  defp del(name) do 
    case Nomad.SQL.delete_instance(name) do 
      :ok -> 
        Mix.Shell.IO.info("The instance has been deleted successfully.")
      msg -> 
        Mix.Shell.IO.info("There was a problem deleting the instance:\n#{msg}")
    end      
  end
end
