utilities
booleanCheatSistaV1: cond
	"cheat the interpreter out of the pleasure of handling the next bytecode IFF it is a jump-on-boolean. Which it is, often enough when the current bytecode is something like bytecodePrimEqual"
	<inline: true>

	cond
		ifTrue: [self booleanCheatTrueSistaV1]
		ifFalse: [self booleanCheatFalseSistaV1]