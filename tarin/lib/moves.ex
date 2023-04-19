defmodule Moves do

  def sequence([], state) do [state] end
  def sequence([move|rest], state) do
    [state | sequence(rest, single(move, state))]
  end

  def single({_, 0}, state)  do state end
  def single({:one,n}, list) do
    if n > 0 do
      {main, one, two} = list
      {0, remain, taken} = Train.main(main, n)
      {remain, Train.append(taken, one), two}
    else
      {main, one, two} = list
      wagons = Train.take(one, -n)
      {Train.append(main, wagons), Train.drop(one, -n), two}
    end
  end
  def single({:two,n}, list) do
    if n > 0 do
      {main, one, two} = list
      {0, remain, taken} = Train.main(main, n)
      {remain, one, Train.append(taken, two)}
    else
      {main, one, two} = list
      wagons = Train.take(two, -n)
      {Train.append(main, wagons), one, Train.drop(two, -n)}
    end
  end





end
