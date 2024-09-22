`GenServer` is part of the OTP framework, and simplifies the implementation of server processes. It's a production-ready abstraction.

Typical server process workflow:
1. Spawn a separate process on start.
2. Run an infinite loop on a process.
3. Maintain the process state.
4. React to messages.
5. Send a response back to the caller.

**OTP behaviours**
A generic code that implement a common pattern. 

![[Pasted image 20240922171010.png]]

1. Client process starts the server process, providing a callback module.
2. Process state is created through the `init/1` callback. Each `handle_*` callback receives this state and must return its new version.

One should alwasy use OTP-compliant processes, started through `GenServer` , `Supervisor` behaviours or `Task`, `Agent` modules. Plain `spawn`'ed processes aren't OTP-compliant.\

Note: one of the key abstractions for building server processes. Most other modules dealing with processes also build on top of GenServer behaviour.

**Summary**
* A generic server process is an abstraction that implements tasks common to any
kind of server process, such as recursion-powered looping and message passing.
* A generic server process can be implemented as a behaviour. A behaviour
drives the process, whereas specific implementations can plug into the
behaviour via callback modules.
* The behaviour invokes callback functions when the specific implementation
needs to make a decision.
* GenServer is a behaviour that implements a generic server process.
* A callback module for GenServer must implement various functions. The most
frequently used of these are init/1, handle_cast/2, handle_call/3, and
handle_info/2.
* You can interact with a GenServer process with the GenServer module.
* Two types of requests can be issued to a server process: calls and casts.
* A cast is a fire-and-forget type of request—a caller sends a message and immedi-
ately moves on to do something else.
* A call is a synchronous send-and-respond request—a caller sends a message and
waits until the response arrives, the timeout occurs, or the server crashes.