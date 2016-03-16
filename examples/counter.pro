islarger([],E,0).
islarger([L|RL], E, F):-
		L>E,
		L<E*E,
		islarger(RL, E, G),
		F is G+1.
				
islarger([L|RL], E, F):-
		islarger(RL, E, F).