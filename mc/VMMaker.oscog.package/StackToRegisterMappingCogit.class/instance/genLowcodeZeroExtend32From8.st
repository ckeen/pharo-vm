inline primitive generators generated code
genLowcodeZeroExtend32From8
	<option: #LowcodeVM>
	<inline: true>
	"Generated by the Lowcode instruction generator."
	| value |
	self allocateRegistersForLowcodeInteger: [:valueValue |
		value := valueValue.
	].

	self ssNativeTop nativePopToReg: value.
	self ssNativePop: 1.

	self ZeroExtend8R: value R: value.
	self ssPushNativeRegister: value.

	^ 0

