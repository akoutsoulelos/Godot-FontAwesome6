extends EditorProperty

# ==============================================================================
# Declare variables
# ==============================================================================
# ------------------------------------------------------------------- Properties
# ---------------------------------------------------------------------- Globals
# -------------------------------------------------------------------- Constants
const FontAwesome6 = preload("FontAwesome6.gd")									# Holds the FontAwesome6 type
const FA6_CHEATSHEET: Dictionary = preload("cheatsheet.gd").cheatsheet_lut		# olds the font awesome 6 cheatsheet
# ------------------------------------------------------------------ Enumerators
# ---------------------------------------------------------------------- Signals
# ---------------------------------------------------------------------- Private
var _vboxContainer : VBoxContainer = VBoxContainer.new()						# Property container
var _lineeditIconname : LineEdit = LineEdit.new()								# The icon_name text control (LineEdit).
var _itemlistSearch : ItemList = ItemList.new()									# The icon_name serach control (ItemList)
var _current_value = ''															# An internal value of the property.
var _updating = false															# A guard against internal changes when the property is updated.
var _object : FontAwesome6														# Holds a reference to the actuall Node in order to access its properties
var _cheatsheet : Dictionary = {												# Holds a sorted cheatsheet
	"brands" : {},
	"solid" : {},
	"regular" : {}
}

# ==================================================================================================
#																						GODOT ENGINE
# ==================================================================================================
# Initialize property control.
# ==============================================================================
func _init(object : FontAwesome6):
	# ---- Prepare initialisation
	_object = object
	var keys : Array 
	for k in ["solid", "regular", "brands"]:
		keys = FA6_CHEATSHEET[k].keys()
		keys.sort()
		for key in keys: _cheatsheet[k][key] = key
	# ---- Inititalize lineEdit child control
	_lineeditIconname.set_h_size_flags(SIZE_EXPAND_FILL)
	_lineeditIconname.connect("focus_entered", self, "_on_lineeditIconname_focus_entered")
	_lineeditIconname.connect("focus_exited", self, "_on_lineeditIconname_focus_exited")
	_lineeditIconname.connect("text_changed", self, "_on_lineeditIconname_text_changed")
	_lineeditIconname.connect("gui_input", self, "_on_lineeditIconname_gui_input")
	_lineeditIconname.text = _object.icon_name
	# ---- Inititalize itemList control
	_itemlistSearch.connect("gui_input", self, "_on_itemlistSearch_gui_input")
	_itemlistSearch.hide()
	_itemlistSearch.rect_min_size = Vector2(0,100)
	_itemlistSearch.focus_mode = Control.FOCUS_NONE
	for key in _cheatsheet[_object.icon_type]:
		_itemlistSearch.add_item(key)
	_itemlistSearch.select(0)
	# ---- Add children controls to main (property) control
	_vboxContainer.add_child(_lineeditIconname)
	_vboxContainer.add_child(_itemlistSearch)
	# ---- Add the control as a direct child of EditorProperty node.
	add_child(_vboxContainer)
	# ---- Make sure the control is able to retain the focus.
	add_focusable(_lineeditIconname)

# ==============================================================================
# Called when the properties are updated.
# ==============================================================================
func update_property():
	# ---- Read the current value from the property.
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == _current_value): return
	# ---- Update the control with the new value.
	_updating = true
	_current_value = new_value
	_updating = false

# ==================================================================================================
#																							  EVENTS
# ==================================================================================================
# [lineeditIconname]	Focus entered
# ==============================================================================
func _on_lineeditIconname_focus_entered():
	_itemlistSearch.clear()
	for key in _cheatsheet[_object.icon_type]:
		if key.matchn("*"+_lineeditIconname.text+"*"):
			_itemlistSearch.add_item(key)
	_itemlistSearch.show()
	_itemlistSearch.select(0)

# ==============================================================================
# [lineeditIconname]	Focus exited
# ==============================================================================
func _on_lineeditIconname_focus_exited(): _itemlistSearch.hide()

# ==============================================================================
# [lineeditIconname]	Text changed
# ==============================================================================
func _on_lineeditIconname_text_changed(new_text):
	_itemlistSearch.clear()
	for key in _cheatsheet[_object.icon_type]:
		if key.matchn("*"+new_text+"*"):
			_itemlistSearch.add_item(key)
	_itemlistSearch.show()
	if _itemlistSearch.get_item_count() > 0 : _itemlistSearch.select(0)
	_current_value = new_text
	emit_changed(get_edited_property(), _current_value)

# ==============================================================================
# [lineeditIconname]	GUI Input
# ==============================================================================
func _on_lineeditIconname_gui_input(event):
	if _itemlistSearch.visible:
		if event is InputEventKey:
			if Input.is_key_pressed(KEY_DOWN):
				if _itemlistSearch.get_selected_items()[0] + 1 == _itemlistSearch.get_item_count():
					_itemlistSearch.select(0)
				else:
					_itemlistSearch.select(_itemlistSearch.get_selected_items()[0] + 1)
				_itemlistSearch.ensure_current_is_visible()
				accept_event()
			if Input.is_key_pressed(KEY_UP):
				if _itemlistSearch.get_selected_items()[0] - 1 < 0:
					_itemlistSearch.select(_itemlistSearch.get_item_count() - 1)
				else:
					_itemlistSearch.select(_itemlistSearch.get_selected_items()[0] - 1)
				_itemlistSearch.ensure_current_is_visible()
				accept_event()
			if Input.is_key_pressed(KEY_ENTER):
				_lineeditIconname.text = _itemlistSearch.get_item_text(_itemlistSearch.get_selected_items()[0])
				_on_lineeditIconname_text_changed(_lineeditIconname.text)
				accept_event()

# ==============================================================================
# [itemlistSearch]		GUI Input
# ==============================================================================
func _on_itemlistSearch_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_doubleclick():
			_lineeditIconname.text = _itemlistSearch.get_item_text(_itemlistSearch.get_selected_items()[0])
			_on_lineeditIconname_text_changed(_lineeditIconname.text)
			accept_event()

# ==================================================================================================
#																					  IMPLEMENTATION
# ==================================================================================================

