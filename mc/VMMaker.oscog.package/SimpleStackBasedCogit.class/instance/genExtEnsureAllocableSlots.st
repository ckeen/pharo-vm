bytecode generators
genExtEnsureAllocableSlots
	"SistaV1	*	236	11101100	iiiiiiii	Ensure Allocable Slots (+ Extend A * 256)"
	| slots skip |
	slots := (extA bitShift: 8) + byte1.
	extA := 0.
	self
		MoveAw: objectMemory freeStartAddress R: TempReg;
		CmpCq: objectMemory getScavengeThreshold - (objectMemory bytesPerOop * slots) R: TempReg.
	skip := self JumpBelow: 0.
	objectRepresentation genSetGCNeeded.
	self CallRT: ceCheckForInterruptTrampoline.
	skip jmpTarget: self Label.
	self annotateBytecode: skip getJmpTarget.
	^0