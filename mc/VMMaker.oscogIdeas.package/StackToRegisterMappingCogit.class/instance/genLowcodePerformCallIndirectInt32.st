inline primitive generators generated code
genLowcodePerformCallIndirectInt32
	<option: #LowcodeVM>	"Lowcode instruction generator"

	self ssNativeTop nativeStackPopToReg: TempReg.
	self ssNativePop: 1.
	self callSwitchToCStack.
	self CallRT: ceFFICalloutTrampoline.
	self annotateBytecode: self Label.
	self MoveR: backEnd cResultRegister R: ReceiverResultReg.
	self ssPushNativeRegister: ReceiverResultReg.

	^ 0

