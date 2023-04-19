defmodule Train do

  #returns the train containing the first n wagons of train
  def take(_, -1) do
    :error
  end
  def take(_, 0) do
    []
  end
  def take([list|train], n) do
    newList = take(train, n-1)
    [list|newList]
  end

  #returns the train train without its first n wagon
  def drop(_, -1) do
    :error
  end
  def drop(rest, 0) do
    rest
  end
  def drop([_|train], n) do
    newList = drop(train, n-1)
    newList
  end

  #returns the train that is the combinations of the two trains.
  def append([],train2) do
    train2
  end
  def append([first|train1],train2) do
    [first|append(train1,train2)]
  end

  #tests whether y is a wagon of train
  def member([],_) do
    :false
  end
  def member([el|train], y) do
    if el==y do
      :true
    else
      member(train, y)
    end
  end

  #returns the first position (1 indexed) of y in the
  #train train.
  def position([], _) do
    :error
  end
  def position([el|train], y) do
    if el==y do
      1
    else
      position(train, y) +1
    end
  end

  #return a tuple with two trains, all the wagons before
  #y and all wagons after y (i.e. y is not part in either).
  def split(train, y) do
    index = position(train, y)
    {take(train, index-1), drop(train, index)}
  end

  #main(train, n) returns the tuple {k, remain, take} where remain
  #and take are the wagons of train and k are the numbers of wagons
  #remaining to have n wagons in the taken part
  def main([], n) do {n, [], []} end
  def main([el|train], n) do
    {n, remain, take} = main(train, n)
    if n == 0 do
      remain = [el|remain]
      {n, remain, take}
    else
      take = [el|take]
      n = n-1
      {n, remain, take}
    end
  end




end
