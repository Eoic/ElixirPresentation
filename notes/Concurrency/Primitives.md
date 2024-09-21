To make system highly available, the following challenges occur:
* **Fault tolerance **- minimize, isolate, and recover from the effects of run-time
errors.
* **Scalability** - handle a load increase by adding more hardware resources without
changing or redeploying the code.
* **Distribution** - run your system on multiple machines so that others can take
over if one machine crashes.

BEAM process is the basic building block of concurrency. Helps to run tasks in parallel, allowing to achieve ==scalability==. In turn, they are isolated, therefore providing fault tolerance, isolating and limiting effects of unexpected ==run-time errors==.

![[Pasted image 20240921232942.png]]

Each process gets gets an execution time-slot, and after the time is up, the process is pre-empted, and the next one takes over.

Processes are lightweight:
1. It takes a few microseconds to create a process.
2. Memory footprint is a few kilobytes.
3. Theoretical limit is 134 million concurrent processes (in practice, a system with 20 million was tested).
4. Processes are completely isolated.
5. BEAM provides means for detecting when the process has crashed.

