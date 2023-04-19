defmodule Higerfuntion do

  def sum( [] ) do 0 end
  def sum( [x|list] ) do
    x + sum(list)
  end

  #takes a list of
  #integers as input and returns a list where all elements have been doubled
  def double( [] ) do [] end
  def double([x|y]) do
    newList = double(y)
    [x * 2|newList]
  end

  #takes a list of integers and returns a
  #list where we have added five to each element.
  def five( [] ) do [] end
  def five( [x|y] ) do
    newList = five(y)
    [x + 5|newList]
  end

  #replaces each occurrence of :dog with :fido
  def animal( [] ) do [] end
  def animal( [x|y] ) do
    newList = animal(y)
    if (x == :dog) do
      [:fedo |newList]
    else
      [x|newList]
    end
  end

  #does all the above with one function
  def double_five_animal( [], _) do [] end
  def double_five_animal( [x|list], argu) do
    case argu do
      :five -> newList = double_five_animal(list, argu)
                [x + 5|newList]
      :double ->  newList = double_five_animal(list, argu)
                  [x * 2|newList]
      :animal -> newList = double_five_animal(list, argu)
                  if (x == :dog) do
                    [:fedo |newList]
                  else
                    [x|newList]
                  end
    end
  end

  #map
  # Higerfuntion.apply_to_all([:dog, :cat], fn(x) -> if (x == :dog), do: :fido, else: x end)
  def apply_to_all([], _) do [] end
  def apply_to_all([x|list], function) do
    newList = apply_to_all(list, function)
    [function.(x)|newList]
  end

  #we first go down the list
  #recurs new och does operations when going up
  def fold_right([], acc, _op ) do acc end
  def fold_right([h|t], acc, f ) do
    f.(h, fold_right(t, acc, f))
  end



  #svans recursive. we do the same. When we go down the botton
  #på vägen ner applicerar vi operationer.
  def fold_left([], acc, _op ) do acc end
  def fold_left([h|t], acc, f ) do
    fold_left(t, f.(h, acc), f)
  end


  def odd( [] ) do [] end
  def odd( [x|list] ) do
    if rem(x,2)==1 do
     [x|odd(list)]
    else
     odd(list)
    end
  end
  #filter([1,3,4,2,5,6], fn (x) -> x>3 end)
  def filter([], _ ) do
    []
  end
  def filter([el|list], op) do
    if op.(el) do
      [el|filter(list, op)]
    else
      filter(list, op)
    end
  end










end
