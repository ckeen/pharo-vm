I/O primitives
primitiveSetWindowSize
	"Primitive. Answer the OS window's size (extent)"
	| w h |
	<export: true>
	h := self stackIntegerValue: 0.
	w := self stackIntegerValue: 1.
	self successful ifTrue:[
		self ioSetWindowWidth: w Height: h.
		self pop: self methodArgumentCount.
	]