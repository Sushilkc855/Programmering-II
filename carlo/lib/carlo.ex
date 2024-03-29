defmodule Carlo do
  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    :math.pow(r, 2) > :math.pow(x, 2) + :math.pow(y, 2)
  end

  def round(0, _, a) do
    a
  end
  def round(k, r, a) do
    if (dart(r)) do
      round(k-1, r, a+1)
    else
      round(k-1, r, a)
    end
  end

  def rounds(k, j, r) do
    rounds(k, j, 0, r, 0)
  end
  def rounds(0, _, t, _, a) do 4*a/t end
  def rounds(k, j, t, r, a) do
    a = round(j, r, a)
    t = t + j
    pi = 4*a/t
    :io.format("pi = ~14.10f,  dp = ~14.10f: ", [pi, (pi - :math.pi())])
    rounds(k-1, j*2, t, r, a)
  end


end
