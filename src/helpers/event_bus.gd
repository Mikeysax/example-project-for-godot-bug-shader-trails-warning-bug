extends Node
class_name EventBus

# You can have multiple EventBus, a global one, one per entity, anything.
# Signals sent on one event bus are only available on this event bus

var listeners : Dictionary = {}
var signal_manager = SignalManager.new()

func subscribe(object, event, function_name):
	var row = {"object": object,
			"function": function_name}
	Util.append_to_dict(listeners, event, row)
	Util.safe_connect(signal_manager, event, object, function_name)


func dispatch(event, args):
	if typeof(args) != TYPE_ARRAY:
		args = [args]
	signal_manager.call_emit_signal([event] + args)
