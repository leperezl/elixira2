
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
  use CSP
  import Supervisor.Spec

  @chan1 Chan1
  @menu MenuMutex
  @apps Apps
  @reqs Requests
  @count Count
  @select Selected

  @rideType {:food, :drive}
  @comm {:api, :phone, :mssg, :fax}
  @payType {:cash, :visa, :mastercard, :points, :epay}
  @name{"John", "Dick", "Bruce", "violet", "Bella"}


    def payType do @payType end
    def comm do @comm end
    def rideType do @rideType end

    def rand_payType() do
      elem(@payType,:rand.uniform(5) -1)
    end

    def rand_name() do
      elem(@name,:rand.uniform(5) -1)
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
      new = IO.gets("Please select one in the next (30 secs):  Type <number> thats in the list above (it selects that number)\n")
      sel= new |> String.trim("\n") |> String.to_integer()
      counter = current_count()
      cond do
        sel < counter -> add_select(sel)
        sel >= counter-> IO.puts("- --- ---- Not in List!!!")
      end
      
    end

    def add_select(sel) do
      
      tup = current_reqs()
      IO.puts("this is tup")
      IO.inspect(tup)
      req = elem(tup, sel)
      t = Time.diff(DateTime.utc_now(), Map.get(req,:created))
      cond do
        t <90 -> select_time(req)
        t >=90 -> reselect(t)
      end
      
    end

    def select_time(req) do
      Channel.get(@chan1)
      IO.puts("-- -- - -- - -- --- -- - -- -- - -- - - \n  v Current service vrrrooo oo ooo mmmm v")
      def = Map.merge(req, %{:duration=> rand_rideTime(), :pickUP => rand_location(), :dropoff => rand_location()}) 
      Agent.update(@select, fn map -> def end)
      IO.inspect(def)
      sleep =Map.get(def, :duration)
      IO.puts("-- -- - -- - -- --- -- - -- -- - -- - - \n  Service ongoing, please wait #{sleep} seconds ")
      :timer.sleep(sleep*1000)
      IO.puts("- -Service Over   :)")
      reset_select()
      #reset_reqs()
      Channel.put(@chan1, :serve)
    end

    def reselect(t) do
        r = t-90
        IO.puts("That request has expired by #{r} seconds")
        select()
    end

      def unregister_op(e) do
        case e do
          {a,b} -> del_item({a,b})
            _-> IO.puts('- --- ---- Not the correct Structure !  --- --- Please enter {"<app>","<channel>"}')
        end
      
      
    end

    def add_item(app) do
      Agent.update(@apps,fn list -> [app | list] end) 
    end

    def del_item(app) do
      Agent.update(@apps,fn list -> List.delete(list,app) end) 
    end


    def requests_periodic(oldTime) do
        Channel.put(@chan1, :serve)
        old = oldTime
        now = DateTime.utc_now()
        dif = Time.diff(now, old)
        Channel.get(@chan1)
       cond do
          dif > 3 -> continue_reqs()
          true -> requests_periodic(old)
        end
       
    end

    def continue_reqs do
      apps = current_apps()
      appTup = List.to_tuple(apps)
      size = tuple_size(appTup)
      app =  elem(appTup,:rand.uniform(size) -1)
      make_req(app)
      requests_periodic(DateTime.utc_now())
    end

    def timer(oldTime) do
      old = oldTime
      now = DateTime.utc_now()
      dif = Time.diff(now, old)
     
     cond do
        dif > 5 -> continue()
        true -> timer(old)
      end
    end

    def continue do
      IO.puts("ping")
      timer(DateTime.utc_now())
    end

    def requests do
      apps = Enum.count(current_apps())
        cond do
          apps == 0 -> register()
          apps > 0 -> req_process()
        end
      
    end

    def req_process do
      
      proc = spawn(fn -> requests_periodic(DateTime.utc_now()) end)
      Process.register(proc, :req_proc)
    end

    def req_stop do
      Process.exit(Process.whereis(:req_proc), :kill)
    end

    def menu do
      ch = IO.gets("--------- -- -- --- -- - \n 1. STOP requests \n 2. Select a service \n 3. Exit \n 4. Reset requests \n chOOse one option!!\n")
      sel= ch |> String.trim("\n") |> String.to_integer()
      case sel do
        1 -> req_stop()
        2 -> select()
        3 -> current_apps()
        4 -> reset_reqs()
        5 -> current_reqs()
        _ -> menu()
      end
    end


    def make_req(x) do
      Agent.update(@reqs,fn tuple -> Tuple.append(tuple,  %{:count => current_count(), :apps => x,:type => rand_rideType(), :price=> rand_price(), 
                                                            :payment => rand_payType(),:name => rand_name() ,:created =>  DateTime.utc_now()} ) end) 
                                                           
      num =current_count()
      tup = current_reqs()
      req = elem(tup, num)
      add_count()
      res = {num, req}
      IO.inspect(res)

     
     
    end

    #|> Tuple.to_list() |>Enum.reverse()|> Enum.slice(0,10) |> Enum.reverse()
    #elem(tup,tuple_size(tup)-1)

    
    def start do
      children = [
        worker(Channel, [[name: @chan1, buffer_size: 10]])
      ]
      {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)

      #chan1 = Channel.new
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

    def current_select do
      Agent.get(@select, fn content -> content end)
    end

    def reset_select do
      Agent.get(@select, fn content -> %{} end)
    end

    def add_count do
        Agent.update(@count, fn content -> content + 1 end)
    end

    def reset_apps do
      Agent.update(@apps, fn content -> [] end)
    end

    def reset_count do
      Agent.update(@count, fn content -> 0 end)
    end

    def reset_reqs do
      Agent.update(@reqs, fn content -> {} end)
      reset_count()
    end
    
end
