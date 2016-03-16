nega([],[]).
nega([I|RI], [G|RS]):-
		I<0,
		G is I*(-1),
		nega(RI,RS).

nega([I|RI], [I|RS]):-
		nega(RI,RS).