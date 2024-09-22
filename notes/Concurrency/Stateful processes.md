Informal name for a process that runs for a long time (or forever) and handles various requests (messages).

```
defmodule DatabaseServer do
	def start do
		spawn(&loop/0)
	end

	def run_async(server_pid, query) do
		send(server_pid, {:run_query, self(), query})
	end

	def get_result() do
		receive do
			{:query_result, result} -> result
		after 
			5000 -> {:error, :timeout}
		end
	end

	defp loop do
		receive do
			{:run_query, caller, query} ->
				result = run_query(query)
				send(caller, {:query_result, result})
		end

		loop()
	end

	defp run_query(query) do
		Process.sleep(2000)
		"#{query} result"
	end
end

server_pid = DatabaseServer.start()
DatabaseServer.run_async(server_pid, "Query #1")
DatabaseServer.get_result()
```

> A stateful process serves as a container of such a data structure. The process keeps
> the state alive and allows other processes in the system to interact with this data via the
> exposed API.

**Shared-nothing concurrency**
Sending messages to a process results in a deep copy of the message contents.

**Scheduler**
Usually, `n` schedulers run `m` processes, where `m`  is significantly larger than  `n` (microthreads). BEAM uses only as many schedulers as there are logical processors available, but this can be adjusted. Each process has an execution window of about 2000 function calls. Context switching is performed frequently, single process is in the scheduler for < 1ms.

---
* A BEAM process is a lightweight concurrent unit of execution. Processes are completely isolated and share no memory.
* Processes communicate via asynchronous messages, but synchronous communication can be implemented manually.
* Server processes (informal name) can run for a long time and keep state. Powered by endless recursion, but does not consume CPU time when waiting for messages.