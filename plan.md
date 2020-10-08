# Some planning notes

## Tasks to do

- [ ] If extra time and will, implement selection sort using higher level approach and compare to low level approach.

- [x] Format and cleanup VHDL and C code. (Ole)

- [x] Get utilization metrics for each algorithm at size 4, 16 and 64. (Rahmat)

- [x] Rewrite methods to explain more our approach to the project as a whole instead of individual algoritms. (Anders)

> The methods section tells readers how you conducted your study. It includes information about your population, sample, methods, and equipment. The “gold standard” of the methods section is that it should enable readers to duplicate your study. Methods sections typically use subheadings; they are written in past tense, and they use a lot of passive voice. This is typically the least read section of an IMRaD report.

- [x] Add paragraph to methods which explains which tools we used (Vivado 2020.1 and Vitis ++). (Anders)

- [x] Write introduction which explains the challange with hardware/software considerations and that we are setting out to explore benefits and disadvantages with different solutions. (Øzlem)

> The introduction explains why this research is important or necessary or important. Begin by describing the problem or situation that motivates the research. Move to discussing the current state of research in the field; then reveal a “gap” or problem in the field. Finally, explain how the present research is a solution to that problem or gap. If the study has hypotheses, they are presented at the end of the introduction.

- [x] Move images into GitHub repo for paper (from Google Drive). (Ole)

- [x] Sort and organize links/references used. (Ole)

- [x] Write results from odd-even sort. (Rahmat)

- [x] Cleanup results chapter (each subchapter should have similar structure).(Rahmat)
	- [x] Selection sort explanations and figures.
	- [x] Linear cell sort explanations and figures.

- [x] Digitize FSMD and ASMD charts for odd-even sort. (Anders)

- [ ] Write discussion topics (Ole)
	- [ ] Concrete comparison of our algoritms in terms of speed, size (space) and parallelization. Talk about why there was no parallelization in HW implementation of selection sort a lot of parallalization in linear sort.
	- [x] Comparison of HW and SW implementations in regards to code-, time- and space-complexity (1 paragraph each). Make sure to use concret examples and comparisons from selection, linear and odd-even. Highlight that there are many tradoffs.
		- [x] Code: HW a lot harder (generics, reusing, boilerplate, errors are unclear) and more time consuming. HW longer feedback cycle (syntesizing vs compiling).
		- [x] Time: HW can be parallelized with ease, thus more operations per clock cycle. Parallelization in SW is not trivial and was not attempted due to single core platform. Even though less cycles in HW, is clockspeed faster in SW on prosessor??
		- [x] Space: Parallelized HW can take a lot of space. SW uses fixed space on generic prosessor. HW can have extra memory/state in addition to RAM in circuitry.
	- [ ] The difficulty of IP implementation. Why was the implementation so hard? What issues did we face? What would be the benefit of an IP block?

### Blocked by other tasks

- [x] Write conclusion based on discussed topics in discussion. Many tradeoffs between HW and SW.

- [x] Write abstract.

- [x] Write a small "whodidwhat" that will be appended as an appendix.
<!--stackedit_data:
eyJoaXN0b3J5IjpbNDExMzg4NjA4LC05MDI2OTY1MjIsLTQ5Nz
M3MDI3NCwtMTAyNTU0Nzc2MiwtMjE0MTc3OTY5OCwtMTM0Mzgy
NTMxNF19
-->
