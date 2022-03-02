defmodule Rider do
  @rider Rider

    children = [
    Mutex.child_spec(@rider)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

  def rider do
    :world
  end
end
