
  # Services  (Uber, Didi, Beat, Indriver, Cabify, Taxi, Uber eats, iFood, Didi Food) 
            # Id: :Name constant      Comm: API  (no idea)
  # Service Req
            # When registered ^Service  For each, services should be generated. Have pattern matching and spawn generator or List Iterator
            # Id: "Service+Count"  Username: "String"   Type: :Food :Drive     Price: Random Int        Payment:        TimeSent:
            # For each ^Service, each service has Type and 3 possible payment methods (we can use just one)
  #Chosen Ride
            # When User selects "Service+Count" ex: "Uber5" (Doubt) -> i have no idea how to select those
            # Username: "String"   Type: :Food :Drive     Price: Random Int       Payment:      Time: Random Int  Pick Up: Random Int    Dropoff: Random Int
  #First Mutex 
            #->  Every Service spawn will compete to Print IO.PUT   Mutex in the print method
            #->  When Selected the spawns shouldnt keep sending stuff. Bigger Mutex that is released
            #-> Bigger Mutex activated by global boolean that will signify one request is activated and it should be changed after a timeout
            #-> 2 functions, one to select init and one that will return after X time
defmodule Rider do
  @menu MenuMutex


    @rider __MODULE__
    @payType {:food, :drive}
    @uber %{:id=> "uber" , :comm=> "api"}
    @didi %{:id=> "didi" , :comm=> "api"}
    @beat %{:id=> "beat" , :comm=> "api"}
    @taxi %{:id=> "taxi" , :comm=> "phone"}

    def payType do @payType end
    def randType(n) do
        elem(@payType, n)
    end
    def start_link do
      children = [
      Mutex.child_spec(@menu)
      ]
      {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
        Agent.start_link(fn ->%{} end , @rider)
    end
end
