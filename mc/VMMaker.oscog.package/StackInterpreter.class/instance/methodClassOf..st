compiled methods
methodClassOf: methodPointer
	<api>
	"Using a read barrier here simplifies the become implementation and costs very little
	 because the class index and ValueIndex of the association almost certainly share a cache line."
	^self cppIf: NewspeakVM
		ifTrue:
			[| literal |
			 literal := self followLiteral: (objectMemory literalCountOf: methodPointer) - 1 ofMethod: methodPointer.
			 literal = objectMemory nilObject
				ifTrue: [literal]
				ifFalse: [objectMemory followField: ValueIndex ofObject: literal]]
		ifFalse:
			[| literal |
			 literal := self followLiteral: (objectMemory literalCountOf: methodPointer) - 1 ofMethod: methodPointer.
			 self assert: ((objectMemory isPointers: literal) and: [(objectMemory numSlotsOf: literal) > ValueIndex]).
			 objectMemory followField: ValueIndex ofObject: literal]