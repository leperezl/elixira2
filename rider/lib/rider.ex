
  # Services  (Uber, Didi, Beat, Indriver, Cabify, Taxi, Uber eats, iFood, Didi Food) 
            # Id: :Name constant      Comm: API  (no idea)
  # Service Req
            # When registered ^Service  For each, services should be generated. Have pattern matching and spawn generator or List Iterator
            #Username: "String"   Type: :Food :Drive     Price: Random Int        Payment:        TimeSent:
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
  @select Selected

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
      r =:rand.uniform(20)
      r
    end

    def rand_price() do
      r =:rand.uniform(90)
      "$#{r}"
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
      new = IO.gets("To register an app:  <AppName> <Communications channel>  \n")
      register_op(new)
      current_apps()
    end

    def unregister(app) do
      IO.puts("To UnRegister an app:  <AppName> <Communications channel>  \n ------------------- \n (PRO TIP) make sure that you type it correctly haha")
      unregister_op(app)
      current_apps()
    end

    #We need the apps key in agent get(map, key, default \\ nil)
    def register_op(e) do
      eF= e |> String.trim("\n") |> String.split() |> List.to_tuple()
      case eF do
        {a,b} -> add_item({a,b})
         _ -> IO.puts("- --- ---- Not the correct Structure !  --- --- Please enter <app> <channel>")
      end
    end

    def select() do
      {IO.puts("-- -- - -- -- - - -- - -- --- -- -- -- - -")}
      new = IO.gets("Please select one in the next (10 secs):  Type <number> from 0 to 9  (it selects that number)\n")
      sel= new |> String.trim("\n") |> String.to_integer()
      cond do
        is_integer(sel) -> add_select(sel)
        is_integer(sel) == false -> IO.puts("- --- ---- Enter a number !!!")
      end
    end

    def add_select(sel) do
      tup = current_reqs()
      req = elem(tup, sel)

    end

      def unregister_op(e) do
        case e do
          {a,b} -> del_item({a,b})
            _-> IO.puts("- --- ---- Not the correct Structure !  --- --- Please enter {<app>,<channel>}")
        end
      
      
    end

    def add_item(app) do
      Agent.update(@apps,fn list -> [app | list] end) 
    end

    def del_item(app) do
      Agent.update(@apps,fn list -> List.delete(list,app) end) 
    end

    #helper function that generates requests based on the current apps registered
    def requests do
        reset_reqs()
        apps = current_apps()
        appTup = List.to_tuple(apps)
        case appTup do
          {x} -> req_spawner(x)
          {x,y} -> req_spawner2(x,y)
          {x,y,z} -> req_spawner2(x,y,z)
          {x,y,z,a} -> req_spawner2(x,y,z,a)
          {x,y,z,a,b} -> req_spawner2(x,y,z,a,b)
          _ -> {IO.puts("-------- More than 5 apps ? come on man ! delete one \n - --- - Use Rider.unregister({<app>, <comm>})")}
        end
        select()
        #Enum.map(apps, fn x -> req_spawner(x) end) 
    end

    def req_spawner(x) do
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(x) end) 
    end

    def req_spawner2(x,y) do
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
    end

    def req_spawner3(x,y,z) do
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(z) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(z) end) 
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(z) end) 
      spawn(fn -> make_req(x) end) 
    end

    def req_spawner4(x,y,z,a) do
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(z) end) 
      spawn(fn -> make_req(a) end) 
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(z) end) 
      spawn(fn -> make_req(a) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(z) end) 
      spawn(fn -> make_req(y) end) 
    end

    def req_spawner5(x,y,z,a, b) do
      spawn(fn -> make_req(y) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(z) end) 
      spawn(fn -> make_req(a) end) 
      spawn(fn -> make_req(b) end) 
      spawn(fn -> make_req(z) end) 
      spawn(fn -> make_req(a) end) 
      spawn(fn -> make_req(x) end) 
      spawn(fn -> make_req(b) end) 
      spawn(fn -> make_req(y) end) 
    end



    def make_req(x) do
      

      resource_id= {User,{:id,1}}
      lock = Mutex.await(@menu, resource_id)

      Agent.update(@reqs,fn tuple -> Tuple.append(tuple,  %{:apps => x,:type => rand_rideType(), :price=> rand_price(), 
                                                              :payment => rand_payType(), :duration=> rand_rideTime(), :pickUP => rand_location(), 
                                                              :dropoff => rand_location(), :created =>  DateTime.utc_now()} ) end)
        
      #:timer.sleep(1000)
      num =current_count()
      tup = current_reqs()
      req = elem(tup, num)
      add_count()
      res = {num, req}
      IO.inspect(res)
      Mutex.release(@menu, lock)
    end

    #When 

    
    def start do
      children = [
        Mutex.child_spec(@menu)
        ]
        {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one) 
        
      Agent.start_link(fn -> [] end , name: @apps)
      Agent.start_link(fn -> {} end , name: @reqs)
      Agent.start_link(fn -> %{}end, name: @select)
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

    def add_count do
      Agent.update(@count, fn content -> content + 1 end)
    end

    def reset_count do
      Agent.update(@count, fn content -> 0 end)
    end

    def reset_reqs do
      Agent.update(@reqs, fn content -> {} end)
      reset_count()
    end
    
end
