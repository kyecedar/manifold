@tool
extends EditorPlugin

const MainScreen : Resource = preload("res://addons/manifold/Editor/editor_view.tscn")

var editor_screen : ManifoldPanelMain

var _curr_script : GDScript
var _curr_focus : Control
var _last_focus : Control

var _cursors : Array[ManifoldTextCursor] = []

const AUTOLOAD_NAME = "Manifold"

var vcs : EditorVCSInterface = EditorVCSInterface.new()



#   the structure of Dialogic was super helpful - 💖
# https://github.com/coppolaemilio/dialogic/blob/main/addons/dialogic/plugin.gd
#   other very helpful resources - 👇
# https://docs.godotengine.org/cs/4.x/tutorials/plugins/editor/making_main_screen_plugins.html
# https://github.com/ACB-prgm/ScriptWriter-Plugin/blob/master/ScriptWriter/plugin.gd
# https://github.com/godotengine/godot-git-plugin
#   thanks for asking - ⁉
# https://ask.godotengine.org/27137/how-do-i-get-the-text-width-of-a-richtextlabel



#region // 󰣖 ACTIVATION & EDITOR SETUP.

func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	pass

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "Manifold.gd")
	
	get_viewport().connect("gui_focus_changed", _on_editor_focus_change)
	editor_screen = MainScreen.instantiate()
	
	EditorInterface.get_editor_main_screen().add_child(editor_screen)
	_make_visible(false)

func _exit_tree() -> void:
	if editor_screen:
		remove_control_from_bottom_panel(editor_screen)
		editor_screen.queue_free()

func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return "Manifold"

func _get_plugin_icon():
	return EditorInterface.get_base_control().get_theme_icon("Node", "EditorIcons")

#endregion 󰣖 ACTIVATION & EDITOR SETUP.



#region // 󰈈 EDITOR INTERACTION.

func _make_visible(visible: bool) -> void:
	if editor_screen:
		editor_screen.visible = visible

# https://ask.godotengine.org/6924/get-scene-tree-from-editor-plugin
## When focus is changed in the Godot editor, this is called.[br]
## Used to connect listeners to the node in focus.
func _on_editor_focus_change(node: Control) -> void:
	_update_node_focus()
	_handle_node_focus(node)
	
	_curr_script = EditorInterface.get_script_editor().get_current_script()
	
	#print()
	#print(EditorInterface.get_script_editor().find_children(""))
	#print(node.get_node("../../..").name)
	#print(EditorInterface.get_script_editor().get_current_editor())
	#print(EditorInterface.get_script_editor().get_current_script().resource_name)
	#print(EditorInterface.get_script_editor().get_current_script().resource_path)
	#EditorInterface.get_file_system_dock().navigate_to_path(EditorInterface.get_script_editor().get_current_script().resource_path)
	#print(EditorInterface.get_script_editor().get_open_scripts())
	#print(EditorInterface.get_script_editor().get_path_to(node))
	
	#print()
	#print(ManifoldUtil.get_history_dock())
	#print(node.get_path())
	
	#print(node.get_node("../.."))
	
	
	if not node.is_connected("tree_exiting", _on_node_free):
		node.connect("tree_exiting", _on_node_free)

func _on_node_free() -> void:
	pass

## To only run checks when dev inputs something.
func _input(event: InputEvent) -> void:
	#print(event)
	pass

## Updates current and last focused nodes, along with removing listeners from the last focused node.
func _update_node_focus() -> void:
	_last_focus = _curr_focus
	_curr_focus = get_tree().root.get_viewport().gui_get_focus_owner()
	
	if _curr_focus != _last_focus:
		_handle_node_unfocus(_last_focus)

func _handle_node_focus(node: Control) -> void:
	if node is TextEdit:
		_add_TextEdit_listeners(node)

func _handle_node_unfocus(node: Control) -> void:
	if node is TextEdit:
		_remove_TextEdit_listeners(node)

func _add_TextEdit_listeners(node: TextEdit) -> void:
	# TODO : add listener for caret position.
	# TODO : add listener for text_changed
	# TODO : get_selection_column, get_selection_line
	if not node.caret_changed.is_connected(_on_TextEdit_caret_changed):
		node.caret_changed.connect(_on_TextEdit_caret_changed)
	
	if not node.text_changed.is_connected(_on_TextEdit_text_changed):
		node.text_changed.connect(_on_TextEdit_text_changed)
	
	_update_cursors()

func _remove_TextEdit_listeners(node: TextEdit) -> void:
	node.caret_changed.disconnect(_on_TextEdit_caret_changed)
	node.text_changed.disconnect(_on_TextEdit_text_changed)

func _on_TextEdit_caret_changed() -> void:
	_update_cursors()

func _on_TextEdit_text_changed() -> void:
	pass

func _update_cursors() -> void:
	if not _curr_focus is TextEdit:
		return
	
	_cursors.clear()
	ManifoldUtil.update_text_cursors(_curr_focus, _cursors)

#endregion 󰈈 EDITOR INTERACTION.
