/*this program supports towers and queens. The code structure was built upon 8QeensV2.pl*/

/* FACTS */
loc([1,1]). loc([1,2]). loc([1,3]). loc([1,4]). loc([1,5]).
loc([2,1]). loc([2,2]). loc([2,3]). loc([2,4]). loc([2,5]).
loc([3,1]). loc([3,2]). loc([3,3]). loc([3,4]). loc([3,5]).
loc([4,1]). loc([4,2]). loc([4,3]). loc([4,4]). loc([4,5]).
loc([5,1]). loc([5,2]). loc([5,3]). loc([5,4]). loc([5,5]).


/*call main with a list of Towers and a list of Queens e.g.: main([T1,T2],[Q1,Q2,Q3])*/
main(TS,QS) :-
	towers(TS),
	queens(TS,QS).

/*Towers*/
towers([]).

towers([_|[]]).

towers([T1|TS]) :-
	validTower(T1, TS),
	towers([TS]).

validTower([_,_], []).
	
validTower([A|B], [[C|D]|TS]) :-
	loc([A|B]), loc([C|D]),
	/* do four tests to make sure [C|D] isn't in the span of [A|B] */
	A =\= C,			% makes sure they are not in same row
	B =\= D,			% makes sure they are not in same column
	/* then test [A|B] against remaining QS */
	validTower([A|B], TS).	


/*Queens*/
queens(_, []).

queens(TS,[Q1|QS]) :-   % recursive step
	validQueens_vs_towers(TS,Q1), 	 /* queen's location must be valid with all towers */
	validQueens(Q1, QS), /* queen's location must be valid with those after it */
	queens(TS,QS).

validQueens_vs_towers([], _).

validQueens_vs_towers([T1|TS],Q1) :-
	checkQueen(T1,Q1),
	validQueens_vs_towers(TS,Q1).

checkQueen([A|B], [C|D]) :-
	loc([A|B]), loc([C|D]),
	/* do four tests to make sure [C|D] isn't in the span of [A|B] */
	A =\= C,		% makes sure they are not in same row
	B =\= D,		% makes sure they are not in same column
	C - A =\= D - B,	% makes sure they are not in same \ (down to right, up to left) directed diagonal 
	C - A =\= B - D.   	% makes sure they are not in same / (up to right, down to left) directed diagonal 
	
	
validQueens(Q1, []) :-
	loc(Q1).

validQueens(Q1, [Q2|QS]) :-
	checkQueen(Q1, Q2),
	validQueens(Q1, QS).
