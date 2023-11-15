class_name ManifoldUtil
extends Node

## Returns first child with given class name.
static func get_child_of_class(node: Node, classname: String) -> Node:
	if not node:
		return null
	
	if not node.get_child_count():
		return null
	
	var children : Array[Node] = node.get_children()
	
	for child: Node in children:
		if child.is_class(classname):
			return child
	
	return null

## Get children with given class name. Non-recursive. Stores result in [code]result[/code].
static func get_array_of_class(node: Node, classname: String, result: Array[Node]) -> void:
	if not node:
		return
	
	if not node.get_child_count():
		return
	
	var children : Array[Node] = node.get_children()
	
	for child: Node in children:
		if child.is_class(classname):
			result.push_back(child)

# root/EditorNode/Panel/VBoxContainer/HSplitContainer/HSplitContainer/VSplitContainer/TabContainer/SceneTreeDock/SceneTreeEditor
## Get the SceneTreeDock in the Godot editor.
static func get_scene_tree_dock() -> Control:
	return EditorInterface.get_base_control().find_children("Scene", "SceneTreeDock", true, false)[0]

## Get the ImportDock in the Godot editor.
static func get_import_dock() -> Control:
	return EditorInterface.get_base_control().find_children("Import", "ImportDock", true, false)[0]

## Get the FileSystemDock in the Godot editor.
static func get_file_system_dock() -> Control:
	return EditorInterface.get_file_system_dock()

## Get the InspectorDock in the Godot editor.
static func get_inspector_dock() -> Control:
	return EditorInterface.get_base_control().find_children("Inspector", "InspectorDock", true, false)[0]

## Get the NodeDock in the Godot editor.
static func get_node_dock() -> Control:
	return EditorInterface.get_base_control().find_children("Node", "NodeDock", true, false)[0]

## Get the HistoryDock in the Godot editor.
static func get_history_dock() -> Control:
	return EditorInterface.get_base_control().find_children("History", "HistoryDock", true, false)[0]



static func get_text_cursors(node: TextEdit, cursors: Array[ManifoldTextCursor]) -> void:
	for i in node.get_caret_count():
		cursors.push_back(ManifoldTextCursor.new(
			Vector2i(
				node.get_caret_column(i),
				node.get_caret_line(i)
			),
			node.get_selected_text(i).length()
		))
		pass
	pass
