Modern functional programming language for building large-scale, distributed, fault tolerant, and scalable systems for the [[Erlang goals|Erlang]] virtual machine. Elixir lowers the entry barrier into the Erlang. Can use all Erlang features and the OTP framework that ships with Erlang.
It's an alternative language for the Erlang virtual machine, that allow for writing cleaner, more compact that better reveals programmer's intentions.
Code is compiled into BEAM-compliant byte code, and can run on the BEAM and communicate with other Erlang code. Provides some constructs that significantly reduce boilerplate and duplication.\

#### Benefits
###### Code simplification
Erlang server process (adds two numbers):
```erlang
-module(sum_server).
-behaviour(gen_server).
-export([
	start/0, sum/3,
	init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
	code_change/3
]).

start() -> gen_server:start(?MODULE, [], []).
sum(Server, A, B) -> gen_server:call(Server, {sum, A, B}).

init(_) -> {ok, undefined}.
handle_call({sum, A, B}, _From, State) -> {reply, A + B, State}.
handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.
```

Elixir server process:
```erlang
defmodule SumServer do
	use GenServer
		def start do
			GenServer.start(__MODULE__, nil)
		end

		def sum(server, a, b) do
			GenServer.call(server, {:sum, a, b})
		end
	
		def handle_call({:sum, a, b}, _from, state) do
			{:reply, a + b, state}
		end
end
```

Elixir server process (with custom tools through macros (Lisp style, not C)):
```erlang
defmodule SumServer do
	use ExActor.GenServer

	defstart start

	defcall sum(a, b) do
		reply(a + b)
	end
end
```

Due to macro support, most of Elixir is written in Elixir.
###### Composing functions
Erlang:
```erlang
process_xml(Model, Xml) ->
	persist(
		process_changes(
			update(Model, Xml)
		)
	).
```
Elixir:
```erlang
def process_xml(model, xml) do
	model
	|> update(xml)
	|> process_changes()
	|> persist()
end
```
The language works with immutable data structures, therefore functions are treated as data transformations, which are then connected together into a kind of "pipeline" to get the desired result.

Other improvements
1. Simplified API.
2. Tooling - Mix, Hex.
3. Explicit support for Unicode manipulations.
### Disadvantages
1. Speed - cannot achieve the speed of machine compiled languages, dues to the way BEAM works. The goal is to keep performance consistent, within limits, with no significant hiccups. Not suitable for heavy CPU-bound work.
2. Ecosystem - not as big as Ruby's or JavaScript's.