defmodule Upp1 do
  @moduledoc """
  Documentation for `Upp1`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Upp1.hello()
      :world

  """
  @type literal() :: {:num, number()}| {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | {:exp, expr(), {:num, literal()}}
  | {:ln, expr()}
  | {:sqrt, expr()}
  | {:sin, expr()}



  def test() do
    e = {:add,
    {:add,
      {:mul, {:num, 2},
        {:mul, {:var, :x}, {:var, :x}} },
          {:mul, {:num, 3}, {:var, :x}}}, {:num, 5}}


    d = deriv(e, :x)
    IO.write(" expression: #{pprint(e)}\n")
    IO.write(" expressions derivative: #{pprint(d)}\n")
    IO.write(" simplified: #{pprint(simplify(d))}\n")

    :ok
  end

  def test2() do
    e = {:add, {:exp, {:var, :x}, {:num, 3}}, {:num, 3}}

    d = deriv(e, :x)
    IO.write(" expression: #{pprint(e)}\n")
    IO.write(" expressions derivative: #{pprint(d)}\n")
    IO.write(" simplified: #{pprint(simplify(d))}\n")

    :ok
  end

  def test3() do
    e = {:sqrt, {:mul,{:num, 2}, {:var, :x}}}
    #e = {:ln, {:var, :x}}
    d = deriv(e, :x)
    IO.write(" expression: #{pprint(e)}\n")
    IO.write(" expressions derivative: #{pprint(d)}\n")
    IO.write(" simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def test4() do
    e = {:sin, {:var, :x}}
    #e = {:ln, {:var, :x}}
    d = deriv(e, :x)
    IO.write(" expression: #{pprint(e)}\n")
    IO.write(" expressions derivative: #{pprint(d)}\n")
    IO.write(" simplified: #{pprint(simplify(d))}\n")
    :ok
  end


  def deriv({:num, _}, _) do
    {:num, 0}
  end

  def deriv({:var, _}, _) do
    {:num, 1}
  end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

 #Product rule.
  def deriv({:mul, e1, e2}, v) do
    {:add,
    {:mul, deriv(e1, v), e2},
    {:mul, e1, deriv(e2, v)}}
  end

  #exp rule
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1} }},
        deriv(e, v)}
  end

  #ln
  def deriv({:ln, e1}, v) do
    {:div, {:num, 1}, {:var, :x}}
  end

  #squre root
  def deriv({:sqrt, e1}, v) do
    {:div,
    deriv(e1, v),
    {:mul, {:num, 2}, {:sqrt, e1}}
  }
  end

  #sinus
  def deriv({:sin, e1}, v) do
    {:mul,
    deriv(e1, v),
    {:cos, e1}}
  end



    #Sin rule
   # def deriv({:sin, {:var, n}}, v) do
    #  {:mul,
     #   {:mul, {:num, n}, {:exp, e, {:num, n-1} }},
      #    deriv(e, v)}
    #end






  #simplifing the expressions
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end



  #Printing so that it will be easier to read.
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)}) ^ (#{pprint(e2)})" end
  def pprint({:div, e1, e2}) do "(#{pprint(e1)}) / (#{pprint(e2)})" end
  def pprint({:sqrt, e1}) do "(sqrt #{pprint(e1)})" end
  def pprint({:cos, e1}) do "(cos #{pprint(e1)})" end
  def pprint({:sin, e1}) do "(sin #{pprint(e1)})" end

end
