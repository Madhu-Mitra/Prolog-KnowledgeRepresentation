/* usage: The main function takes 6 lists as parameters. The first list
 *        contains two elements, the length and with of the board (e.g. [8, 8]
 *        for a standard 8x8 chess board. The remaining 5 lists contain the
 *        pieces to be places on the board in this order: knights, bishops,
 *        rooks, queens, amazons.
 *
 * example: classic 8 queens problem
 *          main([8, 8], [], [], [], [Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8], []). */

main([SizeX, SizeY], NS, BS, RS, QS, AS) :-
	/* first set up the board locations in Loc */
	findall([X, Y], (between(1, SizeX, X), between(1, SizeY, Y)), Loc),
	/* then find a possible solution */
	possibleSolution(Loc, NS, BS, RS, QS, AS),
	/* finally check if solution is correct */
	correctSolution(Loc, NS, BS, RS, QS, AS).

/* Initializes the pieces with possible values. The result is not necessarily a
 * correct solution. */
possibleSolution(Loc, NS, BS, RS, QS, AS) :-
	checkKnights(Loc, NS, []),
	checkBishops(Loc, BS, []),
	checkRooks(Loc, RS, []),
	checkQueens(Loc, QS, []),
	checkAmazons(Loc, AS, []).

/* Checks if the values are a correct solution for the problem. */
correctSolution(Loc, NS, BS, RS, QS, AS) :-
	append([AS, RS, BS, QS], PS_N),
	checkKnights(Loc, NS, PS_N),
	append([AS, NS, RS, QS], PS_B),
	checkBishops(Loc, BS, PS_B),
	append([AS, NS, BS, QS], PS_R),
	checkRooks(Loc, RS, PS_R),
	append([AS, NS, RS, BS], PS_Q),
	checkQueens(Loc, QS, PS_Q),
	append([NS, RS, BS, QS], PS_A),
	checkAmazons(Loc, AS, PS_A).

/* Following are various checkXXX functions that check for each type of piece
 * if all pieces of this type do not attack any other piece. Each of these
 * functions takes 3 lists as parameters in the form
 *     checkXXX(Loc, XXXPieces, OtherPieces)
 * where
 *     Loc - is the list of board locations
 *     XXXPieces - is the list of pieces of this type
 *     OtherPieces - is the list of all pieces of all other types
 *
 * This function is evaluated recursively, starting from the end of the list of
 * pieces of this type (XXXPieces). The base case (XXXPieces is the empty list)
 * is always true. For the recursive call we split the list XXXPieces into the
 * first piece and the list of remaining pieces. Then we do the recursive call
 * with the list of remaining pieces. When the recursion succeeds, we require
 * that the first piece must be on a location of the board. Finally, we check
 * that the first piece does not attack any piece of the list of remaining
 * pieces (XXXPieces minus the first piece) or the list of other pieces
 * (OtherPieces) combined.
 *
 * To check this, we have a function validXXX for each type of piece. In
 * contrast to the checkXXX function (which is basically a duplication for each
 * type of piece), the validXXX function is specific for each type of piece:
 * this function is aware of the directions a piece can attack other pieces.
 * This function takes 3 lists as parameters in the form
 *     validXXX(Loc, XXXPiece, OtherPieces)
 * where
 *     Loc - is the list of board locations
 *     XXXPiece - is the list for the location of this piece in the form [x, y]
 *     OtherPieces - is the list of all other pieces
 *
 * The validXXX function again is evaluated recursively. The base (OtherPieces)
 * is the empty list) is always true. For the recursive call we split the list
 * OtherPieces into the first piece and the list of remaining pieces. We then
 * require that this piece (XXXPiece) does not attack the first piece of
 * OtherPieces. When this succeeds, we recursively call the function with the
 * list of remaining pieces.
 */

/* base case */
checkKnights(_, [], _).

checkKnights(Loc, [N|NS], PS) :-
	/* recursive call */
	checkKnights(Loc, NS, PS),
	/* make sure first knight is on board */
	member(N, Loc),
	/* make sure first knight does not attack any other piece */
	append(NS, PS, NPS),
	validKnights(Loc, N, NPS).

/* base case */
validKnights(_, [_|_], []).

validKnights(Loc, [A|B], [[C|D]|PS]) :-
	/* make sure [A|B] and [C|D] are not in the same location */
	(A =\= C -> true; B =\= D),
	/* make sure [A|B] does not reach [C|D] with a knight's move */
	(A+2 =\= C -> true; B+1 =\= D),
	(A+2 =\= C -> true; B-1 =\= D),
	(A-2 =\= C -> true; B+1 =\= D),
	(A-2 =\= C -> true; B-1 =\= D),
	(A+1 =\= C -> true; B+2 =\= D),
	(A+1 =\= C -> true; B-2 =\= D),
	(A-1 =\= C -> true; B+2 =\= D),
	(A-1 =\= C -> true; B-2 =\= D),
	/* exclude permutations */
	(B < D -> true; A < C),
	/* recursive call */
	validKnights(Loc, [A|B], PS).

/* base case */
checkBishops(_, [], _).

checkBishops(Loc, [B|BS], PS) :-
	/* recursive call */
	checkBishops(Loc, BS, PS),
	/* make sure first bishop is on board */
	member(B, Loc),
	/* make sure first bishop does not attack any other piece */
	append(BS, PS, BPS),
	validBishops(B, BPS).

/* base case */
validBishops([_|_], []).

validBishops([A|B], [[C|D]|PS]) :-
	/* make sure they are not in the same major diagonal */
	C - A =\= D - B,
	/* make sure they are not in the same minor diagonal */
	C - A =\= B - D,
	/* exclude permutations */
	(B < D -> true; A < C),
	/* recursive call */
	validBishops([A|B], PS).

/* base case */
checkRooks(_, [], _).

checkRooks(Loc, [R|RS], PS) :-
	/* recursive call */
	checkRooks(Loc, RS, PS),
	/* make sure first rook is on board */
	member(R, Loc),
	/* make sure first rook does not attack any other piece */
	append(RS, PS, RPS),
	validRooks(R, RPS).

/* base case */
validRooks([_|_], []).

validRooks([A|B], [[C|D]|PS]) :-
	/* make sure they are not in the same row */
	A =\= C,
	/* make sure they are not in the same column */
	B =\= D,
	/* exclude permutations */
	(B < D -> true; A < C),
	/* recursive call */
	validRooks([A|B], PS).

/* base case */
checkQueens(_, [], _).

checkQueens(Loc, [Q|QS], PS) :-
	/* recursive call */
	checkQueens(Loc, QS, PS),
	/* make sure first queen is on board */
	member(Q, Loc),
	/* make sure first queen does not attack any other piece */
	append(QS, PS, QPS),
	validQueens(Q, QPS).

/* base case */
validQueens([_|_], []).

validQueens([A|B], [[C|D]|PS]) :-
	/* make sure they are not in the same row */
	A =\= C,
	/* make sure they are not in the same column */
	B =\= D,
	/* make sure they are not in the same major diagonal */
	C - A =\= D - B,
	/* make sure they are not in the same minor diagonal */
	C - A =\= B - D,
	/* exclude permutations */
	(B < D -> true; A < C),
	/* recursive call */
	validQueens([A|B], PS).

/* base case */
checkAmazons(_, [], _).

checkAmazons(Loc, [A|AS], PS) :-
	/* recursive call */
	checkAmazons(Loc, AS, PS),
	/* make sure first amazon is on board */
	member(A, Loc),
	/* make sure first amazon does not attack any other piece */
	append(AS, PS, APS),
	validAmazons(Loc, A, APS).

/* base case */
validAmazons(_, [_|_], []).

validAmazons(Loc, [A|B], [[C|D]|PS]) :-
	/* make sure they are not in the same row */
	A =\= C,
	/* make sure they are not in the same column */
	B =\= D,
	/* make sure they are not in the same major diagonal */
	C - A =\= D - B,
	/* make sure they are not in the same minor diagonal */
	C - A =\= B - D,
	/* make sure [A|B] does not reach [C|D] with a knight's move */
	(A+2 =\= C -> true; B+1 =\= D),
	(A+2 =\= C -> true; B-1 =\= D),
	(A-2 =\= C -> true; B+1 =\= D),
	(A-2 =\= C -> true; B-1 =\= D),
	(A+1 =\= C -> true; B+2 =\= D),
	(A+1 =\= C -> true; B-2 =\= D),
	(A-1 =\= C -> true; B+2 =\= D),
	(A-1 =\= C -> true; B-2 =\= D),
	/* exclude permutations */
	(B < D -> true; A < C),
	/* recursive call */
	validAmazons(Loc, [A|B], PS).

