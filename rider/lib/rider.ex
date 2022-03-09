
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
  @apps Apps
  @reqs Requests
  @count Count

  @rideType {:food, :drive}
  @comm {:api, :phone, :mssg, :fax}
  @payType {:cash, :visa, :mastercard, :points, :epay}

    def payType do @payType end
    def comm do @comm end
    def rideType do @rideType end

    def rand_payType() do
      elem(@payType,:rand.uniform(5) -1)
    end
   
    def rand_comm() do
      elem(@comm,:rand.uniform(4) -1)
    end
   
    def rand_rideType() do
      elem(@rideType,:rand.uniform(2) -1)
    end
    
    def rand_rideTime() do
      r =:rand.uniform(90)
      "#{r} minutes"
    end

    def rand_location() do
      r =:rand.uniform(90)/17.665
      "Coordinates: #{r}"
    end

    def menu do
      IO.puts("###############################################################")
      op = IO.gets("select one of the following \n")
      redirector(op)
    end

    def redirector(e) do
      eF= String.trim(e,"\n") |> Integer.parse()
      elem(eF,0)
    end

    def register do
      new = IO.gets("select one of the following \n")
      register_op(new)
    end

    #We need the apps key in agent get(map, key, default \\ nil)
    def register_op(e) do
      eF= e |> String.trim("\n") |> String.split() |> List.to_tuple()
      add_item(eF)
      
    end

    def add_item(app) do
    Agent.update(@apps,fn list -> [app | list] end)
        
    end

    def req_service do

        apps = currentApps()
         Enum.map(apps, fn x -> Agent.update(@reqs,fn tuple -> Tuple.append(tuple, %{:apps => x, :payment => rand_payType() }) end) end)
         

         
    end
    
    def start do
      #children = [
      #Mutex.child_spec(@menu)
      #]
      #{:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one) 
      Agent.start_link(fn -> [] end , name: @apps)
      Agent.start_link(fn -> {} end , name: @reqs)
      Agent.start_link(fn -> 0 end , name: @count)
      
    end

    def current_apps do
      Agent.get(@apps, fn content -> content end)
    end

    def current_reqs do
      Agent.get(@reqs, fn content -> content end)
    end

    def current_count do
      Agent.get(@count, fn content -> content end)
    end
    
end
