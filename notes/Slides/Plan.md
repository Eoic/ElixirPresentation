1. **Title** - "The Elixir Programming Language".
2. **Table of contents** - all major sections. 
4. **History of Erlang** - its origin at Ericsson, role in communications, motivation behind creation (concurrency, fault tolerance, updates on-the-fly), also mention that it was banned in the company for some time and why. Intended as a language for AXE telephone exchange, the goal was to make something like PLEX, but better. Created within 2 years, and completed in 1988.
5. **Benefits of Erlang** - fault tolerance, concurrency, scalability. Mention "Write once - run forever" quote, explain relevancy in critical systems, show and example of such resilient system. Mention OTP.
6. **BEAM** - show diagram of the BEAM process and explain how it works. Mention previous Erlang implementation in Prolog and that it was slow and needed to be 40 times faster, which caused the creation of BEAM.g
7. **History of Elixir** - f. First release in 2012.
8. **Benefits of Elixir** - easier approach to Erlang ecosystem, increased developer productivity, simplified API and less boilerplate, tools and growing ecosystem.
9. **Disadvantages of Elixir** - not suitable for intensive CPU-bound work (but excels at I/O bound tasks, real-time systems), smallish ecosystem compared to other languages (e.g. JavaScript, Ruby).
10. **Type system** - dynamic type system, list supported types, mention that integer size in Erlang is unlimited, but has two types (small and large), static analysis and type annotations through documentation comments.
11. **Modules and functions** - how code is organized into modules and functions, and how modules are used for higher order abstractions. 
12. **Control flow**
	1. Pattern matching and guards - the importance of pattern matching and some simple examples, explain that equals (`=`) is not an assignment symbol.
	2. **Multi-clause functions** - pattern matching by declaring the same function with different patterns, few simple code examples.
	3. **Recursion and looping** - explain tail-call optimization and how if affects performance, show how looping is done with recursion with and without tail-call optimization, show how higher-order functions can be used to implement looping easier, without custom code (e.g. `Enum.map`). 
13. **Concurrency** - lightweight processes and how they simplify building concurrent, scalable systems, scaling across multi-core systems and why it is relevant (CPU clock frequencies hardly growing, growing focus on the number of cores).
	1. **Server process** - long running process, processing various messages and often keeping state.
	2. **GenServer** - key abstraction when implementing OTP-compliant server processes.
	3. **Fault tolerance** - "let it crash" philosophy, supervision trees, how to handle failure. Add a real-world system example.
	4. **Supervisors** - what are they used for.
	5. **Supervision trees** - how and why.
14. **Ecosystem** - Mix, Hex, and other tooling.
15. **Case studies** - who is using Elixir and Erlang right now and for what purpose (e.g. Discord, RabbitMQ, Pinterest, Heroku, V7, WhatsApp).
16. **Tooling**
	1. **Phoenix Framework** - web framework, mention LiveView and mention system using this technology.
	2. **Nerves** - embedded systems.
	3. **Membrane** - multimedia streaming and processing.
	4. **Nx** - machine learning and high-performance numerical computing on CPU and GPU.
17. **Learning resources** - books, documentation, etc.
18. **Summary** - mention key points, advantages of Erlang ecosystem, try to distill the potential benefits.
19. **Q&A** - questions slide (just the title).