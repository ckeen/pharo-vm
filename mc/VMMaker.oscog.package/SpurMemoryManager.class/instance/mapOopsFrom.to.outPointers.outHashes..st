image segment in/out
mapOopsFrom: segStart to: segAddr outPointers: outPointerArray outHashes: savedOutHashes
	"This is part of storeImageSegmentInto:outPointers:roots:.
	 Now scan, adding out pointers to the outPointersArray; all objects in arrayOfObjects
	 have had their first fields set to point to their copies in segmentWordArray.  Answer
	 the outIndex if the scan succeded.  Fail if outPointers is too small and answer -1.

	 As established by copyObj:toAddr:startAt:stopAt:savedFirstFields:index:,
	 the marked bit is set for all objects in the segment
	 the remembered bit is set for all classes in the segment.

	 Class indices should be set as follows (see assignClassIndicesAndPinFrom:to:outPointers:filling:)
	 - class indices for classes in the segment "
	| objOop outIndex |
	outIndex := 0.
	self fillObj: outPointerArray numSlots: (self numSlotsOf: outPointerArray) with: nilObj.
	objOop := self objectStartingAt: segStart.
	[objOop < segAddr] whileTrue:
		[| oop hash segIndex |
		 oop := self fetchClassOfNonImm: objOop.
		 "Set the classIndex of the instance.  This is a segment offset (segAddr - segStart / allocatiopnUnit) for instances of
		  classes within the segment, and an outPointer index (index in outPointers + TopHashBit) for classes outside the segment."
		 (self isMarked: oop)
			ifTrue: "oop is a class in the segment; storeImageSegmentInto:outPointers:roots: established offset is within range."
				[oop := self fetchPointer: 0 ofObject: oop.
				 self assert: (self oop: oop isGreaterThanOrEqualTo: segStart andLessThan: segAddr).
				 segIndex := oop - segStart / self allocationUnit.
				 self deny: (segIndex + self firstClassIndexPun anyMask: TopHashBit)]
			ifFalse: "oop is an outPointer; locate or allocate its oop"
				[hash := self rawHashBitsOf: oop.
				((hash anyMask: TopHashBit)
				 and: [hash - TopHashBit <= outIndex
				 and: [oop = (self fetchPointer: hash - TopHashBit ofObject: outPointerArray)]])
					ifTrue: [segIndex := hash]
					ifFalse: "oop is a new outPointer; allocate its oop"
						[outIndex := self newOutPointer: oop at: outIndex in: outPointerArray hashes: savedOutHashes.
						 outIndex = 0 ifTrue: "no room in outPointers; fail"
							[^-1].
						 self assert: ((self rawHashBitsOf: oop) anyMask: TopHashBit).
						 segIndex := self rawHashBitsOf: oop]].
		 self setClassIndexOf: objOop to: segIndex + self firstClassIndexPun.
		 0 to: (self numPointerSlotsOf: objOop) - 1 do:
			[:i|
			 oop := self fetchPointer: i ofObject: objOop.
			 (self isNonImmediate: oop) ifTrue:
				[(self isMarked: oop)
					ifTrue: "oop is an object in the segment."
						[oop := self fetchPointer: 0 ofObject: oop.
						 self assert: (self oop: oop isGreaterThanOrEqualTo: segStart andLessThan: segAddr).
						 oop := oop - segStart]
					ifFalse: "oop is an outPointer; locate or allocate its oop"
						[hash := self rawHashBitsOf: oop.
						((hash anyMask: TopHashBit)
						 and: [(hash := hash - TopHashBit) <= outIndex
						 and: [oop = (self fetchPointer: hash ofObject: outPointerArray)]])
							ifTrue: [oop := hash * self bytesPerOop + TopOopBit]
							ifFalse: "oop is a new outPointer; allocate its oop"
								[outIndex := self newOutPointer: oop at: outIndex in: outPointerArray hashes: savedOutHashes.
								 outIndex = 0 ifTrue: "no room in outPointers; fail"
									[^-1].
								 self assert: ((self rawHashBitsOf: oop) anyMask: TopHashBit).
								 oop := (self rawHashBitsOf: objOop) - TopHashBit * self bytesPerOop + TopOopBit]].
				 self storePointerUnchecked: i ofObject: objOop withValue: oop]].
		 objOop := self objectAfter: objOop limit: segAddr].
	^outIndex