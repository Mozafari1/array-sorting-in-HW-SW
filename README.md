# array-sorting-in-HW-SW
We explored and implemented three different sorting algorithms as software (single-thread C programs) and hardware (VHDL) implementations in FPGAs. Furthermore, we compared the different implementations with regards to efficiency, performance, flexibility, resource usage and code complexity, while particular contrasting hardware and software trade-offs. We found that concurrent sorting algorithms can be parallelized in hardware to achieve higher performance, however hardware implementations require more development effort, have more code complexity and also require more hardware resources. Hence there is a trade-off to be made between multiplexing the algorithm in time or in space, depending on the context of the application. 