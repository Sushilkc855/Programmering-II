defmodule Higher do

  def test() do
    hanoi(5, :a, :b, :c)
  end


  def hanoi(0, _, _, _) do [] end
  def hanoi(n, from, aux, to) do
    hanoi(n-1, from, to, aux) ++
    [{:move, from, to}] ++
    hanoi(n-1, aux, from, to )
  end


  def hello do
    :world
  end
end
