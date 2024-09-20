Erlang was specifically created for this. Some technical challenges are:
1. Fault tolerance - Erlang processes are  completely isolated from each other, which helps to isolate error effects. Also, can detect crash, and spin a new process.
2. Scalability - processes communicate via asynchronous messages (no locks, mutexes, semaphores).
3. Distribution - communication between processes works in the same way whether these two processes are in the same BEAM instance or on different instances (e.g. two different computers). Harder problem than it seems.
4. Responsiveness - a scheduler is preemtive (gives a small execution windowm then pauses the process and runs another process). Due to small execution window, long running processes cannot block the entire system. Also, I/O operations are delegated to separate threads, so process that waits for I/O to finish won't block.
5. Live update (note: somewhat solved by Docker, Kubernetes, etc.?).