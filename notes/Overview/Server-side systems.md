It's an entire system that, in addition to handling requests, runs background jobs, manages server-wide in-memort state, etc. Such system is usually distributed across different machines. Entire such system can be implemented in Erlang.

![[Pasted image 20240920130812.png]]

Server B can run on a single machine, is easier to manage and deploy. However, Erlang tools are not always full-blown alternatives to mainstream alternatives (e.g. Nginx, MongoDB, Redis). Flexibility is not lost on Server B - can still use specialized tools if needed.
![[Pasted image 20240920131017.png]]
Erlang can run code in C, C++, Rust, and communicate with other systems via message queues, in-memory key-value stores.