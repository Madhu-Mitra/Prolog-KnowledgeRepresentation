/* 		3rd (and most effective) Version!											 														*/
/* 			This version also uses recursion but goes straight to the end of the list of queens before checking for validity				*/
/* 			It then moves back towards Q1, checking to make sure that each Q is valid with those after it.									*/
/* 			Doing so results in a much faster runtime than the other versions, completing the puzzle in about 2 seconds						*/
/*   			This is because this version gets all of the eightQueens recursive steps done right away and then 							*/
/*				uses tail recursion with the recursive calls of valid.																		*/
/*						 																													*/
/* 		QUERY TO SEND FROM SHELL: ?- eightQueens([Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8]). 														*/
/* 		it will then print out a solution to the problem. (typing a semicolon will reveal the next solution) 								*/
/* 		in the solution, the queens' locations on the grid are in the format [y, x], similar to how the 'loc's are instantiated below 		*/
/* 		the grid is arranged so that [1,1] is in the upper left and [8,8] is in the bottom right 											*/
/*		example solution:																													*/
/*			Q1 = [8, 4],																													*/
/*			Q2 = [7, 2],																													*/
/*			Q3 = [6, 7],																													*/
/*			Q4 = [5, 3],																													*/
/*			Q5 = [4, 6],																													*/
/*			Q6 = [3, 8],																													*/
/*			Q7 = [2, 5],																													*/
/*			Q8 = [1, 1] 																													*/

/* RULES */

/* to solve the puzzle, all eight queens must be placed in locations such that no two queens threaten each other */
/* the rule, eightQueens, initially takes in a list of 8 queens, [Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8], from the shell. */
/* it then recursively goes through list of queens (starting at end) & makes sure every queen is valid with those after it */

main([]).   % basecase is true 

main([SizeX, SizeY], AS, NS, RS, BS, QS) :-
	findall([X, Y], (between(1, SizeX, X), between(1, SizeY, Y)), Loc),
	possibleSolution(Loc, AS, NS, RS, BS, QS),
	correctSolution(Loc, AS, NS, RS, BS, QS).

possibleSolution(Loc, AS, NS, RS, BS, QS) :-
	checkQueens(Loc, QS, []),
	checkBishops(Loc, BS, []),
	checkRooks(Loc, RS, []),
	checkKnights(Loc, NS, []),
	checkAmazons(Loc, AS, []).

correctSolution(Loc, AS, NS, RS, BS, QS) :-
	append([AS, NS, RS, BS], PS_Q),
	checkQueens(Loc, QS, PS_Q),
	append([AS, NS, RS, QS], PS_B),
	checkBishops(Loc, BS, PS_B),
	append([AS, NS, BS, QS], PS_R),
	checkRooks(Loc, RS, PS_R),
	append([AS, RS, BS, QS], PS_N),
	checkKnights(Loc, NS, PS_N),
	append([NS, RS, BS, QS], PS_A),
	checkAmazons(Loc, AS, PS_A).

checkQueens(_, [], _).

checkQueens(Loc, [Q|QS], PS) :-    % recursive step
	/* call on remaining Queens first so that we start at the back */
	checkQueens(Loc, QS, PS),
	/* all queens are locations */
	member(Q, Loc),
	/* queen's location must be valid with those after it */
	append(QS, PS, QPS),
	validQueens(Q, QPS).

/* two queens are considered to be in valid locations if queen2 is not in the span of queen1 (and therefore queen1 is not in the span of queen2) */
/* queen2 is in the "span" of queen1 if it is either in the same column, the same row, or it can be reached diagonally from queen 1 */
/* the rule, valid, takes in a queen location "Q" (or "[A|B]") & a list of queen locations "QS" (or "[[C|D]|QS]") */
/* it then recursively checks [A|B] against the queens in [[C|D]|QS], asserting that their locations must be valid */

validQueens([_|_], []).    % basecase is true

validQueens([A|B], [[C|D]|PS]) :-     % recursive step
	/* do four tests to make sure [C|D] isn't in the span of [A|B] */
	A =\= C,			% makes sure they are not in same row
	B =\= D,			% makes sure they are not in same column
	C - A =\= D - B,	% makes sure they are not in same \ (down to right, up to left) directed diagonal 
	C - A =\= B - D,    % makes sure they are not in same / (up to right, down to left) directed diagonal 
	/* then test [A|B] against remaining PS */
	validQueens([A|B], PS).

checkBishops(_, [], _).

checkBishops(Loc, [B|BS], PS) :-    % recursive step
	/* call on remaining Bishops first so that we start at the back */
	checkBishops(Loc, BS, PS),
	/* all bishops are locations */
	member(B, Loc),
	/* bishop's location must be valid with those after it */
	append(BS, PS, BPS),
	validBishops(B, BPS).

validBishops([_|_], []).    % basecase is true

validBishops([A|B], [[C|D]|PS]) :-     % recursive step
	/* do two tests to make sure [C|D] isn't in the span of [A|B] */
	C - A =\= D - B,	% makes sure they are not in same \ (down to right, up to left) directed diagonal 
	C - A =\= B - D,    % makes sure they are not in same / (up to right, down to left) directed diagonal 
	/* then test [A|B] against remaining PS */
	validBishops([A|B], PS).

checkRooks(_, [], _).

checkRooks(Loc, [R|RS], PS) :-    % recursive step
	/* call on remaining Rooks first so that we start at the back */
	checkRooks(Loc, RS, PS),
	/* all rooks are locations */
	member(R, Loc),
	/* rook's location must be valid with those after it */
	append(RS, PS, RPS),
	validRooks(R, RPS).

validRooks([_|_], []).    % basecase is true

validRooks([A|B], [[C|D]|PS]) :-     % recursive step
	/* do two tests to make sure [C|D] isn't in the span of [A|B] */
	A =\= C,			% makes sure they are not in same row
	B =\= D,			% makes sure they are not in same column
	/* then test [A|B] against remaining PS */
	validRooks([A|B], PS).

checkKnights(_, [], _).

checkKnights(Loc, [N|NS], PS) :-    % recursive step
	/* call on remaining Knights first so that we start at the back */
	checkKnights(Loc, NS, PS),
	/* all knights are locations */
	member(N, Loc),
	/* knights's location must be valid with those after it */
	append(NS, PS, NPS),
	validKnights(Loc, N, NPS).

validKnights(_, [_|_], []).    % basecase is true

validKnights(Loc, [A|B], [[C|D]|PS]) :-     % recursive step
	(A =\= C -> true; B =\= D),
	(A+2 =\= C -> true; B+1 =\= D),
	(A+2 =\= C -> true; B-1 =\= D),
	(A-2 =\= C -> true; B+1 =\= D),
	(A-2 =\= C -> true; B-1 =\= D),
	(A+1 =\= C -> true; B+2 =\= D),
	(A+1 =\= C -> true; B-2 =\= D),
	(A-1 =\= C -> true; B+2 =\= D),
	(A-1 =\= C -> true; B-2 =\= D),
	validKnights(Loc, [A|B], PS).

checkAmazons(_, [], _).

checkAmazons(Loc, [A|AS], PS) :-    % recursive step
	/* call on remaining Amazons first so that we start at the back */
	checkAmazons(Loc, AS, PS),
	/* all amazons are locations */
	member(A, Loc),
	/* amazons's location must be valid with those after it */
	append(AS, PS, APS),
	validAmazons(Loc, A, APS).

validAmazons(_, [_|_], []).    % basecase is true

validAmazons(Loc, [A|B], [[C|D]|PS]) :-     % recursive step
	A =\= C,			% makes sure they are not in same row
	B =\= D,			% makes sure they are not in same column
	C - A =\= D - B,	% makes sure they are not in same \ (down to right, up to left) directed diagonal 
	C - A =\= B - D,    % makes sure they are not in same / (up to right, down to left) directed diagonal 
	(A+2 =\= C -> true; B+1 =\= D),
	(A+2 =\= C -> true; B-1 =\= D),
	(A-2 =\= C -> true; B+1 =\= D),
	(A-2 =\= C -> true; B-1 =\= D),
	(A+1 =\= C -> true; B+2 =\= D),
	(A+1 =\= C -> true; B-2 =\= D),
	(A-1 =\= C -> true; B+2 =\= D),
	(A-1 =\= C -> true; B-2 =\= D),
	validAmazons(Loc, [A|B], PS).

