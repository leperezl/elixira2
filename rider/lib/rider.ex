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

  # Services  (Uber, Didi, Beat, Indriver, Cabify, Taxi, Uber eats, iFood, Didi Food) 
            # Id: :Name constant      Comm: API  (no idea)
  # Service Req
            # When registered ^Service  For each, services should be generated. Have pattern matching and spawn generator or List Iterator
            # Id: "Service+Count"  Username: "String"   Type: :Food :Drive     Price: Random Int        Payment: 
            # For each ^Service, each service has Type and 3 possible payment methods (we can use just one)
  #Chosen Ride
            # When User selects "Service+Count" ex: "Uber5" (Doubt) -> i have no idea how to select those
            # Username: "String"   Type: :Food :Drive     Price: Random Int       Payment:      Time: Random Int  Pick Up: Random Int    Dropoff: Random Int
  #First Mutex 
            #->  Every Service spawn will compete to Print IO.PUT   Mutex in the print method
            #->  When Selected the spawns shouldnt keep sending stuff. Bigger Mutex that is released
            #-> Bigger Mutex activated by global boolean that will signify one request is activated and it should be changed after a timeout
            #-> 2 functions, one to select init and one that will return after X time
  def rider do
    :world
  end
end
