# Prolog-KnowledgeRepresentation


-------------------------------------
Our project shall analyse variations of the eight queens puzzle with different boards and pieces. As a minimum square boards of size up to n=8 shall be supported, if possible we want to support any rectangular board. Regarding pieces, as a minimum an arbitrary number of bishops shall be supported, if possible we want to support further pieces and maybe also fairy chess pieces like amazons. Ideally, mixing pieces shall be supported, for example m queens and m bishops on a square board of size n.

Inputs: board size (or shape), pieces to place

Output: Solutions for placing the input pieces on the input board such that the pieces do not attack each other

Example Input: QQQQQNNNNN 8 8 (5 queens + 5 knights, 8x8 board)

Example Output:
.Q......
......Q.
..Q.....
.....Q..
.......Q
N.......
N..NN...
...N....
