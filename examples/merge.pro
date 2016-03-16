realsplit([],E,[],[]).
realsplit(Xs,N,Ys,Zs):-
	length(Ys, N),
	append(Ys,Zs,Xs).

half([],[],[]).
half(I, S, T):-
	length(I, L),
	Franz is L//2,
	realsplit(I,Franz, S, T).

merge(A,[],A).
merge([],B,B).
merge([LL|LR],[RL|RR],[LL|SR]):-
	LL<RL,
	merge(LR,[RL|RR],SR).

merge([LL|LR],[RL|RR],[RL|SR]):-
	LL>=RL,
	merge([LL|LR],RR,SR).


mergesort([L],[L]).
mergesort(I, S):-
	half(I,L,R),
	mergesort(L,SL),
	mergesort(R,SR),
	merge(SL,SR,S).


