conc([],L,L).
conc([X|R],L,[X|S]):-conc(R,L,S).

split([],E,[],[]).
split([X|R],E,[X|K],G):-X=<E,split(R,E,K,G).
split([X|R],E,K,[X|G]):-X>E,split(R,E,K,G).

qs([],[]).
qs([E|R],S):-split(R,E,K,G),qs(K,SK),qs(G,SG),conc(SK,[E|SG],S).

rev([],[]).
rev([C|A],D):-rev(A,B),conc(B,[C],D).

halfen([],[],[]).
halfen([X],[X],[]).
halfen([X,Y|R],[X|S],[Y|T]):-
	halfen(R,S,T).

merge([],X,X).
merge(L1,[],L1).
merge([X|R],[Y|L],[X|T]) :-
	X=<Y,
	merge(R,[Y|L],T).
merge([X|R],[Y|L],[Y|T]) :-
	X>Y,
	merge([X|R],L,T).

ms([],[]).
ms([E],[E]).
ms(A,E):-
	halfen(A,B,C),
	ms(B,S1),
	ms(C,S2),
	merge(S1,S2,E).

bubble([],[]).
bubble([Y],[Y]).
bubble([X,Y|R],[X|S]):-
	X=<Y,
	bubble([Y|R],S).
bubble([X,Y|R],[Y|S]):-
	X>Y,
	bubble([X|R],S).

between([],E,0).
between([X|R],E,N):-
	X>E,
	X<E*E,
	between(R,E,M),
	N is M +1.
between([X|R],E,M):-
	between(R,E,M).

absolute([],[]).
absolute([E|R],[Y|L]):-E<0, Y is E*(-1), absolute(R,L).
absolute([E|R],[E|L]):-absolute(R,L).
