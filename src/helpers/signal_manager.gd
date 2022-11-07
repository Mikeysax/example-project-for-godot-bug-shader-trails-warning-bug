extends Node
class_name SignalManager

# Declare every signal used across the game here
# Example:
# signal my_signal
# signal moved

func call_emit_signal(args):
	callv("emit_signal", args)
	# I don't remember why we need callv(), 
	# I wrote that a long time ago but it's probably important
