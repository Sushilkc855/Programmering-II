defmodule Day16 do

  def task() do
    start = :AA
    #rows = File.stream!("day16.csv")
    rows = sample()
    parse(rows)
  end



  ## turning rows
  ##
  ##  "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE"
  ##
  ## into tuples
  ##
  ##  {:DD, {20, [:CC, :AA, :EE]}
  ##

  def parse(input) do
    Enum.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, {rate, valves}}
    end)
  end

  def sample() do
    ["Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
     "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
     "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
     "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
     "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
     "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
     "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
     "Valve HH has flow rate=22; tunnel leads to valve GG",
     "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
     "Valve JJ has flow rate=21; tunnel leads to valve II"]
  end

  def shortestpath(_, 30, _, _) do
      :DONE
  end
  def shortestpath(list, timeCounter, pressure, currentpos) do
    {valve, {rate, valves}} = currentpos
    for n <- valves,
      do:
        shortestpath(list, timeCounter = timeCounter + 10, pressure, lookUp(list, n))
  end

  #lookkup for search valve in the list and returns the element corisspoding to the valve
  def lookUp([], _) do
    :notFound
  end
  def lookUp([element|list], valve1) do
    {valve, {_ , _}} = element
    if (valve == valve1) do
      element
    else
      lookUp(list, valve)
    end
  end



end
