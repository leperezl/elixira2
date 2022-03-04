defmodule Rider do
  @rider Rider

    children = [
    Mutex.child_spec(@rider)
    ]
    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

  #Idea:  Even bigger Agent that saves the settings of the driver, then its function starts the req agent
  #Idea:  My idea is to have a Grand Agent that saves the chosen apps and then starts the req agent
  #      -Now when the user selects a service request (turns it into a service), the ServiceRun starts

  #Doubt:  So i will need to pass the state of a child agent to the parent, so that i can start one or toggle
  #        - Reqs and Services
  #Doubt: Can you have a tuple as the state of the agent, or is it ok to have a list
  #     - I would like to give the ServiceReq agent a list/tuple of all the chosen services
  #     - So that when the reqs start_link they know what reqs to begin sending indefinitely
  def rider do
    :world
  end
end
