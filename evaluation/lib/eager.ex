defmodule Eager do
  @type atm :: {:atm, atom}
  @type variable :: {:var, atom}
  @type ignore :: :ignore
  @type cons(t) :: {:cons, t, t}

  @type pattern :: atm | variable | ignore | cons(pattern)

  @type lambda :: {:lambda, [atom], [atom], seq}
  @type apply :: {:apply, expr, [expr]}
  @type case :: {:case, expr, [clause]}
  @type clause :: {:clause, pattern, seq}

  @type expr :: atm | variable | lambda | apply | case | cons(expr)


  @type match :: {:match, pattern, expr}
  @type seq :: [expr] | [match | seq]

  @type closure :: {:closure, [atom], seq, env}
  @type str :: atom | [str] | closure

  @type env :: [{atom, str}]
 # @spec eval expr({:atm, :a}, []) :: returns {:ok, :a}
 # @spec eval expr({:var, :x}, [{:x, :a}]) :: returns {:ok, :a}
 # @spec eval expr({:var, :x}, []) :: returns :error
 # @spec eval expr({:cons, {:var, :x}, {:atm, :b}}, [{:x, :a}]) :: returns {:ok, {:a, :b}}


 def test() do
  eval = {:var, :x}
  str =  :a
  eval_match(eval, str, [])
 end


 def test2() do
  seq = [{:match, {:var, :x}, {:atm,:a}},
  {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
  {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
  {:var, :z}]
  env = []
  Eager.eval_seq(seq, env)
 end

 def clsTest do
  seq = [{:match, {:var, :x}, {:atm, :a}},
        {:case, {:var, :x},
        [{:clause, {:atm, :b}, [{:atm, :ops}]},
        {:clause, {:atm, :a}, [{:atm, :yes}]}
        ]}]

  Eager.eval_seq(seq, [])

 end

 def landaTest do
  seq = [{:match, {:var, :x}, {:atm, :a}},
    {:match, {:var, :f},
    {:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}},
    {:apply, {:var, :f}, [{:atm, :b}]}
    ]

    Eager.eval_seq(seq, Env.new())
 end

 def lastTest do
  seq = [{:match, {:var, :x},
    {:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}},
    {:match, {:var, :y},
    {:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}},
    {:apply, {:fun, :append}, [{:var, :x}, {:var, :y}]}
  ]
  Eager.eval_seq(seq, Env.new())


 end




  def eval_expr({:atm, id}, _) do
    {:ok, id}
  end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end

  def eval_expr({:cons, head, tail}, env) do
    case eval_expr(head, env) do
      :error ->
        :error

      {:ok, hs} ->
      case eval_expr(tail, env) do
        :error ->
          :error
        {:ok, ts} ->
          {:ok, {hs, ts}}
      end
    end
  end
  # Case expressions
  def eval_expr({:case, expr, cls}, envron) do
    case eval_expr(expr, envron) do
      :error->
        :error
      {:ok, str} ->
    eval_cls(cls, str, envron)
    end
  end
  # Lambda expressions
  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error
      closure ->
        {:ok, {:closure, par, seq, closure}}
    end
  end

  def eval_expr({:apply, expr, args}, env) do
    case  eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, par, seq, closure}} ->
      case eval_args(args, env) do
        :error ->
          :error
        {:ok, strs} ->
          env = Env.args(par, strs, closure)
          eval_seq(seq, env)
      end
    end
  end


  def eval_args(args, env) do
    eval_args(args, env, [])
  end

  def eval_args([], _, strs) do {:ok, Enum.reverse(strs)}  end
  def eval_args([expr | exprs], env, strs) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_args(exprs, env, [str|strs])
    end
  end






# eval match({:atm, :a}, :a, []) : returns {:ok, []}
# eval match({:var, :x}, :a, []) : returns {:ok, [{:x, :a}]}
# eval match({:var, :x}, :a, [{:x, :a}]) : returns {:ok, [{:x,:a}]}
# eval match({:var, :x}, :a, [{:x, :b}]) : returns :fail
# eval match({:cons, {:var, :x}, {:var, :x}}, {:a, :b}, []) :returns :fail
  #e we already have the environment module then we just return the same invaronment.


  def eval_match(:ignore, _, env) do
    {:ok, env}
  end
  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil ->
        {:ok, Env.add(id, str, env)}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end
  #We check for matches of head with hs and tail with ts
  def eval_match({:cons, head, tail}, {hs, ts}, env) do
    case eval_match(head, hs, env) do
      :fail ->
        :fail
      {:ok, env} ->
        eval_match(tail, ts, env)
    end
  end
  def eval_match(_, _, _) do
    :fail
  end


  #Seq
  def eval_scope(pattern, env) do
    Env.remove(extract_vars(pattern), env)
  end
  def eval_seq([exp], env) do
    eval_expr(exp, env)
  end
  def eval_seq([{:match, ptr, exp} | seq], env) do
    case eval_expr(exp, env) do
      :error ->
        :error
      {:ok, str} -> #we get a
        env = eval_scope(ptr, env)
      case eval_match(ptr, str, env) do
        :fail ->
          :error
        {:ok, env} ->
          eval_seq(seq, env)
      end
    end
  end

  def extract_vars(pattern) do
    extract_vars(pattern, [])
  end
  def extract_vars({:atm, _}, vars) do vars end
  def extract_vars(:ignore, vars) do vars end
  def extract_vars({:var, var}, vars) do
    [var | vars]
  end
  def extract_vars({:cons, head, tail}, vars) do
    extract_vars(tail, extract_vars(head, vars))
  end




  def eval_cls([], _, _, _) do
    :error
  end
  def eval_cls([{:clause, ptr, seq} | cls], str, envron) do #a
    case eval_match(ptr, str, eval_scope(ptr, envron)) do # :atm :b and :a
      :fail ->
        eval_cls(cls, str, envron) #a
      {:ok, env} ->
        eval_seq(seq, env) #
    end
  end









end
