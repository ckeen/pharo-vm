combination rules
pixPaint: sourceWord with: destinationWord
	<inline: false>
	<returnTypeC: 'unsigned int'>
	<var: #sourceWord type: 'unsigned int'>
	<var: #destinationWord type: 'unsigned int'>
	sourceWord = 0 ifTrue: [^ destinationWord].
	^ sourceWord bitOr:
		(self partitionedAND: sourceWord bitInvert32 to: destinationWord
						nBits: destDepth nPartitions: destPPW)