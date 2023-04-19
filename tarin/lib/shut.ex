defmodule Shunt do

  def find(_, []) do [] end
  def find(xs, [y|ys]) do
    [head|rest] = xs
    if head == y do
        find(rest, ys)
    else
      {hs, ts} = Train.split(xs, y)
      tn = length(ts) #0
      hn = length(hs) #1
      [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | find(Train.append(hs, ts), ys)]
    end
  end


def better(_, []) do [] end
def better(xs, [y|ys]) do
  [head|rest] = xs
  if head == y do
      find(rest, ys)
  else
    {hs, ts} = Train.split(xs, y)
    tn = length(ts) #0
    hn = length(hs) #1
    [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | better(Train.append(hs, ts), ys)]
  end
end


def rules([]) do
  []
end
def rules([el|rest]) do
  new = rules(rest)
  if new == [] do
    [el|new]
  else
    {atom1,n} = el
    [second|list1] = new
    {atom2,m} = second
    if atom1 == atom2  do
      list1 = [{atom1,m+n}|list1]
    else
      [el|new]
    end

  end
end


end
