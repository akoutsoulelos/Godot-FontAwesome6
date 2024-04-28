extends EditorInspectorPlugin

# ==============================================================================
# Declare variables
# ==============================================================================
# ------------------------------------------------------------------- Properties
# ---------------------------------------------------------------------- Globals
# -------------------------------------------------------------------- Constants
const FontAwesome6 = preload("FontAwesome6.gd")									# Holds the FontAwesome6 type
# ------------------------------------------------------------------ Enumerators
# ---------------------------------------------------------------------- Signals
# ---------------------------------------------------------------------- Private
var _editorPlugin : EditorPlugin												# editor plugin
var _propertyIconname = preload("iconname.property.gd")							# icon_name property

# ==================================================================================================
#																						GODOT ENGINE
# ==================================================================================================
# Initialize inspector plugin
# ==============================================================================
func _init(plugin):
	# CHECK IF EditorPlugin IS REALLY NEEDED
	_editorPlugin = plugin

# ==============================================================================
# Set supported objects.
# ==============================================================================
func can_handle(object):
	# ---- Only FontAwesome6 is supported.
	return (object is FontAwesome6)

# ==============================================================================
# Handle properties.
# ==============================================================================
func parse_property(object, type, path, hint, hint_text, usage):
	# ---- Handle only custom property 'icon_name'.
	if type == TYPE_STRING and path == "icon_name":
		# ---- Create an instance of the custom property editor and register it to a specific property path.
		add_property_editor(path, _propertyIconname.new(object))
		# ---- Inform the editor to remove the default property editor for this property type.
		return true
	else:
		return false
