It does not rely on heavyweight threads on OS processes. The concurrency primitive is called "Erlang process", and typical Erlang programs run thousands if not millions of processes. BEAM is an OS process, and uses it's own schedulers to distribute execution of Erlang processes over the available CPU cores.

BEAM - Bogdan/Björn’s Erlang Abstract Machine

![[Pasted image 20240920124558.png]]
![[Pasted image 20240921232917.png]]
Garbage collection is per-process.