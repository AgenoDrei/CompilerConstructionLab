#pragma once

// END ERKENNUNG
// Vergleiche
// is prädikat
// termliste zahlen float

enum token {
	UNKNOWN, // prevent flex return on zero
	OPEN_BRACKET,
	CLOSE_BRACKET,
	RULE_OPERATOR,
	NAME,
	VARIABLE,
	OPEN_SQUARE_BRACKET,
	CLOSE_SQUARE_BRACKET,
	COMMA,
	PIPE,
	DOT,
	END,
	EQUAL,
	UNEQUAL,
	GREATER,
	SMALLER,
	GREATER_EQUAL,
	SMALLER_EQUAL,
	NUMBER,
	IS
};

