defmodule Env do

  @type value :: any()  #the following constructs are terms and can be any thing form expressons to atom.
  @type key :: atom() # Our key is an atom
  @type env :: [{key, value}]

  def new() do
    []
 end

 def add(key, value, env) do [{key, value}| env] end

 def lookup(_, []) do nil end
 def lookup(key, [h | env]) do
   if(elem(h, 0) == key) do
      {elem(h, 0),elem(h, 1)}
   else
      lookup(key, env)
   end
 end

 def remove(_, []) do [] end
 def remove(key, [h | env]) do
   if(elem(h, 0) == key) do
      remove(key, env)
   else
      newList= remove(key, env)
      [h| newList]
   end
 end






end
