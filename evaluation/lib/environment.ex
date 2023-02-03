defmodule Upp1 do
   """

   @type literal() :: {:num, number()}| {:var, atom()} |{:q, number(), number()}

   @type expr() :: {:add, expr(), expr()}
   | {:sub, expr(), expr()}
   | {:mul, expr(), expr()}
   | {:div, expr(), expr()}
   | literal()


   def addFun({:q, y, z}, {:q, c, d}) do
      {:q, y * d + c * z, z * d}
   end
   def addFun(a, {:q, x, y}) do
      {:q, a * y + x, y}
   end
   def addFun({:q, y, z}, h) do
      {:q, h * z + y, z}
   end
   def addFun(h, p) do
      h + p
   end


   def subFun(h, {:q, y, z}) do
      {:q, h * z - y, z}
   end
   def subFun({:q, y, z}, h) do
      {:q, h * z - y, z}
   end
   def subFun({:q, y, z}, {:q, c, d}) do
      {:q, y * d - c * z, z * d}
   end
   def subFun(h, p) do
      h - p
   end


   def mulFun(h, {:q, y, z}) do
      {:q, h * y, z}
   end
   def mulFun({:q, y, z}, h) do
      {:q, h * y, z}
   end
   def mulFun({:q, y, z}, {:q, c, d}) do
      {:q, y * c, z * d}
   end
   def mulFun(h, p) do
      h * p
   end


   def divFun(h, p) do
      if (is_float(h/p)) do
         h/h
      else
         h/p
      end
   end
   def divFun(h, {:q, y, z}) do
      {:q, h * p, y}
   end
   def divFun({:q, y, z}, h) do
      {:q, y, z * h}
   end
   def divFun({:q, y, z}, {:q, c, d}) do
      {:q, y * d, z * c}
   end

   def eval({:num, z}, _) do z end
   def eval({:var, v}, mapVar) do
      Map.get(mapVar, v)
   end
   def eval({:add, h, p}, mapVar) do
      addFun(eval(h), eval(p))
   end
   def eval({:sub, h, p}, mapVar) do
      subFun(eval(h), eval(p))
   end
   def eval({:mul, h, p}, mapVar) do
      mulFun(eval(h), eval(p))
   end
   def eval({:div, h, p}, mapVar) do
      divFun(eval(h), eval(p))
   end


   def test5() do
      env = %{a: 1, b: 2, c: 3, d: 4}
      e = {:mul, {:div, {:num, 3}, {:num,4 }}, {:num, 2}}
      d= eval(e, env)
   end
#if its is a number then we just return it. But if it is a variable then we get the number assoieted with the variable.

"""








 end
